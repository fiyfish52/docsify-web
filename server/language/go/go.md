# go

[官网地址](http://docscn.studygolang.com/)

[下载地址-win](https://golang.google.cn/dl/go1.20.4.windows-amd64.msi)

[下载地址-linux](https://golang.google.cn/dl/go1.20.4.linux-amd64.tar.gz)

[中文网](https://studygolang.com/dl)

## linux 安装

### 下载

```sh
wget https://studygolang.com/dl/golang/go1.20.4.linux-amd64.tar.gz
```

### 解压

```sh
tar -xvf go1.20.4.linux-amd64.tar.gz
```

### 配置golang环境变量

!> 需要使用root用户

?> `/usr1/software/golang/go` 是golang安装目录

```sh
vi /etc/profile
```

在`/etc/profile`最后一行添加

```sh
export GOROOT=/usr1/software/golang/go
export GOPATH=$HOME/gopath
export PATH=$PATH:$GOROOT/bin
```

保存退出后`source`一下（vi 的使用方法可以自己搜索一下）

```sh
source /etc/profile
```

### 验证

```sh
go version
```

## 手动打包

```sh
go build go文件名
```
