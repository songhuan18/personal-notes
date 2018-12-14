### 配置Spark HA

##### 环境
- 系统环境：Ubuntu16.04 x86_64
- 内核
```
Distributor ID:	Ubuntu
Description:	Ubuntu 16.04.3 LTS
Release:	16.04
Codename:	xenial
```
- 内存：8G
- jdk1.8.181
- ip：192.168.10.237,192.168.10.236,192.168.10.211
- hostname映射：hadoop237,hadoop236,hadoop211

##### 集群规划
hadoop237->master01
hadoop211->master02、slave01
hadoop236->slave01

> 保证已安装好zookeeper集群，zookeeper集群搭建可以[参考](../../zookeeper/zookeeper集群安装.md)

##### 配置spark-env.sh
> 如果之前已经配置好Spark 集群，需停止所有服务

```sh
# 添加如下配置
export SPARK_HISTORY_OPTS="-Dspark.history.ui.port=4000 -Dspark.history.retainedApplications=3 -Dspark.history.fs.logDirectory=hdfs://hadoop237:9000/directory"

export SPARK_DAEMON_JAVA_OPTS="-Dspark.deploy.recoveryMode=ZOOKEEPER -Dspark.deploy.zookeeper.url=hadoop237:2181,hadoop211:2181,hadoop236:2181 -Dspark.deploy.zookeeper.dir=/spark"
#SPARK_MASTER_HOST=hadoop237
SPARK_MASTER_PORT=7077

# 注意：一定要注释掉之前的：SPARK_MASTER_HOST=hadoop237
```
> 需要将修改的spark-env.sh文件同步到 另外两台机器上

##### 启动集群
```sh
sbin/start-all.sh
```
因为需要启动两个master，所以切换到hadoop211上手动启动一个master
```sh
sbin/start-master.sh
```
##### 使用Spark shell执行一个WordCount
```sh
bin/spark-shell --master spark://hadoop237:7077,hadoop211:7077
```
在启动时，发现了一个问题，无法连接上hadoop211:7077，端口也无法telnet上。
![image](../../img/spark.jpg)
最后发现只有本地能连接<br>
解决办法：修改/etc/hosts文件，不使用127.0.0.1这个网卡，删除127.0.0.1  localhost

执行：
```sh
sc.textFile("./LICENSE").flatMap(_.split(" ")).map((_,1)).reduceByKey(_+_).collect
```
手动kill掉master01, kill -9 进程ID，发现Spark shell程序没有退出，控制权已经交到master02上了，代表高可用已搭建好。

##### 通过Spark利用蒙特.卡罗算法求PI
```sh
bin/spark-submit --class org.apache.spark.examples.SparkPi --master spark://hadoop237:7077,hadoop211:7077 --executor-memory 1G --total-executor-cores 2 examples/jars/spark-examples_2.11-2.1.1.jar 100
```
