#### CentOS7：ifconfig command not found解决
- 首先判断是否缺少了ifconfig，它是在/usr/sbin/目录下
- 查看一下是否有ifconfig，执行命令
```shell
ls -l | grep ifconfig
```
- 安装ifconfig，执行命令
```shell
yum install net-tools
```
