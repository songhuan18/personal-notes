> 以hadoop 2.9.1 为例

机器：ubuntu-1604 x86_64

##### 准备
- jdk1.8.0_181
- apache-maven-3.5.0
- protobuf-2.5.0
- hadoop-2.9.1-src
- ant-1.9.13
- findbugs-1.3.9

> JDK和Maven安装配置不再说明

##### 安装依赖库和工具
```sh
sudo apt-get update
sudo apt-get -y install gcc g++ make cmake autoconf automake zlib1g-dev libtool protobuf-compiler libncurses5-dev openssl libssl-dev pkg-config
```
##### ProtocolBuffer 2.5.0安装
> 切换到root用户

```sh
sudo -s
cd protobuf-2.5.0/
./configure --prefix=/usr/local/src/protobuf
make && make install
```
- 配置protobuf环境变量

```sh
cd /etc/profile.d/
vim protoc.sh
# 配置环境变量
export PROTOC_HOME=/usr/local/src/protobuf
export PATH=$PROTOC_HOME/bin:$PATH
```
查看protobuf版本
```sh
protoc --version
```
##### findbugs 1.3.9 安装
```sh
cd /etc/profile.d
touch findbugs.sh
vim findbugs.sh
# 配置环境变量
export FINDBUGS_HOME=/opt/setups/findbugs-1.3.9
export PATH=$PATH:$FINDBUGS_HOME/bin
# 查看findbugs版本
findbugs -version
```
##### ant安装
```sh
sudo wget http://mirror.bit.edu.cn/apache//ant/binaries/apache-ant-1.9.13-bin.tar.gz
sudo tar -zxvf apache-ant-1.9.13-bin.tar.gz -C ../setups/
cd /etc/profile.d
touch ant.sh
vim ant.sh
# 配置以下环境变量
export ANT_HOME=/opt/setups/apache-ant-1.9.13
export PATH=$PATH:$ANT_HOME/bin
# 查看版本
ant -version
```

##### 编译hadoop
> 切换到root用户

```sh
cd hadoop-2.9.1-src/
mvn package -Pdist,native -DskipTests -Dtar
```
编译好的hadoop安装包所在位置：hadoop-2.9.1-src/hadoop-dist/target/hadoop-2.9.1.tar.gz
##### 编译源码遇到的问题

问题1：Failed to execute goal org.apache.hadoop:hadoop-maven-plugins:2.9.1-alpha4:cmake-compile (cmake-compile) on project hadoop-common: CMake failed with error code 1 -> [Help 1]

解决办法：
```sh
sudo apt-get install zlib1g-dev
sudo apt-get install libssl-dev
```
问题2：Failed to execute goal org.apache.hadoop:hadoop-maven-plugins:2.9.1:cmake-compile (cmake-compile) on project hadoop-hdfs-native-client: CMake failed with error code 1

解决办法：
```sh
# 执行这条编译命
sudo apt-get -y install libncurses5-dev
sudo apt-get -y install openssl
sudo apt-get -y install libssl-dev
mvn clean package -Pdist,native -DskipTests -Dtar
```
