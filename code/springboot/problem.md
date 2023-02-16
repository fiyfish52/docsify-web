# problem

## 文件上传异常
---
**提示：[The temporary upload location xxx is not valid]**

分类：**spring tomcat**
> 原因

springboot启动时会创建一个/tmp/tomcat.*/work/Tomcat/localhost/ROOT的临时目录作为文件上传的临时目录，
但是该目录会在n天之后被系统自动清理掉，这个清理是由linux操作系统完成的，
具体的配置如下 
```
vim /usr/lib/tmpfiles.d/tmp.conf
```
> 解决

1. 方法1

应用重启  

2. 方法2

增加服务配置，自定义baseDir
```
server.tomcat.basedir=/tmp/tomcat
```
3. 方法3

注入bean，手动配置临时目录
```
@Bean
MultipartConfigElement multipartConfigElement() {
    MultipartConfigFactory factory = new MultipartConfigFactory();
    factory.setLocation("/tmp/tomcat");
    return factory.createMultipartConfig();
}
```
4. 方法4

配置不删除tmp目录下的tomcat
```
vim /usr/lib/tmpfiles.d/tmp.conf
```

## 不识别html
---
**springboot 不识别 resources/templates 中的html**

分类：**springboot**

由于html是静态文件，所以放在templates中是不能被解析的，所以要使用thymeleaf。因此要在pom.xml中引入thymeleaf。

````
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-thymeleaf</artifactId>
</dependency>
````
## thymeleaf 中文乱码

分类：**springboot**

创建 html页面，声明文件编码格式： **<meta charset="UTF-8">**
```
<html xmlns:th="https://www.thymeleaf.org">
<head>
    <title>system translate center</title>
    <meta charset="UTF-8">
</head>
<body>
    <input type="button" onclick="aclick()" value="jiesu"></input>
    <script>
        function aclick(){
        }
    </script>
</body>
</html>
```


## 不识别 html文件

```
Error resolving template [login], template might not exist or might not be accessible by any of the configured Template Resolvers
```

增加配置：

```
spring:
  thymeleaf:
    prefix: classpath:/templates/
    encoding: UTF-8
    mode: HTML
```


## Maven项目-pom.xml文件首行(Unknow Error)

分类：**springboot**

properties 中增加如下配置

```
<maven-jar-plugin.version>3.1.1</maven-jar-plugin.version>
```