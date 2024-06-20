# fastdfs

## 关于FastDFS

FastDFS 是以 C 语言开发的一项开源轻量级分布式文件系统，他对文件进行管理，主要功能有：`文件存储`，`文件同步`，`文件访问（文件上传/下载）`等，特别适合以文件为载体的在线服务，如：图片网站，视频网站等。

外话：FastDFS 是阿里余庆大神做的一个个人项目，从2008年研发FastDFS开源至今，在一些互联网创业公司中备受推崇，GitHub开源地址：https://github.com/happyfish100/fastdfs

## Docker搭建

### 搜索镜像

执行命令：

```sh
docker search fastdfs
```

补充： 其实看这些镜像的描述也能看出一些区别来的，比如 ygqygq2/fastdfs-nginx，该镜像是整合了 Nginx 的 fastdfs，那么新的问题来了，为什么要整合 Nginx？因为对于 fastdfs 来说，安装后只能在本机访问… 我上传文件肯定是为了能够访问的呀，所以为了提供 web 访问，那么就需要集成 Nginx 了，但是比如就是想自己单独搞 Nginx… 那么肯定就不会选了嘛，season/fastdfs 镜像相对纯净些，本文就是基于 season/fastdfs 镜像的，后面也附带配置 Nginx…

### 安装镜像

```sh
docker pull season/fastdfs
```

### 创建容器并挂载目录

在创建容器之前我们先简单说一下 FastDFS，FastDFS 系统有三个角色：

`跟踪服务器`(Tracker Server)：跟踪服务器，主要做调度工作，起到均衡的作用；负责管理所有的 storage server和 group，每个 storage 在启动后会连接 Tracker，告知自己所属 group 等信息，并保持周期性心跳。

`存储服务器`(Storage Server)：存储服务器，主要提供容量和备份服务；以 group 为单位，每个 group 内可以有多台 storage server，数据互为备份。

`客户端`(Client)：上传下载数据的服务器，也就是我们自己的项目所部署在的服务器。

说到这就是想告诉小伙伴，接下来我们可能创建 跟踪服务器容器、存储服务器容器、客户端容器 这三个容器…

### 创建出所需要的目录

我们先把需要的一些目录创建出来(数据目录、数据存储目录等)，执行命令：

```sh
mkdir -p ./tracker/data
mkdir -p ./storage/data
mkdir -p ./storage/path
```

### 创建tracker容器（跟踪服务器容器）

```sh
docker run -id --name tracker \
-p 22122:22122 \
--restart=always --net host \
-v /usr1/bin/docker/dockerimage/fastdfs/tracker/data:/fastdfs/tracker/data \
season/fastdfs tracker
```

> 指令说明

| 指令   | 说明                                             |
| ------ | ------------------------------------------------ |
| -d     | 让容器在后台运行                                 |
| -p     | 指定容器内部使用的网络端口映射到我们使用的主机上 |
| --name | 指定容器创建的名称                               |
| -v     | 容器跟宿主机之间的挂载目录                       |

### 创建storage容器（存储服务器容器）

执行命令（非最终执行命令，请修改为自己的ip地址）：

```sh
docker run -id --name storage \
--restart=always --net host \
-v /usr1/bin/docker/dockerimage/fastdfs/storage/path:/fastdfs/store_path \
-e TRACKER_SERVER="127.0.0.1:22122" \
season/fastdfs storage
```

### client测试


两个容器创建完之后，但此时两个容器其实并没有关联起来，我们进入tracker容器，通过client.conf测试一下：

```sh
docker exec -it tracker bash
```

```sh
cd /etc/fdfs/
```

```sh
ls
```

```sh
cat client.conf
```

输出的 client.conf 都是默认配置，我们可以找到其中的 `track_server` 地址

```sh
# tracker_server can ocur more than once, and tracker_server format is
#  "host:port", host can be hostname or ip address
tracker_server=177.2.33.109:22122
```

##### 修改client.conf配置文件

修改storage.conf配置文件
通过 `docker exec -it tracker bash` 进入 `tracker` 容器后不能使用 `vi` `vim` 命令，将 `client.conf` 配置文件复制出来，在宿主机修改完再粘贴回去。

