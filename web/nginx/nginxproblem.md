# problem

## 文件上传 提示：413 Request Entity Too Large

> 原因

Nginx默认的request body为1M

> 解决方案

nginx.conf配置文件,在http{}中加入

```sh
client_max_body_size 10m;
```

然后重启nginx
