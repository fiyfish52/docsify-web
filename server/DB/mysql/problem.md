# problem

## mysql错误：1093-You can’t specify target table for update in FROM clause的解决方法

?> 在做更新操作的时候，赋值操作用了子查询，这个时候Mysql就报了如标题的错误。

**解决方法：子查询需要再包裹一层 把他当成一个新表 然后通过新表查询出来的值 来赋值。**

这个方法只适用于你的查询和更新操作都是同一张表的时候。

> 同表名

```sql
Update frameworkdepartments SET ParentId=(SELECT id FROM (SELECT id FROM frameworkdepartments WHERE did='1') as t1  WHERE 1 ) WHERE ParentId='1'
```

> 不同表名

```sql
UPDATE sample  SET UpdateBy=(SELECT Name FROM frameworkusers WHERE id='12') WHERE UpdateBy='12'
```
