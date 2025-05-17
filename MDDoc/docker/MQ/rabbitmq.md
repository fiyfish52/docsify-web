# rabbitmq

使用 `Docker Compose` 部署 RabbitMQ 高可用方案的详细步骤：

## RabbitMQ 高可用方案的核心概念

- **RabbitMQ 集群**：多个 RabbitMQ 节点组成一个集群，共享用户、交换机、队列等元数据。
- **镜像队列**：队列的内容会在集群中的多个节点上复制，确保即使某个节点宕机，队列数据仍然可用。

------

### 使用 Docker Compose 部署 RabbitMQ 集群

#### `docker-compose.yml` 文件

以下是一个包含 3 个 RabbitMQ 节点的 Docker Compose 配置文件：

```yam
version: '3.8'

services:
  rabbitmq1:
    image: rabbitmq:3.11-management
    container_name: rabbitmq1
    hostname: rabbitmq1
    ports:
      - "5672:5672"  # AMQP 端口
      - "15672:15672"  # 管理界面端口
    environment:
      - RABBITMQ_ERLANG_COOKIE=secret_cookie  # 集群通信的 Cookie
      - RABBITMQ_DEFAULT_USER=admin
      - RABBITMQ_DEFAULT_PASS=admin
    volumes:
      - rabbitmq1-data:/var/lib/rabbitmq
    networks:
      rabbitmq-cluster:
        ipv4_address: 172.20.0.2

  rabbitmq2:
    image: rabbitmq:3.11-management
    container_name: rabbitmq2
    hostname: rabbitmq2
    ports:
      - "5673:5672"
      - "15673:15672"
    environment:
      - RABBITMQ_ERLANG_COOKIE=secret_cookie
      - RABBITMQ_DEFAULT_USER=admin
      - RABBITMQ_DEFAULT_PASS=admin
    volumes:
      - rabbitmq2-data:/var/lib/rabbitmq
    networks:
      rabbitmq-cluster:
        ipv4_address: 172.20.0.3
    depends_on:
      - rabbitmq1

  rabbitmq3:
    image: rabbitmq:3.11-management
    container_name: rabbitmq3
    hostname: rabbitmq3
    ports:
      - "5674:5672"
      - "15674:15672"
    environment:
      - RABBITMQ_ERLANG_COOKIE=secret_cookie
      - RABBITMQ_DEFAULT_USER=admin
      - RABBITMQ_DEFAULT_PASS=admin
    volumes:
      - rabbitmq3-data:/var/lib/rabbitmq
    networks:
      rabbitmq-cluster:
        ipv4_address: 172.20.0.4
    depends_on:
      - rabbitmq1

  rabbitmq4:
    image: rabbitmq:3.11-management
    container_name: rabbitmq4
    hostname: rabbitmq4
    ports:
      - "5675:5672"
      - "15675:15672"
    environment:
      - RABBITMQ_ERLANG_COOKIE=secret_cookie
      - RABBITMQ_DEFAULT_USER=admin
      - RABBITMQ_DEFAULT_PASS=admin
    volumes:
      - rabbitmq4-data:/var/lib/rabbitmq
    networks:
      rabbitmq-cluster:
        ipv4_address: 172.20.0.5
    depends_on:
      - rabbitmq1

  rabbitmq5:
    image: rabbitmq:3.11-management
    container_name: rabbitmq5
    hostname: rabbitmq5
    ports:
      - "5676:5672"
      - "15676:15672"
    environment:
      - RABBITMQ_ERLANG_COOKIE=secret_cookie
      - RABBITMQ_DEFAULT_USER=admin
      - RABBITMQ_DEFAULT_PASS=admin
    volumes:
      - rabbitmq5-data:/var/lib/rabbitmq
    networks:
      rabbitmq-cluster:
        ipv4_address: 172.20.0.6
    depends_on:
      - rabbitmq1

  rabbitmq6:
    image: rabbitmq:3.11-management
    container_name: rabbitmq6
    hostname: rabbitmq6
    ports:
      - "5677:5672"
      - "15677:15672"
    environment:
      - RABBITMQ_ERLANG_COOKIE=secret_cookie
      - RABBITMQ_DEFAULT_USER=admin
      - RABBITMQ_DEFAULT_PASS=admin
    volumes:
      - rabbitmq6-data:/var/lib/rabbitmq
    networks:
      rabbitmq-cluster:
        ipv4_address: 172.20.0.7
    depends_on:
      - rabbitmq1
volumes:
  rabbitmq1-data:
  rabbitmq2-data:
  rabbitmq3-data:
  rabbitmq4-data:
  rabbitmq5-data:
  rabbitmq6-data:

networks:
  rabbitmq-cluster:
    driver: bridge
    ipam:
      config:
        - subnet: 172.20.0.0/16
          gateway: 172.20.0.1
```



