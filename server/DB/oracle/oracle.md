# oracle

## 查看sid

```sql
select instance_name from v$instance;
```

## 创建数据库

Oracle安装文件夹：app\oraserver\product\11.2.0\dbhome_1\BIN\launch.exe

也可以查找安装目录：Oracle_OraDB12Home1》Database Configuration Assistant

## pl/sql 15

激活码

```txt
产品编号Product Code: kfj6yg6rfyhqcha6cbgs6fsw3kyje7a6qr
序列号Serial Number: 276182
口令Password: xs374ca
```

## 锁表问题

```sql
 select session_id,t.* from v$locked_object t;
 SELECT sid, serial#, username, oSUSEr FROM v$session t where sid = 2568;
 ALTER SYSTEM KILL SESSION '2568,12693';--sid, serial#
```

> 查找所有锁

```sql
SELECT SESS.SID,  
SESS.SERIAL#,  
LO.ORACLE_USERNAME,  
LO.OS_USER_NAME,  
AO.OBJECT_NAME 被锁对象名, 
LO.LOCKED_MODE 锁模式, 
sess.LOGON_TIME 登录数据库时间,
'ALTER SYSTEM KILL SESSION ''' || SESS.SID || ','||SESS.SERIAL#||'''' FREESQL
FROM V$LOCKED_OBJECT LO,  DBA_OBJECTS AO,  V$SESSION SESS 
WHERE AO.OBJECT_ID = LO.OBJECT_ID 
AND LO.SESSION_ID = SESS.SID 
ORDER BY sid, sess.serial#;
```

```sql
SELECT '''' || sid || ',' || serial# || '''',
         sid,
         serial#,
         username,
         oSUSEr
    FROM v$session
   where sid in (select session_id
                   from v$locked_object t
                  where t.os_user_name = 'zhanglipengLZ');
```



## sql 执行慢

```sql
select *
 from (select sa.SQL_TEXT,
        sa.SQL_FULLTEXT,
        sa.EXECUTIONS "执行次数",
        round(sa.ELAPSED_TIME / 1000000, 2) "总执行时间",
        round(sa.ELAPSED_TIME / 1000000 / sa.EXECUTIONS, 2) "平均执行时间",
        sa.COMMAND_TYPE,
        sa.PARSING_USER_ID "用户ID",
        u.username "用户名",
        sa.HASH_VALUE
     from v$sqlarea sa
     left join all_users u
      on sa.PARSING_USER_ID = u.user_id
     where sa.EXECUTIONS > 0 and sa.LAST_ACTIVE_TIME >to_date( '2021-11-18 00:00:00','yyyy-mm-dd hh24:mi:ss')
     order by (sa.ELAPSED_TIME / sa.EXECUTIONS) desc)
 where rownum <= 50;
```

## 同义词

在Oracle中，同义词（Synonyms）是为数据库对象（如表、视图、序列、过程、函数等）定义的别名，旨在简化对象访问和提高访问安全性。通过使用同义词，用户可以用简短且易记的名称来替代复杂的数据库对象名称，从而使SQL语句更简洁。

### 创建同义词

#### 语法

```
CREATE [PUBLIC] SYNONYM synonym_name FOR object_name;

```

**PUBLIC**：表示创建的是公有同义词，可以被所有用户访问。

**synonym_name**：要创建的同义词的名称。

**object_name**：要为之创建同义词的对象的名称。

#### 示例

```sql
# 创建公有同义词
CREATE PUBLIC SYNONYM emp_synonym FOR scott.emp;
# 创建私有同义词
CREATE SYNONYM s_emp FOR scott.emp;
# 删除同义词
DROP PUBLIC SYNONYM synonym_name;
# 查看同义词
## 查询当前用户创建的所有同义词：
SELECT synonym_name, table_name, table_owner FROM user_synonyms;
## 查询系统中的所有公共同义词：
SELECT synonym_name, table_name, table_owner FROM dba_synonyms WHERE owner='PUBLIC';

```



### 删除同义词

```sql
DROP [PUBLIC] SYNONYM [schema.]synonym_name;
```

其中，schema是可选的，用于指定同义词所在的模式。如果不指定schema，则默认删除当前模式下的同义词。synonym_name是要删除的同义词的名称。
删除同义词的注意事项

#### 权限要求：

删除同义词需要相应的权限。普通用户只能删除自己创建的同义词，如果要删除其他用户创建的同义词，则需要具有DROP ANY SYNONYM系统权限。DBA可以删除所有的公有同义词，而普通用户需要具有DROP PUBLIC SYNONYM系统权限才能删除公共同义词。

#### 依赖关系：

如果同义词依赖于其他对象（如视图、存储过程等），删除同义词时可能会受到限制。可以使用CASCADE选项来自动删除依赖的对象，或者使用RESTRICT选项来拒绝删除。

#### 备份数据：

在执行删除操作之前，建议备份数据以防意外删除重要对象。

### 示例

```sql
# 删除当前模式下的同义词
DROP SYNONYM my_synonym;
# 删除指定模式下的同义词
DROP SYNONYM schema_name.my_synonym;
# 删除公有同义词
DROP PUBLIC SYNONYM public_synonym_name;
```

通过以上步骤和注意事项，可以有效地删除Oracle中的同义词。在执行删除操作时，请确保你有足够的权限，并仔细检查要删除的同义词，以免造成不可逆的影响。

## 索引

根据索引名 查询表

```sql
SELECT * FROM user_ind_columns WHERE index_name = 'your_index_name';
```

## 表空间

### 要查询名为my_index的索引的表空间名称

```sql
SELECT INDEX_NAME, TABLESPACE_NAME FROM USER_INDEXES WHERE INDEX_NAME = 'my_index';

```

