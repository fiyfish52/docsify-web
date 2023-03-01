# nacos

## 官网安装教程

[官网](https://nacos.io/zh-cn/docs/quick-start-docker.html)

## 具体操作如下

> Clone 项目

```sh
git clone https://github.com/nacos-group/nacos-docker.git
cd nacos-docker
```

> 单机模式 Derby

```sh
docker-compose -f example/standalone-derby.yaml up
```

> 单机模式 MySQL

1. 如果希望使用MySQL5.7

```sh
docker-compose -f example/standalone-mysql-5.7.yaml up
```

2. 如果希望使用MySQL8

```sh
docker-compose -f example/standalone-mysql-8.yaml up
```

> 集群模式

```sh
docker-compose -f example/cluster-hostname.yaml up 
```
