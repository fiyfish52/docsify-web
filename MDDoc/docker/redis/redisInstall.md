# redis

## 主从复制

要在Docker中部署Redis的一主两从架构，可以按照以下步骤进行操作。我们将使用docker-compose来简化多容器的部署和管理。

### 创建 docker-compose.yml 文件

首先，创建一个 docker-compose.yml 文件，定义主节点和从节点的配置。

```yaml
version: '3.8'

networks:
  redis-net:
    driver: bridge
    ipam:
        driver: default
        config:
            - subnet: 192.168.100.0/24
services:
  redis-master:
    image: redis:latest
    container_name: redis-master
    ports:
      - "6379:6379"
    volumes:
      - ./redis-master.conf:/usr/local/etc/redis/redis.conf
    networks:
      redis-net:
        ipv4_address: 192.168.100.3
    command: ["redis-server", "/usr/local/etc/redis/redis.conf"]

  redis-slave1:
    image: redis:latest
    container_name: redis-slave1
    ports:
      - "6380:6379"
    volumes:
      - ./redis-slave1.conf:/usr/local/etc/redis/redis.conf
    networks:
      redis-net:
        ipv4_address: 192.168.100.4
    depends_on:
      - redis-master
    command: ["redis-server", "/usr/local/etc/redis/redis.conf"]

  redis-slave2:
    image: redis:latest
    container_name: redis-slave2
    ports:
      - "6381:6379"
    volumes:
      - ./redis-slave2.conf:/usr/local/etc/redis/redis.conf
    networks:
      redis-net:
        ipv4_address: 192.168.100.5
    depends_on:
      - redis-master
    command: ["redis-server", "/usr/local/etc/redis/redis.conf"]

```

### 创建 Redis 配置文件

为每个Redis实例创建相应的配置文件。

#### 主节点配置文件 (redis-master.conf):

`knbsCore123` 为自定义访问密码

```yaml
bind 0.0.0.0
port 6379
requirepass knbsCore123
```

#### 从节点配置文件 (redis-slave1.conf):

`knbsCore123` 为自定义访问密码

```yaml
bind 0.0.0.0
port 6380
slaveof redis-master 6379
masterauth knbsCore123
```

#### 从节点配置文件 (redis-slave2.conf):

`knbsCore123` 为自定义访问密码

```yaml
bind 0.0.0.0
port 6381
slaveof redis-master 6379
masterauth knbsCore123
```

### 启动 Redis 集群

在包含 docker-compose.yml 文件的目录下，运行以下命令启动Redis主从集群：

```
docker-compose up -d
```

### 验证主从状态

使用 redis-cli 连接到主节点或从节点，查看主从复制状态。
连接到主节点：

`knbsCore123` 为自定义访问密码

```sh
docker exec -it redis-master redis-cli
auth knbsCore123
```

在 redis-cli 中，使用 INFO replication 命令查看主从复制状态：

```sh
INFO replication
```

显示结果：

```shell
127.0.0.1:6379> auth knbsCore123
OK
127.0.0.1:6379> INFO replication
# Replication
role:master
connected_slaves:2
slave0:ip=192.168.100.5,port=6381,state=online,offset=42,lag=1
slave1:ip=192.168.100.4,port=6380,state=online,offset=42,lag=1
master_failover_state:no-failover
master_replid:caa287b3c82b9d3f03bd776ae54388e3b445b6b6
master_replid2:0000000000000000000000000000000000000000
master_repl_offset:42
second_repl_offset:-1
repl_backlog_active:1
repl_backlog_size:1048576
repl_backlog_first_byte_offset:1
repl_backlog_histlen:42
127.0.0.1:6379>
```

在输出中，查找以下字段：
**role**: 主节点的值为 master，从节点的值为 slave。
**connected_slaves**: 主节点连接的从节点数量。
**master_link_status**: 从节点的连接状态（up 表示正常）。

### 注意事项

确保每个容器的配置文件正确，特别是 slaveof 和 masterauth 配置。
使用 docker-compose up -d 命令以守护进程模式启动容器。
在生产环境中，建议使用 Docker Swarm 或 Kubernetes 等容器编排工具来管理多容器应用，以实现更高的可用性和可扩展性。
通过以上步骤，你就可以在Docker中成功部署一个Redis的一主两从架构。

### 缺点

主节点

## 哨兵+主从复制









使用 Docker Compose 部署 Redis 高可用方案，可以通过 **Redis Sentinel** 或 **Redis Cluster** 来实现。以下是两种方案的详细部署步骤。

------

### 方案 1：使用 Redis Sentinel 实现高可用

Redis Sentinel 用于监控 Redis 主从实例，并在主节点故障时自动进行故障转移。

#### 1.1 创建 `docker-compose.yml` 文件

以下是一个包含 Redis 主从实例和 Sentinel 的 Docker Compose 配置文件：

yaml

复制

