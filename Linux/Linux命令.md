##### 接收键盘输入
read [选项] [变量名]

选项：
- -p "提示信息" ：在等待read输入时，输出提示信息
- -t 秒数：read命令会一直等待用户输入，使用此选项可以指定等待的时间
- -n 字符数：read命令只接收指定的字符数，并马上会执行(不用按Enter)
- -s ：隐藏输入的数据，使用于机密信息的输入

#### 网卡下线
```shell
ifdown eth0(网卡名)
```

#### 网卡上线
```shell
ifup eth0(网卡名)
```
#### 查询网络状态
netstat [选项]

选项：
- -t 列出TCP协议端口
- -u 列出UDP协议端口
- -n 不使用域名与服务名，而使用IP地址和端口号
- -l 仅列出在监听状态的网络服务
- -a 列出所有的网络连接

#### 重启防火墙
```shell
firewall-cmd --reload #重启firewall
systemctl stop firewalld.service #停止firewall
systemctl disable firewalld.service #禁止firewall开机启动
```
#### Linux查看文件大小
```sh
stat 文件名
du -b 文件名 -b表示以字节计数
du -h 文件名 直接得出文件大小,单位：M
```
#### sed行定位使用
```sh
#只打印第二行，不打印其他的行
sed -n '2'p file
#打印从第一行到第四行的记录
sed -n '1,4'p file
#打印匹配logs的行
sed -n 'logs'p file
#打印从第四行匹配logs之间的所有行
sed -n '4,/logs/'p file
#把第一行和第二行全部删除
sed '1,2'd file
```
#### CentOS 安装telnet命令
```sh
yum -y install telnet telnet-server
```
#### basename基本语法
```sh
# 功能描述：basename命令会删除掉以'/'结尾之前的字符，保留'/'之后的字符
songhuan@ubuntu-1604-7  ~  basename /home/songhuan/java/code/service_registry/start.sh
start.sh
songhuan@ubuntu-1604-7  ~  basename /home/songhuan/java/code/service_registry/start.sh .sh
start
```
#### dirname基本语法
```sh
# dirname 文件绝对路径
# 功能描述：从给定的包含绝对路径的文件名中取出文件名，然后返回剩下的路径
songhuan@ubuntu-1604-7  ~  dirname /home/songhuan/java/code/service_registry/start.sh
/home/songhuan/java/code/service_registry

```
