##### 下载
从官网下载对应的jdk
```
https://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html
```
##### 解压安装包
```shell
sudo tar -zxvf jdk-8u181-linux-x64.tar.gz
```
> 将解压后的文件拷贝至/home/ubuntu/java/jdk目录下

##### 配置环境变量
```shell
sudo vim /etc/profile
```
在文件底部输入以下信息，并保存
```shell
JAVA_HOME=/home/ubuntu/java/jdk/jdk1.8.0_181
JRE_HOME=$JAVA_HOME/jre
PATH=$PATH:$JAVA_HOME/bin
CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
export JAVA_HOME
export JRE_HOME
export PATH
export CLASSPATH
```
##### 重新加载配置文件
```shell
sudo source /etc/profile
```
##### 查看jdk版本
```shell
ubuntu@ubuntu-1604-222:/opt$ java -version
java version "1.8.0_181"
Java(TM) SE Runtime Environment (build 1.8.0_181-b13)
Java HotSpot(TM) 64-Bit Server VM (build 25.181-b13, mixed mode)
```
