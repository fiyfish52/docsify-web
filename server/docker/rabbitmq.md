# rabbitmq

[官网](https://www.rabbitmq.com/tutorials)

## 拉取镜像

```shell
docker pull rabbitmq:management
```

## 启动

```shell
docker run -id --name=knbs-rabbitmq -p 5671:5671 -p 5672:5672 -p 4369:4369 -p 15671:15671 -p 15672:15672 -p 25672:25672 -e RABBITMQ_DEFAULT_USER=zhanglp -e RABBITMQ_DEFAULT_PASS=zhangLIpeng021? rabbitmq:management
```

15672为其web端界面访问时端口，5672为数据通信端口

## 访问管理页面

`http://localhost:15672/#/` 

## 操作
