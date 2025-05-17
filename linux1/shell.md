# Shell

## 第一个shell脚本

打开文本编辑器(可以使用 vi/vim 命令来创建文件)，新建一个文件 test.sh，扩展名为 sh（sh代表shell），扩展名并不影响脚本执行，见名知意就好，如果你用 php 写 shell 脚本，扩展名就用 php 好了。

输入一些代码，第一行一般是这样：

### 实例

```sh
#!/bin/bash
echo "Hello World !"
```

[运行实例 »](https://www.runoob.com/try/runcode.php?filename=helloworld&type=bash)

**#!** 是一个约定的标记，它告诉系统这个脚本需要什么解释器来执行，即使用哪一种 Shell。

echo 命令用于向窗口输出文本。

### 运行 Shell 脚本

**1、作为可执行程序**

将上面的代码保存为 test.sh，并 cd 到相应目录：

```sh
chmod +x ./test.sh  #使脚本具有执行权限
./test.sh  #执行脚本
```

注意，一定要写成 **./test.sh**，而不是 **test.sh**，运行其它二进制的程序也一样，直接写 test.sh，linux 系统会去 PATH 里寻找有没有叫 test.sh 的，而只有 /bin, /sbin, /usr/bin，/usr/sbin 等在 PATH 里，你的当前目录通常不在 PATH 里，所以写成 test.sh 是会找不到命令的，要用 ./test.sh 告诉系统说，就在当前目录找。

**2、作为解释器参数**

这种运行方式是，直接运行解释器，其参数就是 shell 脚本的文件名，如：

```sh
/bin/sh test.sh
/bin/php test.php
```

这种方式运行的脚本，不需要在第一行指定解释器信息，写了也没用。

## Shell 变量

在 Shell 编程中，变量是用于存储数据值的名称。

定义变量时，变量名不加美元符号（$，PHP语言中变量需要），如：

```sh
your_name="runoob"
```

注意，变量名和等号之间不能有空格，这可能和你熟悉的所有编程语言都不一样。同时，变量名的命名须遵循如下规则：

- **只包含字母、数字和下划线：** 变量名可以包含字母（大小写敏感）、数字和下划线 **_**，不能包含其他特殊字符。
- **不能以数字开头：** 变量名不能以数字开头，但可以包含数字。
- **避免使用 Shell 关键字：** 不要使用Shell的关键字（例如 if、then、else、fi、for、while 等）作为变量名，以免引起混淆。
- **使用大写字母表示常量：** 习惯上，常量的变量名通常使用大写字母，例如 **PI=3.14**。
- **避免使用特殊符号：** 尽量避免在变量名中使用特殊符号，因为它们可能与 Shell 的语法产生冲突。
- **避免使用空格：** 变量名中不应该包含空格，因为空格通常用于分隔命令和参数。

等号两侧避免使用空格：

```sh
# 正确的赋值
variable_name=value

# 有可能会导致错误
variable_name = value
```

除了显式地直接赋值，还可以用语句给变量赋值，如：

```sh
# 正确的赋值
variable_name=value

# 有可能会导致错误
variable_name = value
```

以上语句将 `/etc` 下目录的文件名循环出来。

### 使用变量

使用一个定义过的变量，只要在变量名前面加美元符号即可，如：

```sh
your_name="qinjx"
echo $your_name
echo ${your_name}
```

变量名外面的花括号是可选的，加不加都行，加花括号是为了帮助解释器识别变量的边界，比如下面这种情况：

```sh
for skill in Ada Coffe Action Java; do
    echo "I am good at ${skill}Script"
done
```

推荐给所有变量加上花括号，这是个好的编程习惯。

已定义的变量，可以被重新定义，如：

```sh
your_name="tom"
echo $your_name
your_name="alibaba"
echo $your_name
```

这样写是合法的，但注意，第二次赋值的时候不能写$your_name="alibaba"，使用变量的时候才加美元符（$）。

### 只读变量

使用 readonly 命令可以将变量定义为只读变量，只读变量的值不能被改变。

下面的例子尝试更改只读变量，结果报错：

```sh
#!/bin/bash

myUrl="https://www.google.com"
readonly myUrl
myUrl="https://www.runoob.com"
# /bin/sh: NAME: This variable is read only.
```

### 删除变量

使用 unset 命令可以删除变量。语法：

```sh
unset variable_name
```

变量被删除后不能再次使用。unset 命令不能删除只读变量。

### 变量类型

Shell 支持不同类型的变量，其中一些主要的类型包括：

#### **字符串变量**

在 Shell中，变量通常被视为字符串。

你可以使用单引号 **'** 或双引号 **"** 来定义字符串，例如：

```sh
my_string='Hello, World!'

或者

my_string="Hello, World!"
```

字符串是shell编程中最常用最有用的数据类型（除了数字和字符串，也没啥其它类型好用了），字符串可以用单引号，也可以用双引号，也可以不用引号。

##### 单引号

```sh
str='this is a string'
```

单引号字符串的限制：

- 单引号里的任何字符都会原样输出，单引号字符串中的变量是无效的；
- 单引号字符串中不能出现单独一个的单引号（对单引号使用转义符后也不行），但可成对出现，作为字符串拼接使用。

##### 双引号

```sh
your_name="runoob"
str="Hello, I know you are \"$your_name\"! \n"
echo -e $str #Hello, I know you are "runoob"! 
```

双引号的优点：

- 双引号里可以有变量
- 双引号里可以出现转义字符

##### 字符串操作

###### 拼接字符串

```sh
your_name="runoob"
# 使用双引号拼接
greeting="hello, "$your_name" !"
greeting_1="hello, ${your_name} !"
echo $greeting  $greeting_1         # 输出 hello, runoob ! hello, runoob !

# 使用单引号拼接
greeting_2='hello, '$your_name' !'
greeting_3='hello, ${your_name} !'
echo $greeting_2  $greeting_3        # 输出 hello, runoob ! hello, ${your_name} !
```

###### 获取字符串长度

```sh
string="abcd"
echo ${#string}   # 输出 4
或
string="abcd"
echo ${#string[0]}   # 输出 4
```

变量为字符串时，**${#string}** 等价于 **${#string[0]}**:

###### 提取子字符串

以下实例从字符串第 **2** 个字符开始截取 **4** 个字符：

```sh
string="runoob is a great site"
echo ${string:1:4} # 输出 unoo
```

**注意**：第一个字符的索引值为 **0**。

###### 查找子字符串

查找字符 **i** 或 **o** 的位置(哪个字母先出现就计算哪个)：

```sh
string="runoob is a great site"
echo `expr index "$string" io`  # 输出 4
```

**注意：** 以上脚本中 **`** 是反引号，而不是单引号 **'**，不要看错了哦。







#### **整数变量**

 在一些Shell中，你可以使用 **declare** 或 **typeset** 命令来声明整数变量。

这样的变量只包含整数值，例如：

```sh
declare -i my_integer=42
```

这样的声明告诉 Shell 将 my_integer 视为整数，如果尝试将非整数值赋给它，Shell会尝试将其转换为整数。

#### **数组变量**

在 Shell 中，用括号来表示数组，数组元素用"空格"符号分割开。定义数组的一般形式为：

```sh
数组名=(值1 值2 ... 值n)
```

```sh
array_name=(value0 value1 value2 value3)
或
array_name=(
value0
value1
value2
value3
)

或 单独定义数组的各个分量：

array_name[0]=value0
array_name[1]=value1
array_name[n]=valuen

```

可以不使用连续的下标，而且下标的范围没有限制。

##### 读取数组

读取数组元素值的一般格式是：

```sh
${数组名[下标]}
```

```sh
valuen=${array_name[n]}
或  使用 @ 符号 获取数组中的所有元素
echo ${array_name[@]}
```

##### 获取数组的长度

获取数组长度的方法与获取字符串长度的方法相同，例如：

```sh
# 取得数组元素的个数
length=${#array_name[@]}
# 或者
length=${#array_name[*]}
# 取得数组单个元素的长度
length=${#array_name[n]}
```



数组，允许你在一个变量中存储多个值。

数组可以是整数索引数组或关联数组，以下是一个简单的整数索引数组的例子：

```sh
my_array=(1 2 3 4 5)
```

或者关联数组：

```sh
declare -A associative_array
associative_array["name"]="John"
associative_array["age"]=30
```

#### **环境变量** 

这些是由操作系统或用户设置的特殊变量，用于配置 Shell 的行为和影响其执行环境。

例如，PATH 变量包含了操作系统搜索可执行文件的路径：

```sh
echo $PATH
```

#### **特殊变量** 

有一些特殊变量在 Shell 中具有特殊含义，例如 **$0** 表示脚本的名称，**$1**, **$2**, 等表示脚本的参数。

**$#**表示传递给脚本的参数数量，**$?** 表示上一个命令的退出状态等。



## 注释

### 单行注释

以 **#** 开头的行就是注释，会被解释器忽略。

通过每一行加一个 **#** 号设置多行注释，像这样：

```
#--------------------------------------------
# 这是一个注释
# author：菜鸟教程
# site：www.runoob.com
# slogan：学的不仅是技术，更是梦想！
#--------------------------------------------
##### 用户配置区 开始 #####
#
#
# 这里可以添加脚本描述信息
# 
#
##### 用户配置区 结束  #####
```

### 函数注释

如果在开发过程中，遇到大段的代码需要临时注释起来，过一会儿又取消注释，怎么办呢？

每一行加个#符号太费力了，可以把这一段要注释的代码用一对花括号括起来，定义成一个函数，没有地方调用这个函数，这块代码就不会执行，达到了和注释一样的效果。

### 多行注释

**使用 Here 文档**

多行注释还可以使用以下格式：

```sh
:<<EOF
注释内容...
注释内容...
注释内容...
EOF
```

以上例子中，**:** 是一个空命令，用于执行后面的 Here 文档，**<<'EOF'** 表示开启 Here 文档，COMMENT 是 Here 文档的标识符，在这两个标识符之间的内容都会被视为注释，不会被执行。

EOF 也可以使用其他符号:

```
: <<'COMMENT'
这是注释的部分。
可以有多行内容。
COMMENT

:<<'
注释内容...
注释内容...
注释内容...
'

:<<!
注释内容...
注释内容...
注释内容...
!
```

**直接使用 : 号**

我们也可以使用了冒号 **:** 命令，并用单引号 **'** 将多行内容括起来。由于冒号是一个空命令，这些内容不会被执行。

格式为：**: + 空格 + 单引号**。

```sh
: '
这是注释的部分。
可以有多行内容。
'
```

## 传递参数

### 基础用法

我们可以在执行 Shell 脚本时，向脚本传递参数，脚本内获取参数的格式为 **$n**，**n** 代表一个数字，**1** 为执行脚本的第一个参数，**2** 为执行脚本的第二个参数。

例如可以使用 **$1、$2** 等来引用传递给脚本的参数，其中 **$1** 表示第一个参数，**$2** 表示第二个参数，依此类推。

```sh
#!/bin/bash

echo "Shell 传递参数实例！";
echo "执行的文件名：$0";
echo "第一个参数为：$1";
echo "第二个参数为：$2";
echo "第三个参数为：$3";
```

调用

```sh
$ chmod +x test.sh 
$ ./test.sh 1 2 3
```

输出：

```
Shell 传递参数实例！
执行的文件名：./test.sh
第一个参数为：1
第二个参数为：2
第三个参数为：3

```

### 特殊字符处理参数

| 参数处理 |                             说明                             |
| :------- | :---------------------------------------------------------- |
| `$#`     |                     传递到脚本的参数个数                     |
| `$*`     | 以一个单字符串显示所有向脚本传递的参数。 如"$*"用「"」括起来的情况、以"$1 $2 … $n"的形式输出所有参数。 |
| `$$`     |                    脚本运行的当前进程ID号                    |
| `$!`     |                 后台运行的最后一个进程的ID号                 |
| `$@`     | 与$*相同，但是使用时加引号，并在引号中返回每个参数。 如"$@"用「"」括起来的情况、以"$1" "$2" … "$n" 的形式输出所有参数。 |
| `$-`     | 显示Shell使用的当前选项，与[set命令](https://www.runoob.com/linux/linux-comm-set.html)功能相同。 |
| `$?`     | 显示最后命令的退出状态。0表示没有错误，其他任何值表明有错误。 |

```sh
#!/bin/bash
# author:菜鸟教程
# url:www.runoob.com

echo "Shell 传递参数实例！";
echo "第一个参数为：$1";

echo "参数个数为：$#";
echo "传递的参数作为一个字符串显示：$*";
```

执行脚本，输出结果如下所示：

```
$ chmod +x test.sh 
$ ./test.sh 1 2 3
Shell 传递参数实例！
第一个参数为：1
参数个数为：3
传递的参数作为一个字符串显示：1 2 3

```

#### $* 与 $@ 区别

- 相同点：都是引用所有参数。
- 不同点：只有在双引号中体现出来。假设在脚本运行时写了三个参数 1、2、3，则 " * " 等价于 "1 2 3"（传递了一个参数），而 "@" 等价于 "1" "2" "3"（传递了三个参数）。

```sh
#!/bin/bash
# author:菜鸟教程
# url:www.runoob.com

echo "-- \$* 演示 ---"
for i in "$*"; do
    echo $i
done

echo "-- \$@ 演示 ---"
for i in "$@"; do
    echo $i
done
```

执行脚本，输出结果如下所示：

```sh
$ chmod +x test.sh 
$ ./test.sh 1 2 3
-- $* 演示 ---
1 2 3
-- $@ 演示 ---
1
2
3
```



## 流程控制

```sh
if condition1
then
    command1
elif condition2 
then 
    command2
else
    commandN
fi
```

if else 的 **[...]** 判断语句中大于使用 **-gt**，小于使用 **-lt**。

```sh
if [ "$a" -gt "$b" ]; then
    ...
fi
```

如果使用 **((...))** 作为判断语句，大于和小于可以直接使用 **>** 和 **<**。

```sh
if (( a > b )); then
    ...
fi
```

if else 语句经常与 test 命令结合使用，如下所示：

```sh
num1=$[2*3]
num2=$[1+5]
if test $[num1] -eq $[num2]
then
    echo '两个数字相等!'
else
    echo '两个数字不相等!'
fi
```

输出结果：两个数字相等!



## 执行sh脚本时传参数

``` 
#!/bin/sh
Sh xxx.sh  a b c d 

$1 == a
$2 == b
$3 == c
$4 == d
```

## 创建文件，以日期命名

```sh
#!/bin/sh
TIME=$(date "+%Y%m%d_%H%M%S")
d="cp sign.log logs/\"sign_$TIME.log\""
eval $d
```

## 获取某个目录下的所有文件名

```sh
for file in ./*
do
curfilename=$(basename "$file")
echo $curfilename
done
```

## 截取字符串

```sh
curfilename="987654321"
# 从某下标开始，截取几位
substr1=${curfilename:0:4}  #9876
substr2=${curfilename:1:2}  #87
```

## 字符串比较

```sh
if [[ $curfilename == *$filename* ]]
```

## 

## 启动、重启jar包

```sh
#!/bin/bash
#PATH=/usr1/jdk/jdk1.8.0_241/bin:$PATH

#此处是所有要启动的jar包
server=(
text1-1.0.0-SNAPSHOT.jar
text2-1.0.0-SNAPSHOT.jar
……
)
#此处是所有要启动的jar包对应的日志文件名
log=(
text1
text2
)

echo "================================================================================================================="
echo "请确认要执行的操作："
echo "1 重启所有服务"
echo "2 重启单点服务"
echo "=================================================================================================================" 
echo "请输入你要执行的操作，如：1"
echo ""
echo "================================================================================================================="
echo ""
# 读取 键盘输入
# read char
## 可读取文件输入 调用方式 ./sh < a.txt   a.txt内容为：1 执行后，char=1
read -t 15 char


len=${#server[@]}

if [[ $char = 1 ]]; then

for ((i=0; i<$len; i++))
 
do
#echo "$i ${server[i]} ===="
Server=${server[i]}
Log=${log[i]}

#echo "N=$i  Server=$Server  LOG=$Log"

pid=`ps -ef | grep java | grep $Server | sed -n '1p' |awk '{print $2}'`

if [ -n "$pid" ]; then
echo "Server $Server is now running:$pid,I will kill it."
kill -9 $pid
fi
echo "I will run the Server $Server now ... "
nohup java -jar $Server -Dfile.encoding=utf-8  > $Log.log 2>&1 &
sleep 5
done


echo "================================================================================================================="
echo -e "|\tServername\t\t\t\t PID\t\t\t\t\t STATUS\t\t\t|"
for ((i=0; i<$len; i++))
do

Server=${server[i]}
Log=${log[i]}

ISSTART=0
LOGCUN=0

 while [ $ISSTART -eq 0 ] && [ $LOGCUN -lt 10 ];
 do
   pid=`ps -ef | grep java | grep $Server |  sed -n '1p' |awk '{print $2}'`

   ISSTART=$(cat $Log.log |head -n 500 | grep "is running! Access URLs" | wc -l)
sleep 1
   LOGCUN=`expr $LOGCUN + 1 `
sleep 1
#echo $pid $ISSTART
 done  
if [ -n "$pid" ] || [$ISSTART -eq 1 ];then
 #echo -e "|\t\033[34m$Server\t	$pid\t						server start success.\t	|\033[0m"
printf "|\t\e[34m%-20s \t\t\t%-10s\t\t\t%-25s\t\e[0m|\n" "$Log" "$pid" "server start success." 
#echo -e "\t\t\t\t\033[34mserver start success.\t |\033[0m"
else
 #echo -e "|\t\033[31m$Server\t							server start fail.\t	|\033[0m"
printf "|\t\e[34m%-20s \t\t\t%-10s\t\t\t%-25s\t\e[0m|\n" "$Log" "$pid" "server start fail.."
fi;
sleep 1
done
sleep 1
echo "================================================================================================================="
fi


if [[ $char = 2 ]]; then

for s in ${server[@]}
do
echo "=================================================================================================================" 

for (( i=0; i<$len; i++))
do

#echo "|$i\t$s\t|"
printf "|\t %-2s \t%-90s\t|\n" "$i" "${server[i]}"

done
echo "================================================================================================================="
echo "请选择你要重启的服务，如：0"
echo ""
read char
Server=${server[$char]}
Log=${log[$char]}

pid=`ps -ef | grep java | grep $Server | sed -n '1p' |awk '{print $2}'`

if [ -n "$pid" ];then
echo "Server $Server is now running $pid,I will kill it."
kill -9 $pid
fi
echo " IwillruntheServer:$Servernow"

nohup java -jar $Server -Dfile.encoding=utf-8  > $Log.log 2>&1 &
sleep 5
done 
fi
exit 1
```

## java -jar 指定端口号

```sh
Java -jar xxx.jar --server.port=8085
```
