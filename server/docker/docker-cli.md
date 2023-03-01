# docker-cli

## 官网地址

[官网命令地址](https://docs.docker.com/engine/reference/commandline/exec/)

## docker run

[docker run](https://docs.docker.com/engine/reference/run/#tmpfs-mount-tmpfs-filesystems)

> -v

```sh
-v, --volume=[host-src:]container-dest[:<options>]: Bind mount a volume.
The comma-delimited `options` are [rw|ro], [z|Z],
[[r]shared|[r]slave|[r]private], and [nocopy].
The 'host-src' is an absolute path or a name value.

If neither 'rw' or 'ro' is specified then the volume is mounted in
read-write mode.

The `nocopy` mode is used to disable automatically copying the requested volume
path in the container to the volume storage location.
For named volumes, `copy` is the default mode. Copy modes are not supported
for bind-mounted volumes.

--volumes-from="": Mount all volumes from the given container(s)
```

> 示例

多个-v 挂载多个卷

```sh
docker run  -v /usr1/maywide/docker/sftp:/home/foo/upload -v  /usr1/maywide/docker/sftp/upload:/home/settle -p 10022:22 -d atmoz/sftp  settle:S1t3T2l4:1001
```

## 查看网络类型

```sh
docker network ls
```

查看某个网络中的容器

```sh
docker network inspect bridge
```

## 容器操作

> 进入容器

```sh
docker ps
```

```sh
docker exec -it [CONTAINERID] /bin/bash
```

> docker 删除容器 镜像

```sh
1.停用全部运行中的容器: docker stop $(docker ps -a)
2.删除全部容器: docker rm $(docker ps -aq)
3.一条命令实现停用并删除容器: docker stop $(docker ps -a) & docker rm -f $(docker ps -aq)
同样删除全部镜像文件
docker rmi -f $(docker images)
```

> 删除镜像

```sh
docker rmi -f 镜像id
```

> docker 删除/停止容器

1. 查看所有正在运行容器

```sh
docker ps
```

```sh
查看所有容器 
docker ps -a 
查看所有容器ID 
docker ps -a -q  
```

2. 停止容器 **containerId 是容器的ID**

```sh
docker stop [containerId]
```

停止所有容器

```sh
docker stop $(docker ps -a -q)  
```

3. 删除容器

```sh
docker rm [containerId]
```

```sh
删除所有容器
docker rm $(docker ps -a -q)   
```

> 卸载docker

1. 查询docker安装过的包：

```sh
yum list installed | grep docker
```

2. 删除安装包：

```sh
yum remove docker-ce.x86_64 ddocker-ce-cli.x86_64 -y
```

3. 删除镜像/容器等

```sh
rm -rf /var/lib/docker
```

## docker 镜像迁移

> linux系统间迁移

```sh
docker save  [镜像名或镜像id] | gzip > [压缩文件名].tar.gz
```

```sh
docker load -i [压缩文件名].tar.gz
```

> 跨系统迁移（win->linux）

使用上面的命令报错：**docker：Untar exit status 1 archive/tar: invalid tar header 错误解决**

使用如下命令镜像文件没有压缩


1. 获取镜像名 `REPOSITORY`

```sh
docker images
```

2. 生成镜像文件

`image.tar` 自定义压缩包名称

```sh
docker save 镜像名 -o image.tar
```

迁移多个

```sh
docker save 镜像名1 空格 镜像名2 -o image.tar
```

2. docker 导入镜像

```sh
docker load -i image.tar
```

?> `Docker load 之后镜像名字为<none>` 原因：在于这个镜像压缩包在打包的时候操作不当所导致：**使用镜像ID打包的话导致解压的出来的镜像没有名字**

?> 镜像重命名: docker tag [镜像id] [新镜像名称]:[新镜像标签]

3. 启动镜像
