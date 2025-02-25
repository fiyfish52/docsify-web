# Docker

## 安装docker dockercompose

[安装](/linux1/install/docker.md)

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

## 访问宿主机服务 即访问 localhost

| 指定通信个体	 | 别名                   |
|---------|----------------------|
| 解释成容器	  | localhost或127.0.0.1  |
| 解释成主机	  | host.docker.internal | 
