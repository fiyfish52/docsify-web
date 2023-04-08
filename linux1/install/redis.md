# redis

Linux系统：VMware 14 中 CentOS 7 64 位
redis版本：redis-stable.tar.gz（当前版本是：redis-cli 4.0.9）

## Linux在线安装redis

> 因为redis是c语言开发的，所以需要安装gcc（在根目录下执行）：

```sh
yum install gcc-c++
```

> 因为是在线安装，需要使用wget命令，如果linux中没有，就用如下命令安装（在根目录下执行）：

```sh
yum -y install wget
```

> 下载redis最新的稳定版本，也可以下载其他版本压缩包，此时会下载到当前目录下

```sh
wget http://download.redis.io/redis-stable.tar.gz
```

> 解压redis压缩包：

```sh
tar xzf redis-stable.tar.gz
```

> 进入到redis的解压文件中，编译redis：

```sh
make
```

> 安装redis：

```sh
make install PREFIX=/usr/local/redis
```

PREFIX参数指定文件的安装目录，一般安装在/usr目录下
/usr/local/目录下已经生成redis目录
> 启动redis，进入redis到安装目录中，即/usr/local/redis/bin：

```sh
./redis-server
```

redis的默认端口是6379，也可以对其进行修改。

## redis的启动

redis分两种启动：

1. 前端启动：

在usr/local/redis/bin/  中执行命令：

```sh
./redis-server
```

前端启动以后，我们不能再继续操作redis,所以一般不用。启动成功后如上图所示。

2. 后台启动：

> 把redis解压文件中的redis.conf文件复制到redis的安装目录下，即/usr/local/redis/bin。
进入到redis的解压文件中，执行命令：

```sh
cp redis.conf /usr/local/redis/bin/
```

复制成功以后，redis安装目录中会多出一个redis.conf文件。
> 修改一下这个配置文件的内容：将daemonize的值由原来的no修改为yes,保存退出。

> 在redis的安装文件的bin目录下输入命令，则redis便会后台启动：

```sh
./redis-server redis.conf
```

> 通过进程查看命令，查看redis有没有启动：

```sh
ps aux | grep redis
```

> 停止redis：

```sh
./redis-cli shutdown
```

## 配置

1. 外部无法访问linux上的redis：

解决Redis.conf配置文件中 注释掉 bind 127.0.0.1

protected-mode no 保护模式（设置为yes之后，外网无法访问）

2. 密码

初始化Redis密码：
   在配置文件中有个参数： requirepass  这个就是配置redis访问密码的参数；
   比如 requirepass test123；
   （Ps:需重启Redis才能生效）
