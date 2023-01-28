# bat 脚本

## bat 脚本中文乱码

>1. 方案一

默认情况下，在 bat 脚本文件中，如果中文不是ANSI编码，就会出现乱码。因此，可以采用Windows操作系统平台自带的记事本打开脚本文件，点击菜单【文件】-【另存为】操作，选择ANSI编码进行保存。

>2. 方案二

在原先 bat 脚本文件中声明更改代码页
```
chcp 65001
```

>3. chcp命令

**Changes the active console code page.**

常用代码映射

|代码页|映射的字符集|
|:--:|:--:|
|936|GB2312|
|20127|US-ASCII|
|65001|UTF-8|



## 创建文件夹，已当前时间命名

```
set hour=%time:~0,2%
if /i %hour% LSS 10 (
 set hour=0%time:~1,1%
)
set filename=%date:~0,4%%date:~5,2%%date:~8,2%_%hour%.%time:~3,2%.%time:~6,2%
echo "创建文件夹：jar-%filename%"
md jar-%filename%
```