# 统一认证设计

## 前言

服务端：
认证方式：提供Oauth2协议认证方式；
用户、权限管理： user-server：用于返回用户信息以及权限信息；
第三方客户端管理： client-server：提供注册能力

前端：
    用户、权限管理界面；
    第三方客户端管理界面；


## 认证服务

第三方客户端注册信息：
clientId：（必须的）第三方用户的id（可理解为账号）---第三方账户
clientSecret：第三方应用和授权服务器之间的安全凭证(可理解为密码) -----第三方密码
scope：指定客户端申请的权限范围,可选值包括read,write,trust;其实授权赋予第三方用户可以在资源服务器获取资源，第三方访问资源的一个权限，访问范围。----第三方的可访问范围
resourceIds：客户端所能访问的资源id集合
authorizedGrantTypes： 此客户端可以使用的授权类型，默认为空。
accessTokenValiditySeconds： 设定客户端的access_token的有效时间值(单位:秒),可选, 若不设定值则使用默认的有效时间值(60 * 60 * 12, 12小时).
refreshTokenValiditySeconds： 设定客户端的refresh_token的有效时间值(单位:秒),可选, 若不设定值则使用默认的有效时间值(60 * 60 * 24 * 30, 30天).


## 认证方式 grant_type

> client_credentials:客户端模式；
```
localhost:8761/auth/oauth/token?client_id=clientId01&client_secret=secret&grant_type=client_credentials
```
> password:用户名密码模式；
```
localhost:8761/auth/oauth/token?client_id=clientId01&client_secret=secret&grant_type=password&username=admin&password=admin
```
> implicit:简明模式；
```
localhost:8761/auth/oauth/authorize?client_id=clientId01&response_type=token&scope=all&redirect_uri=http://www.baidu.com
```
> authorization-code：授权码模式；
```
localhost:8761/auth/oauth/authorize?client_id=clientId01&response_type=code&scope=all&redirect_uri=http://www.baidu.com

localhost:8761/auth/oauth/token?grant_type=authorization_code&code=NMhOWc&client_id=clientId01&client_secret=secret&redirect_uri=http://www.baidu.com
```

## 