执行命令：

```sh
docker cp tracker:/etc/fdfs/client.conf /usr1/maywide/bin/dockerimage/fdfs
```

```sh
vi client.conf
```

> 修改1

```sh
# tracker_server can ocur more than once, and tracker_server format is
#  "host:port", host can be hostname or ip address
tracker_server=177.2.33.109:22122


#HTTP settings
http.tracker_server_port=8091

```

> 修改2

```sh
# the base path to store log files
base_path=/fastdfs/store_path
```

> 修改后保存，然后将修改后的文件替换回去。指令命令：

```sh
docker cp /usr1/maywide/bin/dockerimage/fdfs/client.conf tracker:/etc/fdfs
```


##### 修改storage.conf配置文件

```sh
docker cp tracker:/etc/fdfs/storage.conf /usr1/maywide/bin/dockerimage/fdfs
```

```sh
vi storage.conf
```

> 修改1

```sh
# tracker_server can ocur more than once, and tracker_server format is
#  "host:port", host can be hostname or ip address
tracker_server=192.168.209.121:22122
```

`修改为`

```sh
# tracker_server can ocur more than once, and tracker_server format is
#  "host:port", host can be hostname or ip address
tracker_server=177.2.33.109:22122
```

> 保存，然后将修改后的文件替换回去。指令命令：

```sh
docker cp /usr1/maywide/bin/dockerimage/fdfs/storage.conf tracker:/etc/fdfs
```

##### 文件上传测试

> 进入 tracker 容器中：

```sh
docker exec -it tracker bash
```

> 创建一个 txt 文件：

```sh
echo "niceyoo" > niceyoo.txt
```

> 然后通过 fdfs_upload_file 命令将 niceyoo.txt 文件上传至服务器：

```sh
fdfs_upload_file /etc/fdfs/client.conf niceyoo.txt
```

上传后返回文件名：`group1/M00/00/00/rBEABmQ3wHaAJr6RAAAACBfWGpM166.txt`

后面配置nginx时配置访问文件路径。

> 查看宿主机文件路径：

```sh
cd /usr1/maywide/bin/dockerimage/fdfs/storage/path/data/00/00
ls
```



#### docker安装 fdfs-Nginx

访问fdfs 文件服务器内容

##### 制作nginx 二进制文件

制作包含 `fastdfs-nginx-module` 的nginx启动文件；

文件位置：14陕西省网BOSS2项目\社会代理商管理系统平台\05代码\正式环境部署\环境\docker-images\fdfs\

```sh
./configure --prefix=/etc/nginx --sbin-path=/usr/sbin/nginx --modules-path=/usr/lib/nginx/modules --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx.pid --lock-path=/var/run/nginx.lock --http-client-body-temp-path=/var/cache/nginx/client_temp --http-proxy-temp-path=/var/cache/nginx/proxy_temp --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp --http-scgi-temp-path=/var/cache/nginx/scgi_temp --user=nginx --group=nginx --with-compat --with-threads --with-http_addition_module --with-http_auth_request_module --with-http_dav_module --with-http_flv_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_mp4_module --with-http_random_index_module --with-http_realip_module --with-http_secure_link_module --with-http_slice_module --with-http_ssl_module --with-http_stub_status_module --with-http_sub_module --with-http_v2_module --with-mail --with-mail_ssl_module --with-stream --with-stream_realip_module --with-stream_ssl_module --with-stream_ssl_preread_module --add-module=/usr1/maywide/bin/dockerimage/fdfs/nginx/fastdfs-nginx-module/src --with-openssl=/usr1/maywide/bin/dockerimage/fdfs/nginx/openssl-1.1.1l/
```

```sh
make
```

##### 创建nginx目录

```sh
mkdir -p /usr1/maywide/bin/dockerimage/fdfs/nginx
```

```sh
cd /usr1/maywide/bin/dockerimage/fdfs/nginx
```

##### 上传 fastdfs-nginx-module

文件位置：14陕西省网BOSS2项目\社会代理商管理系统平台\05代码\正式环境部署\环境\docker-images\fdfs\

