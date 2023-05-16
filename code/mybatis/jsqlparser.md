# jsqlparser

## 前言

JSqlParser支持WHERE及多表操作SQL构建。

## 单表WHERE

```sh
 @Test
    public void testSelectOneTable() throws JSQLParserException {
        // 单表全量
        Table table = new Table("test");
        Select select = SelectUtils.buildSelectFromTable(table);
        System.err.println(select); // SELECT * FROM test

        // 指定列查询
        Select buildSelectFromTableAndExpressions = SelectUtils.buildSelectFromTableAndExpressions(new Table("test"), new Column("col1"), new Column("col2"));
        System.err.println(buildSelectFromTableAndExpressions); // SELECT col1, col2 FROM test

        // WHERE =
        EqualsTo equalsTo = new EqualsTo(); // 等于表达式
        equalsTo.setLeftExpression(new Column(table, "user_id")); // 设置表达式左边值
        equalsTo.setRightExpression(new StringValue("123456"));// 设置表达式右边值
        PlainSelect plainSelect = (PlainSelect) select.getSelectBody(); // 转换为更细化的Select对象
        plainSelect.setWhere(equalsTo);
        System.err.println(plainSelect);//  SELECT * FROM test WHERE test.user_id = '123456'

        // WHERE  != <>
        NotEqualsTo notEqualsTo = new NotEqualsTo();
        notEqualsTo.setLeftExpression(new Column(table, "user_id")); // 设置表达式左边值
        notEqualsTo.setRightExpression(new StringValue("123456"));// 设置表达式右边值
        PlainSelect plainSelectNot = (PlainSelect) select.getSelectBody();
        plainSelectNot.setWhere(notEqualsTo);
        System.err.println(plainSelectNot);//  SELECT * FROM test WHERE test.user_id <> '123456'

        // 其他运算符, 参考上面代码添加表达式即可
        GreaterThan gt = new GreaterThan(); // ">"
        GreaterThanEquals geq = new GreaterThanEquals(); // ">="
        MinorThan mt = new MinorThan(); // "<"
        MinorThanEquals leq = new MinorThanEquals();// "<="
        IsNullExpression isNull = new IsNullExpression(); // "is null"
        isNull.setNot(true);// "is not null"
        LikeExpression nlike = new LikeExpression();
        nlike.setNot(true); // "not like"
        Between bt = new Between();
        bt.setNot(true);// "not between"

        // WHERE LIKE
        LikeExpression likeExpression = new LikeExpression(); // 创建Like表达式对象
        likeExpression.setLeftExpression(new Column("username")); // 表达式左边
        likeExpression.setRightExpression(new StringValue("张%")); // 右边表达式
        PlainSelect plainSelectLike = (PlainSelect) select.getSelectBody();
        plainSelectLike.setWhere(likeExpression);
        System.err.println(plainSelectLike); // SELECT * FROM test WHERE username LIKE '张%'

        // WHERE IN
        Set<String> deptIds = Sets.newLinkedHashSet(); // 创建IN范围的元素集合
        deptIds.add("0001");
        deptIds.add("0002");
        ItemsList itemsList = new ExpressionList(deptIds.stream().map(StringValue::new).collect(Collectors.toList())); // 把集合转变为JSQLParser需要的元素列表
        InExpression inExpression = new InExpression(new Column("dept_id "), itemsList); // 创建IN表达式对象，传入列名及IN范围列表
        PlainSelect plainSelectIn = (PlainSelect) select.getSelectBody();
        plainSelectIn.setWhere(inExpression);
        System.err.println(plainSelectIn); // SELECT * FROM test WHERE dept_id  IN ('0001', '0002')

        // WHERE BETWEEN AND
        Between between = new Between();
        between.setBetweenExpressionStart(new LongValue(18)); // 设置起点值
        between.setBetweenExpressionEnd(new LongValue(30)); // 设置终点值
        between.setLeftExpression(new Column("age")); // 设置左边的表达式，一般为列
        PlainSelect plainSelectBetween = (PlainSelect) select.getSelectBody();
        plainSelectBetween.setWhere(between);
        System.err.println(plainSelectBetween); // SELECT * FROM test WHERE age BETWEEN 18 AND 30

        //  WHERE AND 多个条件结合,都需要成立
        AndExpression andExpression = new AndExpression(); // AND 表达式
        andExpression.setLeftExpression(equalsTo); // AND 左边表达式
        andExpression.setRightExpression(between);  // AND 右边表达式
        PlainSelect plainSelectAnd = (PlainSelect) select.getSelectBody();
        plainSelectAnd.setWhere(andExpression);
        System.err.println(plainSelectAnd); //  SELECT * FROM test WHERE test.user_id = '123456' AND age BETWEEN 18 AND 30

        //  WHERE OR 多个条件满足一个条件成立返回
        OrExpression orExpression = new OrExpression();// OR 表达式
        orExpression.setLeftExpression(equalsTo); // OR 左边表达式
        orExpression.setRightExpression(between);  // OR 右边表达式
        PlainSelect plainSelectOr = (PlainSelect) select.getSelectBody();
        plainSelectOr.setWhere(orExpression);
        System.err.println(plainSelectOr); // SELECT * FROM test WHERE test.user_id = '123456' OR age BETWEEN 18 AND 30

        // ORDER BY 排序
        OrderByElement orderByElement = new OrderByElement(); // 创建排序对象
        orderByElement.isAsc(); //  设置升序排列 从小到大
        orderByElement.setExpression(new Column("col01")); // 设置排序字段
        PlainSelect plainSelectOrderBy = (PlainSelect) select.getSelectBody();
        plainSelectOrderBy.addOrderByElements(orderByElement);
        System.err.println(plainSelectOrderBy); // SELECT * FROM test WHERE test.user_id = '123456' OR age BETWEEN 18 AND 30 ORDER BY col01
    }
```

