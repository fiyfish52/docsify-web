# Linux-cli

## 给用户赋文件夹权限

```
chown -R 用户名 文件夹名
```
登陆root(拥有文件夹权限)

**chown -R maywide elasticsearch-8.5.1**

---

## 创建新用户

>增加用户
```
useradd -m 用户名
```
**useradd -m sixwork**

>设置密码  
```
passwd 用户名
```
**passwd sixwork**

---

## 更改环境变量

> 适用当前窗口
 此方式只使用于当前会话
```
export NODE_HOME=/opt/node
export PATH=$NODE_HOME/bin:$PATH
```
或者 
```
export PATH=/opt/node/bin:$PATH
```
> 
> 适用所有窗口

1. 方案一
```
    Vi ~/.bashrc（打开隐藏文件  ll -a）
最后一句添加：export PATH=/opt/node/bin:$PATH
然后执行source ~/.bashrc
```
2. 方案二
```
1，vim /etc/profile
2，在文件末尾添加以下代码
export PATH=/usr/local/go/bin:$PATH 
3，使用source使配置文件立即生效
source /etc/profile 
```
>**/etc/profile**
>>此文件为系统的每个用户设置环境信息，当用户第一次登录时，该文件被执行。
并从 /etc/profile.d 目录的配置文件中收集 shell 的设置。
如果你有对 /etc/profile 有修改的话必须得 source 一下你的修改才会生效，此修改对每个用户都生效。
3. 方案三
   
**设置环境变量，最方便**

```
1，添加新的环境变量：/usr/local/go/bin
export PATH=/usr/local/go/bin:$PATH
2，使用环境变量生效
source /etc/profile
```

---

## 远程复制（SCP）

1.scp基本格式
```
scp local_file user@host:/dir
```

2.scp复制文件到指定端口
scp默认连接的远端主机22端口，如果ssh不是使用标准的22端口（以16022为例）则使用-P（P大写）指定：
```
scp -P 16022 local_file user@host:/dir
```
3.从远端主机将文件复制到另一台远端主机
scp不仅可以将文件从本机复制到远端机器，还可以将文件从远端机复制到本机，还可以将文件从一台远端机复制到另一台远端机：
```
scp user1@host1:file1 user2@host2:file
```
这也就是说当情况如：A/B/C三台主机，A和B、B和C网络相通但A和C网络不通，要求把文件从A复制到C上。

那么可行的操作是把文件从A复制到B，再把文件从B复制到C；还可行的情况是直接在B上把文件从A复制到C，在B上执行：
```
scp userA@hostA:fileA userC@hostC:fileC
```
---

## 文件夹、文件操作

Linux文件夹或文件创建、删除

> Linux删除文件夹命令

linux删除目录很简单，很多人还是习惯用rmdir，不过一旦目录非空，就陷入深深的苦恼之中，现在使用rm -rf命令即可。

直接rm就可以了，不过要加两个参数-rf 即：rm -rf 目录名字

删除目录、文件 rm(remove)

功能说明：删除文件或目录。

语　　法：
```
rm [-dfirv][--help][--version][文件或目录...]
```
补充说明：执行rm指令可删除文件或目录，如欲删除目录必须加上参数”-r”，否则预设仅会删除文件。


|参数|说明|
|---|---|
|-d或–directory| 　直接把欲删除的目录的硬连接数据删成0，删除该目录。
|-f或–force |　强制删除文件或目录。
|-i或–interactive| 　删除既有文件或目录之前先询问用户。
|-r或-R或–recursive |　递归处理，将指定目录下的所有文件及子目录一并处理。
|-v或–verbose| 　显示指令执行过程。


> 删除文件夹
```
rm -rf fileName
```
> 删除文件夹实例：
```
rm -rf /var/log/httpd/access
```
将会删除/var/log/httpd/access目录以及其下所有文件、文件夹
需要提醒的是：使用这个rm -rf的时候一定要格外小心，linux没有回收站的

> 删除文件
```
rm -f fileNamede>
```

> 添加文件夹

创建目录：
```
mkdir(make directories)  
```
功能说明：建立目录  
语　　法：
```
mkdir [-p][--help][--version][-m <目录属性>][目录名称]  
```
补充说明：mkdir可建立目录并同时设置目录的权限。

|参数|说明|
|---|---|
|-m|<目录属性>或–mode<目录属性> 建立目录时同时设置目录的权限。
|-p或–parents| 若所要建立目录的上层目录目前尚未建立，则会一并建立上层目录。

```
mkdir test
```

> 创建文件 touch

功能说明：改变文件或目录时间。

语　　法：
```
touch [-acfm][-d <日期时间>][-r <参考文件或目 录>][-t <日期时间>] [--help]　　 [--version][文件或目录...] 或 touch [-acfm][--help][--version][日期时 间][文件或目录...]
```
**例：touch test.txt （注：Linux下没有文件后缀名区分文件类型之说，系统文件类型只有可执行文件和不可执行文件）**

