#

## 网关 gateway

> 官网

[官网](https://docs.spring.io/spring-cloud-gateway/docs/3.0.8/reference/html/#gateway-request-predicates-factories)

> 选择版本

[不同版本](https://spring.io/projects/spring-cloud-gateway#learn)

> 允许跨域配置

与版本相关性较大，仅作参考

cloud：`Hoxton.SR9` springboot: `2.3.7.RELEASE`

```yml
spring:
  cloud:
    gateway:
      #   gateway 解决跨域问题
      globalcors: # 全局的跨域处理
        add-to-simple-url-handler-mapping: true # 解决options请求被拦截问题
        corsConfigurations:
          '[/**]':
            allowedOrigins: "*"
              # 允许哪些网站的跨域请求
            #              - "http://localhost:8090"
            allowedMethods: "*"
            # 允许的跨域ajax的请求方式
            #              - "GET"
            #              - "POST"
            #              - "DELETE"
            #              - "PUT"
            #              - "OPTIONS"
            #  "*" 代表允许所有请求
            allowedHeaders: "*" # 允许在请求中携带的头信息
            allowCredentials: true # 是否允许携带cookie
            maxAge: 360000 # 这次跨域检测的有效期
      discovery:
        locator:
          enabled: false #设置为true 请求路径前可以添加微服务名称
          lower-case-service-id: true # 允许转为小写


      routes: #集合。
        - id: oauth2-auth  #ID：唯一标示，默认是一个UUID
          uri: lb://auth
          predicates: #predicates: 条件，用于请求网关路径的匹配规则
            - Path=/auth/**
        - id: oauth2-order  #ID：唯一标示，默认是一个UUID
          uri: lb://order
          predicates: #predicates: 条件，用于请求网关路径的匹配规则
            - Path=/order/**

        - id: oauth2-account  #ID：唯一标示，默认是一个UUID
          uri: lb://account
          predicates: #predicates: 条件，用于请求网关路径的匹配规则
            - Path=/account/**

#   网关自己的有的负载均衡
      global-filter:
        load-balancer-client:
          enabled: true
```

## spring-security 5.3.6