`fastdfs-nginx-module-maywide.tar.gz`
`libfastcommon.so`
`libfdfsclient.so`
`nginx-fdfs.tar.gz`
`openssl-1.1.1l.tar.gz`

```sh
tar -xvf fastdfs-nginx-module-maywide.tar.gz
```

```sh
tar -xvf openssl-1.1.1l.tar.gz
```

```sh
tar -xvf nginx-fdfs.tar.gz
```

##### 更改nginx.conf 配置

?> nginx 镜像中没有

##### 启动容器

```sh
docker run -d \
    --name fdfs-nginx \
    --restart=always \
    -p 8091:8091 \
    -v /usr1/maywide/bin/dockerimage/fdfs/nginx/nginx-fdfs/data/conf/nginx:/etc/nginx \
    -v /usr1/maywide/bin/dockerimage/fdfs/nginx/nginx-fdfs/data/web/html:/usr/share/nginx/html \
    -v /usr1/maywide/bin/dockerimage/fdfs/nginx/nginx-fdfs/data/logs/nginx:/var/log/nginx \
    -v /usr1/maywide/bin/dockerimage/fdfs/nginx/tmp:/fastdfs/tmp \
    -v /usr1/maywide/bin/dockerimage/fdfs/storage/path:/fastdfs/store_path \
    -v /usr1/maywide/bin/dockerimage/fdfs/nginx/fastdfs-nginx-module:/usr1/maywide/bin/dockerimage/fdfs/nginx/fastdfs-nginx-module \
    -v /usr1/maywide/bin/dockerimage/fdfs/nginx/openssl-1.1.1l:/usr1/maywide/bin/dockerimage/fdfs/nginx/openssl-1.1.1l \
    nginx
```

##### 拷贝配置文件

```sh
docker cp /usr1/maywide/bin/dockerimage/fdfs/nginx/fastdfs-nginx-module/src/mod_fastdfs.conf fdfs-nginx:/etc/fdfs/
```

```sh
docker cp /usr1/maywide/bin/dockerimage/fdfs/nginx/nginx-fdfs/nginx fdfs-nginx:/usr/sbin/
```

```sh
docker cp /usr1/maywide/bin/dockerimage/fdfs/nginx/libfastcommon.so fdfs-nginx:/usr/lib/
```

```sh
docker cp /usr1/maywide/bin/dockerimage/fdfs/nginx/libfdfsclient.so fdfs-nginx:/usr/lib/
```

##### 获取fdfs配置信息

```sh
docker cp tracker:/etc/fdfs/http.conf /usr1/maywide/bin/dockerimage/fdfs/nginx/nginx-fdfs
docker cp tracker:/etc/fdfs/mime.types /usr1/maywide/bin/dockerimage/fdfs/nginx/nginx-fdfs
```

拷贝到 fdfs-nginx

```sh
docker cp /usr1/maywide/bin/dockerimage/fdfs/nginx/nginx-fdfs/http.conf fdfs-nginx:/etc/fdfs/
docker cp /usr1/maywide/bin/dockerimage/fdfs/nginx/nginx-fdfs/mime.types fdfs-nginx:/etc/fdfs/
```

##### 处理文件链接

在文件存储目录下创建软连接，将其链接到实际存放数据的目录，注意这个文件存储的位置后面多个data目录是系统自动生成的

```sh
docker exec -it fdfs-nginx bash
```

```sh
mkdir /fastdfs/store_path/data/M00
```

```sh
cd /fastdfs/store_path
```

```sh
ln -s /fastdfs/store_path/data /fastdfs/store_path/data/M00
```

##### 重启 容器

```sh
docker restart fdfs-nginx
```

```sh
docker restart tracker
```

```sh
docker restart storage
```

##### 测试nginx访问

我们测试一下之前上传的文件 `group1/M00/00/00/CtM3BF84iz2AWE_JAAAACBfWGpM793.txt`，执行如下命令：

```sh
curl -i http://177.2.33.109:8091/group1/M00/00/00/CtM3BF84iz2AWE_JAAAACBfWGpM793.txt
```
