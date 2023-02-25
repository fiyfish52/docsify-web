# openfeign

> maven 依赖

```pom
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-openfeign</artifactId>
    <version>${openfeign.version}</version>
</dependency>
```

> 启动类 添加注解

```java
@EnableFeignClients
```

> 编写 feign接口

```java
@FeignClient("client-server")
public interface ClientServerFeign {
    @RequestMapping(method = RequestMethod.GET,value="/client/doQueryClientInfos")
    public String doQueryClientInfos();
}
```

> 调用

```java
// 注入
@Autowired
    private ClientServerFeign clientServerFeign;
// 调用
    clientServerFeign.XXXXX
```
