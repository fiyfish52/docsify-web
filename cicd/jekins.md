# jekins

[jekins官网](https://www.jenkins.io/zh/)

## linux安装
1. [下载war包](https://www.jenkins.io/zh/download/)
Generic java package(.war)
```bash
wget http://mirrors.jenkins.io/war-stable/2.346.3/jenkins.war
```
2. 启动
```
脚本：
#/bin/bash
echo "starting jenkins……"
nohup java -jar ./jenkins.war  --httpPort=8081 >>jenkins.log   &
echo "started jenkins"
ps -ef|grep jenkins
```
3. 访问
   http://ip:8081
   等待自安装

4. 查找自动生成的密码（日志文件中）
   输入后等待启动
---
## 插件安装
Manage Jenkins --> Manage Plugins

远程发布：publish over ssh

---
## 问题处理
1. gitea 配置web钩子不生效
   
解决：jekins安全配置（configureSecurity）配置授权策略：匿名用户增加配置
    ![安全配置](./../_media/jenkins安全策略.jpg)