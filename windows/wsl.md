# wsl

## 安装wsl

设置-》更多windows服务 

勾选虚拟机平台/适用于Linux的windows子系统


### 查询可安装服务

```shell
wsl --list -o
```

### 安装服务

```shell
wsl --install -d Ubuntu-24.04
```

### 报错

```vim
wsl/service/0x8007273d
```

解决方法： 管理员终端：netsh winsock reset 重启电脑

### 检查更新

```shell
 wsl --update
```

## 用户名密码

ubuntu:root/zhangLIpeng021?|zhanglipeng/zhangLIpeng021?

## 修改root用户密码

WSL 默认是没有设置 root 密码的
设置 root 用户密码, 这样要输三次命令, 第一次当前用户密码, 后两次就是设置密码以及确认密码

### 语法: sudo passwd 用户名

```sh
sudo passwd root
```

password updated successfully 代表密码更新成功, 切换用户

### 语法: su 用户名

```sh
su root
```

## 安装 systemd

wsl默认是没有systemd服务的，需要自行去安装。

### 安装daemonize和fontconfig

```sh
sudo apt install -y fontconfig daemonize
```

### 编辑/etc/profile脚本，加入如下内容：

```sh
sudo vi /etc/profile
```

```sh
SYSTEMD_PID=$(ps -ef | grep '/lib/systemd/systemd --system-unit=basic.target$' | grep -v unshare | awk '{print $2}')

if [ -z "$SYSTEMD_PID" ]; then
   sudo /usr/bin/daemonize /usr/bin/unshare --fork --pid --mount-proc /lib/systemd/systemd --system-unit=basic.target
   SYSTEMD_PID=$(ps -ef | grep '/lib/systemd/systemd --system-unit=basic.target$' | grep -v unshare | awk '{print $2}')
fi

if [ -n "$SYSTEMD_PID" ] && [ "$SYSTEMD_PID" != "1" ]; then
    exec sudo /usr/bin/nsenter -t $SYSTEMD_PID -a su - $LOGNAME
fi
```

### 修改/etc/sudoers文件，加入如下内容

```sh
sudo nano /etc/sudoers
```

```sh
%sudo ALL=(ALL) NOPASSWD: /usr/sbin/daemonize /usr/bin/unshare --fork --pid --mount-proc /lib/systemd/systemd --system-unit=basic.target
%sudo ALL=(ALL) NOPASSWD: /usr/bin/nsenter -t [0-9]* -a su - [a-zA-Z0-9]*
```

### 执行source /etc/profile

```sh
source /etc/profile
```

### 执行systemctl验证是否能够正常操作

```sh
systemctl -version
```

## wsl 与windows 文件互通

### 打开WSL子系统的shell终端

```sh
cd /mnt
```

> 显示当前windows系统的所有盘符.

```sh
ls
```

> 之后使用mv或者cp等命令进行复制移动即可

如：

```sh
cp /mnt/d/sixDgrs/docker/docker/docker-compose-linux-x86_64 /usr1/bin/docker/
```