#### 启动 RabbitMQ 集群

1. 在终端中运行以下命令启动集群：

   ```
docker-compose up -d
   ```

2. 等待所有容器启动后，进入 `rabbitmq2` 和 `rabbitmq3` 容器，将它们加入到 `rabbitmq1` 的集群中：

   ```
   # 进入 rabbitmq2 容器
   docker exec -it rabbitmq2 bash
   
   # 停止 RabbitMQ 应用
   rabbitmqctl stop_app
   
   # 加入集群
   rabbitmqctl join_cluster rabbit@rabbitmq1
   
   # 启动 RabbitMQ 应用
   rabbitmqctl start_app
   
   # 退出容器
   exit
   ```
   
   对 `rabbitmq3` 重复上述步骤。
   
3. 验证集群状态：

   ```
   docker exec -it rabbitmq1 rabbitmqctl cluster_status
   ```

   输出应显示所有节点已加入集群。

### 配置镜像队列

为了确保队列的高可用性，需要配置镜像队列。镜像队列会将队列的内容复制到集群中的其他节点。

1. 进入任意一个 RabbitMQ 容器：

   ```
   docker exec -it rabbitmq1 bash
   ```

2. 设置镜像队列策略：

   ```
   rabbitmqctl set_policy ha-all "^ha\." '{"ha-mode":"all"}'
   ```

   这条命令表示：

   - `^ha\.`：匹配所有以 `ha.` 开头的队列。
   - `ha-mode: all`：将队列镜像到所有节点。

3. 验证策略是否生效：

   ```
   rabbitmqctl list_policies
   ```

------

### 4. 访问 RabbitMQ 管理界面

- 打开浏览器，访问以下地址：
  - `http://localhost:15672`（rabbitmq1）
  - `http://localhost:15673`（rabbitmq2）
  - `http://localhost:15674`（rabbitmq3）
- 使用用户名 `admin` 和密码 `admin` 登录。

在管理界面中，可以查看集群状态、队列、交换机等信息。

------

### 5. 测试高可用性

1. 创建一个队列（如 `ha.test_queue`）。

2. 停止其中一个节点（如 `rabbitmq1`）：

   ```
   docker stop rabbitmq1
   ```

3. 检查其他节点是否接管了队列和服务。

------

### 6. 注意事项

1. **网络配置**：
   - 确保所有 RabbitMQ 节点能够互相通信。
   - 使用 Docker 的 `networks` 功能，确保容器在同一网络中。
2. **数据持久化**：
   - 使用 Docker 卷（`volumes`）持久化 RabbitMQ 数据，避免容器重启后数据丢失。
3. **Erlang Cookie**：
   - 所有节点的 `RABBITMQ_ERLANG_COOKIE` 必须一致，否则无法加入集群。
4. **资源分配**：
   - 根据实际需求调整容器的 CPU 和内存限制。

------

### 7. 扩展与优化

- **增加节点**：可以通过修改 `docker-compose.yml` 文件，添加更多 RabbitMQ 节点。
- **负载均衡**：使用 HAProxy 或 Nginx 对 RabbitMQ 集群进行负载均衡。
- **监控与告警**：集成 Prometheus 和 Grafana，监控 RabbitMQ 集群的健康状态。

------

通过以上步骤，你可以使用 Docker Compose 快速部署一个高可用的 RabbitMQ 集群，并通过镜像队列确保数据的可靠性。



