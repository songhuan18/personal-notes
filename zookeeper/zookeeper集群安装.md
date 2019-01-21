##### 环境准备
- 系统环境：Ubuntu16.04 x86_64
- 内核
```
Linux version 4.4.0-117-generic
```
- jdk1.8.181
- hadoop版本：hadoop-2.7.2
- 三台虚拟机，ip分别为：10.211.55.11、10.22.55.13、10.211.55.14
- hostname分别对应为：hadoop11、hadoop13、hadoop14

##### 解压安装
```sh
tar -zxvf zookeeper-3.4.10.tar.gz -C ~/hadoop/setups/
```
##### 同步~/hadoop/setups/zookeeper-3.4.10目录到其他两台服务器
```sh
xsync ~/hadoop/setups/zookeeper-3.4.10
```
> xsync 脚本之前已写好，具体可以[参考](../hadoop/hadoop集群搭建.md)

##### 配置服务器编号
在~/hadoop/setups/zookeeper-3.4.10/这个目录下创建zkData
```sh
mkdir -p zkData
```
在~/hadoop/setups/zookeeper-3.4.10/zkData目录下创建一个myid的文件
```sh
touch myid
vim myid
# 在文件中添加与server对应的编号
2
# 注意：另外两台服务器上对应编号为3，4
```
拷贝配置好的zookeeper到其他机器上
```sh
xsync zkData
```
##### 配置zoo.cfg
重命名~/hadpoop/setups/zookeeper-3.4.10/conf这个目录下的zoo_sample.cfg为zoo.cfg
```sh
mv zoo_sample.cfg zoo.cfg
```
编辑zoo.cfg
```sh
# 修改数据存储路径配置
dataDir=~/hadoop/setups/zookeeper-3.4.10/zkData
# 增加如下配置
#######################cluster##########################
server.2=hadoop11:2888:3888
server.3=hadoop13:2888:3888
server.4=hadoop14:2888:3888
```
同步zoo.cfg配置文件
```sh
xsync zoo.cfg
```
配置参数解读
```sh
server.A=B:C:D
```
- A是一个数字，表示这个是第几号服务器；

  集群模式下配置一个文件myid，这个文件在dataDir目录下，这个文件里面有一个数据就是A的值，Zookeeper启动时读取此文件，拿到里面的数据与zoo.cfg里面的配置信息比较从而判断到底是哪个server。

- B是这个服务器的ip地址；
- C是这个服务器与集群中的Leader服务器交换信息的端口；
- D是万一集群中的Leader服务器挂了，需要一个端口来重新进行选举，选出一个新的Leader，而这个端口就是用来执行选举时服务器相互通信的端口。

##### 在三个服务器上分别启动zk
```sh
# 启动zk
bin/zkServer.sh start
# 查看zk状态
bin/zkServer.sh status
```
##### 停止zk
```sh
bin/zkServer.sh stop
```
