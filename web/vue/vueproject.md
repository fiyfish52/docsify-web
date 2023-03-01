# vue project

## 配置跨域代理

[官网](https://cli.vuejs.org/zh/config/#devserver-proxy)

> 文件位置

`vue.config.js`

> 设置跨域跳转

```sh
前端请求路径："http://localhost/knbs/user/userOpt/userinfos?username=admin"

=>

跳转到："http://localhost:8773/user/userOpt/userinfos?username=admin"
```

```javascript
//认证服务
const UserServerHost = "http://localhost:8773/"
…………
proxy: {
    '/knbs/user': {
    target: UserServerHost,
    changeOrigin: true, // 启用跨域
    logLevel: 'debug', // 打印跳转日志
    pathRewrite: {
        '^/knbs/': ''
    }
    }
}
```

> 配置 logLevel 打印跳转日志

```sh
[HPM] Rewriting path from "/knbs/user/userOpt/userinfos?username=admin" to "user/userOpt/userinfos?username=admin"
[HPM] GET /knbs/user/userOpt/userinfos?username=admin ~> http://localhost:8783/
[HPM] Rewriting path from "/knbs/user/userOpt/userinfos?username=admin" to "user/userOpt/userinfos?username=admin"
[HPM] GET /knbs/user/userOpt/userinfos?username=admin ~> http://localhost:8783/

```

## vue 启动绑定 host

[vue-cli-service命令](https://cli.vuejs.org/zh/guide/cli-service.html#vue-cli-service-serve)

```json
 "serve": "vue-cli-service serve --host 127.0.0.1"
```