## 多表Join

```sh
    /**
     * 多表SQL查询
     * JOIN / INNER JOIN: 如果表中有至少一个匹配，则返回行
     * LEFT JOIN: 即使右表中没有匹配，也从左表返回所有的行
     * RIGHT JOIN: 即使左表中没有匹配，也从右表返回所有的行
     * FULL JOIN: 只要其中一个表中存在匹配，就返回行
     */
    @Test
    public void testSelectManyTable() {
        Table t1 = new Table("tab1").withAlias(new Alias("t1").withUseAs(true)); // 表1
        Table t2 = new Table("tab2").withAlias(new Alias("t2", false)); // 表2
        PlainSelect plainSelect = new PlainSelect().addSelectItems(new AllColumns()).withFromItem(t1); // SELECT * FROM tab1 AS t1

        // JOIN ON 如果表中有至少一个匹配，则返回行
        Join join = new Join(); // 创建Join对象
        join.withRightItem(t2); // 添加Join的表 JOIN t2 =>JOIN tab2 t2
        EqualsTo equalsTo = new EqualsTo(); // 添加 = 条件表达式  t1.user_id  = t2.user_id
        equalsTo.setLeftExpression(new Column(t1, "user_id "));
        equalsTo.setRightExpression(new Column(t2, "user_id "));
        join.withOnExpression(equalsTo);// 添加ON
        plainSelect.addJoins(join);
        System.err.println(plainSelect); // SELECT * FROM tab1 AS t1 JOIN tab2 t2 ON t1.user_id  = t2.user_id

        // 设置join参数可实现其他类型join
        // join.setLeft(true); LEFT JOIN
        // join.setRight(true);  RIGHT JOIN
        // join.setFull(true); FULL JOIN
        // join.setInner(true);
    }
```

## SQL函数

```sh
    /**
     * SQL 函数
     * SELECT function(列) FROM 表
     */
    @Test
    public void testFun() throws JSQLParserException {
        Table t1 = new Table("tab1").withAlias(new Alias("t1").withUseAs(true)); // 表1
        PlainSelect plainSelect = new PlainSelect();
        plainSelect.setFromItem(t1); // 设置FROM t1= >  SELECT  FROM tab1 AS t1
        List<SelectItem> selectItemList = new ArrayList<>(); // 查询元素集合
        SelectExpressionItem selectExpressionItem001 = new SelectExpressionItem(); // 元素1表达式
        selectExpressionItem001.setExpression(new Column(t1,"col001"));
        SelectExpressionItem selectExpressionItem002 = new SelectExpressionItem(); // 元素2表达式
        selectExpressionItem002.setExpression(new Column(t1,"col002"));
        selectItemList.add(0, selectExpressionItem001); // 添加入队
        selectItemList.add(1, selectExpressionItem002); // 添加入队

        // COUNT
        SelectExpressionItem selectExpressionItemCount = new SelectExpressionItem(); // 创建函数元素表达式
        selectExpressionItemCount.setAlias(new Alias("count")); // 设置别名
        Function function = new Function(); // 创建函数对象  Function extends ASTNodeAccessImpl implements Expression
        function.setName("COUNT"); // 设置函数名
        ExpressionList expressionListCount = new ExpressionList(); // 创建参数表达式
        expressionListCount.setExpressions(Collections.singletonList(new Column(t1, "id")));
        function.setParameters(expressionListCount); // 设置参数
        selectExpressionItemCount.setExpression(function);
        selectItemList.add(2,selectExpressionItemCount);

        plainSelect.setSelectItems(selectItemList); // 添加查询元素集合入select对象
        System.err.println(plainSelect); // SELECT t1.col001, t1.col002, COUNT(t1.id) AS count FROM tab1 AS t1
    }
```

原文链接：https://blog.csdn.net/qq_43437874/article/details/115011117