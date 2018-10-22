##### 解压安装包
```sh
sudo tar -zxvf apache-maven-3.5.0-bin.tar.gz -C /opt/setups/
```
##### 配置环境变量
```sh
sudo vim /etc/profile.d/maven.sh
export M2_HOME=/opt/setups/apache-maven-3.5.0
export PATH=$PATH:$M2_HOME/bin
```
> 注意：不要将环境变量配置在/etc/profile文件中，这样远程ssh连接时mvn -v 是无法生效的
##### 查看maven版本
```sh
songhuan@ubuntu-1604-238:~$ mvn -v
Apache Maven 3.5.0 (ff8f5e7444045639af65f6095c62210b5713f426; 2017-04-04T03:39:06+08:00)
Maven home: /opt/setups/apache-maven-3.5.0
Java version: 1.8.0_181, vendor: Oracle Corporation
Java home: /usr/local/jdk1.8.0_181/jre
Default locale: en_US, platform encoding: UTF-8
OS name: "linux", version: "4.4.0-87-generic", arch: "amd64", family: "unix"
```
