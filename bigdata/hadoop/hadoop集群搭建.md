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
- 三台虚拟机，ip分别为：10.211.55.11、10.22.55.13、10.211.55.14
- hostname分别对应为：hadoop11、hadoop13、hadoop14

> Java环境变量和Hadoop环境变量不再赘述

将原来搭建好的hadoop拷贝至另外两台。具体可以[参考](hadoop搭建.md)
##### 集群分发脚本
> 用来分发机器上的文件，比如说A机器上修改了配置文件，需要分发到B和C机器上，那么就可以使用一下脚本

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
for host in 11 13 14
   do
      if [ "$hostname" == "hadoop$host" ]
         then
           continue
      fi
      echo ------------------- hadoop$host --------------
      rsync -rvl $pdir/$fname $user@hadoop$host:$pdir
   done
```
举例：比如将当前用户目录下的bin分发到另外两台机器上，执行以下命令：
```sh
xsync bin
```
### 集群配置
##### 集群部署规划

无 | hadoop11 | hadoop13 | hadoop14
--- | --- | --- | ---
HDFS | NameNode<br>DataNode | DataNode | SecondaryNameNode<br>DataNode
YARN | NodeManager | ResourceManager<br>NodeManager | NodeManager

##### 配置集群
> 以下操作均在10.211.55.11(hadoop11)上进行操作，如果没有特别说明均在该机器进行以下操作

hadoop解压文件放在：~/hadoop/setups<br>
cd ~/hadoop/setups

配置core-site.xml<br>
```sh
vim etc/hadoop/core-site.xml
<configuration>
    <!-- 指定HDFS中NameNode的地址 -->
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://hadoop11:9000</value>
    </property>
    <!-- 指定Hadoop运行时产生文件的存储目录 -->
    <property>
        <name>hadoop.tmp.dir</name>
        <value>/home/songhuan/hadoop/setups/hadoop-data/data/tmp</value>
    </property>
</configuration>
```
HDFS配置文件<br>
配置hadoop-env.sh
```sh
vim etc/hadoop/hadoop-env.sh
export JAVA_HOME=/opt/setups/jdk1.8.0_181
```
配置hdfs-site.xml<br>
```sh
vim etc/hadoop/hdfs-site.xml
<configuration>
    <!-- 指定HDFS副本的数量(系统默认的副本数也是3，其实可以不用配置) -->
    <property>
        <name>dfs.replication</name>
        <value>3</value>
    </property>
    <!-- 指定Hadoop辅助名称节点主机配置  -->
    <property>
        <name>dfs.namenode.secondary.http-address</name>
        <value>hadoop14:50090</value>
    </property>
</configuration>
```
YARN配置文件<br>
配置yarn-env.sh
```sh
vim etc/hadoop/yarn-env.sh
export JAVA_HOME=/opt/setups/jdk1.8.0_181
```
配置yarn-site.xml
```sh
vim yarn-site.xml
<configuration>
    <!-- Reducer获取数据的方式 -->
    <property>
        <name>yarn.nodemanager.aux-services</name>
        <value>mapreduce_shuffle</value>
    </property>
   <!-- 指定YARN的ResourceManager的地址 -->
   <property>
        <name>yarn.resourcemanager.hostname</name>
        <value>hadoop13</value>
   </property>
</configuration>
```
配置MapReduce文件<br>
配置mapred-env.sh
```sh
vim etc/hadoop/mapred-env.sh
export JAVA_HOME=/opt/setups/jdk1.8.0_181
```
配置mapred-site.xml
```sh
mv etc/hadoop/mapred-site.xml.template etc/hadoop/mapred-site.xml
vim etc/hadoop/mapred-site.xml
<configuration>
    <!-- 指定MR运行在YARN上 -->
    <property>
        <name>mapreduce.framework.name</name>
        <value>yarn</value>
    </property>
