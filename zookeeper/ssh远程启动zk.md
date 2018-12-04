##### 环境
- 系统环境：Ubuntu16.04 x86_64
- 内核
```
Distributor ID:	Ubuntu
Description:	Ubuntu 16.04.3 LTS
Release:	16.04
Codename:	xenial
```

##### 问题描述
通过ssh远程启动服务器上的zk，根据日志输出判断为启动成功。但是在远程服务器上通过jps查看，并未启动成功，而且无错误日志输出。但是在远程服务器上通过命令能够正常启动，所以这个服务是正常的，只和ssh远程启动有关系。

- 远程启动zk命令
```sh
ssh ubuntu124 "/home/songhuan/hadoop/setups/zookeeper-3.4.10/zkServer.sh start"
```

##### 问题追踪
- 查看zkServer.sh启动文件

关键代码：
```sh
nohup $JAVA "-Dzookeeper.log.dir=${ZOO_LOG_DIR}" "-Dzookeeper.root.logger=${ZOO_LOG4J_PROP}" \
    -cp "$CLASSPATH" $JVMFLAGS $ZOOMAIN "$ZOOCFG" > "$_ZOO_DAEMON_OUT" 2>&1 < /dev/null &
```
2>&1 < /dev/null 表示将错误结果不显示也不保存文件，将以上关键代码删除：2>&1 < /dev/null &，再通过远程ssh启动zk。

> 启动报错，发现是无Java环境变量，但是Java环境变量配置在/etc/profile中的


- 解决办法

在启动zk之前先source /etc/profile
```sh
ssh ubuntu124 "source /etc/profile;/home/songhuan/hadoop/setups/zookeeper-3.4.10/bin/zkServer.sh start"
```
##### 思考
1. 如果Java环境变量配置在用户家目录.bashrc中(环境变量配置在代码末尾)，source .bashrc 后启动zk无效<br>
2. ssh远程执行命令是非交互式登陆（具体交互式和非交互式理解可以[参考](http://feihu.me/blog/2014/env-problem-when-ssh-executing-command-on-remote/?nsukey=uhTMmd2TxxkT57luiIClNgxOISBQQWuZUuDmrG2cZ4uQVXSe6OR8NaqxXqVYw7%2F8ejOwD%2BxpfnHsZ7csei5m%2FMfS7BWCSva6AGjSI%2BuN7llWsgob1Z5VutFwgiskvfyQ4IDVf9yfGy8d%2BAI1gIrR4MXF3tj7ooXNt2iFVvDiLl1Bep96yRJqp4A00lWg61yUGStPdoz5CAJ8VPxpGKOTqg%3D%3D)）,所以在加载用户家目录中.bashrc会被中断，具体看一下代码：
```sh
# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac
```
