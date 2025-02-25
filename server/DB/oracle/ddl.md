# ddl

## 自定义方法

### 字符串转table

> 使用

```sql
SELECT lower(column_value) val FROM table(str_to_table(v_param,','))
```

> 创建

```sql
create FUNCTION str_to_table
(v_str IN VARCHAR2, v_delimiter IN VARCHAR2 DEFAULT '~')
RETURN split_to_table
AS
  val_list split_to_table;
  v_cnt number :=1;
  do_loop BOOLEAN := true;
begin
  val_list := split_to_table(NULL);
  v_cnt := split_cnt(v_str, v_delimiter);
  FOR i IN 1 .. v_cnt
  LOOP
    IF i = 1 THEN
      val_list.DELETE(1);
    ELSE
      val_list.EXTEND;
    END IF;
    val_list(i) := split(v_str,v_delimiter,i);
  END LOOP;
  RETURN val_list;
END;
/
```

```sql
-- auto-generated definition
create type SPLIT_TO_TABLE as table of VARCHAR2(2000)
/
```

## 存储过程 procedure



## 方法  function


### 语法

```sql
--创建函数
CREATE OR REPLACE FUNCTION 函数名(参数1 模式 参数类型)
  RETURN 返回值类型
AS
  变量1 变量类型;
  变量2 变量类型;
BEGIN
    函数体;
END 函数名;
```
