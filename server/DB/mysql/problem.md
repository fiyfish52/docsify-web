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

## 自增序列不是1

> 查看自增序列

```sql
show variables like '%increment%';
```

> 修改自增序列为1

```sql
set @@auto_increment_increment = 1;
```

## [42000] [1075] Incorrect table definition; there can be only one auto column and it must be defined as a key

设置了自增序列，需要设置为主键

数据库中设置了自增列（auto-Incrementing column），但未将其设置为PRIMARY KEY或UNIQUE KEY，导致执行脚本失败。所以，针对该问题的解决方法：

方法1：将自增列（auto-Incrementing column）设置为主键（PRIMARY KEY）；

方法2：如果不将自增列设置为主键，可将其设置为 唯一索引UNIQUE KEY也可解决该问题；
