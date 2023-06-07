# java

## 安装 java

>下载指定版本：

`https://www.oracle.com/java/technologies/downloads/archive/`

> 上传jdk压缩包并解压

```sh
rz
```

> 配置环境变量

?> `/home/local/java/jdk1.8.0_271` 是jdk安装目录

```sh
vi /etc/profile
```

?> 在`/etc/profile`最后一行添加

```sh
export JAVA_HOME=/home/local/java/jdk1.8.0_271
export PATH=$JAVA_HOME/bin:$PATH
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
```

?> 保存退出后source一下（vi 的使用方法可以自己搜索一下）

```sh
source /etc/profile
```
