## 部署

使用 `docker-compose` 部署 Jenkins 可以简化部署流程，并确保环境的一致性。以下是一个基本的步骤指南，帮助你通过 `docker-compose` 部署 Jenkins。

### 步骤一：构建自定义镜像（可选）

如果你需要自定义 Jenkins 镜像，可以创建一个 `Dockerfile`，例如：

```Dockerfile
# 基础镜像
FROM jenkinsci/jenkins:latest

# 维护者信息
MAINTAINER "Your Name"

# 安装 Node.js 和 Maven
RUN apt-get update && apt-get install -y nodejs npm maven

# 配置环境变量
ENV PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"

# 设置时区
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
```

然后，在 `docker-compose.yml` 文件中使用这个自定义镜像：

```yaml
version: '3.3'
services:
  jenkins:
    image: your_custom_jenkins_image:tag
    container_name: jenkins
    restart: always
    privileged: true
    environment:
      TZ: 'Asia/Shanghai'
    ports:
      - 9003:8080
      - 50000:50000
    volumes:
      - ./data/jenkins_home:/var/jenkins_home
      - /var/run/docker.sock:/var/run/docker.sock
```

### 步骤二：创建 `docker-compose.yml` 文件

创建一个名为 `docker-compose.yml` 的文件，内容如下：

```yaml
version: '3.3'
services:
  jenkins:
    image: jenkins/jenkins:lts  # 使用官方 Jenkins 镜像
    container_name: jenkins
    restart: always
    privileged: true
    environment:
      TZ: 'Asia/Shanghai'
    ports:
      - 9003:8080  # 将容器的 8080 端口映射到主机的 9003 端口
      - 50000:50000  # 将容器的 50000 端口映射到主机的 50000 端口
    volumes:
      - ./data/jenkins_home:/var/jenkins_home  # 挂载 Jenkins 数据卷
      - /var/run/docker.sock:/var/run/docker.sock  # 挂载 Docker 套接字
```

### 步骤三：运行容器

在 `docker-compose.yml` 文件的同级目录下执行以下命令启动容器：

```sh
docker-compose up -d
```

### 步骤四：访问 Jenkins

打开浏览器，访问 `http://localhost:9003`，你将看到 Jenkins 的安装页面。首次访问时，需要输入初始管理员密码，该密码可以在容器日志中找到，或者在 `/var/jenkins_home/secrets/initialAdminPassword` 文件中查看。

### 注意事项

1. **权限问题**：在运行容器时，可能会遇到数据卷权限问题。可以使用以下命令解决：

    ```sh
    sudo chown -R 1000:1000 ./data
    ```

2. **时区配置**：确保时区配置正确，以避免时间显示不正确的问题。

3. **插件安装**：首次访问 Jenkins 时，建议安装推荐的插件，以便快速开始使用。

通过以上步骤，你可以使用 `docker-compose` 轻松部署 Jenkins，并确保其在容器环境中顺利运行。

## 配置

根目录：/var/jenkins_home

### accountserver

```sh
mkdir -p /var/jenkins_home/workspace/package/accountserver
mkdir -p /var/jenkins_home/workspace/package/accountserver/lib
cd /var/jenkins_home/workspace/package/accountserver

rm -f ./knbs-*.jar
rm -f ./lib/*
echo " cp server ……"
cp /var/jenkins_home/workspace/AccountServer2/target/*.jar /var/jenkins_home/workspace/package/accountserver/

rm -f ./lib.tar.gz
cp /var/jenkins_home/workspace/AccountServer2/target/lib/* /var/jenkins_home/workspace/package/accountserver/lib/
tar -cvf lib.tar.gz lib
```

sh 

```sh
#!/bin/bash
#PATH=cd /usr1/software/jdk-17.0.5/bin:$PATH

jvmOpts="-server -Xms256M -Xmx512M -Xss2m"
profile=prod

#如果有新的jar包，直接将文件名称放入下面，注意换行
server=(
KnbsAccountServer-0.0.1-SNAPSHOT.jar
)

#日志文件名和上面jar包对应，直接将文件名称放入下面，注意换行
log=(
accountserver
)


echo "================================================================================================================="

len=${#server[@]}

for ((i=0; i<$len; i++))
 
do
#echo "$i ${server[i]} ===="
Server=${server[i]}
Log=${log[i]}

#echo "N=$i  Server=$Server  LOG=$Log"

pid=`ps -ef | grep java | grep $Server | sed -n '1p' |awk '{print $2}'`

if [ -n "$pid" ];then
echo "Server $Server is now running($pid),I will kill it."
kill -9 $pid
fi
echo "I will run the Server $Server now ... "
nohup java -jar $jvmOpts $Server -Dfile.encoding=utf-8  --spring.profiles.active=$profile  > $Log.log 2>&1 &
sleep 5
done


echo "================================================================================================================="


echo -e "|\tServername\t\t\t\t PID\t\t\t\t\t STATUS\t\t\t|"
for ((i=0; i<$len; i++))
do

Server=${server[i]}
Log=${log[i]}

ISSTART=0
LOGCUN=0

 while [ $ISSTART -eq 0 ] && [ $LOGCUN -lt 10 ];
 do
   pid=`ps -ef | grep java | grep $Server |  sed -n '1p' |awk '{print $2}'`

   ISSTART=$(cat $Log.log |head -n 500 | grep "is running! Access URLs" | wc -l)
sleep 1
   LOGCUN=`expr $LOGCUN + 1 `
sleep 1
#echo $pid $ISSTART
 done  
if [ -n "$pid" ] || [$ISSTART -eq 1 ];then
 #echo -e "|\t\033[34m$Server\t	$pid\t						server start success.\t	|\033[0m"
printf "|\t\e[34m%-20s \t\t\t%-10s\t\t\t%-25s\t\e[0m|\n" "$Log" "$pid" "server start success." 
#echo -e "\t\t\t\t\033[34mserver start success.\t |\033[0m"
else
 #echo -e "|\t\033[31m$Server\t							server start fail.\t	|\033[0m"
printf "|\t\e[34m%-20s \t\t\t%-10s\t\t\t%-25s\t\e[0m|\n" "$Log" "$pid" "server start fail.."
fi;
sleep 1
done
sleep 1
echo "================================================================================================================="


#sleep 15
exit 0


```

启动accountserver

```sh
#!/bin/bash


PATH=/usr1/software/jdk-17.0.5/bin:$PATH

echo "java version"
java -version


jvmOpts="-server -Xms256M -Xmx512M -Xss2m"

Server="KnbsAccountServer-0.0.1-SNAPSHOT.jar"
Log="accountserver"



pid=`ps -ef | grep java | grep $Server | sed -n '1p' |awk '{print $2}'`



if [ -n "$pid" ];then
echo "Server $Server is now running($pid),I will kill it."
kill -9 $pid
fi


echo "I will run the Server $Server now ... "
nohup  java -jar $jvmOpts $Server -Dfile.encoding=utf-8 --spring.config.location=./application.yml    > $Log.log 2>&1 &
# nohup ./java -jar /usr1/project/accountServer/KnbsAccountServer-0.0.1-SNAPSHOT.jar --server.port=8791 --spring.config.location=/usr1/project/accountServer/application.yml > &
sleep 5
```

