# problem


## openfeign 调用报错

> nacos 集成 openfeign报错

```java
Caused by: java.lang.AbstractMethodError: org.springframework.cloud.netflix.ribbon.RibbonLoadBalancerClient.choose(Ljava/lang/String;Lorg/springframework/cloud/client/loadbalancer/Request;)Lorg/springframework/cloud/client/ServiceInstance;
```

> 原因

当前我的springboot版本 2.4.3 ，springcloud版本 2020.0.2
出现这个问题是没有loadbalancer，但是nacos中ribbon会造成loadbalancer包失效,所以在包中移除ribbion依赖，并加入loadbalancer依赖；

> 解决

```pom
 <dependency>
            <groupId>com.alibaba.cloud</groupId>
            <artifactId>spring-cloud-starter-alibaba-nacos-discovery</artifactId>
            <version>2021.1</version>
            <exclusions>
                <exclusion>
                    <groupId>org.springframework.cloud</groupId>
                    <artifactId>spring-cloud-starter-netflex-ribbon</artifactId>
                </exclusion>
                <exclusion>
                    <groupId>org.springframework.cloud</groupId>
                    <artifactId>spring-cloud-netflex-ribbon</artifactId>
                </exclusion>
            </exclusions>
        </dependency>
        <!--nacos与spring cloud openfeign 冲突-->
        <!-- https://mvnrepository.com/artifact/org.springframework.cloud/spring-cloud-starter-loadbalancer -->
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-loadbalancer</artifactId>
            <version>3.0.6</version>
        </dependency>
```