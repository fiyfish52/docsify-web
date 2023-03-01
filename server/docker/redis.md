# redis

## 获取Redis镜像

> 直接下载

```sh
docker search redis
```

> 下载特定版本

查找所有版本：

```sh
docker search redis
```

下载

```sh
docker pull redis
```

> 查看本地镜像

linux

```sh
docker images | grep redis
```

windows

```sh
docker images | grep redis
```

## 使用自定义配置文件

> 创建redis.conf

?> 由于docker上的redis版本与 redis官网不一定一至，所以 这里的`redis.config` 与redis镜像可能不一致，配置文件中某些配置项可能会报错。直接在官网下载对应的版本,然后拷贝其对应的`redis.config`

[官网下载页](https://redis.io/download/)

[下载路径](http://download.redis.io/redis-stable/redis.conf)

[样例-可直接使用](/server/redis/redis.conf?id=%e4%bf%ae%e6%94%b9%e5%90%8e)

> 修改配置文件

必选

```sh
bind 127.0.0.1 #注释掉这部分，这是限制redis只能本地访问

protected-mode no #默认yes，开启保护模式，限制为本地访问

requirepass Maywide123 #设置密码
```

可选

```sh
daemonize no #默认no，改为yes意为以守护进程方式启动，可后台运行，除非kill进程，改为yes会使配置文件方式启动redis失败

databases 16 #数据库个数（可选），我修改了这个只是查看是否生效。。

dir  ./ #输入本地redis数据库存放文件夹（可选）

appendonly yes #redis持久化（可选）
```

## 启动

> 快速启动

```sh
docker run -itd --name redis-test -p 6379:6379 redis
```

`-p 6379:6379`：映射容器服务的 6379 端口到宿主机的 6379 端口。
外部可以直接通过宿主机ip:6379 访问到 Redis 的服务。

> 配置文件启动

windows

```sh
docker run -p 26379:6379 --name myredis -v D:/sixDgrs/docker/redis/redis.conf:/etc/redis/redis.conf -v D:/sixDgrs/docker/redis/data:/data -d redis redis-server /etc/redis/redis.conf --appendonly yes
```

linux

```sh
docker run -p 26379:6379 --name myredis -v /usr/local/docker/redis/redis.conf:/etc/redis/redis.conf -v /usr/local/docker/redis/data:/data -d redis redis-server /etc/redis/redis.conf --appendonly yes
```

`-p 26379:6379` 端口映射：前表示主机部分，：后表示容器部分。

`--name myredis` 指定该容器名称，查看和进行操作都比较方便。

`-v` 挂载目录，规则与端口映射相同。

**为什么需要挂载目录：个人认为docker是个沙箱隔离级别的容器，这个是它的特点及安全机制，不能随便访问外部（主机）资源目录，所以需要这个挂载目录机制。**

例： `-v /usr/local/docker/redis/redis.conf:/etc/redis/redis.conf` 容器 `/etc/redis/redis.conf` 配置文件 映射宿主机 `/usr/local/docker/redis/redis.conf`。
会将宿主机的配置文件复制到docker中

**配置文件映射，docker镜像redis 默认无配置文件。**

`-d redis` 表示后台启动redis
`redis-server /etc/redis/redis.conf` 以配置文件启动redis，加载容器内的conf文件，最终找到的是挂载的目录/usr/local/docker/redis/redis.conf
**docker 镜像reids 默认 无配置文件启动**
`--appendonly yes` 开启redis 持久化

## 查看是否成功

windows

```sh
 docker ps
```

linux

```sh
docker ps -a | grep redis
```

## 测试


> telnet

```sh
telnet 127.0.0.1 26379
auth 密码
set a 1
get a
```

> docker

1. 获取镜像ID: `CONTAINERID`

```sh
docker ps
```

2. 进入容器

`CONTAINERID` 镜像id

```sh
docker exec -it CONTAINERID redis-cli
```

3. 认证

```sh
auth 密码
```
