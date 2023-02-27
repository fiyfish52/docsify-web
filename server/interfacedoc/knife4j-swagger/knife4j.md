# knife4j

## 官网

[官网地址](https://doc.xiaominfo.com/docs/quick-start)

## pom 引入

```pom
  <dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>
<!-- https://mvnrepository.com/artifact/org.springdoc/springdoc-openapi-ui -->
<dependency>
    <groupId>org.springdoc</groupId>
    <artifactId>springdoc-openapi-ui</artifactId>
    <version>1.6.14</version>
</dependency>
<!--        &lt;!&ndash;引入Knife4j的官方ui包,OpenAPI3建议使用springdoc-openapi项目&ndash;&gt;-->
<dependency>
    <groupId>com.github.xiaoymin</groupId>
    <artifactId>knife4j-springdoc-ui</artifactId>
    <version>3.0.3</version>
</dependency>

<!--解决实体类 swagger 注解不生效-->
<dependency>
    <groupId>io.swagger</groupId>
    <artifactId>swagger-annotations</artifactId>
    <version>1.6.6</version>
</dependency>
```

## 增加配置文件

```java
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.License;
import org.springdoc.core.GroupedOpenApi;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;


/**
 * @author Mr.zhang
 * @version 1.0
 * @description: TODO
 * @date 2023/2/24 21:25:32
 */
@Configuration
public class AuthSwaggerConfig {


    @Bean
    public GroupedOpenApi userApi() {
        String[] paths = {"/**"};
        String[] packagedToMatch = {"com.knbs.auth"};
        return GroupedOpenApi.builder()
                .group("auth")
                .pathsToMatch(paths)
//                .addOperationCustomizer((operation, handlerMethod) -> {
//                    return operation.addParametersItem(new HeaderParameter().name("groupCode").example("测试").description("集团code").schema(new StringSchema()._default("BR").name("groupCode").description("集团code")));
//                })
                .packagesToScan(packagedToMatch).build();
    }

    @Bean
    public OpenAPI customOpenAPI() {
        return new OpenAPI()
                .info(new Info()
                        .title("knbs认证中心")
                        .version("1.0")
                        .description("认证中心")
                        .termsOfService("http://doc.xiaominfo.com")
                        .license(new License().name("Apache 2.0")
                                .url("http://doc.xiaominfo.com")));
    }


}
```

## 编写公共 打印访问路径的方法（可省略）

```java
package com.knbs.doc.config;

import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.core.env.Environment;

import java.net.InetAddress;

/**
 * @author Mr.Zhang
 * @desc
 * @date 2022/10/1 23:58
 */
@Slf4j
public class KnbsDocStartPrint {

    public static void printAppInfo(Environment env) throws Exception {

        String protocol = "http";
        if (env.getProperty("server.ssl.key-store") != null) {
            protocol = "https";
        }
        String port = env.getProperty("server.port");

        String context = env.getProperty("server.servlet.context-path");

        if (StringUtils.isBlank(context)) {
            context = "";
        }

        String port_context = port + context;
        String Local = protocol + "://localhost:" + port_context;
        String External = protocol + "://" + InetAddress.getLocalHost().getHostAddress() + ":" + port_context;

//        log.info(
//                "\n----------------------------------------------------------\n\t"
//                        + "Application '{}' is running! Access URLs:\n\t" + "Local: \t\t{}\n\t" + "External: \t{}\n\t"
//                        + "swagger-ui: {}/swagger-ui/index.html\n\t" + "swagger-ui: {}/swagger-ui/index.html\n\t"
//                        + "Profile(s): {}\n----------------------------------------------------------",
//                env.getProperty("spring.application.name"), Local, External, Local, External, env.getActiveProfiles());
        log.info("\n----------------------------------------------------------\n\t"
                        + "Application '{}' is running! Access URLs:\n\t" + "Local: \t\t{}\n\t" + "External: \t{}\n\t"
                        + "swagger-ui: {}/swagger-ui/index.html\n\t" + "swagger-ui: {}/swagger-ui/index.html\n\t"
                        + "swagger-new-ui: {}/doc.html\n\t"
                        + "swagger-new-ui: {}/doc.html\n\t"
                        + "Profile(s): {}\n----------------------------------------------------------",
                env.getProperty("spring.application.name"), Local, External, Local, External, Local, External, env.getActiveProfiles());
    }
}

```

## yml/properties 配置

```yml
server:
  port: 8783
  servlet:
    context-path: /user
spring:
  mvc:
    pathmatch:
      # 配置策略
      matching-strategy: ant-path-matcher
```

## 创建启动类

调用该方法可在启动日志中打印接口文档访问路径；
**KnbsDocStartPrint.printAppInfo(configurableApplicationContext.getEnvironment());**

```java
import com.knbs.doc.config.KnbsDocStartPrint;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ConfigurableApplicationContext;

/**
 * @author Mr.zhang
 * @version 1.0
 * @description: 认证用户服务
 * @date 2023/2/27 11:43:51
 */
@SpringBootApplication
public class KnbsUserServer {
    public static void main(String[] argz) throws Exception {
        ConfigurableApplicationContext configurableApplicationContext = SpringApplication.run(KnbsUserServer.class,argz);
        KnbsDocStartPrint.printAppInfo(configurableApplicationContext.getEnvironment());
    }
}

```

## 启动工程

启动

## 访问

> knife4j 页面

```url
http://localhost:8783/user/doc.html
```

> swagger页面

```url
http://localhost:8783/user/swagger-ui/index.html
```
