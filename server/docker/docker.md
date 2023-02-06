# Docker

## 安装docker dockercompose

[安装](/linux/docker.md)


## Dockerfile


> nginx 

直接发布编译后的dist，并使用nginx默认config
```bash
FROM nginx
COPY ./dist /usr/share/nginx/html
```
构建镜像
```
docker build -t local-digit .
```
启动容器
```
docker run -d --name local-digit-80 -p 8891:80 local-digit
```

> 发布jar包
```bash
FROM java:8
MAINTAINER maywide
ADD ./fmind.eureka.boot-0.0.1-SNAPSHOT.jar ./fmind.eureka.boot-0.0.1-SNAPSHOT.jar
ADD ./fmind.eureka.boot-0.0.1-SNAPSHOT-lib ./fmind.eureka.boot-0.0.1-SNAPSHOT-lib
EXPOSE 8000
ENTRYPOINT ["java","-jar","./fmind.eureka.boot-0.0.1-SNAPSHOT.jar"]
```

构建镜像
```
docker build -t local-eureka .
```
启动容器
```
docker run -d --name local-eureka-8000 -p 8000:8000 local-eureka
```

## docker 镜像迁移

> linux系统间迁移
```
docker save  [镜像名或镜像id] | gzip > [压缩文件名].tar.gz
```
```
docker load -i [压缩文件名].tar.gz
```

> 跨系统迁移（win->linux）

使用上面的命令报错：**docker：Untar exit status 1 archive/tar: invalid tar header 错误解决**

使用如下命令镜像文件没有压缩
1. 生成镜像文件

```
docker save [镜像id] -o image.tar
```

2. docker导入镜像

```
docker load -i image.tar
```

3. 启动镜像