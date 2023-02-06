# windows-Cli


## 查看文件

```
type filename
```

## 端口占用
```
netstat -aon|findstr 80 
```
```
tasklist|findstr 15892
```
```
taskkill -F /pid 15892    根据pid 结束进程
```
```
taskkill /f /t /im nginx.exe 根据进程名结束进程
```


## 	自启动bat配置
C:\Users\Mr.zhang\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup

>1. 示例 （启动consule.exe） 

启动文件 startConsul.bat:
```
call "D:\workspace\TKH\consul_1.11.4_windows_amd64\startConsul.bat"
pause
```
启动脚本 D:\workspace\TKH\consul_1.11.4_windows_amd64\startConsul.bat：
```
d:
cd D:\workspace\TKH\consul_1.11.4_windows_amd64
.\consul.exe agent -dev -client 0.0.0.0 -ui
Pause
```


## 右键菜单加入指定快捷

新建vscode.reg文件；更改文件中的exe路径；注意分隔符使用双划线；然后双击执行即可

更改内容主要包含为：

**exe路径：【C:\\user\\program\\JetBrains\\WebStorm 2021.1.1\\bin\\WebStorm64.exe】**

**右键菜单显示的名称【WebStorm】**

```
Windows Registry Editor Version 5.00

[HKEY_CLASSES_ROOT\*\shell\WebStorm]
@="Open with WebStorm"
"Icon"="C:\\user\\program\\JetBrains\\WebStorm 2021.1.1\\bin\\WebStorm64.exe"

[HKEY_CLASSES_ROOT\*\shell\WebStorm\command]
@="\"C:\\user\\program\\JetBrains\\WebStorm 2021.1.1\\bin\\WebStorm64.exe\" \"%1\""

Windows Registry Editor Version 5.00

[HKEY_CLASSES_ROOT\Directory\shell\WebStorm]
@="Open with WebStorm"
"Icon"="C:\\user\\program\\JetBrains\\WebStorm 2021.1.1\\bin\\WebStorm64.exe"

[HKEY_CLASSES_ROOT\Directory\shell\WebStorm\command]
@="\"C:\\user\\program\\JetBrains\\WebStorm 2021.1.1\\bin\\WebStorm64.exe\" \"%V\""

Windows Registry Editor Version 5.00

[HKEY_CLASSES_ROOT\Directory\Background\shell\WebStorm]
@="Open with WebStorm"
"Icon"="C:\\user\\program\\JetBrains\\WebStorm 2021.1.1\\bin\\WebStorm64.exe"

[HKEY_CLASSES_ROOT\Directory\Background\shell\WebStorm\command]
@="\"C:\\user\\program\\JetBrains\\WebStorm 2021.1.1\\bin\\WebStorm64.exe\" \"%V\""
```


## 配置支持 gzip

1. 下载gzip
[下载链接](https://udomain.dl.sourceforge.net/project/gnuwin32/gzip/1.3.12-1/gzip-1.3.12-1-bin.zip)

2. 解压
3. 拷贝 ../bin/gzip.exe --> C:\Windows\System32
4. ok
