# Gitea

使用 Docker 部署 Gitea 是一个简单且高效的方式。Gitea 是一个轻量级的自托管 Git 服务，类似于 GitHub。以下是使用 Docker 部署 Gitea 的详细步骤。

---

## 1. **准备工作**
1. **安装 Docker 和 Docker Compose**：
   - 确保已安装 Docker 和 Docker Compose。
   - 参考官方文档：
     - [Docker 安装指南](https://docs.docker.com/get-docker/)
     - [Docker Compose 安装指南](https://docs.docker.com/compose/install/)

2. **创建项目目录**：
   - 创建一个目录来存放 Gitea 的配置和数据文件：
     ```bash
     mkdir gitea
     cd gitea
     ```

---

## 2. **创建 `docker-compose.yml` 文件**

在项目目录中创建 `docker-compose.yml` 文件，配置 Gitea 服务：

```yaml
version: '3.8'

services:
  gitea:
    image: gitea/gitea:latest
    container_name: gitea
    environment:
      - USER_UID=1000
      - USER_GID=1000
      - DB_TYPE=mysql
      - DB_HOST=db:3306
      - DB_NAME=gitea
      - DB_USER=gitea
      - DB_PASSWD=gitea
    restart: always
    volumes:
      - ./gitea:/data
    ports:
      - "3000:3000"
      - "222:22"
    depends_on:
      - db

  db:
    image: mysql:5.7
    container_name: gitea_db
    restart: always
    environment:
      - MYSQL_ROOT_PASSWORD=gitea
      - MYSQL_DATABASE=gitea
      - MYSQL_USER=gitea
      - MYSQL_PASSWORD=gitea
    volumes:
      - ./mysql:/var/lib/mysql

networks:
  default:
    driver: bridge
```

- **说明**：
  - **Gitea 服务**：
    - 使用 `gitea/gitea:latest` 镜像。
    - 挂载 `./gitea` 目录到容器的 `/data` 目录，用于持久化 Gitea 数据。
    - 映射端口：
      - `3000`：HTTP 访问端口。
      - `222`：SSH 访问端口。
  - **MySQL 数据库**：
    - 使用 `mysql:5.7` 镜像。
    - 挂载 `./mysql` 目录到容器的 `/var/lib/mysql` 目录，用于持久化数据库数据。
    - 配置数据库用户名、密码和数据库名称。

---

## 3. **启动 Gitea 服务**

1. 启动容器：
   ```bash
   docker-compose up -d
   ```

2. 查看容器日志：
   ```bash
   docker-compose logs -f
   ```

---

## 4. **初始化 Gitea**

1. 打开浏览器，访问 Gitea：
   - 地址：`http://localhost:3000`

2. 按照页面提示完成初始化配置：
   - **数据库设置**：
     - 数据库类型：MySQL
     - 主机：`db:3306`
     - 用户名：`gitea`
     - 密码：`gitea`
     - 数据库名称：`gitea`
   - **应用常规设置**：
     - 站点标题：自定义标题。
     - 仓库根目录：`/data/git/repositories`（默认）。
     - SSH 服务器域名：`localhost`。
     - SSH 服务器端口：`222`。
   - **管理员账户设置**：
     - 设置管理员用户名、密码和邮箱。

3. 点击“安装 Gitea”完成初始化。

---

## 5. **验证 Gitea 功能**

1. **创建仓库**：
   - 登录 Gitea，点击“新建仓库”创建一个测试仓库。

2. **克隆仓库**：
   - 使用 HTTP 或 SSH 克隆仓库：
     ```bash
     git clone http://localhost:3000/username/repo.git
     ```
     或
     ```bash
     git clone ssh://git@localhost:222/username/repo.git
     ```

3. **推送代码**：
   - 在本地仓库中添加文件并推送到 Gitea：
     ```bash
     git add .
     git commit -m "Initial commit"
     git push origin main
     ```

---

## 6. **备份与恢复**

1. **备份数据**：
   
   - 备份 `./gitea` 和 `./mysql` 目录：
     ```bash
     tar -czvf gitea-backup.tar.gz gitea mysql
     ```
   
2. **恢复数据**：
   - 解压备份文件并替换 `./gitea` 和 `./mysql` 目录：
     ```bash
     tar -xzvf gitea-backup.tar.gz
     ```

---

## 7. **使用 HTTPS**

如果需要通过 HTTPS 访问 Gitea，可以使用 Nginx 作为反向代理。

### 7.1 创建 Nginx 配置文件

在项目目录中创建 `nginx.conf` 文件：

```nginx
events {}

http {
    server {
        listen 80;
        server_name yourdomain.com;
        return 301 https://$host$request_uri;
    }

    server {
        listen 443 ssl;
        server_name yourdomain.com;

        ssl_certificate /etc/nginx/ssl/certificate.crt;
        ssl_certificate_key /etc/nginx/ssl/private.key;

        location / {
            proxy_pass http://gitea:3000;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
    }
}
```

### 7.2 修改 `docker-compose.yml`

在 `docker-compose.yml` 中添加 Nginx 服务：

```yaml
nginx:
  image: nginx:latest
  container_name: nginx
  ports:
    - "80:80"
    - "443:443"
  volumes:
    - ./nginx.conf:/etc/nginx/nginx.conf
    - ./ssl:/etc/nginx/ssl
  depends_on:
    - gitea
```

### 7.3 启动 Nginx

1. 将 SSL 证书文件放入 `ssl` 目录：
   ```bash
   mkdir ssl
   cp /path/to/certificate.crt ssl/
   cp /path/to/private.key ssl/
   ```

2. 启动 Nginx：
   ```bash
   docker-compose up -d
   ```

3. 访问 Gitea：
   - HTTPS：`https://yourdomain.com`

---

## 8. **总结**

通过 Docker Compose 部署 Gitea，可以快速搭建一个自托管的 Git 服务。关键点包括：
- 使用 Docker Compose 管理 Gitea 和 MySQL 服务。
- 持久化 Gitea 数据和数据库数据。
- 可选地使用 Nginx 配置 HTTPS。

根据实际需求调整配置，确保服务的安全性和稳定性。