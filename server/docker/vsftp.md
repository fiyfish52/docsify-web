# vsftp

[dockerhub](https://hub.docker.com/r/fauria/vsftpd)

1. 查找镜像

```
docker search vsftp
```

2. 拉取镜像

```
docker pull fauria/vsftpd 
```

3. 启动容器

```
docker run -d -v ./agent:/home/vsftpd -p 20:20 -p 21:21 -p 21100-21110:21100-21110 -e FTP_USER=digittest -e FTP_PASS=digit123456 -e PASV_ADDRESS=127.0.0.1 -e PASV_MIN_PORT=21100 -e PASV_MAX_PORT=21110 --name vsftpd --restart=always fauria/vsftpd
```