# MinIO

使用 Docker 部署高可用的 MinIO 集群，可以通过分布式模式实现。MinIO 是一个高性能的对象存储系统，支持分布式部署，确保数据的高可用性和持久性。以下是使用 Docker 部署高可用 MinIO 集群的详细步骤。

------

### 1. **MinIO 高可用架构**

- **分布式模式**：
  - MinIO 支持分布式部署，数据会自动分片并存储在多个节点上。
  - 每个文件会被分成多个块（erasure-coded blocks），并分布在不同的节点上。
- **高可用性**：
  - 即使部分节点宕机，MinIO 仍然可以提供服务。
  - 默认情况下，MinIO 支持最多一半节点宕机而不影响数据可用性。

------

### 2. **部署 MinIO 集群**

#### 2.1 创建 `docker-compose.yml` 文件

以下是一个包含 4 个 MinIO 节点的 Docker Compose 配置文件：

```
version: '3.8'

services:
  minio1:
    image: minio/minio:latest
    container_name: minio1
    ports:
      - "9001:9000"  # API 端口
      - "9002:9001"  # 控制台端口
    environment:
      MINIO_ROOT_USER: minioadmin
      MINIO_ROOT_PASSWORD: minioadmin
    volumes:
      - ./data1:/data
    command: server http://minio{1...4}/data --console-address ":9001"
    networks:
      - minio-cluster

  minio2:
    image: minio/minio:latest
    container_name: minio2
    ports:
      - "9003:9000"
      - "9004:9001"
    environment:
      MINIO_ROOT_USER: minioadmin
      MINIO_ROOT_PASSWORD: minioadmin
    volumes:
      - ./data2:/data
    command: server http://minio{1...4}/data --console-address ":9001"
    networks:
      - minio-cluster

  minio3:
    image: minio/minio:latest
    container_name: minio3
    ports:
      - "9005:9000"
      - "9006:9001"
    environment:
      MINIO_ROOT_USER: minioadmin
      MINIO_ROOT_PASSWORD: minioadmin
    volumes:
      - ./data3:/data
    command: server http://minio{1...4}/data --console-address ":9001"
    networks:
      - minio-cluster

  minio4:
    image: minio/minio:latest
    container_name: minio4
    ports:
      - "9007:9000"
      - "9008:9001"
    environment:
      MINIO_ROOT_USER: minioadmin
      MINIO_ROOT_PASSWORD: minioadmin
    volumes:
      - ./data4:/data
    command: server http://minio{1...4}/data --console-address ":9001"
    networks:
      - minio-cluster

networks:
  minio-cluster:
    driver: bridge
```

------

#### 2.2 启动 MinIO 集群

1. 创建数据目录：

   ```
mkdir -p ./data{1..4}
   ```

2. 启动 MinIO 集群：

   ```
docker-compose up -d
   ```

3. 查看日志，确保所有节点正常启动：

   ```
   docker-compose logs -f
   ```

------

#### 2.3 访问 MinIO 控制台

1. 打开浏览器，访问 MinIO 控制台：
   - 地址：`http://localhost:9002`
   - 用户名：`minioadmin`
   - 密码：`minioadmin`
2. 在控制台中创建 Bucket 并上传文件，验证集群功能。

------

### 3. **验证高可用性**

1. **模拟节点宕机**：

   - 停止一个 MinIO 节点：

     ```
   docker stop minio1
     ```

   - 验证集群是否仍然可以访问。
   
2. **恢复节点**：

   - 重新启动节点：

     ```
   docker start minio1
     ```

   - 验证节点是否重新加入集群。

------

### 4. **数据持久化与备份**

1. **数据持久化**：

   - 在 `docker-compose.yml` 中，使用本地目录（如 `./data1`）挂载到容器的 `/data` 目录，确保数据持久化。

2. **数据备份**：

   - 定期备份 MinIO 数据目录（如 `./data1`、`./data2` 等）。

   - 使用 MinIO 的 `mc` 工具进行数据备份：

     ```
     mc mirror myminio/mybucket /path/to/backup
     ```

------

### 5. **扩展 MinIO 集群**

如果需要扩展 MinIO 集群，可以添加更多节点：

1. 修改 `docker-compose.yml`，添加新的 MinIO 服务：

   ```
   minio5:
     image: minio/minio:latest
     container_name: minio5
     ports:
       - "9009:9000"
       - "9010:9001"
     environment:
       MINIO_ROOT_USER: minioadmin
       MINIO_ROOT_PASSWORD: minioadmin
     volumes:
       - ./data5:/data
     command: server http://minio{1...5}/data --console-address ":9001"
     networks:
       - minio-cluster
   ```
   
2. 启动新节点：

   ```
docker-compose up -d
   ```

3. 验证新节点是否加入集群：

   ```
   docker-compose logs -f minio5
   ```

------

### 6. **使用负载均衡器**

为了提高访问性能和高可用性，可以在 MinIO 集群前部署负载均衡器（如 Nginx 或 HAProxy）。

#### 6.1 使用 Nginx 作为负载均衡器

1. 创建 `nginx.conf` 文件：

   ```
   events {}
   
   http {
       upstream minio_servers {
           server minio1:9000;
           server minio2:9000;
           server minio3:9000;
           server minio4:9000;
       }
   
       server {
           listen 9000;
           location / {
               proxy_pass http://minio_servers;
               proxy_set_header Host $host;
               proxy_set_header X-Real-IP $remote_addr;
               proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
           }
       }
   }
   ```

2. 在 `docker-compose.yml` 中添加 Nginx 服务：

   ```
   nginx:
     image: nginx:latest
     container_name: nginx
     ports:
       - "9000:9000"
     volumes:
       - ./nginx.conf:/etc/nginx/nginx.conf
     networks:
       - minio-cluster
     depends_on:
       - minio1
       - minio2
       - minio3
       - minio4
   ```
   
3. 启动 Nginx：

   ```
docker-compose up -d
   ```

4. 通过 Nginx 访问 MinIO：

   - 地址：`http://localhost:9000`

### 7.**创建accessKey secretKey**

登陆后，菜单 users->access keys 页面创建即可

### 8.**设置存储桶**

------

### 9. **总结**

通过 Docker Compose 部署高可用的 MinIO 集群，可以实现数据的分布式存储和高可用性。关键点包括：

- 使用分布式模式部署多个 MinIO 节点。
- 确保数据持久化和定期备份。
- 使用负载均衡器提高访问性能和高可用性。

根据实际需求调整节点数量和配置，确保集群的稳定性和性能。