# mysql

## 创建数据库、用户，并授权

```sql
CREATE SCHEMA `sx_kf_grid` DEFAULT CHARACTER SET utf8 COLLATE utf8_bin ;
```

> 创建用户 在mysql用户下执行

?> 数据库版本不同，可能不能识别特殊符号，导致创建成功，但是登录报错

```sql
create user "sxcmms"@"%" identified by "sxcmms_1234_!@#$";
```

> 授权 数据库【sx_kf_grid】的权限给用户【sxcmms】

```sql
grant all privileges on `sx_kf_grid`.* to 'sxcmms'@'%' ;
```

> 刷新授权

```sql
flush privileges;
```

## 快捷创建表、复制数据

> MySQL复制相同表结构的方法：

1. 使用AS复制相同的表结构

```sql
 CREATE TABLE table_name AS SELECT * FROM other_table WHERE 1=2;(或者LIMIT 0) 
```

2. 使用LIKE复制相同的表结构

```sql
CREATE TABLE table_name LIKE other_table;
```

> 复制表的数据

1. 复制全部数据 注意：复制全部数据 列的类型要相同 

```sql
INSERT INTO table_name SELECT * FROM other_name; 
```

2. 复制指定的列 

```sql
INSERT INTO test_index_tbl1 ( 
 test_index_tbl1.`id`,
 test_index_tbl1.`name`, 
 test_index_tbl1.`author`,
 test_index_tbl1.`info` 
) SELECT id, NAME, author, info 
FROM 
test_index_tbl;
```

3. AS与LIKE的用途

?> `AS` 用来创建相同表结构并复制源表数据(可根据后面的条件来控制要不要复制源表数据)

?> `LIKE` 用来创建完整表结构和全部索引。

> 示例：book表作为测试使用

①.使用SHOW CREATE TABLE 查看表的创建语句

```sql
SHOW CREATE TABLE book ;
```

结果：

```sql
CREATE TABLE `book` (  
 `id` int(11) NOT NULL AUTO_INCREMENT,   
 `name` varchar(50) NOT NULL,   
 `author` varchar(20) NOT NULL,   
 `info` varchar(255) DEFAULT NULL,   
 PRIMARY KEY (`id`),   
 KEY `author` (`author`) 
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8
```

②.使用AS复制book表

```sql
CREATE TABLE table_name as SELECT * FROM book;
```

③.查看table_name的创建语句

```sql
SHOW CREATE TABLE table_name ;
```

结果：

```sql
CREATE TABLE `table_name` (   
 `id` int(11) NOT NULL DEFAULT '0',   
 `name` varchar(50) NOT NULL,   
 `author` varchar(20) NOT NULL,   
 `info` varchar(255) DEFAULT NULL 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
```

?> 使用AS复制源表，结论：对比两次查询的创建语句发现，AS复制了表的源数据和结构，但没有复制索引和主键的设置。


>> 测试LIKE复制表

①.使用LIKE复制表

```sql
CREATE TABLE table_name LIKE book;
```

②.查询book(源表)的创建语句

结果：

```sql
CREATE TABLE `book` (  
 `id` int(11) NOT NULL AUTO_INCREMENT,  
 `name` varchar(50) NOT NULL,  
 `author` varchar(20) NOT NULL,   
 `info` varchar(255) DEFAULT NULL,   
 PRIMARY KEY (`id`),   KEY `author` (`author`) 
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8
```

③.查询table_name(复制表)的创建语句

结果：

```sql
CREATE TABLE `table_name` (   
 `id` int(11) NOT NULL AUTO_INCREMENT,
 `name` varchar(50) NOT NULL, 
 `author` varchar(20) NOT NULL,   
 `info` varchar(255) DEFAULT NULL,   
 PRIMARY KEY (`id`),   
 KEY `author` (`author`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
```

对比两次结果发现完完全全的复制了源表的结构包括索引信息。

>> 结论：

?> AS：用来创建相同表结构并复制源表数据(可根据后面的条件来控制要不要复制源表数据)

?> LIKE：用来创建完整表结构和全部索引。(可以使用INSERT INTO和SELECT语句复制源表的所有数据 )

INSERT INTO table_name SELECT * FROM book;

> AS与LIKE的区别:

?> AS:创建出来的table_name 缺少源表的索引信息，只有表结构相同，没有索引。

?> LIKE：创建出来的新表包含源表的完整结构和索引信息。

?> 补充：Oracle支持AS，即只有表结构没有索引，Oracle不支持LIKE


## 导出sql

```sql
 mysqldump.exe --defaults-file="C:\Users\MR3A2A~1.ZHA\AppData\Local\Temp\tmpaqcwytib.cnf"  --host=172.28.28.165 --port=13306 --default-character-set=utf8 --user=root --protocol=tcp --column-statistics=FALSE --skip-triggers "channel"
```


## 字符串转数字

在使用mysql中，经常遇到要将字符串数字转换成可计算数字，现总结 了几种方式：

> 将字符的数字转成数字，比如'0'转成0可以直接用加法来实现

例如：将pony表中的d 进行排序，可d的定义为varchar，可以这样解决
select * from pony order by (d+0)

> 在进行ifnull处理时，比如 ifnull(a/b,'0') 这样就会导致 a/b成了字符串，因此需要把'0'改成0，即可解决此困扰

> 比较数字和varchar时，比如a=11，b="11ddddd";
则 select 11="11ddddd"相等
若绝对比较可以这样：

select binary 11 =binary "11ddddd"

> 字符集转换 : CONVERT(xxx USING gb2312)
类型转换和SQL Server一样,就是类型参数有点点不同 : CAST(xxx AS 类型) , CONVERT(xxx,类型)，类型必须用下列的类型：

可用的类型：

二进制,同带binary前缀的效果 : BINARY
字符型,可带参数 : CHAR()
日期 : DATE
时间: TIME
日期时间型 : DATETIME
浮点数 : DECIMAL
整数 : SIGNED
无符号整数 : UNSIGNED

```sql
方法一：SELECT CAST('123' AS SIGNED);
方法二：SELECT CONVERT('123',SIGNED);
方法三：SELECT '123'+0;
```
