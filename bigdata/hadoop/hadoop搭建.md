##### 大数据概念
大数据是指无法在一定时间内用常规软件工具对其内容进行抓取、管理和处理的数据集合。大数据技术，是指从各种各样类型的数据中，快速获得有价值信息的能力。适用于大数据的技术，包括大规模并行处理（MPP）数据库，数据挖掘电网，分布式文件系统，分布式数据库，云计算平台，互联网，和可扩展的存储系统。
##### hadoop生态
![image](http://pceh5403k.bkt.clouddn.com/hadoop%E7%94%9F%E6%80%81%E5%9B%BE.jpg)
##### 环境准备
- 系统环境：Ubuntu16.04 x86_64
- 内核
```
Distributor ID:	Ubuntu
Description:	Ubuntu 16.04.3 LTS
Release:	16.04
Codename:	xenial
```
- jdk1.8.181
- hadoop版本：hadoop-2.7.2
- 本机ip：192.168.10.237
- [官方文档](http://hadoop.apache.org/docs/r2.7.2/hadoop-project-dist/hadoop-common/SingleCluster.html)

##### 配置JDK环境变量
```sh
cd /etc/profile.d/
sudo vim java_env.sh
# 添加环境变量如下
JAVA_HOME=/opt/setups/jdk1.8.0_181
PATH=$PATH:$JAVA_HOME/bin
JRE_HOME=$JAVA_HOME/jre
CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
export JAVA_HOME PATH JRE_HOME CLASSPATH
```
> 以下操作是在ubuntu用户下

##### 下载Hadoop
```sh
wget https://archive.apache.org/dist/hadoop/core/hadoop-2.7.2/hadoop-2.7.2.tar.gz
# 解压
tar -zxvf hadoop-2.7.2.tar.gz - C /home/ubuntu/hadoop/setups/
```
##### 配置Hadoop环境
> 在普通用户下

```sh
vim .bashrc
# 在最底部添加
# hadoop env
export HADOOP_HOME=/home/ubuntu/hadoop/setups/hadoop-2.7.2
export PATH=$PATH:$HADOOP_HOME/bin
export PATH=$PATH:$HADOOP_HOME/sbin
```
查看环境变量版本：
```sh
hadoop version
```
##### Hadoop目录结构
- 查看Hadoop目录结构

```sh
ubuntu@ubuntu-1604-237:~/hadoop/setups/hadoop-2.7.2$ ll
total 60
drwxr-xr-x 9 ubuntu ubuntu  4096 Jan 26  2016 ./
drwxrwxr-x 3 ubuntu ubuntu  4096 Oct 22 14:59 ../
drwxr-xr-x 2 ubuntu ubuntu  4096 Jan 26  2016 bin/
drwxr-xr-x 3 ubuntu ubuntu  4096 Jan 26  2016 etc/
drwxr-xr-x 2 ubuntu ubuntu  4096 Jan 26  2016 include/
drwxr-xr-x 3 ubuntu ubuntu  4096 Jan 26  2016 lib/
drwxr-xr-x 2 ubuntu ubuntu  4096 Jan 26  2016 libexec/
-rw-r--r-- 1 ubuntu ubuntu 15429 Jan 26  2016 LICENSE.txt
-rw-r--r-- 1 ubuntu ubuntu   101 Jan 26  2016 NOTICE.txt
-rw-r--r-- 1 ubuntu ubuntu  1366 Jan 26  2016 README.txt
drwxr-xr-x 2 ubuntu ubuntu  4096 Jan 26  2016 sbin/
drwxr-xr-x 4 ubuntu ubuntu  4096 Jan 26  2016 share/
```
- 重要目录
 - bin目录：存放对Hadoop相关服务（HDFS,YARN）进行操作的脚本
 - etc目录：Hadoop的配置文件目录，存放Hadoop的配置文件
 - lib目录：存放Hadoop的本地库（对数据进行压缩解压缩功能）
 - sbin目录：存放启动或停止Hadoop相关服务的脚本
 - share目录：存放Hadoop的依赖jar包、文档、和官方案例

##### 官方grep案例
> 当前目录: /home/ubuntu/hadoop/setups/hadoop-2.7.2

```sh
mkdir input
cp etc/hadoop/*.xml input
bin/hadoop jar share/hadoop/mapreduce/hadoop-mapreduce-examples-2.7.2.jar grep input output 'dfs[a-z.]+'
cat output/*
```
- 运行以上示例报错
```
Error: JAVA_HOME is not set and could not be found.
```
- 解决办法

更改etc/hadoop/hadoop-env.sh
```sh
export JAVA_HOME=${JAVA_HOME} # 更改之前
export JAVA_HOME=/opt/setups/jdk1.8.0_181 # 更改之后
```
### 搭建HDFS伪分布式

##### 配置ip映射
```sh
sudo vim /etc/hosts
192.168.10.237  hadoop237
```
> 注意：访问hadoop的机器也需要配置ip映射

##### 配置core-site.xml
```sh
vim etc/hadoop/core-site.xml
<configuration>
    <!-- 指定HDFS中NameNode的地址 -->
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://hadoop237:9000</value>
    </property>
    <!-- 指定Hadoop运行时产生文件的存储目录 -->
    <property>
        <name>hadoop.tmp.dir</name>
        <value>/home/ubuntu/hadoop/setups/hadoop-data/data/tmp</value>
    </property>
</configuration>
```
##### 配置hdfs-site.xml
```sh
vim etc/hadoop/hdfs-site.xml
<configuration>
    <!-- 指定HDFS副本的数量 -->
    <property>
        <name>dfs.replication</name>
        <value>1</value>
    </property>
</configuration>
```
##### 格式化NameNode
```sh
bin/hdfs namenode -format
```
##### 启动NameNode和DataNode后台运行
```sh
sbin/start-dfs.sh
# 或者使用以下命令
sbin/hadoop-daemon.sh start datanode
sbin/hadoop-daemon.sh start namenode
```
##### web端查看HDFS文件系统
```
http://hadoop237:50070
```
> 如果web页面不能查看，请看[以下帖子](http://www.cnblogs.com/zlslch/p/6604189.html)

思考：为什么不能一直格式化NameNode，格式化NameNode，要注意什么？

格式化NameNode，会产生新的集群id,导致NameNode和DataNode的集群id不一致，集群找不到已往数据。所以，格式NameNode时，一定要先删除data数据和log日志，然后再格式化NameNode。

##### 操作集群
- 在HDFS文件系统上创建一个input文件夹
```sh
bin/hdfs dfs -mkdir -p /user/ubuntu/input
```
- 查看多级目录所有文件
```sh
bin/hdfs dfs -ls -R /
```
- 将测试文件内容上传到文件系统
```sh
bin/hdfs dfs -put input/core-site.xml /user/ubuntu/input
```
- 运行MapReduce程序统计单词个数
```sh
bin/hadoop jar share/hadoop/mapreduce/hadoop-mapreduce-examples-2.7.2.jar wordcount /user/ubuntu/input /user/ubuntu/output
```
- 查看输出结果
```sh
bin/hdfs dfs -cat /user/ubuntu/output/*
```
- 将测试文件内容下载到本地
```sh
bin/hdfs dfs -get /user/ubuntu/output/* output/
```
- 删除输出结果
```sh
bin/hdfs dfs -rm -r /user/ubuntu/output
```
- 查看集群ID
```sh
cat /home/ubuntu/hadoop/setups/hadoop-data/data/tmp/dfs/name/current/VERSION
```
##### 停止NameNode和DataNode
```sh
sbin/stop-dfs.sh
```

### 搭建YARN
##### 配置yarn-env.sh
```sh
vim etc/hadoop/yarn-env.sh
export JAVA_HOME=/opt/setups/jdk1.8.0_181
```
##### 配置yarn-site.xml
```sh
vim etc/hadoop/yarn-site.xml
<configuration>
    <!-- Reducer获取数据的方式 -->
    <property>
        <name>yarn.nodemanager.aux-services</name>
        <value>mapreduce_shuffle</value>
    </property>
   <!-- 指定YARN的ResourceManager的地址 -->
   <property>
	<name>yarn.resourcemanager.hostname</name>
	<value>hadoop237</value>
   </property>
</configuration>
```
##### 配置mapred-env.sh
```sh
vim etc/hadoop/mapred-env.sh
export JAVA_HOME=/opt/setups/jdk1.8.0_181
```
##### 配置mapred-site.xml
```sh
cp etc/hadoop/mapred-site.xml.template etc/hadoop/mapred-site.xml
vim etc/hadoop/mapred-site.xml
<configuration>
    <!-- 指定MR运行在YARN上 -->
    <property>
        <name>mapreduce.framework.name</name>
        <value>yarn</value>
    </property>
</configuration>
```
##### 启动集群
> 启动前必须保证NameNode和DataNode已经启动

```sh
sbin/start-yarn.sh
# 或者使用如下命令
sbin/yarn-daemon.sh start resourcemanager
sbin/yarn-daemon.sh start nodemanager
```
可以通过：hadoop237:8088 查看网页
> 可以通过jps查看

##### 操作集群
- 执行MapReduce程序
```sh
hadoop jar share/hadoop/mapreduce/hadoop-mapreduce-examples-2.7.2.jar wordcount /user/ubuntu/input /user/ubuntu/output
```
- 查看运行结果
```sh
hadoop fs -cat /user/ubuntu/output/*
```

##### 设置免密启动
```sh
ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 0600 ~/.ssh/authorized_keys
```
#####  配置历史服务器
为了查看程序的历史运行情况，需要配置一下历史服务器
```sh
vim etc/hadoop/mapred-site.xml
# 增加以下配置
<!-- 历史服务器端地址 -->
<property>
    <name>mapreduce.jobhistory.address</name>
    <value>hadoop237:10020</value>
</property>
<!-- 历史服务器web端地址 -->
<property>
    <name>mapreduce.jobhistory.webapp.address</name>
    <value>hadoop237:19888</value>
</property>
```
- 启动历史服务器
```sh
sbin/mr-jobhistory-daemon.sh start historyserver
```

##### 配置日志的聚集
日志聚集概念：应用运行完成以后，将程序运行日志信息上传到HDFS系统上。<br>
日志聚集功能好处：可以方便的查看到程序运行详情，方便开发调试。
> 注意：开启日志聚集功能，需要重新启动NodeManager 、ResourceManager和JobHistoryServer。

- 配置yarn-site.xml
```sh
vim etc/hadoop/yarn-site.xml
# 增加以配置
<!-- 日志聚集功能使能 -->
<property>
    <name>yarn.log-aggregation-enable</name>
    <value>true</value>
</property>
<!-- 日志保留时间设置7天 -->
<property>
    <name>yarn.log-aggregation.retain-seconds</name>
      <value>604800</value>
</property>
```
- 关闭NodeManager、ResourceManager、JobHistoryServer
```sh
sbin/mr-jobhistory-daemon.sh stop historyserver
sbin/yarn-daemon.sh stop resourcemanager
sbin/yarn-daemon.sh stop nodemanager
```
- 启动NodeManager、ResourceManager、JobHistoryServer
```sh
sbin/mr-jobhistory-daemon.sh start historyserver
sbin/yarn-daemon.sh start resourcemanager
sbin/yarn-daemon.sh start nodemanager
```
- 删除HDFS上已经存在的输出文件
```sh
bin/hdfs dfs -rm -R /user/ubuntu/output
```
- 执行WordCount程序
```sh
hadoop jar share/hadoop/mapreduce/hadoop-mapreduce-examples-2.7.2.jar wordcount /user/ubuntu/input /user/ubuntu/output
```
- 查看日志
```
http://hadoop237:19888/jobhistory/logs
```
