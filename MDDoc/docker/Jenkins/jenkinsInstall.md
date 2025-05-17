# Jenins

使用 Docker 部署 Jenkins 是一个简单且高效的方式。Jenkins 是一个开源的持续集成和持续交付（CI/CD）工具，广泛用于自动化构建、测试和部署。以下是使用 Docker 部署 Jenkins 的详细步骤。

---

## 1. **准备工作**
1. **安装 Docker**：
   - 确保已安装 Docker。
   - 参考官方文档：[Docker 安装指南](https://docs.docker.com/get-docker/)

2. **创建项目目录**：
   - 创建一个目录来存放 Jenkins 的配置和数据文件：
     ```bash
     mkdir jenkins
     cd jenkins
     ```

---

## 2. **创建 `docker-compose.yml` 文件**

在项目目录中创建 `docker-compose.yml` 文件，配置 Jenkins 服务：

```yaml
version: '3.8'

services:
  jenkins:
    image: jenkins/jenkins:lts
    container_name: jenkins
    user: root
    ports:
      - "8080:8080"
      - "50000:50000"
    volumes:
      - ./jenkins_home:/var/jenkins_home
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      - JAVA_OPTS=-Djenkins.install.runSetupWizard=false
    restart: always
```

- **说明**：
  - **Jenkins 服务**：
    - 使用 `jenkins/jenkins:lts` 镜像（长期支持版本）。
    - 挂载 `./jenkins_home` 目录到容器的 `/var/jenkins_home` 目录，用于持久化 Jenkins 数据。
    - 映射端口：
      - `8080`：Jenkins Web 界面访问端口。
      - `50000`：Jenkins Agent 通信端口。
    - 挂载 Docker 套接字（`/var/run/docker.sock`），使 Jenkins 可以在容器内使用 Docker。
    - 设置 `JAVA_OPTS` 环境变量，跳过初始设置向导。

---

## 3. **启动 Jenkins 服务**

1. 启动容器：
   ```bash
   docker-compose up -d
   ```

2. 查看容器日志：
   ```bash
   docker-compose logs -f
   ```

3. 获取初始管理员密码：
   - 从日志中查找初始管理员密码，或者从挂载的 `jenkins_home` 目录中获取：
     ```bash
     cat jenkins_home/secrets/initialAdminPassword
     ```

---

## 4. **初始化 Jenkins**

1. 打开浏览器，访问 Jenkins：
   - 地址：`http://localhost:8080`

2. 输入初始管理员密码，点击“继续”。

3. 安装推荐插件：
   - 选择“安装推荐的插件”，等待插件安装完成。

4. 创建管理员用户：
   - 设置管理员用户名、密码和邮箱。

5. 完成初始化：
   - 点击“保存并完成”，然后点击“开始使用 Jenkins”。

---

## 5. **配置 Jenkins**

1. **安装插件**：
   - 在 Jenkins 管理界面，点击“Manage Jenkins” -> “Manage Plugins”。
   - 安装常用插件，如：
     - Docker Pipeline
     - Git
     - Blue Ocean

2. **配置 Docker**：
   - 在 Jenkins 管理界面，点击“Manage Jenkins” -> “Configure System”。
   - 找到“Cloud”部分，配置 Docker 云：
     - 名称：`docker`
     - Docker Host URI：`unix:///var/run/docker.sock`
     - 测试连接，确保配置正确。

3. **创建 Pipeline 任务**：
   - 点击“新建任务”，输入任务名称，选择“Pipeline”，点击“确定”。
   - 在 Pipeline 配置页面，编写 Jenkinsfile 或直接从 Git 仓库加载。

---

## 6. **验证 Jenkins 功能**

1. **创建测试任务**：
   - 创建一个简单的 Pipeline 任务，验证 Jenkins 功能：
     ```groovy
     pipeline {
       agent any
       stages {
         stage('Build') {
           steps {
             echo 'Building...'
           }
         }
         stage('Test') {
           steps {
             echo 'Testing...'
           }
         }
         stage('Deploy') {
           steps {
             echo 'Deploying...'
           }
         }
       }
     }
     ```

2. **运行任务**：
   - 点击“立即构建”，查看任务运行结果。

---

## 7. **备份与恢复**

1. **备份数据**：
   - 备份 `./jenkins_home` 目录：
     ```bash
     tar -czvf jenkins-backup.tar.gz jenkins_home
     ```

2. **恢复数据**：
   - 解压备份文件并替换 `./jenkins_home` 目录：
     ```bash
     tar -xzvf jenkins-backup.tar.gz
     ```

---

## 8. **使用 HTTPS**

如果需要通过 HTTPS 访问 Jenkins，可以使用 Nginx 作为反向代理。

### 8.1 创建 Nginx 配置文件

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
            proxy_pass http://jenkins:8080;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
    }
}
```

### 8.2 修改 `docker-compose.yml`

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
    - jenkins
```

### 8.3 启动 Nginx

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

3. 访问 Jenkins：
   - HTTPS：`https://yourdomain.com`

---

## 9. **总结**

通过 Docker Compose 部署 Jenkins，可以快速搭建一个持续集成和持续交付平台。关键点包括：
- 使用 Docker Compose 管理 Jenkins 服务。
- 持久化 Jenkins 数据。
- 可选地使用 Nginx 配置 HTTPS。

根据实际需求调整配置，确保服务的安全性和稳定性。