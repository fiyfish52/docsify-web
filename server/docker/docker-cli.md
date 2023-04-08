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

> 查看docker容器 日志

```sh
docker logs [OPTIONS] CONTAINER
  Options:
        --details        显示更多的信息
    -f, --follow         跟踪实时日志
        --since string   显示自某个timestamp之后的日志，或相对时间，如42m（即42分钟）
        --tail string    从日志末尾显示多少行日志， 默认是all
    -t, --timestamps     显示时间戳
        --until string   显示自某个timestamp之前的日志，或相对时间，如42m（即42分钟）
```

1. 查看指定时间后的日志，只显示最后100行：

```sh
docker logs -f -t --since="2018-02-08" --tail=100 CONTAINER_ID
```

2. 查看最近30分钟的日志:

```sh
docker logs --since 30m CONTAINER_ID
```

3. 查看某时间之后的日志：

```sh
docker logs -t --since="2018-02-08T13:23:37" CONTAINER_ID
```

4. 查看某时间段日志：

```sh
docker logs -t --since="2018-02-08T13:23:37" --until "2018-02-09T12:23:37" CONTAINER_ID
```

> 查看镜像文件

**imagesname : 镜像名称**

```sh
docker run -i -t imagesname /bin/bash
```

> 拷贝镜像文件至宿主

```sh
docker cp nginx-dgwork-4:/etc/nginx /home/dgwork/data/nginx-4
```

| 属性                        | 说明             |
| --------------------------- | ---------------- |
| `nginx-dgwork-4`            | `镜像名`         |
| `/etc/nginx`                | `镜像内文件路径` |
| `/home/dgwork/data/nginx-4` | `宿主文件路径`   |

## docker 问题

> 查看日志

报错：/docker-entrypoint.sh: 38: exec: -p: not found

原因： `-p` 参数放到了 `-d`的后面

解决： 更改启动`docker run` 命令，将`-d` 参数放到最后面，

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
