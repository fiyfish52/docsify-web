# 安装fdfs

> 下载压缩包
```bash
wget https://github.com/happyfish100/libfastcommon/archive/V1.0.7.tar.gz
wget http://jaist.dl.sourceforge.net/project/fastdfs/FastDFS%20Nginx%20Module%20Source%20Code/fastdfs-nginx-module_v1.16.tar.gz
wget https://github.com/happyfish100/fastdfs/archive/V5.05.tar.gz
wget http://nginx.org/download/nginx-1.12.1.tar.gz
```

## 安装gcc
>1. 检查gcc是否已安装
```
gcc -v
或
gcc -version
```
>2. 安装gcc
```
yum -y install gcc gcc-c++ autoconf pcre pcre-devel make automake
yum -y install wget httpd-tools vim
```

## 更改下载文件名 
```
mv V5.05.tar.gz  fastdfs-V5.05.tar.gz
mv V1.0.7.tar.gz  libfastcommon-V1.0.7.tar.gz
```

## 安装 libfastcommon

>1. 解压编译
```
tar -xvf libfastcommon-V1.0.7.tar.gz
cd libfastcommon-1.0.7/
./make.sh 
./make.sh install
>> mkdir -p /usr/lib64
>>install -m 755 libfastcommon.so /usr/lib64
>>mkdir -p /usr/include/fastcommon
>>install -m 644 common_define.h hash.h chain.h logger.h base64.h shared_func.h pthread_func.h ini_file_reader.h _os_bits.h sockopt.h sched_thread.h http_func.h md5.h local_ip_func.h avl_tree.h ioevent.h ioevent_loop.h fast_task_queue.h fast_timer.h process_ctrl.h fast_mblock.h connection_pool.h /usr/include/fastcommon
```

>2. 获取so
```
cd ./src
ls libfastc*
```
>3. 复制到 /usr/lib
```
cp libfastcommon.so /usr/lib
```

## 安装FastDFS

>1. 解压并编译

```
tar -xvf fastdfs-V5.05.tar.gz
cd fastdfs-5.05
./make.sh
./make.sh install
```

>2. 安装成功后将目录conf内的文件拷贝到/etc/fdfs目录下：
```
mkdir -p /etc/fdfs
cp ./conf/* /etc/fdfs/
```

## 安装tracker

>1. 创建日志文件：
```
 mkdir -p /home/yuqing/fastdfs
```
>2. 更改配置文件
```
view /etc/fdfs/tracker.conf
```
**端口可不更改**  
>3. 进入/etc/fdfs目录，修改tracker.conf文件。如果不存在，就拷贝tracker.conf.sample文件为tracker.conf，然后再修改：
```
 base_path=/home/yuqing/fastdfs 根据需要更改，此处不更改，更改后的文件路径如果不存在需要提前创建 （注解：日志文件）
 http.server_port=8080 >>> http.server_port=8091 （注解：端口，8091是方便默认）
 store_group=group1 >>> store_group=group2（注解：组名）
```

 

>4. 启动tracker，并查看是启动成功(出现如下提示，表示启动成功)：restart重启
```
fdfs_trackerd /etc/fdfs/tracker.conf start
netstat -unltp | grep tracker
```

## 安装storage

**注意：storage 和tracker 安装文件在一起**  
>1. 由于storage和tracker运行的都是fastDFS程序，每一台服务器都部署一台fasfDFS，一台服务器是tracker，一台是storage

修改storage.conf文件。如果不存在，就拷贝storage.conf.sample文件为storage.conf，然后再修改：

```
view /etc/fdfs/tracker.conf
```

```

#base_path=/home/yuqing/fastdfs >>> base_path=/home/logs/storage 
根据需要更改，此处不更改，更改后的文件路径如果不存在需要提前创建 （注解：日志文件）（日志路径）

#store_path0=/home/yuqing/fastdfs >>> store_path0=/home/data/storage 
根据需要更改，此处不更改，更改后的文件路径如果不存在需要提前创建 （注解：日志文件） （实际储存文件路径，可以配置多个）

tracker_server=192.168.209.121:22122 >>> tracker_server=39.96.36.32:22122 （连接tracker服务器地址）

group_name=group2 （必须和tracker的组名相同）

http.server_port=8091 （这个端口也要改）
```
 

>2. 启动storage，并查看是否成功（出现如下提示，表示启动成功）：

```
fdfs_storaged /etc/fdfs/storage.conf start
```
**注意：启动storaged的时候，启动无响应：原因：如果是在云服务器上启动，因为storaged要访问tracker_server=服务器ip:22122，所以需要开放服务器访问权限**

**云服务器需要开放8888、8091 端口**
```
netstat -unltp | grep storage
```



>3. 最后，查看tracker和storage是不是在通信：
```
fdfs_monitor /etc/fdfs/storage.conf
```
出现ACTIVE，表示二者均正常启动，至此就可以进行上传文件测试了。

![验证成功](../_media/fdfs通信.jpg)

## 测试图片上传

>1. Tracker和storage都已经安装完成，使用命令测试文件上传：
FastDFS提供一个文件上传命令：usr/bin/fdfs_test 测试文件上传。测试上传需要连接tracker服务器，连接storage服务器。因此需要指定一个配置文件：client.conf配置文件，通过Client.conf连接tracker服务器。

>2. 修改/etc/fdfs下client.conf

