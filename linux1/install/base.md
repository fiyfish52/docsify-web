# 基础

## 安装rz sz

```sh
yum -y install lrzsz
```

## 配置环境变量

> 编辑

```sh
vi /etc/profile
```

最后一行加入： `export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/lib64`

> 应用使生效

```sh
source /etc/profile
```
