# oracle grammar



## drop table XXX purge

操作 Oracle 时，经常会删除一个表，当删除错误后，希望能够恢复该表，有时也希望删除表之后能够立刻释放表的空间。

通过 purge 的使用可以在 Oracle 中删除表、恢复表和空间释放。

> drop table

当在 Oracle 中删除（drop）一个表时，数据库不会立刻释放表的空间，而是重命名这个表然后将其放入回收站，可以通过以下方式查询：
```sql
select object_name,
       original_name
from user_recyclebin
where original_name = 'TEMP'
```
```
OBJECT_NAME						ORIGINAL_NAME
-------------------------------------------------------
BIN$C1LT5U0DaV7gVAAhKENZ5A==$0	TEMP
```

`object_name`：对象在回收站中的名称；

`original_name`：对象的原始名称。

表放入回收站后，Oracle 不会将该表的空间给其它对象使用，表所占用的空间依然占用，除非用户手工进行 `Purge` 或者因为存储空间不够而被数据库清掉。  
如果你发现错误的删除了表，可以通过 `flashback table` 将表恢复。

> flashback table

可以使用 `flashback table` 恢复已删除的表。

```sql
flashback table temp to before drop;
```

`to before drop` 表示恢复这个表及其所有依赖的对象。

如果该表的名称已经被其它表使用，那么执行 flashback table 该表时则会报错：`ORA-38312:original name is used by an existing object`,
这时，可以在执行 `flashback table` 时将表重命名：

```sql
flashback table temp to before drop rename to temp_old;
```

`rename to` 表示将该表恢复后重命名。如果该表已经被删除了多次，
那么使用 `flashback table` 恢复该表将默认恢复最后一次删除的那个，

如果想恢复之前的一个版本，需要在回收站中查询该表：
```sql
select object_name,original_name,droptime from user_recyclebin where original_name = 'TEMP';
```
```
OBJECT_NAME						ORIGINAL_NAME	DROPTIME
------------------------------------------------------------------------
BIN$C1LT5U0FaV7gVAAhKENZ5A==$0	TEMP			2014-12-29:10:59:41
BIN$C1LT5U0HaV7gVAAhKENZ5A==$0	TEMP			2014-12-29:10:59:54
BIN$C1LT5U0GaV7gVAAhKENZ5A==$0	TEMP			2014-12-29:10:59:47
```

然后可以使用那个恢复并重命名的方式依次恢复每一个。

**使用 `flashback table` 需要注意：**

**数据库将从回收站恢复该表的所有索引，注意`bitmap` `join` `Index`不能恢复，因为该索引在表格删除后不会被放入回收站中，所以不能恢复;数据库将恢复该表的`trigger`和`constraint`，除了指向其它表的完整性约束;当删除一个表格时，定义在该表格上的所有物化视图日志也被删除，但不会放入回收站中，因此，物化视图日志不能随着表格被恢复;当删除一个表格时，该表格相关的所有索引都将被放入回收站中，如果数据库空间不足，数据库将首先清除掉索引的空间，因此，在这种情况下，恢复表格将无法恢复所有的索引；如果被删除的表格已经被 `purge` 了，那么将无法恢复。如果用户在删除一个表后不会再恢复它，可以考虑使用 `purge` 将其彻底清除掉。**

> purge
`purge` 可以将表彻底清除，并且释放表所占用的空间。

```sql
purge table temp;
drop table table_name purge;
```
**需要注意不能回滚一个 purge 操作，一旦对一个表执行了 purge 操作，该表将无法再恢复。  
如果该表被删除了多次，purge 操作将清除最早删除的那个表，也可以清除整个回收站的内容：**

```sql
purge recyclebin;
```

> drop table ... purge

也可以将删除表格和释放空间一步完成，例如：

```sql
drop table table_name purge
```

这种方式相当于先删除表格 table_name，然后在对表格执行 purge 操作。

**注意，在这种情况下，不能回滚一个带上 purge 的 drop table 操作，也不能恢复一个使用 purge 删除的表格。**

> 测试

如果在存储过程中，或者是其他代码中使用了 `drop` 语句删除大量表，容易在回收站中产生垃圾，DBA会投诉。

如果确定要 `drop` 表，则最好加上 `purge`，但是要`慎用`，因为无法回滚。

> 示例

```sql
SQL> show parameter recycle;
 
NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
buffer_pool_recycle                  string      
db_recycle_cache_size                big integer 0
recyclebin                           string      OFF

SQL> purge recyclebin;

Done -- 清空回收站

SQL> show recyclebin;
-- 查询

SQL> drop table dt;
-- 删除表  
SQL> show recyclebin;
ORIGINAL NAME    RECYCLEBIN NAME                OBJECT TYPE  DROP TIME
---------------- ------------------------------ ------------ -------------------
dt              BIN$2cOZCZj0Ry27btpd7ymTHg==$0 TABLE        2019-04-10:10:56:58

SQL> flashback table dt to before drop;
-- 回滚数据表

SQL> drop table dt purge;
-- 删除表并清空回收站
SQL> show recyclebin; -- 为空
```


## 打印输出

1. 输出普通参数 

```
bms_output.put_line('参数名'||paramName);
```

2. 输出时间类参数
注意是TO_CHAR

```
dbms_output.put_line('开始时间'||TO_CHAR(startDATE, 'DD-MON-YYYY HH24:MI:SS'));|
```