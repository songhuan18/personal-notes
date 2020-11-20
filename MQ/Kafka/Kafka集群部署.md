##### 环境准备
- 系统环境：Ubuntu16.04 x86_64
- 内核
```
Linux version 4.4.0-117-generic
```
- jdk1.8.181
- 三台虚拟机，ip分别为：192.168.10.237、192.168.10.211、192.168.10.236
- hostname分别对应为：hadoop237、hadoop211、hadoop236
- Kafka版本：0.11.0.0

##### 下载
```sh
wget https://archive.apache.org/dist/kafka/0.11.0.0/kafka_2.11-0.11.0.0.tgz
```
##### 解压
```sh
tar -zxvf kafka_2.11-0.11.0.0.tgz -C /home/songhuan/bigdata/setups
```
> 注意：kafka是依赖于zookeeper，所以必须保证要有zookeeper

KAFKA_DIR=/home/songhuan/bigdata/setups/kafka_2.11-0.11.0.0
##### 创建logs文件
在$KAFKA_DIR创建logs文件夹
```sh
# 日志文件和缓存数据都是放在该目录下的
mkdir logs
```
##### 修改配置文件server.properties
```sh
cd $KAFKA_DIR/config
vim server.properties
# 对于每一个broker来说必须是唯一的，所以每个机器上的broker.id是不一样的
broker.id=0
# 是否可以删除topic，默认是false
delete.topic.enable=true
#处理网络请求的线程数量 num.network.threads=3
#用来处理磁盘 IO 的现成数量
num.io.threads=8
#发送套接字的缓冲区大小
socket.send.buffer.bytes=102400
#接收套接字的缓冲区大小
socket.receive.buffer.bytes=102400
#请求套接字的缓冲区大小
socket.request.max.bytes=104857600
# 日志和数据存放目录
log.dirs=$KAFKA_DIR/logs
# zookeeper 集群地址，以逗号分隔开
zookeeper.connect=hadoop237:2181,hadoop211:2181,hadoop236:2181
```
> 将kafka分发到另外两台机器

```sh
# xsync 是自己写的分发脚本，可以参看hadoop集群搭建
xsync kafka_2.11-0.11.0.0/
```
将hadoop211上的broke.id=0改为broke.id=1，将hadoop236上的broke.id=0改为broke.id=3

##### 启动kafka(前台启动)
```sh
cd $KAFKA_DIR
bin/kafka-server-start.sh config/server.properties
```
> 将其他机器也按照该方式启动，该方式启动起来之后，kafka就是一个阻塞进程

##### 启动kafka(后台启动)
```sh
cd $KAFKA_DIR
bin/kafka-server-start.sh -daemon config/server.properties &
```
##### 停止kafka
```sh
bin/kafka-server-stop.sh stop
```
