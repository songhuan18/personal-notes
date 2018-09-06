> 在安装之前先确保机器上存在JDK

##### 下载
```shell
sudo wget https://archive.apache.org/dist/kafka/0.10.1.0/kafka_2.10-0.10.1.0.tgz
```
##### 解压
```shell
tar -zxvf kafka_2.10-0.10.1.0.tgz
```
##### 前台启动zookeeper
```shell
songhuan@ubuntu-1604-7  ~/tmp/Kafka/kafka_2.10-0.10.1.0  bin/zookeeper-server-start.sh config/zookeeper.properties
```
> 查看端口2181是否被监听

##### 前台启动kafka
```shell
songhuan@ubuntu-1604-7  ~/tmp/Kafka/kafka_2.10-0.10.1.0  bin/kafka-server-start.sh config/server.properties
```
##### 创建topic
```shell
songhuan@ubuntu-1604-7  ~/tmp/Kafka/kafka_2.10-0.10.1.0  bin/kafka-topics.sh --zookeeper localhost:2181 --create --topic test1 --partitions 3 --replication-factor 1
```
##### 查看topic
```shell
songhuan@ubuntu-1604-7  ~/tmp/Kafka/kafka_2.10-0.10.1.0  bin/kafka-topics.sh --zookeeper localhost:2181 --describe --topic test1
Topic:test1	PartitionCount:3	ReplicationFactor:1	Configs:
	Topic: test1	Partition: 0	Leader: 0	Replicas: 0	Isr: 0
	Topic: test1	Partition: 1	Leader: 0	Replicas: 0	Isr: 0
	Topic: test1	Partition: 2	Leader: 0	Replicas: 0	Isr: 0
```
##### 创建一个kafka生产者
```shell
songhuan@ubuntu-1604-7  ~/tmp/Kafka/kafka_2.10-0.10.1.0  bin/kafka-console-producer.sh --broker-list localhost:9092 --topic test1
```
##### 创建一个kafka消费者
```shell
songhuan@ubuntu-1604-7  ~/tmp/Kafka/kafka_2.10-0.10.1.0  bin/kafka-console-consumer.sh --zookeeper localhost:2181 --topic test1
```
##### 清除kafka和zookeeper中的数据
```shell
sudo rm -rf /tmp/*
```
##### 使用Docker安装Zookeeper
```shell
docker build -t sh/zookeeper:3.4.6 -f zookeeper.Dockerfile .
```
##### 使用Docker安装Kafka
```shell
docker build -t sh/kafka:0.8.2.2 -f kafka.Dockerfile .
```
