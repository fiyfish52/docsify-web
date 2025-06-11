# 开发指南

## 核心开发配置

### 自动配置

#### 模版

##### XXXAutoconfiguration.java

`@AutoConfiguration`用于标记这是一个自动配置类

`@EnableConfigurationProperties`用于启用配置属性绑定

`@Bean`用于在Spring容器中注册一个Bean,这个Bean会被Spring容器管理，并且可以在其他地方通过依赖注入来使用。

```java
@AutoConfiguration
@EnableConfigurationProperties(value = SmsProperties.class)
public class SmsAutoConfiguration {

    @Bean
    public SmsTemplate smsTemplate(){
        return new SmsTemplate();
    }

    @Bean
    public AliCloudSmsServiceImpl ali(){
        return new AliCloudSmsServiceImpl();
    }

    @Bean
    public TxCloudSmsServiceImpl tx(){
        return new TxCloudSmsServiceImpl();
    }

    @Bean
    public YmxCloudSmsServiceImpl ymx(){
        return new YmxCloudSmsServiceImpl();
    }

}
```

##### XXXProperties.java

` @ConfigurationProperties` 注解，并指定了前缀 `sms.server.achieve`。这意味着，当 Spring Boot 加载配置文件时，所有以 sms.server.achieve 开头的属性都将被绑定到这个类的字段上。

```java
@ConfigurationProperties(prefix = "sms.server.achieve")
public class SmsProperties {

    /**
     * 发送短信类型
     */
    private String type;

    public String getType() {
        if(type == null || "".equals(type)){
            type = SysTypeEnum.ALI_CLOUD.findType();
        }
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }
}
```

XXXTemplate

#### 自动生成

### 工具类

#### fastjsonutil



### 加载参数

yaml 配置 enable:true  指定参数 ：paramStr, 就会加载到内存

加载位置：caech: memory,redis,

```yaml
knbs:
	params:
		enable: true
		position: memory/redis // 保存在内存或者 redis中
		expire: 300 // 超时时间秒
		params-table-name: sys_params
        params-codes: ACCOUNT_TYPE,ACCOUNT_TYPE // 需要加载的参数
        db-type: mysql 
		config:
            db:
                mysql:
                    ip: 39.96.36.32
                    port: 3306
                    data-base: knbs_account
                    jdbc-username: knbs_account_user
                    jdbc-password: 'knbs_account_1234_!@#$'
                    
            memory:
            	
	
```





## 工程调用配置

### Knife4j API 文档



> 配置文档描述

```yaml
knbs:
  knife4j:
    // 是否开启
    enable: true
    title: 账本服务
    description: 账本服务
    version: 2.0
    license:
      name: Apache 2.0
      url: http://www.apache.org/licenses/LICENSE-2.0.html
    contact:
      name: KnbsAccountServer
      url: https://github.com/zhengkun/KnbsAccountServer
      email: <EMAIL>
```

> 配置接口分组

```yaml
springdoc:
  version: '@springdoc.version@'
  swagger-ui:
    display-request-duration: true
    groups-order: DESC
    operationsSorter: method
    disable-swagger-default-url: true
    use-root-path: true
  show-actuator: true
  group-configs:
    - group: account1
      paths-to-match: /**
      #生成文档所需的扫包路径，一般为启动类目录
      packages-to-scan: org.knbs.account.customer
  cache:
    disabled: true
```



> 代码注释

```java
@RestController
@RequestMapping("body")
@Tag(name = "body参数")
public class BodyController {

   @Operation(summary = "普通body请求")
   @PostMapping("/body")
   public ResponseEntity<FileResp> body(@RequestBody FileResp fileResp){
       return ResponseEntity.ok(fileResp);
   }

   @Operation(summary = "普通body请求+Param+Header+Path")
   @Parameters({
           @Parameter(name = "id",description = "文件id",in = ParameterIn.PATH),
           @Parameter(name = "token",description = "请求token",required = true,in = ParameterIn.HEADER),
           @Parameter(name = "name",description = "文件名称",required = true,in=ParameterIn.QUERY)
   })
   @PostMapping("/bodyParamHeaderPath/{id}")
   public ResponseEntity<FileResp> bodyParamHeaderPath(@PathVariable("id") String id,@RequestHeader("token") String token, @RequestParam("name")String name,@RequestBody FileResp fileResp){
       fileResp.setName(fileResp.getName()+",receiveName:"+name+",token:"+token+",pathID:"+id);
       return ResponseEntity.ok(fileResp);
   }
}

```



### 自动生成代码

> 配置

```yaml
knbs:
  mybatisplus:
    generate:
      mysql:
        ip: 39.96.36.32
        port: 3306
        data-base: knbs_account
        jdbc-username: knbs_account_user
        jdbc-password: 'knbs_account_1234_!@#$'
```

> junit test调用

```java
@SpringBootTest
public class GenerateTest {

    @Autowired
    GenerateTemplate generateTemplate;

    @Test
    public void generate(){

        generateTemplate.generator("user_account");
    }
}
```





问题：

> spring 自定义的starter 中如何自动执行某个方法
>
> maven 编译后没有mybatis 的xml文件
>
> 如何在java代码中配置mybatis的datasource
>
> spring 自定义的starter 中如何使用mybatis



## 代码规范

### 接口文档配置

[Knife4j · 集Swagger2及OpenAPI3为一体的增强解决方案. | Knife4j](https://doc.xiaominfo.com/)

使用OpenAPI3的规范注解

```java
@RestController
@RequestMapping("body")
@Tag(name = "body参数")
public class BodyController {

   @Operation(summary = "普通body请求")
   @PostMapping("/body")
   public ResponseEntity<FileResp> body(@RequestBody FileResp fileResp){
       return ResponseEntity.ok(fileResp);
   }

   @Operation(summary = "普通body请求+Param+Header+Path")
   @Parameters({
           @Parameter(name = "id",description = "文件id",in = ParameterIn.PATH),
           @Parameter(name = "token",description = "请求token",required = true,in = ParameterIn.HEADER),
           @Parameter(name = "name",description = "文件名称",required = true,in=ParameterIn.QUERY)
   })
   @PostMapping("/bodyParamHeaderPath/{id}")
   public ResponseEntity<FileResp> bodyParamHeaderPath(@PathVariable("id") String id,@RequestHeader("token") String token, @RequestParam("name")String name,@RequestBody FileResp fileResp){
       fileResp.setName(fileResp.getName()+",receiveName:"+name+",token:"+token+",pathID:"+id);
       return ResponseEntity.ok(fileResp);
   }
}
```