```
version: '3.8'

services:
  redis-master:
    image: redis:latest
    container_name: redis-master
    ports:
      - "6379:6379"
    command: redis-server --requirepass yourpassword --masterauth yourpassword

  redis-slave1:
    image: redis:latest
    container_name: redis-slave1
    ports:
      - "6380:6379"
    command: redis-server --slaveof redis-master 6379 --requirepass yourpassword --masterauth yourpassword
    depends_on:
      - redis-master

  redis-slave2:
    image: redis:latest
    container_name: redis-slave2
    ports:
      - "6381:6379"
    command: redis-server --slaveof redis-master 6379 --requirepass yourpassword --masterauth yourpassword
    depends_on:
      - redis-master

  redis-sentinel1:
    image: redis:latest
    container_name: redis-sentinel1
    ports:
      - "26379:26379"
    command: redis-sentinel /usr/local/etc/redis/sentinel.conf
    volumes:
      - ./sentinel1.conf:/usr/local/etc/redis/sentinel.conf
    depends_on:
      - redis-master
      - redis-slave1
      - redis-slave2

  redis-sentinel2:
    image: redis:latest
    container_name: redis-sentinel2
    ports:
      - "26380:26379"
    command: redis-sentinel /usr/local/etc/redis/sentinel.conf
    volumes:
      - ./sentinel2.conf:/usr/local/etc/redis/sentinel.conf
    depends_on:
      - redis-master
      - redis-slave1
      - redis-slave2

  redis-sentinel3:
    image: redis:latest
    container_name: redis-sentinel3
    ports:
      - "26381:26379"
    command: redis-sentinel /usr/local/etc/redis/sentinel.conf
    volumes:
      - ./sentinel3.conf:/usr/local/etc/redis/sentinel.conf
    depends_on:
      - redis-master
      - redis-slave1
      - redis-slave2
```

#### 1.2 创建 Sentinel 配置文件

在项目目录下创建 `sentinel1.conf`、`sentinel2.conf` 和 `sentinel3.conf` 文件，内容如下：

plaintext

复制

```
port 26379
sentinel monitor mymaster redis-master 6379 2
sentinel down-after-milliseconds mymaster 5000
sentinel failover-timeout mymaster 10000
sentinel auth-pass mymaster yourpassword
```

#### 1.3 启动服务

1. 启动所有服务：

   bash

   复制

   ```
   docker-compose up -d
   ```

2. 验证 Sentinel 状态：

   bash

   复制

   ```
   docker exec -it redis-sentinel1 redis-cli -p 26379 sentinel master mymaster
   ```

------

### 方案 2：使用 Redis Cluster 实现高可用

Redis Cluster 提供了自动分片和高可用性，数据分布在多个节点上。

#### 2.1 创建 `docker-compose.yml` 文件

以下是一个包含 6 个 Redis 节点的 Docker Compose 配置文件：

yaml

复制

```
version: '3.8'

services:
  redis-node1:
    image: redis:latest
    container_name: redis-node1
    ports:
      - "7001:6379"
    command: redis-server --cluster-enabled yes --cluster-config-file nodes-node-1.conf --cluster-node-timeout 5000 --appendonly yes --requirepass yourpassword --masterauth yourpassword

  redis-node2:
    image: redis:latest
    container_name: redis-node2
    ports:
      - "7002:6379"
    command: redis-server --cluster-enabled yes --cluster-config-file nodes-node-2.conf --cluster-node-timeout 5000 --appendonly yes --requirepass yourpassword --masterauth yourpassword

  redis-node3:
    image: redis:latest
    container_name: redis-node3
    ports:
      - "7003:6379"
    command: redis-server --cluster-enabled yes --cluster-config-file nodes-node-3.conf --cluster-node-timeout 5000 --appendonly yes --requirepass yourpassword --masterauth yourpassword

  redis-node4:
    image: redis:latest
    container_name: redis-node4
    ports:
      - "7004:6379"
    command: redis-server --cluster-enabled yes --cluster-config-file nodes-node-4.conf --cluster-node-timeout 5000 --appendonly yes --requirepass yourpassword --masterauth yourpassword

  redis-node5:
    image: redis:latest
    container_name: redis-node5
    ports:
      - "7005:6379"
    command: redis-server --cluster-enabled yes --cluster-config-file nodes-node-5.conf --cluster-node-timeout 5000 --appendonly yes --requirepass yourpassword --masterauth yourpassword

  redis-node6:
    image: redis:latest
    container_name: redis-node6
    ports:
      - "7006:6379"
    command: redis-server --cluster-enabled yes --cluster-config-file nodes-node-6.conf --cluster-node-timeout 5000 --appendonly yes --requirepass yourpassword --masterauth yourpassword
```

#### 2.2 启动服务并创建集群

1. 启动所有服务：

   bash

   复制

   ```
   docker-compose up -d
   ```

2. 创建 Redis Cluster：

   bash

   复制

   ```
   docker exec -it redis-node1 redis-cli --cluster create \
     172.17.0.2:6379 172.17.0.3:6379 172.17.0.4:6379 \
     172.17.0.5:6379 172.17.0.6:6379 172.17.0.7:6379 \
     --cluster-replicas 1 -a yourpassword
   ```

3. 验证集群状态：

   bash

   复制

   ```
   docker exec -it redis-node1 redis-cli -c -a yourpassword cluster nodes
   ```

------

### 3. **总结**

- **Redis Sentinel**：
  - 适合中小规模部署，提供自动故障转移。
  - 配置简单，易于管理。
- **Redis Cluster**：
  - 适合大规模部署，提供数据分片和高可用性。
  - 配置复杂，但扩展性强。

根据实际需求选择合适的方案，并确保网络配置和容器间的通信正常。
