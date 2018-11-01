## Hive安装

##### 环境
- 系统环境：Ubuntu16.04 x86_64
- 内核
```
Distributor ID:	Ubuntu
Description:	Ubuntu 16.04.3 LTS
Release:	16.04
Codename:	xenial
```
- jdk1.8.1
- hadoop-2.7.2
- hive-1.2.1

##### Hive的安装地址
```sh
wget http://archive.apache.org/dist/hive/hive-1.2.1/apache-hive-1.2.1-bin.tar.gz
```
##### 解压
```sh
tar -zxvf apache-hive-1.2.1-bin.tar.gz -C ../setups/
```
##### 配置环境变量
```sh
vim .bashrc
# 在配置文件最后添加一下环境变量
export HIVE_HOME=/home/songhuan/hadoop/setups/apache-hive-1.2.1-bin
export PATH=$PATH:$HIVE_HOME/bin
```
##### 配置hive-env.sh
```sh
cd conf/
cp hive-env.sh.template hive-env.sh
vim hive-env.sh
# 配置HADOOP_HOME路径
HADOOP_HOME=/home/songhuan/hadoop/setups/hadoop-2.7.2
# 配置HIVE_CONF_DIR路径
export HIVE_CONF_DIR=/home/songhuan/hadoop/setups/apache-hive-1.2.1-bin/conf
```
##### Hive基本操作
> 在启动Hive之前，需要先保证Hadoop运行

- 启动hadoop
```sh
$HADOOP_HOME/sbin/start-dfs.sh
$HADOOP_HOME/sbin/start-yarn.sh
```
- 在HDFS上创建目录并修改它们的权限
```sh
hadoop fs -mkdir /tmp
hadoop fs -mkdir -p /user/hive/warehouse
hadoop fs -chmod g+w /tmp
hadoop fs -chmod g+w /user/hive/warehouse
```
- 启动Hive
```sh
$HIVE_HOME/bin/hive
```
- 查看数据库
```sql
show databases;# 最后一定记得加分号
```
- 使用default数据库
```sql
use default;
```
- 显示default数据库中的表
```sql
show tables;
```
- 创建一张表
```sql
create table student(id int,name string);
```
- 查看表结构
```sql
desc student;
```
- 向表中插入数据
```sql
insert into student(id,name) values(1,"sh");
```
- 查询表中数据
```sql
select * from student;
```
- 统计表中的条数
```sql
select count(*) from student;
```
- 退出hive
```sql
quit;
```

### 将本地文件导入Hive
##### 数据准备
在/home/songhuan/hadoop创建datas目录
```sh
mkdir datas
```
在/home/songhuan/hadoop/datas目录下创建student.txt文件并添加数据
```sh
cd datas/
touch student.txt
vim student.txt
# 添加一下数据到文件
1001	zhangshan
1002	lishi
1003	zhaoliu
```
##### Hive实际操作
- 启动Hive
```sh
$HIVE_HOME/bin/hive
```
- 显示数据库
```sql
show databases;
```
- 使用default数据库
```sql
use default;
```
- 显示default数据库中的表
```sql
show tables;
```
- 加载本地student.txt文件到student数据库表中
```sh
load data local inpath "/home/songhuan/hadoop/datas/student.txt" into table student;
```
- 查询结果
```sql
select * from student;
```
> 以上查询结果全为空，原因是因为文件和表的格式不一致导致

解决办法：
- 删除已创建的表
```sql
drop table student;
```
- 创建表student，并声明文件分隔符'\t'
```sql
create table student(id int, name string) row format delimited fields terminated by '\t';
```
- 再重新导入文件student.txt
```sql
load data local inpath "/home/songhuan/hadoop/datas/student.txt" into table student;
```
- Hive查询结果
```sql
hive> select * from student;
OK
1001	zhangshan
1002	lishi
1003	zhaoliu
Time taken: 0.067 seconds, Fetched: 3 row(s)
```
- 遇到的一个问题
再打开一个客户端窗口启动hive，会产生java.sql.SQLException异常
```
Caused by: java.sql.SQLException: Failed to start database 'metastore_db' with class loader sun.misc.Launcher$AppClassLoader@682a0b20, see the next exception for details.
	at org.apache.derby.impl.jdbc.SQLExceptionFactory40.getSQLException(Unknown Source)
	at org.apache.derby.impl.jdbc.Util.newEmbedSQLException(Unknown Source)
	at org.apache.derby.impl.jdbc.Util.seeNextException(Unknown Source)
	at org.apache.derby.impl.jdbc.EmbedConnection.bootDatabase(Unknown Source)
	at org.apache.derby.impl.jdbc.EmbedConnection.<init>(Unknown Source)
	at org.apache.derby.impl.jdbc.EmbedConnection40.<init>(Unknown Source)
	at org.apache.derby.jdbc.Driver40.getNewEmbedConnection(Unknown Source)
	at org.apache.derby.jdbc.InternalDriver.connect(Unknown Source)
	at org.apache.derby.jdbc.Driver20.connect(Unknown Source)
	at org.apache.derby.jdbc.AutoloadedDriver.connect(Unknown Source)
	at java.sql.DriverManager.getConnection(DriverManager.java:664)
	at java.sql.DriverManager.getConnection(DriverManager.java:208)
	at com.jolbox.bonecp.BoneCP.obtainRawInternalConnection(BoneCP.java:361)
	at com.jolbox.bonecp.BoneCP.<init>(BoneCP.java:416)
	... 60 more
```
> MySQL安装不再赘述

