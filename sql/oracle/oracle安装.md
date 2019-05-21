#### 环境准备
- 系统环境：Ubuntu16.04 x86_64
- 内核
```
Linux version 4.4.0-117-generic
```
- jdk1.8.181
- Oracle11g
> 本机已安装JDK

#### 安装所需依赖
```sh
sudo apt-get -y install automake
sudo apt-get -y install autotools-dev
sudo apt-get -y install binutils
sudo apt-get -y install bzip2
sudo apt-get -y install elfutils
sudo apt-get -y install expat
sudo apt-get -y install gawk
sudo apt-get -y install gcc
sudo apt-get -y install gcc-multilib
sudo apt-get -y install g++-multilib
sudo apt-get -y install lib32ncurses5 ​
sudo apt-get -y install lib32z1
sudo apt-get -y install ksh
sudo apt-get -y install less
sudo apt-get -y install libaio1
sudo apt-get -y install libaio-dev
sudo apt-get -y install libc6-dev
sudo apt-get -y install libc6-dev-i386
sudo apt-get -y install libc6-i386
sudo apt-get -y install libelf-dev
sudo apt-get -y install libltdl-dev
sudo apt-get -y install libodbcinstq4-1 libodbcinstq4-1:i386
sudo apt-get -y install libpth-dev libpthread-stubs0-dev libstdc++5
sudo apt-get -y install make openssh-server rlwrap
sudo apt-get -y install rpm sysstat unixodbc unixodbc-dev unzip x11-utils zlibc
```
#### 检查系统变量
```sh
/sbin/sysctl -a | grep sem
/sbin/sysctl -a | grep shm
/sbin/sysctl -a | grep file-max
/sbin/sysctl -a | grep aio-max
/sbin/sysctl -a | grep ip_local_port_range
/sbin/sysctl -a | grep rmem_default
/sbin/sysctl -a | grep rmem_max
/sbin/sysctl -a | grep wmem_default
/sbin/sysctl -a | grep wmem_max
```
#### 在/etc/sysctl.conf中增加对应的系统变量数据
```sh
kernel.sem = 32000 1024000000 500 32000
kernel.shmall = 18446744073692774399
kernel.shmmax = 18446744073692774399
kernel.shmmni = 4096
fs.file-max = 811483
fs.aio-max-nr = 65536
net.ipv4.ip_local_port_range = 32768 60999
net.core.rmem_default = 212992
net.core.rmem_max = 212992
net.core.wmem_default = 212992
net.core.wmem_max = 212992
```
运行一下命令更新内核参数：

sysctl –p

#### 添加对用户的内核限制
 添加对ubuntu用户的内核限制在 /etc/security/limits.conf 文件中增加以下数据,注:其中ubuntu是我ubuntu系统的普通用户
 ```sh
oracle              soft    nproc   2047
oracle              hard    nproc   16384
oracle              soft    nofile  10240
oracle              hard    nofile  65536
oracle              soft    stack   10240
 ```
#### 查看/etc/pam.d/login
```sh
cat /etc/pam.d/login
# 查看session required pam_limits.so 是否存在，如果不存在就添加上
```
#### 创建oracle目录
```sh
mkdir -p oracle/Oracle11g
mkdir -p oracle/oradata
```
#### 为oracle配置环境变量
```sh
#oracle安装目录，上一步创建的文件夹
export ORACLE_BASE=/home/oracle/oracle/oracle11g
export ORACLE_HOME=$ORACLE_BASE/product/11.2.0/dbhome_1
#数据库的sid
export ORACLE_SID=orcl
export ORACLE_UNQNAME=orcl
#默认字符集
export NLS_LANG=.AL32UTF8
#环境变量
export PATH=${PATH}:${ORACLE_HOME}/bin/:$ORACLE_HOME/lib64
```
##### 欺骗oracle的安装程序
Oracle本身并不支持ubuntu来安装，所以要进行欺骗oracle的安装程序，执行以下命令(root用户下执行)
```sh
mkdir /usr/lib64
ln -s /etc /etc/rc.d
ln -s /lib/x86_64-linux-gnu/libgcc_s.so.1 /lib64/
ln -s /usr/bin/awk /bin/awk
ln -s /usr/bin/basename /bin/basename
ln -s /usr/bin/rpm /bin/rpm
ln -s /usr/lib/x86_64-linux-gnu/libc_nonshared.a /usr/lib64/
ln -s /usr/lib/x86_64-linux-gnu/libpthread_nonshared.a /usr/lib64/
ln -s /usr/lib/x86_64-linux-gnu/libstdc++.so.6 /lib64/
ln -s /usr/lib/x86_64-linux-gnu/libstdc++.so.6 /usr/lib64/
#不知道为什么要执行这句
echo 'Red Hat Linux release 5' > /etc/RedHat-release
```
#### 解压两个安装文件
```sh
sudo unzip linux.x64_11gR2_database_1of2.zip
sudo unzip linux.x64_11gR2_database_2of2.zip
```
#### 开始安装
进入到database文件，执行以下命令，在root用户下执行
```sh
# 更改文件权限
chmod 777 runInstaller
./runInstaller
```
