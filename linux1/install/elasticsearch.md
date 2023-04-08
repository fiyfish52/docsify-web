# elasticsearch

?> elasticsearch是用Java实现的 跑elasticsearch必须要有jre支持 所以必须先安装jre

?>由于限制了不能是root用户；所以需要先创建新的用户：

> 创建新的用户

```sh
• useradd -m sixwork  
• 然后设置密码  passwd sixwork
```

> 下载

```sh
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.2.4.tar.gztar -zxvf elasticsearch-6.2.4.tar.gz -C /usr/local/
```

> 启动

```sh
sh /usr/local/elasticsearch-6.2.4/bin/elasticsearch &
```

默认端口问9200 启动后测试即可；

## 配置

设置外网访问：

配置文件增加：http.host: 0.0.0.0

默认用户名：elastic
默认密码在启动日志里找：password

更改密码：
./elasticsearch-reset-password   -u  elastic