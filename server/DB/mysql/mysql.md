# mysql

## 创建数据库、用户，并授权

```sql
CREATE SCHEMA `sx_kf_grid` DEFAULT CHARACTER SET utf8 COLLATE utf8_bin ;
```

> 创建用户 在mysql用户下执行

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
