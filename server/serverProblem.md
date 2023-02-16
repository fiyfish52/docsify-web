# problem


## 文件上传异常

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