# docker-cli

## 官网地址

[官网命令地址](https://docs.docker.com/engine/reference/commandline/exec/)

## docker cli

[官网地址](https://docs.docker.com/engine/reference/commandline/restart/)

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

## 查看镜像版本

> linux

```sh
docker image inspect redis:latest|grep -i version
```

> windows

```sh
 docker image inspect elasticsearch:latest
```

结果：在`ContainerConfig.Env`中展示

```sh
[
    {
        "Id": "sha256:5acf0e8da90b995bace9fdc8f12c02ba323441873a509c19258ce0afa6754d0b",
        "RepoTags": [
            "elasticsearch:latest"
        ],
        "RepoDigests": [
            "elasticsearch@sha256:a8081d995ef3443dc6d077093172a5931e02cdb8ffddbf05c67e01d348a9770e"
        ],
        "Parent": "",
        "Comment": "",
        "Created": "2018-09-20T20:19:38.886693283Z",
        "Container": "1c9c59eb7fdec5051d9d9ac1b849fd3856c56049a6cba50fdd191ee015f0146c",
        "ContainerConfig": {
            "Hostname": "1c9c59eb7fde",
            "Domainname": "",
            "User": "",
            "AttachStdin": false,
            "AttachStdout": false,
            "AttachStderr": false,
            "ExposedPorts": {
                "9200/tcp": {},
                "9300/tcp": {}
            },
            "Tty": false,
            "OpenStdin": false,
            "StdinOnce": false,
            "Env": [
                "PATH=/usr/share/elasticsearch/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
                "LANG=C.UTF-8",
                "JAVA_HOME=/docker-java-home/jre",
                "JAVA_VERSION=8u181",
                "JAVA_DEBIAN_VERSION=8u181-b13-1~deb9u1",
                "CA_CERTIFICATES_JAVA_VERSION=20170531+nmu1",
                "GOSU_VERSION=1.10",
                "ELASTICSEARCH_VERSION=5.6.12",
                "ELASTICSEARCH_DEB_VERSION=5.6.12"
            ],
            "Cmd": [
                "/bin/sh",
                "-c",
                "#(nop) ",
                "CMD [\"elasticsearch\"]"
            ],
            "ArgsEscaped": true,
            "Image": "sha256:4dacdbbdee85231a55553b175a550553e8c97b367b307ded562e04cef18e31a8",
            "Volumes": {
                "/usr/share/elasticsearch/data": {}
            },
            "WorkingDir": "/usr/share/elasticsearch",
            "Entrypoint": [
                "/docker-entrypoint.sh"
            ],
            "OnBuild": [],
            "Labels": {}
        },
        "DockerVersion": "17.06.2-ce",
        "Author": "",
        "Config": {
            "Hostname": "",
            "Domainname": "",
            "User": "",
            "AttachStdin": false,
            "AttachStdout": false,
            "AttachStderr": false,
            "ExposedPorts": {
                "9200/tcp": {},
                "9300/tcp": {}
            },
            "Tty": false,
            "OpenStdin": false,
            "StdinOnce": false,
            "Env": [
                "PATH=/usr/share/elasticsearch/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
                "LANG=C.UTF-8",
                "JAVA_HOME=/docker-java-home/jre",
                "JAVA_VERSION=8u181",
                "JAVA_DEBIAN_VERSION=8u181-b13-1~deb9u1",
                "CA_CERTIFICATES_JAVA_VERSION=20170531+nmu1",
                "GOSU_VERSION=1.10",
                "ELASTICSEARCH_VERSION=5.6.12",
                "ELASTICSEARCH_DEB_VERSION=5.6.12"
            ],
            "Cmd": [
                "elasticsearch"
            ],
            "ArgsEscaped": true,
            "Image": "sha256:4dacdbbdee85231a55553b175a550553e8c97b367b307ded562e04cef18e31a8",
            "Volumes": {
                "/usr/share/elasticsearch/data": {}
            },
            "WorkingDir": "/usr/share/elasticsearch",
            "Entrypoint": [
                "/docker-entrypoint.sh"
            ],
            "OnBuild": [],
            "Labels": null
        },
        "Architecture": "amd64",
        "Os": "linux",
        "Size": 485921387,
        "VirtualSize": 485921387,
        "GraphDriver": {
            "Data": {
                "LowerDir": "/var/lib/docker/overlay2/6834bb3e365df8117d470fe5511dcc72c6970e4737f934ac58a505c4c5493ef1/diff:/var/lib/docker/overlay2/438ba230b0a8cefa27fff63e1aaf2d3ed4e3c6e2c2e7ddb607257ce31ce041b7/diff:/var/lib/docker/overlay2/b4e861711f291d38e3730dbd2899a78a01b2ba95fbe54316412364952e4f5118/diff:/var/lib/docker/overlay2/7f81267c1cff46b898d6902ee1e718508fbc5d194b7c6ba01935c29e2e8a512a/diff:/var/lib/docker/overlay2/cf96dd5eea373d87167e3e18a4bcebe2ccd8ca7c28bc507efd2ef033c58b9ea4/diff:/var/lib/docker/overlay2/cb16e9ace5fd64789ff6db9c3bffea00faea5e18fc6e8c7ec1cc2bd4cdb5099f/diff:/var/lib/docker/overlay2/0004e6256621af09169c6d9ac10ac129ebfe04d3ec3efe3921a3b5e6bfa290f4/diff:/var/lib/docker/overlay2/1ba01ec7d765c6f545ea0de2498bed17630965f52701a840ab46b4f453936fbc/diff:/var/lib/docker/overlay2/352f5c2c9bdf26d6945cf55e832c2f565b21c5eb662f85f6555ffbe08ebeefd2/diff:/var/lib/docker/overlay2/52854923bccb9af4b8db97a14f1eca88f0f60beff58f1686fe5c732bb489e416/diff:/var/lib/docker/overlay2/e0fa61f147867662da3c1b9a41058c2842edccd7bbcabeed829bdd0d9e7f78a5/diff:/var/lib/docker/overlay2/76f3c66df8e398ad75568d0bb27fce6321ed4bd5aaccdae39aaaabec4012b2a7/diff:/var/lib/docker/overlay2/d4e358684ceb798e4c5fdd3ba1de0b8e6fc8b5e2cc122464bfc20f07357edba8/diff:/var/lib/docker/overlay2/63458e0f8034a58aa463b3f11fe4716cfc597910170a5ee5be31eb6dc4fb9aff/diff",
                "MergedDir": "/var/lib/docker/overlay2/1db35a923693d6a066c8d337a695e1f364c65937837febd22943be8e0e9f06b3/merged",
                "UpperDir": "/var/lib/docker/overlay2/1db35a923693d6a066c8d337a695e1f364c65937837febd22943be8e0e9f06b3/diff",
                "WorkDir": "/var/lib/docker/overlay2/1db35a923693d6a066c8d337a695e1f364c65937837febd22943be8e0e9f06b3/work"
            },
            "Name": "overlay2"
        },
        "RootFS": {
            "Type": "layers",
            "Layers": [
                "sha256:b28ef0b6fef80faa25436bec0a1375214d9a23a91e9b75975bba3b2889f8504f",
                "sha256:0b703c74a09c1e55d52e6b689babc6ae6374a793c1acfe8ff21a554014d8f434",
                "sha256:2eb1c9bfc5ead1e646e39ab760ead591f995cf606c327235a21eeb075ec5c178",
                "sha256:da22ca4fb8f335b238d147e69431671d8ef4d00632f98cc057df1a1c0ed66e75",
                "sha256:e0caf225fa20180b539e1a9732bab2879d8a4c10968717425dd3a89a77bc8805",
                "sha256:a8d68e0ce4e3b83d356e1d6354fb96ae561e456934bf55296509edd5fdd4b7c7",
                "sha256:034f354793a45b692d49805261a4e8532dbc189c973a905a33551b28c6c5f237",
                "sha256:00fc55ade1b87affa70219f2a4bf9a2c571c5b30b59c00fb7bcb666d9cd91eef",
                "sha256:6caba5c72c54ce4cb01fd8e9cdb0d9d9a7ff9822a8b92bffecff07938b30c2e9",
                "sha256:5454b4aa0e08ff6c46a2d7efe6c88c3986cc1e61d36bc0bfa95e2a0df1173c1f",
                "sha256:33b658943a63efcd8384d446b260473eb12ac69082227d665e969247355695cc",
                "sha256:57c9b5e6f84bfca3bfeaf7861127d974c81270b786b239c522a1c55af6638933",
                "sha256:8323112b1aa39e51319e9b686be347e9f4160b8a80af08a88e2069e876554912",
                "sha256:6631835ccd804cf175d1039ae0dc1965d33a2b487de814a445cb3a6bfcfcaf4b",
                "sha256:15fe7d194ae6bbf9bf34a145b935bd6c8f585ca9f1767c5e1a174d4b9231b1fc"
            ]
        },
        "Metadata": {
            "LastTagTime": "0001-01-01T00:00:00Z"
        }
    }
]
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

### 进入容器

```sh
docker ps
```

```sh
docker exec -it [CONTAINERID] /bin/bash
```

### docker 删除容器 镜像

```sh
1.停用全部运行中的容器: docker stop $(docker ps -a)
2.删除全部容器: docker rm $(docker ps -aq)
3.一条命令实现停用并删除容器: docker stop $(docker ps -a) & docker rm -f $(docker ps -aq)
同样删除全部镜像文件
docker rmi -f $(docker images)
```

### 删除镜像

```sh
docker rmi -f 镜像id
```

### docker 删除/停止容器

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

### 卸载docker

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

### 查看docker容器 日志

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

### 查看镜像文件

**imagesname : 镜像名称**

```sh
docker run -i -t imagesname /bin/bash
```

### 拷贝镜像文件至宿主

```sh
docker cp nginx-dgwork-4:/etc/nginx /home/dgwork/data/nginx-4
```

| 属性                        | 说明             |
| --------------------------- | ---------------- |
| `nginx-dgwork-4`            | `镜像名`         |
| `/etc/nginx`                | `镜像内文件路径` |
| `/home/dgwork/data/nginx-4` | `宿主文件路径`   |

## 容器更新


### restart 设置自启动



```sh
docker update --restart=always  容器id
```

### restart 参数

[官网说明](https://docs.docker.com/engine/reference/commandline/run/#restart)

> no 默认值，表示容器退出时，docker不自动重启容器

> on-failure 若容器的退出状态非0，则docker自动重启容器，还可以指定重启次数，若超过指定次数未能启动容器则放弃

```sh
--restart=on-failure:3
```

> always 容器退出时总是重启

> unless-stopped 容器退出时总是重启，但不考虑Docker守护进程启动时就已经停止的容器

> 如果容器启动时没有设置–restart参数，则通过下面命令进行更新

```sh
docker update --restart=always [容器名]
```

## docker 问题

> 查看日志

报错：/docker-entrypoint.sh: 38: exec: -p: not found

原因： `-p` 参数放到了 `-d`的后面

解决： 更改启动`docker run` 命令，将`-d` 参数放到最后面，

## docker 容器迁移

?> 1.把运行中的容器打包成镜像，2.迁移镜像

### 查找容器id

```sh
docker ps
```

### 容器打包成镜像

```sh
docker commit d1b696ef8378 mywide-fdfs-nginx-165:0.0.1
```

### 迁移打包好的镜像

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
