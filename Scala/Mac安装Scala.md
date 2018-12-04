##### Mac安装Scala
```sh
wget https://downloads.lightbend.com/scala/2.12.7/scala-2.12.7.tgz
```
##### 解压scala-2.12.7.tgz
```sh
tar -zxvf scala-2.12.7.tgz
```
##### 配置sScala环境变量
```sh
vim .bash_profile
# 添加一下内容
export SCALA_HOME=/Users/songhuan/scala/scala-2.12.7
export PATH=$PATH:$SCALA_HOME/bin
#重新加载.bash_profile
source .bash_profile
```
##### 查看scala版本
```sh
scala -version
```
##### Mac安装sbt
```sh
brew install sbt@1
sudo port selfupdate
sudo port install sbt
```
> 如果提示：command not found: port，请安装Macports

##### 安装Macports
> Mac版本：MacOs Sierra v10.12.6

下载地址：https://distfiles.macports.org/MacPorts/MacPorts-2.5.4-10.12-Sierra.pkg

##### 配置Macports环境变量
```sh
vim .bash_profile
# 或者
vim /etc/profile
# 添加如下配置
export PATH=$PATH:/opt/local/bin
export PATH=$PATH:/opt/local/sbin
# 最后
source .bash_profile
```
