##### 环境准备
- 系统环境：Ubuntu16.04 x86_64
- 内核
```
Distributor ID:	Ubuntu
Description:	Ubuntu 16.04.3 LTS
Release:	16.04
Codename:	xenial
```
- jdk1.8.1
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

##### 配置core-site.xml
```sh
vim etc/hadoop/core-site.xml
<configuration>
    <!-- 指定HDFS中NameNode的地址 -->
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://192.168.10.237:9000</value>
    </property>
    <!-- 指定Hadoop运行时产生文件的存储目录 -->
    <property>
        <name>hadoop.tmp.dir</name>
        <value>/home/ubuntu/hadoop/setups/hadoop-data/hadoop-2.7.2/data/tmp</value>
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
<configuration>
```
##### 格式化NameNode
```sh
bin/hdfs namenode -format
```
##### 启动NameNode和DataNode后台运行
```sh
sbin/start-dfs.sh
```
##### web端查看HDFS文件系统
```
http://192.168.10.237:50070
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
bin/hdfs dfs -rmr /user/ubuntu/output
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
