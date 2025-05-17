# nginx(SSl)



## certbot  生成证书

### 安装 certbot

sudo yum install epel-release;

sudo yum install certbot;

certbot --version



#### 如果有问题需要调整环境

sudo pip uninstall urllib3

sudo pip install urllib3

sudo easy_install urllib3==1.21.1

sudo pip install --upgrade --force-reinstall 'requests==2.6.0'

### 获取证书

```sh
certbot certonly --standalone -d yourdomain.com
```

```sh
Saving debug log to /var/log/letsencrypt/letsencrypt.log
Requesting a certificate for www.shanzha.work

Successfully received certificate.
Certificate is saved at: /etc/letsencrypt/live/www.shanzha.work/fullchain.pem
Key is saved at:         /etc/letsencrypt/live/www.shanzha.work/privkey.pem
This certificate expires on 2025-06-17.
These files will be updated when the certificate renews.
Certbot has set up a scheduled task to automatically renew this certificate in the background.
*
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
If you like Certbot, please consider supporting our work by:
 * Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
 * Donating to EFF:                    https://eff.org/donate-le
```



### 将证书文件复制到 `ssl` 目录：

```
cp /etc/letsencrypt/live/www.shanzha.work/fullchain.pem ./ssl/certificate.crt
cp  /etc/letsencrypt/live/www.shanzha.work/privkey.pem ./ssl/private.key
```

### 自动续期

1. 添加定时任务，自动续期证书：

   ```
   crontab -e
   ```

2. 添加以下内容（每天凌晨 2 点检查续期）：

   ```
   0 2 * * * certbot renew --quiet --post-hook "docker-compose -f /path/to/docker-compose.yml restart nginx"
   ```

./nginx -c /usr1/maywide/bin/nginx-openssl/nginx-ssl/conf/nginx.conf

## 部署nginx

###  **创建 `docker-compose.yml` 文件**

在项目目录中创建 `docker-compose.yml` 文件：

```
version: '3.8'

services:
  nginx:
    image: nginx:latest
    container_name: nginx-https
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
      - ./ssl:/etc/nginx/ssl
      - ./html:/usr/share/nginx/html
    networks:
      - nginx-network

networks:
  nginx-network:
    driver: bridge
```

- **说明**：
  - `ports`：将主机的 80 和 443 端口映射到容器。
  - `volumes`：
    - 挂载 Nginx 配置文件。
    - 挂载 SSL 证书目录。
    - 挂载静态文件目录（如 `./html`）。

### nginx.conf

```
events {}

http {
    server {
        listen 443 ssl;
        server_name www.shanzha.work;

        ssl_certificate /etc/nginx/ssl/certificate.crt;
        ssl_certificate_key /etc/nginx/ssl/private.key;


       location ^~ /AccountApi/ {
            rewrite ^/AccountApi/(.+) /$1 break;
            proxy_set_header Host $host;
            proxy_set_header X-Real-Ip $remote_addr;
            proxy_set_header X-Real-Port $remote_port;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_pass http://39.96.36.32:8791;
        }

            location / {
           root   /usr/share/nginx/html/docsify-web;
           index  index.html ;
       }

    }

    server {
        listen 80;
        server_name www.shanzha.work;
        return 301 https://$host$request_uri;
    }
}
```