补充说明：使用touch指令可更改文件或目录的日期时间，包括存取时间和更改时间。

|参数|说明|
|---|---|
|-a或–time=atime或–time=access或–time=use| 　只更改存取时间。
|-c或–no-create |　不建立任何文件。
|-d|<时间日期> 使用指定的日期时间，而非现在的时间。
|-f| 　此参数将忽略不予处理，仅负责解决BSD版本touch指令的兼容性问题。
|-m或–time=mtime或–time=modify| 　只更改变动时间。
|-r|<参考文件或目录> 把指定文件或目录的日期时间，统统设成和参考文件或目录的日期时间相同。
|-t|<日期时间> 使用指定的日期时间，而非现在的时间。


---

## 压缩与解压缩
 
 **tar命令**

> 压缩操作
```
tar -cvf /usr/local/auto_bak/test.tar /usr/local/test
```
**仅打包，不压缩**
```
tar -zcvf /usr/local/auto_bak/test.tar.gz /usr/local/test
```
**打包后，以gzip压缩 在参数f后面的压缩文件名是自己取的，习惯上用tar来做，**   
**如果加z参数，则以tar.gz 或tgz来代表gzip压缩过的tar file文件**

> 解压操作
```
tar -zxvf /usr/local/test.tar.gz
```

> tar 解压缩命令详解  

|||
|---|---|
|-c:| 建立压缩档案  |
|-x：|解压  |
|-t：|查看内容  |
|-r：|向压缩归档文件末尾追加文件  
|-u：|更新原压缩包中的文件  
**这五个是独立的命令，压缩解压都要用到其中一个，可以和别的命令连用但只能用其中一个。下面的参数是根据需要在压缩或解压档案时可选的。** 
|-z：|有gzip属性的  
|-j：|有bz2属性的  
|-Z：|有compress属性的  
|-v：|显示所有过程  
|-O：|将文件解开到标准输出  
**下面的参数-f是必须的**
|-f: |使用档案名字，切记，这个参数是最后一个参数，后面只能接档案名。  

> 示例

|命令|说明|
|---|---|
|tar -cf all.tar *.jpg |这条命令是将所有.jpg的文件打成一个名为all.tar的包。-c是表示产生新的包，-f指定包的文件名。|
|tar -rf all.tar *.gif |这条命令是将所有.gif的文件增加到all.tar的包里面去。-r是表示增加文件的意思。|
| tar -uf all.tar logo.gif |这条命令是更新原来tar包all.tar中logo.gif文件，-u是表示更新文件的意思。|
|tar -tf all.tar |这条命令是列出all.tar包中所有文件，-t是列出文件的意思|
|tar -xf all.tar |这条命令是解出all.tar包中所有文件，-x是解开的意思|

> 压缩

|命令|说明|
|---|---|
|tar –cvf jpg.tar *.jpg |将目录里所有jpg文件打包成tar.jpg|
|tar –czf jpg.tar.gz *.jpg   |将目录里所有jpg文件打包成jpg.tar后，并且将其用gzip压缩，生成一  个gzip压缩过的包，命名为jpg.tar.gz|
|tar –cjf jpg.tar.bz2 *.jpg |将目录里所有jpg文件打包成jpg.tar后，并且将其用bzip2压缩，生成一个bzip2压缩过的包，命名为jpg.tar.bz2|
|tar –cZf jpg.tar.Z *.jpg   |将目录里所有jpg文件打包成jpg.tar后，并且将其用compress压缩，生成一个umcompress压缩过的包，命名为jpg.tar.Z|
|rar a jpg.rar *.jpg |rar格式的压缩，需要先下载rar for linux|
|zip jpg.zip *.jpg |zip格式的压缩，需要先下载zip for linux|

> 解压

|命令|说明|
|---|---|
|tar –xvf file.tar |解压 tar包|
|tar -xzvf file.tar.gz |解压tar.gz|
|tar -xjvf file.tar.bz2   |解压 tar.bz2|
|tar –xZvf file.tar.Z   |解压tar.Z|
|unrar e file.rar |解压rar|
|unzip file.zip |解压zip|

> 总结

|命令|说明|
|---|---|
|*.tar| 用 tar –xvf 解压|
|*.gz| 用 gzip -d或者gunzip 解压|
|*.tar.gz和 *.tgz| 用 tar –xzf 解压|
|*.bz2| 用 bzip2 -d或者用bunzip2 解压|
|*.tar.bz2|用tar –xjf 解压|
|*.Z |用 uncompress 解压|
|*.tar.Z| 用tar –xZf 解压|
|*.rar |用 unrar e解压|
|*.zip |用 unzip 解压|



---












## 问题
>更改环境变量后 ll，ls命令失效

ftp进入/root/ 重新设置 .bashrc 文件
```
1. export PATH=/usr/local/git/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin
2. rsource ~/.bashc
ok
```


