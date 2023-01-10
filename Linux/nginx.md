# Nginx
[官网](https://nginx.org/en/download.html)

## 安装依赖
	
>1. GCC  

GNU编译器集合（GCC可以使用默认包管理器的仓库（repositories）来安装，包管理器的选择依赖于你使用的Linux发布版本，包管理器有不同的实现：yum是基于Red Hat的发布版本；apt用于Debian和Ubuntu；yast用于SuSE Linux等等。）
```
yum install gcc
```
>2. PCRE库

（Nginx编译需要PCRE（Perl Compatible Regular Expression），因为Nginx的Rewrite模块和HTTP核心模块会使用到PCRE正则表达式语法。这里需要安装两个安装包pcre和pcre-devel。第一个安装包提供编译版本的库，而第二个提供开发阶段的头文件和编译项目的源代码，这正是我们需要的理由。）
```
yum install pcre pcre-devel
```
>3. zlib库

（zlib库提供了开发人员的压缩算法，在Nginx的各种模块中需要使用gzip压缩。如同安装PCRE一样，同样需要安装库和它的源代码：zlib和zlib-devel。）
```
yum install zlib zlib-devel
```
>4. OpenSSL库

（在Nginx中，如果服务器提供安全网页时则会用到OpenSSL库，我们需要安装库文件和它的开发安装包（openssl和openssl-devel）。）
```
yum install openssl openssl-devel
```
## 安装

```
wget http://nginx.org/download/nginx-1.20.1.tar.gz
```
```
tar -xvf nginx-1.20.1.tar.gz
```
```
cd nginx-1.20.1
```
```
./configure   （后面可添加参数，更改安装路径等信息）
```
```
make
```
```
make install
```

## 命令
指定配置文件启动：nginx -c 配置文件路径

重启：nginx -s reload -c 配置文件

停止: nginx -s stop 


## 安装ssl模块

安装改模块后，可配置https访问

>1. 准备

备份nginx/sbin/nginx文件，停止nginx程序
```
ps -ef|grep nginx
kill -9 pid1 pid2
```

>2. 下载openssl

```
wget https://www.openssl.org/source/openssl-1.1.1l.tar.gz
```
```
tar zxfv openssl-1.1.1l.tar.gz
```
>4. 官网下载nginx版本

```
wget https://nginx.org/download/nginx-1.19.9.tar.gz
```
```
tar -zxvf nginx-1.19.9.tar.gz
```

>5. 编译

```
cd nginx-1.19.9
```
**注意，执行nginx 编译命令（./configure）前，若是nginx升级，可以新建一个安装目录，并配置给： --prefix 这样安装的时候，就不会影响已安装的程序**
```
mkdir -p /usr1/maywide/bin/nginx_1_22
```
```
./configure --prefix=/usr1/maywide/bin/nginx_1_22/nginx  --with-openssl=/usr1/maywide/bin/nginx_1_22/openssl-1.1.1s  --with-http_ssl_module --with-http_dav_module --with-http_mp4_module --with-http_flv_module --with-http_realip_module --with-http_addition_module --with-http_stub_status_module --with-http_sub_module --with-http_random_index_module --with-http_degradation_module --with-http_secure_link_module --with-http_gzip_static_module   --with-debug --with-file-aio --with-mail --with-mail_ssl_module --with-stream --with-ld-opt="-Wl,-E"
```

```
make && make install
```

>6. 查看版本

生成了新文件/usr1/maywide/tkh/install-web/bin/nginx/，查看nginx版本号，升级成功
```
nginx -V
```

>7. 替换可执行文件

文件通用，可将此版本可执行文件（nginx/sbin 下的nginx）替换到其他项目（原有nginx/sbin 下），并赋予755权限
```
chmod +x nginx
```
然后重启nginx即可

## nginx.config 配置（包含ssl配置）

>1. 示例一
```
	server {
	#	listen 443 ssl;
        listen       8030 ssl ;
        server_name  192.168.81.215;
		ssl_certificate  ssl/tkhapplication.pem;
		ssl_certificate_key ssl/tkhapplication.key;
		ssl_session_timeout 5m;
		ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE:ECDH:AES:HIGH:!NULL:!aNULL:!MD5:!ADH:!RC4;  
		ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
		ssl_prefer_server_ciphers on; 
		# 记录日志
          access_log /usr1/nginxssl/nginx/logs/access_base.log daily_log;
		
		location ^~ /Auth/{
            rewrite ^/Auth/(.+) /$1 break;
			proxy_set_header Host $host;
		    proxy_set_header X-Real-Ip $remote_addr;
		    proxy_set_header X-Real-Port $remote_port;
		    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
		    proxy_pass http://GATEWAY;
	   }  
		
        location / {
            root   /usr1/web;
            try_files $uri $uri/ /index.html
            index  index.html index.htm;
            add_header 'Access-Control-Allow-Origin' '*';
        }

        #error_page  404              /404.html;

        # redirect server error pages to the static page /50x.html
        #
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }
    }
```
>2. 示例二
```
	server {
        listen       8060 ssl;
		server_name  192.168.81.215;
        ssl_certificate  ssl/tkhapplication.pem;
		ssl_certificate_key ssl/tkhapplication.key;
		ssl_session_timeout 5m;
		ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE:ECDH:AES:HIGH:!NULL:!aNULL:!MD5:!ADH:!RC4;
		ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
		ssl_prefer_server_ciphers on;

		# 记录日志
        access_log /usr1/nginxssl/nginx/logs/access_base.log daily_log;

		
		location ^~ /tkh/Auth/ {
            rewrite ^/tkh/(.+) /$1 break;
			proxy_set_header Host $host;
		    proxy_set_header X-Real-Ip $remote_addr;
		    proxy_set_header X-Real-Port $remote_port;
		    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
		    proxy_pass http://192.168.81.216:8775;
	    }  
		location ^~ /tkh/BaseParams/ {
 	 		rewrite ^/tkh/(.+) /$1 break;
            proxy_set_header Host $host;
			proxy_set_header X-Real-Ip $remote_addr;
			proxy_set_header X-Real-Port $remote_port;
			proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
			proxy_pass http://192.168.81.216:8778;
		}
```
>3. 示例三
```
http {

    upstream NODEINFO {
        server 172.16.101.20:8763;
        ip_hash;
    }
    upstream INFO {
        server 172.16.101.11:7800;
        ip_hash;
    }
	………………
	server {
      listen       8762;
      server_name  localhost;
      access_log /usr1/log/nginx/rmtrate.log daily_log;
     
     location /rmtrate/channelio/total/info {
          rewrite ^(.*) channelio/total/info break;
          proxy_set_header Host $host;
          proxy_set_header X-Real-Ip $remote_addr;
          proxy_set_header X-Real-Port $remote_port;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_pass http://INFO;
      }
	location ^~ /rmtrate/NODE/ {
            rewrite ^/rmtrate/NODE/(.+) /$1 break;
	    proxy_set_header Host $host;
            proxy_set_header X-Real-Ip $remote_addr;
            proxy_set_header X-Real-Port $remote_port;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_pass http://NODEINFO;
      }
      
       location ^~ /rmtrate/LOCALGO/ {
            rewrite ^/rmtrate/LOCALGO/(.+) /$1 break;
	    proxy_set_header Host $host;
            proxy_set_header X-Real-Ip $remote_addr;
            proxy_set_header X-Real-Port $remote_port;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_pass http://INFO;
      }
     
      location /rmtrate/ {
            alias   /usr1/nioe-center/vue/rmtrate/;
            try_files $uri $uri/ /index.html
            index  index.html index.htm;
            add_header 'Access-Control-Allow-Origin' '*';
      }
      error_page   500 502 503 504  /50x.html;
      location = /50x.html {
            root   html;
      }
    }

}
```











## 安装遇到的问题

>1.	./configure: error: the HTTP rewrite module requires the PCRE library.
You can either disable the module by using --without-http_rewrite_module
option, or install the PCRE library into the system, or build the PCRE library
statically from the source with nginx by using --with-pcre=<path> option.

安装 pcre pcre-devel
```
yum -y install pcre pcre-devel
```