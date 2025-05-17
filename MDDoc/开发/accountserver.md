



server

cd /usr1/software/jdk-17.0.5/bin/

 cd /usr1/project/accountServer/

 ./java -jar /usr1/project/accountServer/KnbsAccountServer-0.0.1-SNAPSHOT.jar

./java -jar /usr1/project/accountServer/KnbsAccountServer-0.0.1-SNAPSHOT.jar --server.port=8191



```sh
cd /usr1/software/jdk-17.0.5/bin/

./java -jar /usr1/project/accountServer/KnbsAccountServer-0.0.1-SNAPSHOT.jar --server.port=8791 --spring.config.location=/usr1/project/accountServer/application.yml
 
 
 cd /usr1/project/accountServer
tail -100f account.log

cd /usr1/software/jdk-17.0.5/bin/
nohup ./java -jar /usr1/project/accountServer/KnbsAccountServer-0.0.1-SNAPSHOT.jar --server.port=8791 --spring.config.location=/usr1/project/accountServer/application.yml >/usr1/project/accountServer/account.log &

nohup ./java -jar /usr1/project/accountServer/KnbsAccountServer-0.0.1-SNAPSHOT.jar --server.port=8791 --spring.config.location=/usr1/project/accountServer/application.yml
```



