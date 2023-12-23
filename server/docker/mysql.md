# mysql

## 拉取镜像

?> 拉取最新mysql镜像 `docker pull mysql:latest`

```sh
docker pull mysql:8.0.31
```

## 启动镜像

!> 此处启动是为了获取配置文件，后面会挂载到宿主

```sh
docker run -p 13316:3306 --name MyMysql -e MYSQL_ROOT_PASSWORD='abcd!@#$'  -d mysql:8.0.31
```

## 查看是否启动成功

```sh
docker ps -a
```

## 创建宿主机mysql数据目录

```sh
mkdir -p /usr1/maywide/bin/images/mysql/data

```

## 启动成功后，进入容器内部拷贝配置文件，到宿主主机

?> `/usr1/maywide/bin/images/mysql/data` 自己指定的宿主地址 用于挂载mysql数据文件

```sh
docker cp  MyMysql:/etc /usr1/maywide/bin/images/mysql/data
```

拷贝容器的 /etc目录 到 主机目录/usr1/maywide/bin/images/mysql/data

## 删除mysql容器，重新创建容器

### 先停止容器

```sh
docker stop MyMysql
```

### 再删除容器

```sh
docker rm MyMysql
```

## 启动mysql

?> 挂载配置文件，数据持久化到宿主主机

```sh
docker run -p 13316:3306 \
--name MyMysql \
--privileged=true \
--restart unless-stopped \
-v /usr1/maywide/bin/images/mysql/mydata/etc:/etc \
-v /usr1/maywide/bin/images/mysql/mydata/logs:/logs \
-v /usr1/maywide/bin/images/mysql/mydata/data:/var/lib/mysql \
-v /etc/localtime:/etc/localtime \
-e MYSQL_ROOT_PASSWORD=Maywide368_#^* \
-d mysql:8.0.31
```

命令解释：

 -p 端口映射

--privileged=true  挂载文件权限设置

--restart unless-stopped  设置 开机后自动重启容器

-v /mnt/sda1/mysql8.0.20/mysql:/etc/mysql    挂载配置文件

-v /mnt/sda1/mysql8.0.20/logs:/logs \      挂载日志

-v /mnt/sda1/mysql8.0.20/data:/var/lib/mysql \  挂载数据文件 持久化到主机，

-v /etc/localtime:/etc/localtime    容器时间与宿主机同步

-e MYSQL_ROOT_PASSWORD=123456    设置密码

-d  mysql:8.0.20   后台启动,mysql

## 查看是否启动成功

```sh
docker ps -a  
```

!> 如果要修改  mysql的配置信息 直接 修改挂载出来的配置文件即可。

修改完记得重启

## 停止mysql  

```sh
docker stop mysql
```

## 启动 mysql

```sh
docker start mysql
```