</configuration>
```
在集群上分发配置好的Hadoop配置文件
```sh
# 退回到当前用户目录/home/songhuan
# 执行以下命令
xsync ~/hadoop/setups/hadoop-2.7.2/
```
可以去对应的机器上验证配置文件分发情况

##### 集群单点启动
cd ~/hadoop/setups/hadoop-2.7.2
> 如果集群是第一次启动，需要格式化NameNode

```sh
bin/hdfs namenode -format
```
在hadoop11上启动NameNode
```sh
hadoop-daemon.sh start namenode
```
在hadoop11、hadoop13、hadoop14上启动DataNode
```sh
hadoop-daemon.sh start datanode
```
> 缺点：需要一个一个节点的去启动

##### SSH无密登陆配置
生成公钥和私钥
```sh
ssh-keygen -t rsa
# 敲三个回车即可生成id_rsa、id_rsa.put
```
将公钥拷贝到要免密登陆的机器上
```sh
ssh-copy-id hadoop11
ssh-copy-id hadoop13
ssh-copy-id hadoop14
```
.ssh文件夹下(~./ssh)的文件功能解释

known_hosts | 记录ssh访问过计算机的公钥
--- | ---
id_rsa | 生成的私钥
id_rsa.pub | 生成的公钥
authorized_keys | 存放授权过的无密登陆服务器公钥

##### 群起集群
配置slaves
```sh
cd ~/hadoop/setups/hadoop-2.7.2/etc/hadoop
vim slaves
# 在该文件中添加一下内容(删除对应的locahost)
hadoop11
hadoop13
hadoop14
# 注意：在该文件中不允许有空行，或者文件结尾有空格
```
然后同步所有节点slaves配置文件
```sh
xsync slaves
```
##### 启动集群
如果集群是第一次启动，需要格式化NameNode(注意格式化之前，一定要先停止上次启动的所有namenode和datanode进程，然后再删除data和logs数据)

因为上次启动NameNode和DataNode，所以需要将各个机器上的NameNode或DataNode先停掉。

在hadoop11上启动HDFS
```sh
sbin/start-dfs.sh
```
如下图所示：
![image](http://pceh5403k.bkt.clouddn.com/hadoop%E9%9B%86%E7%BE%A4%E5%90%AF%E5%8A%A8%E5%9B%BE.jpeg)
查看hadoop11上启动的节点：
![image](http://pceh5403k.bkt.clouddn.com/hadoop11%E5%90%AF%E5%8A%A8%E8%8A%82%E7%82%B9.jpeg)
查看hadoop13上启动的节点：
![image](http://pceh5403k.bkt.clouddn.com/hadoop13%E5%90%AF%E5%8A%A8%E8%8A%82%E7%82%B9.jpeg)
查看hadoop14上启动的节点：
![image](http://pceh5403k.bkt.clouddn.com/hadoop14%E5%90%AF%E5%8A%A8%E8%8A%82%E7%82%B9.jpeg)
在hadoop13上启动YARN
> 注意：NameNode和ResourceManager如果不是在同一台机器，不能再NameNode上启动YARN，应该在ResourceManager所在的机器上启动YARN

启动命令如下：
```sh
sbin/start-yarn.sh
```
如下图所示：
![image](http://pceh5403k.bkt.clouddn.com/hadoop13-yarn%E5%90%AF%E5%8A%A8%E8%8A%82%E7%82%B9.jpeg)

##### 集群基本测试
上传小文件
```sh
bin/hdfs dfs -put input/core-site.xml /
```
上传大文件
```sh
bin/hdfs dfs -put ../../software/hadoop-2.7.2.tar.gz /
```
在浏览器中输入：http://hadoop11:50070/explorer.html#/ 可查看上传的文件<br>
如下图所示：
![image](http://pceh5403k.bkt.clouddn.com/hdfs%E6%96%87%E4%BB%B6%E4%B8%8A%E4%BC%A0.jpeg)

上传文件后查看文件存放的位置
![image](http://pceh5403k.bkt.clouddn.com/%E4%B8%8A%E4%BC%A0%E6%96%87%E4%BB%B6%E5%AD%98%E5%82%A8%E4%BD%8D%E7%BD%AE.jpeg)

说明：大文件是分块存储的，比如上图的大文件存储分为两块blk_1073741826和blk_1073741827，可以将他们合并为一块并解压(上传的大文件是一个压缩包)
```sh
cat blk_1073741826 >> tmp.file
cat blk_1073741827 >> tmp.file
tar -zxvf tmp.file
```
##### 集群启动/停止方式总结
- 各个服务组件逐一启动/停止
```sh
# 分别启动/停止HDFS组件
hadoop-daemon.sh start/stop namenode/datanode/secondarynamenode
```
```sh
# 启动停止YARN
yarn-daemon.sh start/stop resourcemanager/nodemanager
```
- 各个模块分开启动/停止（配置ssh是前提）
```sh
# 整体启动/停止HDFS
start-dfs.sh/stop-dfs.sh
# 整体启动/停止YARN
start-yarn.sh/stop-yarn.sh
```

##### 集群时间同步
>时间同步方式：找一个机器作为时间服务器，所有的机器与这台服务器进行定时的同步.

- 安装ntp时间服务
切换到root用户
```sh
apt-get -y install ntp
```
- 启动、停止、重启NTP
```sh
service ntp start
service ntp stop
service ntp restart
```
- 使用下面的命令检查NTP服务是否运行
```sh
pgrep ntpd
# 最终应该能得到一个进程id
```
- 配置ntp.conf
```sh
vim /etc/ntp.conf
# 修改1
restrict 192.168.1.0 mask 255.255.255.0 notrust 修改为
restrict 10.211.0.0 mask 255.255.255.0 notrap nomodify
# 修改2
pool 0.ubuntu.pool.ntp.org iburst
pool 1.ubuntu.pool.ntp.org iburst
pool 2.ubuntu.pool.ntp.org iburst
pool 3.ubuntu.pool.ntp.org iburst 修改为
#pool 0.ubuntu.pool.ntp.org iburst
#pool 1.ubuntu.pool.ntp.org iburst
#pool 2.ubuntu.pool.ntp.org iburst
#pool 3.ubuntu.pool.ntp.org iburst
# 修改3
添加：
server 127.127.1.0
fudge 127.127.1.0 stratum 10
```
- 查看时间服务器版本
```sh
ntpd --version
```
- 在另外一台机器上验证
```sh
sudo apt-get -y install ntpdate
# 验证是否可以同步时间
ntpdate -d hadoop11
输出以下内容即代表成功：
26 Oct 09:42:19 ntpdate[5997]: adjust time server 10.211.55.11 offset 0.081644 sec
```
- 同步时间
```sh
/usr/sbin/ntpdate 10.211.55.11
```
