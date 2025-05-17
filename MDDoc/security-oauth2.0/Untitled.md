

3.2.开发授权服务器
1.引入所需的依赖
<dependency><groupId>org.springframework.security</groupId><artifactId>spring-security-oauth2-authorization-server</artifactId></dependency>
提示:oauth2-authorization-server 依赖中已经包含 spring-sceurity 依赖。
注意:SpringBoot v3.3.0 默认 oauth2-authorization-server 的版本是 1.30，勿手动指定版本!
2.配置文件
参考地址:GettingStarted
server:

# 授权服务器端口
```apl
server:
  port: 9000

spring:
  security:
    user:
      name: admin
      password: 1111
    oauth2:
      authorizationserver:
        client:
          # 客户端名称
          myclient:
            registration:
              # 客户端id
              client-id: myclient
#              客户端秘钥
              client-secret: myclient
#              客户端身份验证方法
              client-authentication-method:
                - client_secret_basic
#              授权类型
              authorization-grant-type:
                - authorization_code
                - refresh_token
#              客户端回调地址
              redirect-uris:
                - http://localhost:9000/login/oauth2/code/myclient
#              客户端应用首页
              post-logout-redirect-uris:
                - http://localhost:9000
#              授权范围
              scopes:
                - openid
                - profile
#              是否需要"授权确认"
              require-authorization-consent: true
```



## 3.3 开发客户端应用

> 引入所需依赖

```xml
 <!--spring-security启动器-->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-security</artifactId>
</dependency>
<!--oauth2-client启动器-->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-oauth2-client</artifactId>
</dependency>
```



> 配置文件

```yaml
server:
  port: 8091
spring:
  security:
    oauth2:
      client:
        registration:
          #蜜户端应用名
          myclient :
          # 客户端id
            clientId: laoli
            # 客户端secret
            clientSecret:  123456
            # 授权码的模式
            authorizationGrantType: authorization_code
          #回调地址(勿用127.0.0.1)
            redirectUri: http://localhost:8080/login/oauth2/code/myclient
          # 授权范围
            scope:
              - openid
              - profile
            # 服务提供商名
            provider: sas
        provider:
          sas :
          # 授权地址
          authorizationUri: http://oauth2-server:9000/oauth2/authorize
          # 访问令牌地址
          tokenUri: http://oauth2-server:9000/oauth2/token
          # 用于验证JWT签名的、oauth2授权服务器的公钥集合
          jwkSetUri: http://oauth2-server:9000/oauth2/iwks
```



> 注意

```structured text
1.provider 中各个uri的默认值可通过 Authorizationserversettings 查看得知;provider 中各个uri的host部分若写成localhost，导致与回调地址的host一样，会产生cookie覆2 
盖，从而无法获取授权请求;
3.域名"http://oauth2-server"是修改了本机 hosts 文件所得。注意:用管理员身份修改 hosts文件，否则无法保存。
```



> security 配置类开启 OAuth2 的登录



```java

```

