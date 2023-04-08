# ldap

## 查找镜像

```sh
docker search openldap
```

## 拉取镜像

```sh
docker pull XXXX
```

## 启动

> 创建映射文件夹

```sh
mkdir ldap
```

> 启动

```sh
docker run -d -p 389:389 -p 636:636 -v /usr/local/ldap:/usr/local/ldap --name ldap ldapaccountmanager/lam
```


# 默认配置
dn          dc=example,dc=org
admin       cn=admin,dc=example,dc=org
password    admin
进入容器，验证一下是否可用

# 进入容器
docker exec -it ldap /bin/bash

# 执行查询
ldapsearch -x -H ldap://localhost:389 -b dc=example,dc=org -D "cn=admin,dc=example,dc=org" -w admin
或直接在容器外执行查询

docker exec -it ldap ldapsearch -x -H ldap://localhost:389 -b dc=example,dc=org -D "cn=admin,dc=example,dc=org" -w admin
查询结果

# extended LDIF
#
# LDAPv3
# base <dc=example,dc=org> with scope subtree
# filter: (objectclass=*)
# requesting: ALL
#

# example.org
dn: dc=example,dc=org
objectClass: top
objectClass: dcObject
objectClass: organization
o: Example Inc.
dc: example

# admin, example.org
dn: cn=admin,dc=example,dc=org
objectClass: simpleSecurityObject
objectClass: organizationalRole
cn: admin
description: LDAP administrator
userPassword:: e1NTSEF9VGpERTFMN1FuZGJDT3pKT0poQnhnQnNxRDN6QTV5WFE=

# search result
search: 2
result: 0 Success

# numResponses: 3
# numEntries: 2