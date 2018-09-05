##### 下载
从官网下载对应的jdk
```
https://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html
```
通过命令下载
```
wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u181-b13/96a7b8442fe848ef90c96a2fad6ed6d1/jdk-8u181-linux-x64.tar.gz
```
> 注意：在oracle官网下载jdk必须“Accept License Agreement”，所以在下载jdk时需添加命令：--no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie"。如果不添加该命令，那么下载下来的包无法解压

##### 解压安装包
```shell
sudo tar -zxvf jdk-8u181-linux-x64.tar.gz
```
> 将解压后的文件拷贝至/home/ubuntu/java/jdk目录下

##### 配置环境变量
```shell
sudo vim /etc/environment
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
sudo source /etc/environment
```
##### 查看jdk版本
```shell
ubuntu@ubuntu-1604-222:/opt$ java -version
java version "1.8.0_181"
Java(TM) SE Runtime Environment (build 1.8.0_181-b13)
Java HotSpot(TM) 64-Bit Server VM (build 25.181-b13, mixed mode)
```
