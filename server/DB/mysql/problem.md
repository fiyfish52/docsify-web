# problem

## useSSL=false

`SSL(Secure Sockets Layer 安全套接字协议)，在mysql进行连接的时候,如果mysql的版本是5.7之后的版本必须要加上useSSL=false,
mysql5.7以及之前的版本则不用进行添加useSSL=false，会默认为false，
一般情况下都是使用useSSL=false，尤其是在将项目部署到linux上时，一定要使用useSSL=false！！！，
useSSL=true是进行安全验证，一般通过证书或者令牌什么的，useSSL=false就是通过账号密码进行连接，通常使用useSSL=false！！！`

## 外部工具链接 提示：Public Key Retrieval is not allowed

```
链接后面添加：allowPublicKeyRetrieval=true
```

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