### Hive元数据配置MySQL
##### MySQL驱动拷贝
```sh
cp mysql-connector-java-5.1.27-bin.jar $HIVE_HOME/lib
```
##### 配置hive-site.xml
在$HIVE_HOME/conf目录下创建hive-site.xml文件
```xml
touch hive-site.xml
vim hive-site.xml
# 配置以下内容
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
        <property>
          <name>javax.jdo.option.ConnectionURL</name>
          <value>jdbc:mysql://192.168.10.4:3306/metastore?createDatabaseIfNotExist=true</value>
          <description>JDBC connect string for a JDBC metastore</description>
        </property>

        <property>
          <name>javax.jdo.option.ConnectionDriverName</name>
          <value>com.mysql.jdbc.Driver</value>
          <description>Driver class name for a JDBC metastore</description>
        </property>

        <property>
          <name>javax.jdo.option.ConnectionUserName</name>
          <value>root</value>
          <description>username to use against metastore database</description>
        </property>

        <property>
          <name>javax.jdo.option.ConnectionPassword</name>
          <value>root</value>
          <description>password to use against metastore database</description>
        </property>
</configuration>
```
> 配置完成之后，如果重启hive异常，可以重新启动虚拟机。（重启虚拟机之后一定要记得启动hadoop）

最后多窗口启动hive测试正常。

##### Hive常用交互命令
```sh
songhuan@hadoop11:~/hadoop/setups/apache-hive-1.2.1-bin$ bin/hive -help
usage: hive
 -d,--define <key=value>          Variable subsitution to apply to hive
                                  commands. e.g. -d A=B or --define A=B
    --database <databasename>     Specify the database to use
 -e <quoted-query-string>         SQL from command line
 -f <filename>                    SQL from files
 -H,--help                        Print help information
    --hiveconf <property=value>   Use value for given property
    --hivevar <key=value>         Variable subsitution to apply to hive
                                  commands. e.g. --hivevar A=B
 -i <filename>                    Initialization SQL file
 -S,--silent                      Silent mode in interactive shell
 -v,--verbose                     Verbose mode (echo executed SQL to the
                                  console)
```
> 在之前的操作中，是创建了student表的，但是在配置了MySQL数据库之后，无法查询到表数据（之前的数据是存储在derby数据库的），连表都已经不存在了。之前通过load一个文件插入了数据，该数据是存储在hdfs中的，虽然换了数据库，元数据信息不在了，但是hdfs中的数据还在，但是再创建了student表之后，MySQL中有了元数据信息，所有通过select查询是能够查到数据的。

- “-e”不进入hive的交互窗口执行sql语句
```sql
bin/hive -e "select * from student"
```
- “-f”执行脚本中sql语句
```sql
touch hive.sql
vim hive.sql
# 新增以下sql
select * from student;
```
然后通过以下命令执行：
```sh
bin/hive -f hive.sql
```
执行文件中的sql语句并将结果写入文件中:
```sh
bin/hive -f hive.sql > hive_result.txt
```
##### Hive其他命令操作
- 退出窗口
```sh
exit;
# 或
quit;
```
在新版的hive中没区别了，在以前的版本是有的：
exit:先隐性提交数据，再退出；
quit:不提交数据，退出
- 在hive cli命令窗口中如何查看hdfs文件系统
```sh
dfs -ls /;
```
- 在hive cli命令窗口中如何查看本地文件系统
```sh
! ls /opt/module/datas;
```
- 查看在hive中输入的所有历史命令
进入到当前用户家目录：
```sh
cat .hivehistory
```
### Hive常见属性配置
##### Hive数据仓库位置配置
1) Default数据仓库的最原始位置是在hdfs上的：/user/hive/warehouse路径下。<br>
2) 在仓库目录下，没有对默认的数据库default创建文件夹。如果某张表属于default数据库，直接在数据仓库目录下创建一个文件夹。<br>
3) 修改default数据仓库原始位置:
```sh
vim $HIVE_HOME/conf/hive-site.xml
# 添加以下配置
<property>
	<name>hive.metastore.warehouse.dir</name>
	<value>/user/hive/warehouse</value>
	<description>location of default database for the warehouse</description>
</property>
```
##### 执行sql查询后显示字段名
vim $HIVE_HOME/conf/hive-site.xml
```xlm
<property>
	<name>hive.cli.print.header</name>
	<value>true</value>
</property>

<property>
	<name>hive.cli.print.current.db</name>
	<value>true</value>
</property>
```
启动hive后可以对比差异
##### Hive运行日志信息配置
```sh
cd $HIVE_HOME/conf
cp hive-log4j.properties.template hive-log4j.properties
vim hive-log4j.properties
# 更改以下配置
hive.log.dir=/home/songhuan/hadoop/hive-logs
```
##### 参数配置方式
- 配置文件方式
	- 默认配置文件：hive-default.xml
	- 用户自定义配置文件：hive-site.xml
	- 注意：用户自定义配置会覆盖默认配置。另外，Hive也会读入Hadoop的配置，因为Hive是作为Hadoop的客户端启动的，Hive的配置会覆盖Hadoop的配置。配置文件的设定对本机启动的所有Hive进程都有效

- 命令行参数方式
启动Hive时，可以在命令行添加-hiveconf param=value来设定参数。
```sh
bin/hive -hiveconf mapred.reduce.tasks=10;
```
> 注意：仅对本次hive启动有效

查看参数设置：
```sh
set mapred.reduce.tasks;
```
- 参数声明方式
可以在HQL中使用SET关键字设定参数：
```sh
set mapred.reduce.tasks=100;
```
> 注意：仅对本次hive启动有效

查看参数设置：
```sh
set mapred.reduce.tasks;
```
上述三种设定方式的优先级依次递增。即配置文件<命令行参数<参数声明。注意某些系统级的参数，例如log4j相关的设定，必须用前两种方式设定，因为那些参数的读取在会话建立以前已经完成了。
