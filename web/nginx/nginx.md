# nginx

## 负载均衡

```sh
跨多个应用程序实例的负载平衡是优化资源利用、最大化吞吐量、减少延迟和确保容错配置的常用技术。
可以使用nginx作为一个非常高效的HTTP负载均衡器，将流量分配到多个应用服务器，并使用nginx提高web应用程序的性能、可扩展性和可靠性。
```

### 配置

[官网地址](https://nginx.org/en/docs/http/load_balancing.html)

```sh
upstream gateways{
    server 192.168.6.29:9527 weight=1;
    server 192.168.6.29:9528 weight=1;
}
server {
    listen 80;
    server_name 192.168.6.29;
    charset utf8;

    location /{
        ...
        proxy_pass http://gateways;
        ...
    }
}
```

### 负载方案

```sh
round-robin — requests to the application servers are distributed in a round-robin fashion,
least-connected — next request is assigned to the server with the least number of active connections,
ip-hash — a hash-function is used to determine what server should be selected for the next request (based on the client’s IP address).
```

```sh
  upstream myapp1 {
        least_conn;
        server srv1.example.com;
        server srv2.example.com;
        server srv3.example.com;
    }
```

| 负载配置      | 名称       | 说明                                                                                                       |
| ------------- | ---------- | ---------------------------------------------------------------------------------------------------------- |
| `round-robin` | `轮询`     | 对应用服务器的请求以轮询方式分发                                                                           |
| `least_conn`  | `最少连接` | 下一个请求被分配给具有最少活动连接数的服务器                                                               |
| `ip-hash`     | `ip 哈希`  | 一个hash函数用于确定下一个请求应该选择哪个服务器(基于客户端的IP地址)，`确保同一个客户端始终在同一个server` |

### 权重

?> 使用此配置，每5个新请求将在应用程序实例之间分布如下:3个请求将定向到srv1，一个请求将定向到srv2，另一个请求将定向到srv3。

```sh
  upstream myapp1 {
        server srv1.example.com weight=3;
        server srv2.example.com;
        server srv3.example.com;
    }
```

## HTTPS

[官网地址](https://nginx.org/en/docs/http/configuring_https_servers.html)

## 集群

?> upstream + keepalived
