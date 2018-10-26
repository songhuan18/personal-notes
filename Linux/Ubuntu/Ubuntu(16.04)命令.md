##### 查看ubuntu系统命令
```shell
root@ubuntu-1604-220:~# uname -a
Linux ubuntu-1604-220 4.4.0-87-generic #110-Ubuntu SMP Tue Jul 18 12:55:35 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux
root@ubuntu-1604-220:~# cat /proc/version
Linux version 4.4.0-87-generic (buildd@lcy01-31) (gcc version 5.4.0 20160609 (Ubuntu 5.4.0-6ubuntu1~16.04.4) ) #110-Ubuntu SMP Tue Jul 18 12:55:35 UTC 2017
```
##### ubuntu安装ping
```sh
sudo apt-get -y install iputils-ping
```
##### ubuntu安装brctl
```sh
sudo apt-get -y install bridge-utils
```
##### ubuntu安装netstat
```sh
sudo apt-get -y install net-tools
```
##### ubuntu安装telnet
```sh
apt-get update && apt-get -y install telnet
```
##### ubuntu创建新用户
```sh
# 切换为root用户，获取创建用户权限
sudo su
# 添加一个新用户
useradd -m songhuan
# 为该用户设置登录密码
passwd songhuan
# 为该用户指定命令解释程序
usermod -s /bin/bash songhuan
# 查看用户属性
cat /etc/passed
# 给用户增加sudo权限
chmod u+w /etc/sudoers
vim /etc/sudoers
# 增加以下命令
songhuan        ALL=(ALL:ALL) ALL
chmod u-w /etc/sudoers
```
##### 使用w命令查看登录用户正在使用的进程信息

##### 添加 ubunut 国内镜像源
```sh
# 备份
sudo cp /etc/apt/sources.list /etc/apt/sources.list_backup
# 修改
sudo sed -i "s/us.archive.ubuntu.com/mirrors.aliyun.com/g" /etc/apt/sources.list
```
##### ssh远程连接
```sh
sudo apt-get -y install openssh-server
```
##### 通过私钥生成公钥

ssh-keygen -y -f [private-key-path] > [output-path]

```sh
ssh-keygen -y -f id_rsa > id_rsa.pub
```
