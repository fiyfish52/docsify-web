# sftp

[官网](https://www.ssh.com/academy/ssh/sftp-ssh-file-transfer-protocol)

sftp命令行登录过程
> 查看所有命令

```
sftp -help 
```

> 登录（默认root用户）
```
sftp ip 
```

> 指定用户 

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

> 下载整个文件目录

1. 使用-r参数
2. 在目录后面使用"."号

这样的话就可以把/opt/merkle 目录和子目录里面的文件全部下载到本地了。

> 常用命令汇总


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
