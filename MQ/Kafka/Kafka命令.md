##### 创建topic
```sh
bin/kafka-topics.sh --create --zookeeper hadoop237:2181 --partitions 2 --replication-factor 2 --topic first
```
选项说明:
- topic 定义 topic 名
- replication-factor 定义副本数
- partitions 定义分区数

##### 查看所创建的topic
```sh
bin/kafka-topics.sh --list --zookeeper hadoop237:2181
```
##### 发送消息(生产者)
```sh
bin/kafka-console-producer.sh --broker-list hadoop237:9092 --topic first
```
##### 消费消息(消费者)
```sh
bin/kafka-console-consumer.sh --zookeeper hadoop237:2181 --from-beginning --topic first
```
> 老版本需要连接zookeeper

--from-beginning:会把 first 主题中以往所有的数据都读取出来。根据业务场景选择是否

或者使用以下方式：
```sh
bin/kafka-console-consumer.sh --bootstrap-server hadoop237:9092 --from-beginning --topic first
```
> 新版本连接的是kafka集群，offset是存在本地的

##### 查看topic的详情
```sh
bin/kafka-topics.sh --zookeeper hadoop237:2181 --describe --topic first
```
##### 删除topic
```sh
bin/kafka-topics.sh --zookeeper hadoop237:2181 --delete --topic first
```
