# dml


## in

### 单个字段

```sql
…… from table_a where id_value in (select id from table_b);
```


### 多个字段

```sql
…… from table_a where (id_value, code_value, year_value) in (select id, code, year from table_b);
```

## 闪回查询

通过DELETE删除数据后相当于放入回收站，一般情况下可以找回；通过UPDATE更新数据后数据库也会保留数据快照。闪回就是恢复指定时间的数据快照以达到恢复数据的目的。
根据步骤一查询出数据快照，恢复数据自行决定（之前的数据都有了，咋恢复还不会吗？）

### 查询指定时间的数据快照

> 查询执行过SQL语句，确定快照的时间 

```sql
SELECT R.FIRST_LOAD_TIME,R.SQL_TEXT,R.* FROM V$SQLAREA R
WHERE R.SQL_TEXT LIKE '%ABOUT YOUR SQL%' ORDER BY R.FIRST_LOAD_TIME DESC
```

> 查询基于指定时间的数据快照

```sql
SELECT * FROM YOUR_TABLENAME AS OF TIMESTAMP
TO_TIMESTAMP('2019-02-05 20:00:00', 'yyyy-mm-dd hh24:mi:ss');
```

> 以当前时间为准，125分钟之前的数据快照

```sql
SELECT * FROM YOUR_TABLENAME AS OF TIMESTAMP SYSDATE - 125 / 1440
```

### 恢复数据

FLASHBACK时，如果不确定删除的具体时间，在没有太多操作这个表的情况下，闪回的时间稍微提前一点。

> 闪回表数据SQL语句：

>> 启动表的row movement特性

```sql
ALTER TABLE YOUR_TABLENAME ENABLE ROW MOVEMENT;
```

>> 闪回指定时间的快照

```sql
FLASHBACK TABLE YOUR_TABLENAME TO TIMESTAMP
TO_TIMESTAMP('2018-04-23 16:06:00','yyyy-mm-dd hh24:mi:ss');
```

>> 关闭表的row movement功能

```sql
ALTER TABLE YOUR_TABLENAME DISABLE ROW MOVEMENT;
```

### 闪回数据表的SQL语句：

> 闪回表（通过TRUNCATE语句删除的表无法闪回）

```sql
FLASHBACK TABLE YOUR_TABLENAME TO BEFORE DROP;
```