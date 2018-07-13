### 常用的一些Linux(CentOS7)命令，方便以后查阅
#####1. 查看是否有iptables规则
```shell
iptables -L
```
#####2. 关闭iptables规则
```shell
iptables -F
```
#####3. 查看iptables nat 是否有规则
```shell
iptables -t nat -L
```
#####4. 关闭iptables nat 规则
```shell
iptables -t nat -F
```
#####5. 查看SELinux是否关闭
```shell
getenforce
```
#####6. 关闭SELinux
```shell
setenforce 0
```
#####7. 升级所有包，不改变软件设置和系统设置，系统版本升级，内核不改变.
```shell
yum -y upgrade
```
#####8. 重启命令
```shell
1. reboot
2. shutdown -r now 立刻重启(root用户使用)
3. shutdown -r 10 过10分钟自动重启(root用户使用)
4. shutdown -r 20:35 在时间为20:35时候重启(root用户使用)
```
#####9. 关机命令
```shell
1. halt 立刻关机
2. poweroff 立刻关机
3. shutdown -h now 立刻关机(root用户使用)
4. shutdown -h 10 10分钟后自动关机
```
#####10. 列出所有已安装的软件
```shell
yum list installed
```
#####11. 查看开放端口
```shell
firewall-cmd --zone=public --list-ports
```
#####12. 开放一个端口
```shell
firewall-cmd --zone=public --add-port=80/tcp --permanent （--permanent永久生效，没有此参数重启后失效）
```
#####13. 关闭一个端口
```shell
firewall-cmd --zone=public --remove-port=80/tcp --permanent
```
#####14. 开启或关闭一个端口之后需重新载入
```shell
firewall-cmd --reload
```
#####15. 查看正在执行的进程
```shell
ps -ef
ps -aux
```
#####16. 快速清空文件内容
```shell
echo "" > test.txt（文件大小被截为1字节）
> test.txt（文件大小被截为0字节）
cat /dev/null > test.txt（文件大小被截为0字节）
```
