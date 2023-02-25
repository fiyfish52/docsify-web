# elasticsearch 安装


## 安装
> 查找镜像

```sh
docker search elasticsearch
```

> 拉取镜像

docker pull 镜像名

```sh
docker pull elasticsearch
```

> 启动

```sh
docker run --name docker-local-es -d -e ES_JAVA_OPTS="-Xms512m -Xmx512m" -e "discovery.type=single-node" -p 9200:9200 -p 9300:9300 elasticsearch
```

| 参数   | 说明                                          |
| ------ | --------------------------------------------- |
| --name | 表示镜像启动后的容器名称                      |
| -d     | 后台运行容器，并返回容器ID；                  |
| -e     | 指定容器内的环境变量                          |
| -p     | 指定端口映射，格式为：主机(宿主)端口:容器端口 |