# nginx

## 查找镜像

```sh
docker search nginx
```

## 拉取镜像

```sh
docker pull nginx
```

## 启动临时容器

```sh
docker run --name test-nginx -d nginx
```

## 拷贝配置文件到宿主要挂载文件路径位置

```sh
docker cp test-nginx:/etc/nginx /usr1/maywide/bin/dockerimage/nginx/data
docker cp test-nginx:/var/log/nginx /usr1/maywide/bin/dockerimage/nginx/data/logs
docker cp test-nginx:/usr/share/nginx/html /usr1/maywide/bin/dockerimage/nginx/data/html
```

## 停止并删除临时容器

```sh
docker ps -a
```

```sh
docker stop containerid
```

```sh
docker rm containerid
```

## 启动正式容器

```sh
docker run -d \
    --name prod-nginx \
    --restart=always \
    -p 80:80 \
    -v /usr1/maywide/bin/dockerimage/nginx/data:/etc/nginx \
    -v /usr1/maywide/bin/dockerimage/nginx/data/html:/usr/share/nginx/html:ro \
    -v /usr1/maywide/bin/dockerimage/nginx/data/logs:/var/log/nginx \
    nginx
```
