# elasticsearch 安装


## 安装

### 查找镜像

```sh
docker search elasticsearch
```

### 拉取镜像

docker pull 镜像名

```sh
docker pull elasticsearch
```

### 启动

#### 默认配置启动

```sh
docker run --name docker-local-es -d -e ES_JAVA_OPTS="-Xms512m -Xmx512m" -e "discovery.type=single-node" -p 9200:9200 -p 9300:9300 elasticsearch
```

| 参数   | 说明                                          |
| ------ | --------------------------------------------- |
| --name | 表示镜像启动后的容器名称                      |
| -d     | 后台运行容器，并返回容器ID；                  |
| -e     | 指定容器内的环境变量                          |
| -p     | 指定端口映射，格式为：主机(宿主)端口:容器端口 |

#### 自定义配置启动

> 创建专用网络

```sh
docker network create elastic-net
```

> 单节点部署

```sh
docker run -p 127.0.0.1:9200:9200 -d --name elasticsearch --network elastic-net \
  -e ELASTIC_PASSWORD=$ELASTIC_PASSWORD \
  -e "discovery.type=single-node" \
  -e "xpack.security.http.ssl.enabled=false" \
  -e "xpack.license.self_generated.type=trial" \
  docker.elastic.co/elasticsearch/elasticsearch:8.14.3
```
|配置| 说明                              |
|-|---------------------------------|
|ELASTIC_PASSWORD| 指定elastic用户的密码                  |
|discovery.type| 指定为单节点部署                        |
|127.0.0.1:9200:9200| 配置只能本地访问，外部无法访问 外部访问配置9200:9200 |
|xpack.security.http.ssl.enabled||
|xpack.license.self_generated.type||

> 集群部署

查看docker-compose 版本

```shell
docker-compose -v
```

```yml
version: '2.2'
services:
  es01:
    image: docker.elastic.co/elasticsearch/elasticsearch:7.11.2
    container_name: es01
    environment:
      - node.name=es01
      - cluster.name=es-docker-cluster
      - discovery.seed_hosts=es02,es03
      - cluster.initial_master_nodes=es01,es02,es03
      - bootstrap.memory_lock=true
      - "ES_JAVA_OPTS=-Xms512m -Xmx512m"
    ulimits:
      memlock:
        soft: -1
        hard: -1
    volumes:
      - data01:/usr/share/elasticsearch/data
    ports:
      - 9200:9200
    networks:
      - elastic
  es02:
    image: docker.elastic.co/elasticsearch/elasticsearch:7.11.2
    container_name: es02
    environment:
      - node.name=es02
      - cluster.name=es-docker-cluster
      - discovery.seed_hosts=es01,es03
      - cluster.initial_master_nodes=es01,es02,es03
      - bootstrap.memory_lock=true
      - "ES_JAVA_OPTS=-Xms512m -Xmx512m"
    ulimits:
      memlock:
        soft: -1
        hard: -1
    volumes:
      - data02:/usr/share/elasticsearch/data
    networks:
      - elastic
  es03:
    image: docker.elastic.co/elasticsearch/elasticsearch:7.11.2
    container_name: es03
    environment:
      - node.name=es03
      - cluster.name=es-docker-cluster
      - discovery.seed_hosts=es01,es02
      - cluster.initial_master_nodes=es01,es02,es03
      - bootstrap.memory_lock=true
      - "ES_JAVA_OPTS=-Xms512m -Xmx512m"
    ulimits:
      memlock:
        soft: -1
        hard: -1
    volumes:
      - data03:/usr/share/elasticsearch/data
    networks:
      - elastic

volumes:
  data01:
    driver: local
  data02:
    driver: local
  data03:
    driver: local

networks:
  elastic:
    driver: bridge
```
