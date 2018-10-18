##### centos7 设置静态ip
```sh
vim /etc/sysconfig/network-scripts/ifcfg-eth0

TYPE="Ethernet"
BOOTPROTO="static" #dhcp改为static 
DEFROUTE="yes"
PEERDNS="yes"
PEERROUTES="yes"
IPV4_FAILURE_FATAL="no"
IPV6INIT="yes"
IPV6_AUTOCONF="yes"
IPV6_DEFROUTE="yes"
IPV6_PEERDNS="yes"
IPV6_PEERROUTES="yes"
IPV6_FAILURE_FATAL="no"
NAME="eth0"
UUID="bb3a302d-dc46-461a-881e-d46cafd0eb71"
ONBOOT="yes" #开机启用本配置
IPADDR=192.168.7.106 #静态IP
GATEWAY=192.168.7.1 #默认网关
NETMASK=255.255.255.0 #子网掩码
DNS1=192.168.7.1 #DNS 配置
```
##### 重启网络服务
```sh
service network restart
```
##### 更改主机名
```sh
# To set host name to “R2-D2”, enter:
hostnamectl set-hostname R2-D2
# To set static host name to “server1.cyberciti.biz”, enter:
hostnamectl set-hostname server1.cyberciti.biz --static
# To set pretty host name to “Senator Padme Amidala’s Laptop”, enter:
hostnamectl set-hostname "Senator Padme Amidala's Laptop" --pretty
```
