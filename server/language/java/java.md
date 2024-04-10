# java

## 安装 java

> 下载指定版本：

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

## keytool

### 生成证书

?> 管理员启动cmd

?> jdk1.8.0.11 生成的证书中有md5； jdk 11.0.11 生成的证书中没有md5

```sh
.\keytool.exe -genkey -alias cmms -keyalg RSA -keysize 1024 -validity 365 -keystore test1.keystore
```

| 参数          | 说明    | 值                           |
|-------------|-------|-----------------------------|
| `-alias`    | 别名    | 自定义字符串 `cmms`               |
| `keysize`   | 密钥位数  | `1024` `2048`               |
| `-validity` | 有效期天数 | 单位是天 `365` 表示365天           |
| `-keystore` | 证书名称  | 名称自定义 `test1.keystore` 后缀固定 |

### 查看证书

```sh
 .\keytool.exe -list -v -alias cmms  -storepass 123456  -keystore .\test1.keystore
```
