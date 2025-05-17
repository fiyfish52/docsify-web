# sftp

## docker 部署

### 拉取镜像

```
docker pull atmoz/sftp
```

### 启动服务

**settle:S1t3T2l4  用户名:密码**
```
 docker run --name knbs-sftp  -v ./upload:/home/foo/upload  -p 10022:22 -d atmoz/sftp  settle:S1t3T2l4:1001
```

### 赋权限

**此时docker里的文件服务器目录还无法使用**

docker 中文件服务器根目录地址
1. 进入docker
2. cd /home/[启动服务是的用户名：settle]
3. 创建指定的文件上传路径 mkdir -p usr1/uploadfile
4. 赋权：chmod 777 usr1/uploadfile
5. 测试，登录sftp

```
sftp -oPort=10022 用户名@ip
```



## sftp命令



[官网](https://www.ssh.com/academy/ssh/sftp-ssh-file-transfer-protocol)

sftp命令行登录过程

### 查看所有命令

```
sftp -help 
```

### 登录（默认root用户）

```
sftp ip 
```

### 指定用户

进行登录（blue为用户名）
```
sftp blue@ip 
```

① 录成功后，会提示输入 密码  
② 然后，可进入目录， ls 查看目录下内容  
③ cd 切换目录，get 获取文件， put 上传文件  
④ quit / bye / exit 退出sftp

> 如果登陆的时候端口不是默认的22，添加-oPort参数指定端口
(SFTP指定端口号登陆)

```
sftp -oPort=2289 用户名@ip
```

### 下载整个文件目录



1. 使用-r参数
2. 在目录后面使用"."号

这样的话就可以把/opt/merkle 目录和子目录里面的文件全部下载到本地了。



### 常用命令汇总


| SFTP 命令                     | 说明                        |
| ----------------------------- | --------------------------- |
| cd 路径                       | 更改到远程目录的路径        |
| lcd 路径                      | 更改到本地目录的路径        |
| chgrp group path              | 将文件path的组更改为group   |
| chmod mode path               | 将文件path的权限更改为mode  |
| chown owner path              | 将文件path的属主更改为owner |
| exit                          | 退出 sftp                   |
| help                          | 显示这个帮助文本            |
| get 远程路径                  | 下载文件                    |
| ln existingpath linkpath      | 符号链接远程文件            |
| ls [选项] [路径]              | 显示远程目录列表            |
| lls [选项] [路径]             | 显示本地目录列表            |
| mkdir 路径                    | 创建远程目录                |
| lmkdir 路径                   | 创建本地目录                |
| mv oldpath newpath            | 移动远程文件                |
| open [用户@]主机[:端口]       | 连接到远程主机              |
| put 本地路径                  | 上传文件                    |
| pwd                           | 显示远程工作目录            |
| lpwd                          | 打印本地工作目录            |
| quit                          | 退出 sftp                   |
| rmdir 路径                    | 移除远程目录                |
| lrmdir 路径                   | 移除本地目录                |
| rm 路径                       | 删除远程文件                |
| lrm 路径                      | 删除本地文件                |
| symlink existingpath linkpath | 符号链接远程文件            |
| version                       | 显示协议版本                |



## 示例

### 登陆

```
sftp -oPort=10022 用户名@ip
```

### 上传

```shell
# XXX切换本地补录
lcd C:\Users\zhanglipengLZ\Desktop
# 上传文件到远端 目录。必须拥有这个目录的权限 即必须赋权
put aaa.txt /usr1/uploadfile
```

### 下载

```sh
# 切换本地目录
lcd C:\UserszhanglipengLZ\Desktop
# 切换远程目录
cd /usr1/uploadfile
# 下载文件
get aaa.txt
```





## 更多配置

```shell
# 格式：username:password:uid:gid:home_dir:permissions
user1:pass123:1001:1001::/home/user1/upload:rw,nosuid,nodev,noexec
user2:pass456:1002:1002::/home/user2/upload:rw

```