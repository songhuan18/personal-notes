### Spark安装
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

##### 下载
```sh
wget https://archive.apache.org/dist/spark/spark-2.1.1/spark-2.1.1-bin-hadoop2.7.tgz
```
##### 解压到指定目录
```sh
tar -zxvf spark-2.1.1-bin-hadoop2.7.tgz -C /home/songhuan/bigdata/setups
```
### Standalone集群部署模式
说明：hadoop237->master,hadoop211->slave,hadoop236->slave
> hadoop集群保证已搭建好

##### 集群脚本分发
在当前用户下进行操作
```sh
mkdir bin
cd bin/
touch xsync #创建分发脚本文件
chmod a+x xsync
vim xsync
```
分发脚本的内容：
```sh
#!/bin/bash
#1 获取输入参数个数，如果没有参数，直接退出
pcount=$#
if((pcount==0))
   then
     echo no args;
     exit;
fi

#2 获取文件名称
p1=$1
fname=`basename $p1`
echo fname=$fname

#3 获取上级目录到绝对路径
pdir=`cd -P $(dirname $p1); pwd`
echo pdir=$pdir

#4 获取当前用户名称
user=`whoami`
hostname=$(hostnamectl --static)
#5 循环
for host in hadoop211 hadoop237 hadoop236
   do
      if [ "$hostname" == "$host" ]
         then
           continue
      fi
      echo ------------------- $host --------------
      rsync -rvl $pdir/$fname $user@$host:$pdir
   done
```
举例：比如将当前用户目录下的bin分发到另外两台机器上，执行以下命令：
```sh
xsync bin
```

##### 配置Spark
> Spark部署模式有Local、Local-Cluster、Standalone、Yarn、Mesos

- 进入到conf目录
```sh
cd /home/songhuan/bigdata/setups/spark-2.1.1-bin-hadoop2.7/conf
```
- 将slaves.template复制为slaves
```sh
cp slaves.template slaves
```
- 将spark-env.sh.template复制为spark-env.sh
```sh
cp spark-env.sh.template spark-env.sh
```
- 修改slaves文件，将work的hostname输入
```sh
# 在文件末尾添加一下内容(localhost 干掉)
hadoop211
hadoop236
```
- 修改spark-env.sh文件，添加如下配置
```sh
# 任意位置添加
SPARK_MASTER_HOST=hadoop237
SPARK_MASTER_PORT=7077
```
##### 将Spark文件目录分发到另外两台机器
```sh
xsync spark-2.1.1-bin-hadoop2.7/
```
> 至此，集群配置完毕，1个Master(hadoop237)，两个Work(hadoop211,hadoop236)，在hadoop237上启动集群

注意：如果遇到 “JAVA_HOME not set” 异常，可以在sbin目录下的spark-config.sh 文件中加入如下配置：
```
export JAVA_HOME=XXXX
```
##### 启动集群
```sh
sbin/start-all.sh
```
##### 停止集群
```sh
sbin/stop-all.sh
```
##### 使用Spark
```sh
bin/spark-shell
#退出Spark
:quit
```
> 以上使用Spark只是本地使用

##### 使用Spark，通过集群的方式
```sh
bin/spark-shell --master spark://hadoop237:7077
# 执行一个WordCount
sc.textFile("./LICENSE").flatMap(_.split(" ")).map((_,1)).reduceByKey(_+_).collect
```
说明：通过http://192.168.10.237:8080 界面可以查询到执行过程，但是该shell退出，执行过程也就看不到了，因此需要配置Job History Server

##### 配置Job History Server 【Standalone】
- 进入到conf目录
```sh
cd /home/songhuan/bigdata/setups/spark-2.1.1-bin-hadoop2.7/conf
```
- 将spark-defaults.conf.template复制为spark-defaults.conf
```sh
cp spark-defaults.conf.template spark-defaults.conf
```
- 在hadoop集群上创建/directory目录
```sh
bin/hdfs dfs -mkdir -p /directory
```
- 配置spark-default.conf
```sh
# 在最后添加一下内容
spark.eventLog.enabled   true
spark.eventLog.dir       hdfs://hadoop237:9000/directory
```
参数描述：spark.eventLog.dir：Application在运行过程中所有的信息均记录在该属性指定的路径下；

- 修改spark-env.sh文件，添加以下配置
```sh
export SPARK_HISTORY_OPTS="-Dspark.history.ui.port=4000 -Dspark.history.retainedApplications=3
-Dspark.history.fs.logDirectory=hdfs://hadoop237:9000/directory"
```
参数描述：
  - spark.history.ui.port=4000  调整WEBUI访问的端口号为4000<br>
  - spark.history.fs.logDirectory=hdfs://hadoop237:9000/directory  配置了该属性后，在start-history-server.sh时就无需再显式的指定路径，Spark History Server页面只展示该指定路径下的信息
  - spark.history.retainedApplications=3   指定保存Application历史记录的个数，如果超过这个值，旧的应用程序信息将被删除，这个是内存中的应用数，而不是页面上显示的应用数。

  > 将spark-default.conf spark-enc.sh 分发到另外两台机器上

##### 启动Spark集群
```sh
sbin/start-all.sh
```
##### 启动Job History Server
```sh
sbin/start-history-server.sh
```
> 通过 http://hadoop237:4000/ 即可访问 History Server

##### 使用Spark shell执行一个WordCount
```sh
sc.textFile("./LICENSE").flatMap(_.split(" ")).map((_,1)).reduceByKey(_+_).collect
```
说明：只有退出了Spark shell 之后才能在http://hadoop237:4000/页面查询WordCount的执行过程

注意：如果遇到Hadoop HDFS的写入权限问题：
org.apache.hadoop.security.AccessControlException
解决方案： 在hdfs-site.xml中添加如下配置，关闭权限验证
```sh
<property>
  <name>dfs.permissions</name>
  <value>false</value>
</property>
```
