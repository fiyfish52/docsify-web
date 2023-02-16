# sftp

> 拉取镜像

```
docker pull atmoz/sftp
```

> 启动服务

**settle:S1t3T2l4  用户名:密码**
```
docker run  -v ./upload:/home/foo/upload  -p 10022:22 -d atmoz/sftp  settle:S1t3T2l4:1001
```

> 赋权限

**此时docker里的文件服务器目录还无法使用**

docker 中文件服务器根目录地址
1. 进入docker
2. cd /home/[启动服务是的用户名：settle]
3. 创建指定的文件上传路径 mkdir -p usr1/uploadfile
4. 赋权：chmod 777 usr1/uploadfile
5. 测试，登录sftp

[sftp命令](/linux/sftp.md)
```
sftp -oPort=10022 用户名@ip
```