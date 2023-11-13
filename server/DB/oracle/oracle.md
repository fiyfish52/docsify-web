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