```
view client.conf
```
**云服务器需要开放23000 端口**
```
base_path=/home/logs/client 根据需要更改，此处不更改，更改后的文件路径如果不存在需要提前创建 （日志目录）
tracker_server=39.96.36.32:22122  （tracker端口）

http.tracker_server_port=8091(外网访问端口)
```

>3. 测试命令
```
/usr/bin/fdfs_test /etc/fdfs/client.conf upload anti-steal.jpg
```
>4. 成功
![上传成功](../_media/fdfs上传成功.jpg)
***
**记录下此路径，后面配置完nginx后，在浏览器访问**

## 配置nginx-fdfs模块（fastdfs-nginx-module）

>1. 首先解压fastdfs-nginx-module_v1.16.tar.gz，修改/fastdfs-nginx-module/src/config文件。去掉所有的local（三个）
   

>2. 拷贝usr/lib64目录下库文件libfdfsclient.so 
```
cp /usr/lib64/libfdfsclient.so /usr/lib 
```

>3. 在nginx安装目录下执行如下命令：把module添加nginx中。通过设置安装参数方式添加模块。
```
cd nginx-1.20.1
./configure --add-module=/usr1/software/fdfs/fastdfs-nginx-module/src
```
**路径为：model绝对位置**

>4. 重新安装编译
```
make && make install
```
**如果在安装过程中遇到【致命错误：fdfs_define.h：没有那个文件或目录】**
```
ln -sv /usr/include/fastcommon /usr/local/include/fastcommon 
ln -sv /usr/include/fastdfs /usr/local/include/fastdfs 
ln -sv /usr/lib64/libfastcommon.so /usr/local/lib/libfastcommon.so
```
**Nginx编译安装错误error: the HTTP gzip module requires the zlib library**

安装zlib依赖即可；



>5. 查看Nginx的模块
```
/usr/local/nginx/sbin/nginx -V
```

>6. 复制 fastdfs-nginx-module 源码中的配置文件到/etc/fdfs 目录， 并修改
```
cd fastdfs-nginx-module/src
cp mod_fastdfs.conf /etc/fdfs/
```
进入/etc/fdfs/修改mod_fastdfs.conf如下配置，其他默认
```
view /etc/fdfs/mod_fastdfs.conf
```

```
    # 连接超时时间
    connect_timeout=10

    # Tracker Server
    tracker_server=39.96.36.32:22122

    # StorageServer 默认端口
    storage_server_port=23000

    group_name=group2

    # 如果文件ID的uri中包含/group**，则要设置为true
    url_have_group_name = true

    # Storage 配置的store_path0路径，必须和storage.conf中的一致
    #store_path0=/home/data/storage
    store_path0=/home/yuqing/fastdfs 无需更改

    # the base path to store log files
    base_path=/home/yuqing/fastdfs  #默认配置，根据实际情况更改
```



>7. 配置Nginx.conf

在8091端口下添加fastdfs-nginx模块
```
#user  nobody;
………………
http {
    include       mime.types;
    default_type  application/octet-stream;

    #log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
    #                  '$status $body_bytes_sent "$http_referer" '
    #                  '"$http_user_agent" "$http_x_forwarded_for"';

    #access_log  logs/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    #keepalive_timeout  0;
    keepalive_timeout  65;

    #gzip  on;

    server {
        listen       8091;
        server_name  39.96.36.32;

        #charset koi8-r;

        #access_log  logs/host.access.log  main;

        location ~/group([0-9])/M00 {
           ngx_fastdfs_module;
        }

         location / {
            root   html;
            index  index.html index.htm;
        }

        error_page  404              /404.html;

        # redirect server error pages to the static page /50x.html
        #
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }

        # proxy the PHP scripts to Apache listening on 127.0.0.1:80
        #
        #location ~ \.php$ {
        #    proxy_pass   http://127.0.0.1;
        #}

        # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
        #
        #location ~ \.php$ {
        #    root           html;
        #    fastcgi_pass   127.0.0.1:9000;
        #    fastcgi_index  index.php;
        #    fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
        #    include        fastcgi_params;
        #}

        # deny access to .htaccess files, if Apache's document root
        # concurs with nginx's one
        #
        #location ~ /\.ht {
        #    deny  all;
        #}
    }

```
**listen 8091 端口值是要与 /etc/fdfs/storage.conf 中的 http.server_port=8091 (前面改成8091了)相对应。如果改成其它端口，则需要统一，同时在防火墙中打开该端口。**  

**location 的配置，如果有多个group则配置location ~/group([0-9])/M00 ，没有则不用配group。**

****


>8. 在文件存储目录下创建软连接，将其链接到实际存放数据的目录，注意这个文件存储的位置后面多个data目录是系统自动生成的
```
cd /home/yuqing/fastdfs
ln -s /home/yuqing/fastdfs/data/ /home/yuqing/fastdfs/data/M00
```

>9. 启动nginx

cd /usr/local/nginx/sbin/nginx
./nginx -c /usr/local/nginx/conf/nginx.conf

**如果是重启nginx：./nginx -s reload -c /usr/local/nginx/conf/nginx.conf**


## 测试 
访问上面测试上传时的路径，能访问则ok。

## 注意

|序号|注意事项|
|--|--|
|1.| 开放端口 22122 23000 8888 8091|
|2.| 创建软连接|
|3.| 重启nginx|


