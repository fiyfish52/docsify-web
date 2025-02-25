# EFK

# 版本 8.14.3

> ## 下载镜像

```sh
docker pull  docker.elastic.co/elasticsearch/elasticsearch:6.5.2
docker pull docker.elastic.co/kibana/kibana:6.5.2
docker pull docker.elastic.co/beats/filebeat:6.5.2
```

> ## 部署elasticsearch+kibana

[官网地址](https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html)

### docker-compose 启动 

```shell
version: "2"
services:
  EFK-Elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:8.14.3
    container_name: EFK-Elasticsearch
    environment:
      - ELASTICSEARCH_USERNAME=elastic
      - ELASTIC_PASSWORD=zhangLIpeng0211
      - "discovery.type=single-node"
      # - "xpack.security.http.ssl.enabled=false"
      - "xpack.license.self_generated.type=trial"
    ports:
      - 9300:9300
      - 9200:9200
    restart: always
  EFK-kibana:
    image: docker.elastic.co/kibana/kibana:8.14.3
    container_name: Knbs-Kibana
    environment:
      # - ELASTICSEARCH_URL=https://EFK-Elasticsearch:9200
      # - ELASTICSEARCH_HOSTS=https://EFK-Elasticsearch:9200
      # - ELASTICSEARCH_USERNAME=elastict
      # - ELASTICSEARCH_PASSWORD=f5i1+aqucpBHDq9oO*D_
      # - "xpack.security.enabled=false"
      - "xpack.license.self_generated.type=trial"
    ports:
      - 5601:5601
    restart: always
```

启动过程需要2-3 分钟



### 绑定Kibana 与 ES

1. 访问 Kibana `http://localhost:5601/` ,此时需要输入ES TOKEN
2. 获取 ES TOKEN ,执行【获取ES TOKEN】命令  会在控制台打印 token
3. 输入token后，需要输入验证码，验证码详见kibana docker 日志
4. 需要输入ES 用户名密码，用户名密码 详见 部署shell ：${ELASTICSEARCH_USERNAME} ${ELASTIC_PASSWORD} 
5. 完成

### 获取 ES TOKEN

```shell
docker exec -it EFK-Elasticsearch /usr/share/elasticsearch/bin/elasticsearch-create-enrollment-token -s kibana
```


### 重置ES密码（可选操作）

```shell
docker exec -it es01 /usr/share/elasticsearch/bin/elasticsearch-reset-password -u elastic
```

密码会打印在 控制台

### ES登录验证

浏览器访问 ：`https://localhost:9200`
用户名：elastic
密码：上一步重置的密码

# 版本 6.5.2

> ## 下载镜像

```sh
docker pull  docker.elastic.co/elasticsearch/elasticsearch:6.5.2
docker pull docker.elastic.co/kibana/kibana:6.5.2
docker pull docker.elastic.co/beats/filebeat:6.5.2
```

> ## 创建网络

```sh
docker network create -d bridge efk-net
```

> ### 删除网络

```sh
docker network rm efk-net
```

> ## docker-compose

```shell
version: "3"
services:
  EFK-Elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:6.5.2
    container_name: Knbs-ES
    environment:
      - ELASTIC_PASSWORD=zhangLIpeng0211
      - "discovery.type=single-node"
    ports:
      - 127.0.0.1:9300:9300
      - 127.0.0.1:9200:9200
    restart: always
  EFK-kibana:
    image: docker.elastic.co/kibana/kibana:6.5.2
    container_name: Knbs-Kibana
    environment:
      - ELASTICSEARCH_URL=http://Knbs-ES:9200
      - ELASTICSEARCH_HOSTS=http://Knbs-ES:9200
      - ELASTICSEARCH_USERNAME=elastic
      - ELASTICSEARCH_PASSWORD=zhangLIpeng0211
      - "xpack.security.enabled=false"
      - "xpack.license.self_generated.type=trial"
    ports:
      - 5601:5601
    restart: always
  EFK-filebeat-01:
    image: docker.elastic.co/beats/filebeat:6.5.2
    container_name: Knbs-Filebeat-01
    environment:
      - setup.kibana.host=kibana:5601
      - output.elasticsearch.hosts=["Knbs-ES:9200"]
    # env_file:
    #   - ./env/filebeat01.env
    volumes:
      # - ./filebeat/volumes/filebeat.yml:/usr/share/filebeat/filebeat.yml
      - D:/sixDgrs/gitProject/knowlage-base/logs/camunda/2024-07-17/output.2024-07-17.log:/var/log/camunda/
      - D:/sixDgrs/gitProject/knowlage-base/logs/gateway/2024-07-17/output.2024-07-17.log:/var/log/gateway/
    depends_on:
      - EFK-kibana
      - EFK-Elasticsearch
    restart: always

```


