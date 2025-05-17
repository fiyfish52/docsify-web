# 离线安装docker、docker-compose

**<font color=red>安装docker必须拥有root权限</font>**

## docker

> 环境说明

在某些部署环境下，因为网络或者其他原因，不能在线部署，这时候就需要以离线的方式安装docker；

> 安装步骤

1. 获取docker安装文件，官方地址如下：

```
https://download.docker.com/linux/static/stable/x86_64
```
版本自选，示例选择版本：docker-19.03.9.tgz

2. 将下载的安装文件进行解压，命令如下：

```
tar zxvf docker-19.03.9.tgz
```
3. 将上述解压后文件（docker文件夹）全部移动至/usr/bin目录下（必须），命令如下：

```
cp -p docker/* /usr/bin
```
4. 将docker注册为service，步骤如下：

① 输入如下命令：
```
vi /usr/lib/systemd/system/docker.service
```
② 点击i，下面出现-----insert----进入编辑状态

复制下面内容至docker.service，复制内容如下：

```
[Unit]
Description=Docker Application Container Engine
Documentation=http://docs.docker.com
After=network.target docker.socket
[Service]
Type=notify
EnvironmentFile=-/run/flannel/docker
WorkingDirectory=/usr/local/bin
ExecStart=/usr/bin/dockerd \
                -H tcp://0.0.0.0:4243 \
                -H unix:///var/run/docker.sock \
                --selinux-enabled=false \
                --log-opt max-size=1g
ExecReload=/bin/kill -s HUP $MAINPID
# Having non-zero Limit*s causes performance problems due to accounting overhead
# in the kernel. We recommend using cgroups to do container-local accounting.
LimitNOFILE=infinity
LimitNPROC=infinity
LimitCORE=infinity
# Uncomment TasksMax if your systemd version supports it.
# Only systemd 226 and above support this version.
#TasksMax=infinity
TimeoutStartSec=0
# set delegate yes so that systemd does not reset the cgroups of docker containers
Delegate=yes
# kill only the docker process, not all processes in the cgroup
KillMode=process
Restart=on-failure
[Install]
WantedBy=multi-user.target
```
复制完成之后，点击esc键，并输入:wq!保存并强制退出；

可执行如下命令，查看上述复制内容是否正确

```
cat /usr/lib/systemd/system/docker.service
```
5. 重新加载docker配置文件，命令如下：

```
systemctl daemon-reload
```
6. 启动docker，命令如下：

```
systemctl start docker
```

重启
```
systemctl restart docker
```
1. 设置docker开机启动，命令如下：


```
systemctl enable docker
```
8. 查看docker是否安装成功，命令如下：

```
docker version
```


## docker-compose
1. 下载

```
https://github.com/docker/compose/releases
```

1. 上传到服务器，将文件转移至/usr/local/bin/

```
mv docker-compose-linux-x86_64 /usr/local/bin/docker-compose
```
3. 添加权限

```
chmod +x /usr/local/bin/docker-compose
```
4. 测试

```
docker-compose -v
```

## 拉取镜像超时

```shell
vi /etc/docker/daemon.json
```

增加镜像地址：

2025年4月28日 09:38:04 阿里云镜像加速，公共地址用不了了 

```shell
    "https://docker.1ms.run",
    "https://docker.xuanyuan.me",
    "https://h6x865gy.mirror.aliyuncs.com",
    "https://do.nark.eu.org",
    "https://dc.j8.work",
    "https://docker.m.daocloud.io",
    "https://dockerproxy.com",
    "https://docker.mirrors.ustc.edu.cn",
    "https://docker.nju.edu.cn"
```

重新加载配置
sudo systemctl daemon-reload
重启docker
sudo systemctl restart docker