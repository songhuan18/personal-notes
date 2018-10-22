> 以hadoop 2.9.1 为例

机器：ubuntu-1604 x86_64

##### 准备
- jdk1.8.0_181
- apache-maven-3.5.0
- findbugs-1.3.9
- protobuf-2.5.0
- hadoop-2.9.1-src

> JDK和Maven安装配置不再说明

##### 安装依赖库和工具
```sh
sudo apt-get update
sudo apt-get -y install gcc g++ make cmake autoconf libtool protobuf-compiler
```

##### Findsbugs安装
貌似可要可不要

```sh

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
##### 编译hadoop
> 切换到root用户

```sh
cd hadoop-2.9.1-src/
mvn package -Pdist,native -DskipTests -Dtar
```
