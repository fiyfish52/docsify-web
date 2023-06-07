# code

## 包

### strconv

`字符串和数字类型相互转换`

Itoa is equivalent to FormatInt(int64(i), 10).

```java
strconv.Itoa(1)
```

## 安装新模块

```sh
go get ****
```

### 异常

#### 无法下载

```sh
go: go.mod file not found in current directory or any parent directory.
        'go get' is no longer supported outside a module.
        To build and install a command, use 'go install' with a version,
        like 'go install example.com/cmd@latest'
        For more information, see https://golang.org/doc/go-get-install-deprecation
        or run 'go help get' or 'go help install'.
```

> 解决

需要先生成 go.mod 文件

```sh
# 生成 mod 文件（切换到模块根目录）
go mod init modulename

# 清理无效依赖，增加缺失依赖
go mod tidy
```

#### 链接超时

?> 默认go的代理网站是`GOPROXY=https://proxy.golang.org,direct`，是一个外网地址，国内访问不到，因此我们需要修改代理网站。

```sh
go env -w GOPROXY=https://goproxy.cn,direct
```

### 安装ftp

```sh
go get -u -v github.com/dutchcoders/goftp
```

## main入参

```go
func main() {
    for idx, arg := range os.Args {
        fmt.Println("参数" + strconv.Itoa(idx) + ":" + arg)
    }
}
```
