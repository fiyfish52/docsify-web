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

### 配置说明

| 语法                                           | 默认值 | 上下文                  | 说明                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
|----------------------------------------------|-----|----------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| client_header_timeout time                   | 60s | http server          | 指定等待client发送一个请求头的超时时间（例如：GET / HTTP/1.1）.仅当在一次read中，没有收到请求头，才会算成超时。如果在超时时间内，client没发送任何东西，nginx返回HTTP状态码408(“Request timed out”)                                                                                                                                                                                                                                                                                                                                  |
| client_body_timeout time                     | 60s | http server location | 该指令设置请求体（request body）的读超时时间。仅当在一次readstep中，没有得到请求体，就会设为超时。超时后，nginx返回HTTP状态码408(“Request timed out”)                                                                                                                                                                                                                                                                                                                                                              |
| keepalive_timeout timeout [ header_timeout ] | 75s | http server location | 第一个参数指定了与client的keep-alive连接超时时间。服务器将会在这个时间后关闭连接。可选的第二个参数指定了在响应头Keep-Alive: timeout=time中的time值。这个头能够让一些浏览器主动关闭连接，这样服务器就不必要去关闭连接了。没有这个参数，nginx不会发送Keep-Alive响应头（尽管并不是由这个头来决定连接是否“keep-alive”）   两个参数的值可并不相同  --------------注意不同浏览器怎么处理“keep-alive”头   MSIE和Opera忽略掉"Keep-Alive: timeout=<N>" header.   MSIE保持连接大约60-65秒，然后发送TCP RST     Opera永久保持长连接    Mozilla keeps the connection alive for N plus about 1-10 seconds.    Konqueror保持长连接N秒    lingering_timeout |
| lingering_timeout time                       | 5s  | http server location | lingering_close生效后，在关闭连接前，会检测是否有用户发送的数据到达服务器，如果超过lingering_timeout时间后还没有数据可读，就直接关闭连接；否则，必须在读取完连接缓冲区上的数据并丢弃掉后才会关闭连接。                                                                                                                                                                                                                                                                                                                                                |
| resolver_timeout time                        | 30s | http server location | 该指令设置DNS解析超时时间                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| proxy_connect_timeout time                   | 60s | http server location | 该指令设置与upstream server的连接超时时间，有必要记住，这个超时不能超过75秒。 这个不是等待后端返回页面的时间，那是由proxy_read_timeout声明的。如果你的upstream服务器起来了，但是hanging住了（例如，没有足够的线程处理请求，所以把你的请求放到请求池里稍后处理），那么这个声明是没有用的，由于与upstream服务器的连接已经建立了。                                                                                                                                                                                                                                                                      |
| proxy_read_timeout time                      | 60s | http server location | 该指令设置与代理服务器的读超时时间。它决定了nginx会等待多长时间来获得请求的响应。这个时间不是获得整个response的时间，而是两次reading操作的时间                                                                                                                                                                                                                                                                                                                                                                                  |
| proxy_send_timeout time                      | 60s | http server location | 这个指定设置了发送请求给upstream服务器的超时时间。超时设置不是为了整个发送期间，而是在两次write操作期间。如果超时后，upstream没有收到新的数据，nginx会关闭连接                                                                                                                                                                                                                                                                                                                                                                       |
| server address [fail_timeout=30s]            | 10s | upstream             | Upstream模块下 server指令的参数，设置了某一个upstream后端失败了指定次数（max_fails）后，该后端不可操作的时间，默认为10秒                                                                                                                                                                                                                                                                                                                                                                                      |

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

| 负载配置          | 名称      | 说明                                                            |
|---------------|---------|---------------------------------------------------------------|
| `round-robin` | `轮询`    | 对应用服务器的请求以轮询方式分发                                              |
| `least_conn`  | `最少连接`  | 下一个请求被分配给具有最少活动连接数的服务器                                        |
| `ip-hash`     | `ip 哈希` | 一个hash函数用于确定下一个请求应该选择哪个服务器(基于客户端的IP地址)，`确保同一个客户端始终在同一个server` |

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
