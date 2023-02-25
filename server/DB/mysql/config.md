#

## 数据库链接配置

> mysql 5之前的配置：

```yml
driverClassName=com.mysql.jdbc.Driver
url=jdbc:mysql://localhost:3306/test?useUnicode=true&characterEncoding=utf8&useSSL=false
username=****
password=****
```

> mysql 6之后的配置：

```yml
driverClassName=com.mysql.cj.jdbc.Driver
url=jdbc:mysql://localhost:3306/test?serverTimezone=UTC&useUnicode=true&characterEncoding=utf8&useSSL=false&allowPublicKeyRetrieval=true
username=****
password=****
```

> 设置时区为Asia/Shanghai为北京时间

**设置时区serverTimezone为UTC比北京时间早8个小时。**

```yml
driverClassName=com.mysql.cj.jdbc.Driver
url=jdbc:mysql://localhost:3306/test?serverTimezone=Asia/Shanghai&useUnicode=true&characterEncoding=utf8&useSSL=false&allowPublicKeyRetrieval=true
username=****
password=****
```