## 问题

### 集群节点重启后，无法再次加入集群

#### 原因

因为集群配置了镜像队列，重启后的需要重新同步镜像队列；

#### 处理办法

镜像同步

当集群只剩下最后一个节点的时候，同步镜像依旧报错；







RabbitMQ 镜像模式是一种高可用集群配置，旨在确保消息的可靠性和可用性。通过镜像模式，消息可以在多个节点之间复制，从而减少单点故障的风险。

配置镜像队列

要配置 RabbitMQ 的镜像队列，可以使用 *rabbitmqctl* 命令设置策略。以下是一些常见的配置示例：

为所有队列开启镜像配置

rabbitmqctl set_policy ha-all "^" '{"ha-mode":"all"}'

此命令将所有队列设置为镜像模式，消息会被同步到所有节点的相同队列中[1](https://blog.csdn.net/ory001/article/details/121537963)。

设置复制系数

如果集群中有很多节点，可以选择合适的复制系数以减少性能开销。以下示例将消息复制到两个节点：

rabbitmqctl set_policy ha-two "^" '{"ha-mode":"exactly","ha-params":2,"ha-sync-mode":"automatic"}'

此命令将消息复制到两个节点，并设置同步模式为自动[1](https://blog.csdn.net/ory001/article/details/121537963)。

使用正则表达式过滤队列

可以使用正则表达式来过滤需要进行镜像操作的队列。例如，只对以 *ha.* 开头的队列进行镜像：

rabbitmqctl set_policy ha-all "^ha\." '{"ha-mode":"all"}'

此命令只会对以 *ha.* 开头的队列进行镜像[1](https://blog.csdn.net/ory001/article/details/121537963)。

加入集群

要将节点加入 RabbitMQ 集群，可以使用以下命令：

rabbitmqctl stop_app

rabbitmqctl reset

rabbitmqctl join_cluster rabbit@rabbit-node1

rabbitmqctl start_app

其中，*rabbit-node1* 是基准节点，其他节点将逐步加入集群[1](https://blog.csdn.net/ory001/article/details/121537963)。

变更节点类型

可以将节点的类型从 RAM 更改为 Disk，反之亦然。以下示例将 *rabbit@rabbit-node2* 从 RAM 节点转换为磁盘节点：

rabbitmqctl stop_app

rabbitmqctl change_cluster_node_type disc

rabbitmqctl start_app

此命令首先停止节点应用，然后更改节点类型，最后重新启动应用[1](https://blog.csdn.net/ory001/article/details/121537963)。

通过以上配置，RabbitMQ 的镜像模式可以有效提高消息的可靠性和可用性，适用于需要高可用性的场景[1](https://blog.csdn.net/ory001/article/details/121537963)[2](https://www.cnblogs.com/huligong1234/p/13549450.html)。



## 常用命令



`rabbitmqctl` 是 RabbitMQ 的命令行管理工具，用于管理和监控 RabbitMQ 服务器。以下是一些常用的 `rabbitmqctl` 命令及其说明：

------

### **1. 服务器管理**

#### **启动 RabbitMQ 服务器**



```
rabbitmq-server
```

#### **停止 RabbitMQ 服务器**



```
rabbitmqctl stop
```

#### **重启 RabbitMQ 服务器**



```
rabbitmqctl restart
```

#### **查看 RabbitMQ 状态**



```
rabbitmqctl status
```

------

### **2. 节点管理**

#### **查看集群节点状态**



```
rabbitmqctl cluster_status
```

#### **加入集群**



```
rabbitmqctl join_cluster rabbit@<主节点名称>
```

#### **离开集群**



```
rabbitmqctl forget_cluster_node rabbit@<节点名称>
```

#### **重置节点**



```
rabbitmqctl reset
```

------

### **3. 用户管理**

#### **添加用户**



```
rabbitmqctl add_user <用户名> <密码>
```

#### **删除用户**



```
rabbitmqctl delete_user <用户名>
```

#### **修改用户密码**



```
rabbitmqctl change_password <用户名> <新密码>
```

#### **清除用户密码（禁止密码登录）**



```
rabbitmqctl clear_password <用户名>
```

#### **列出所有用户**



```
rabbitmqctl list_users
```

------

### **4. 权限管理**

#### **设置用户权限**



```
rabbitmqctl set_permissions -p <虚拟主机> <用户名> ".*" ".*" ".*"
```

#### **清除用户权限**



```
rabbitmqctl clear_permissions -p <虚拟主机> <用户名>
```

#### **列出用户权限**



```
rabbitmqctl list_user_permissions <用户名>
```

#### **列出虚拟主机权限**



```
rabbitmqctl list_permissions -p <虚拟主机>
```

------

### **5. 虚拟主机管理**

#### **添加虚拟主机**



```
rabbitmqctl add_vhost <虚拟主机名称>
```

#### **删除虚拟主机**



```
rabbitmqctl delete_vhost <虚拟主机名称>
```

#### **列出所有虚拟主机**



```
rabbitmqctl list_vhosts
```

------

### **6. 队列管理**

#### **列出所有队列**



```
rabbitmqctl list_queues
```

#### **列出队列详细信息**



```
rabbitmqctl list_queues name messages_ready messages_unacknowledged
```

#### **清除队列中的消息**

bash

复制

```
rabbitmqctl purge_queue <队列名称>
```

#### **删除队列**

bash

复制

```
rabbitmqctl delete_queue <队列名称>
```

------

### **7. 交换机管理**

#### **列出所有交换机**

bash

复制

```
rabbitmqctl list_exchanges
```

#### **列出交换机绑定**

bash

复制

```
rabbitmqctl list_bindings
```

#### **删除交换机**

bash

复制

```
rabbitmqctl delete_exchange <交换机名称>
```

------

### **8. 连接管理**

#### **列出所有连接**

bash

复制

```
rabbitmqctl list_connections
```

#### **关闭连接**

bash

复制

```
rabbitmqctl close_connection <连接名称> "原因"
```

------

### **9. 通道管理**

#### **列出所有通道**

bash

复制

```
rabbitmqctl list_channels
```

------

### **10. 插件管理**

#### **列出所有插件**

bash

复制

```
rabbitmq-plugins list
```

#### **启用插件**

bash

复制

```
rabbitmq-plugins enable <插件名称>
```

#### **禁用插件**

bash

复制

```
rabbitmq-plugins disable <插件名称>
```

------

### **11. 策略管理**

#### **添加策略**

bash

复制

```
rabbitmqctl set_policy -p <虚拟主机> <策略名称> "<模式>" '{"key":"value"}' --apply-to <目标>
```

#### **删除策略**

bash

复制

```
rabbitmqctl clear_policy -p <虚拟主机> <策略名称>
```

#### **列出所有策略**

bash

复制

```
rabbitmqctl list_policies -p <虚拟主机>
```

------

### **12. 日志管理**

#### **查看日志文件**

bash

复制

```
cat /var/log/rabbitmq/rabbitmq.log
```

#### **跟踪日志**

bash

复制

```
tail -f /var/log/rabbitmq/rabbitmq.log
```

------

### **13. 其他常用命令**

#### **查看 RabbitMQ 版本**

bash

复制

```
rabbitmqctl version
```

#### **查看 RabbitMQ 环境变量**

bash

复制

```
rabbitmqctl environment
```

#### **查看 RabbitMQ 运行状态**

bash

复制

```
rabbitmqctl node_health_check
```

------

### **14. 高级命令**

#### **强制关闭节点**

bash

复制

```
rabbitmqctl force_reset
```

#### **检查节点是否在运行**

bash

复制

```
rabbitmqctl await_startup
```

#### **检查节点是否已停止**

bash

复制

```
rabbitmqctl await_shutdown
```

------

### **总结**

`rabbitmqctl` 是管理 RabbitMQ 的核心工具，涵盖了用户、虚拟主机、队列、交换机、连接、通道、插件、策略等方面的管理。通过合理使用这些命令，可以高效地管理和监控 RabbitMQ 服务器。