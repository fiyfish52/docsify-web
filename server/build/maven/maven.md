# maven



在项目文件夹控制台执行：将制定路径的包安装到maven repository下

mvn install:install-file -DgroupId=com.oracle -DartifactId=ojdbc7 -Dversion=12.1.0.2 -Dpackaging=jar -Dfile=D:\workspace\sxwork\SX-ES\esweb\ojdbc\ojdbc7-12.1.0.2.jar


## 镜像地址

```pom
http://maven.aliyun.com/nexus/content/groups/public//

```

## repository 镜像地址

```text
<mirror>
  <id>aliyunmaven</id>
  <mirrorOf>*</mirrorOf>
  <name>阿里云公共仓库</name>
  <url>https://maven.aliyun.com/repository/public</url>
</mirror>
```
