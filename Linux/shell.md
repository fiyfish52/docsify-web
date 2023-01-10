# Shell


## 执行sh脚本时传参数
``` 
#!/bin/sh
Sh xxx.sh  a b c d 

$1 == a
$2 == b
$3 == c
$4 == d
```


## 启动、重启jar包

```
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
read char

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