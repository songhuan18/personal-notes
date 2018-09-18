> ubuntu版本：16.04
#### Ubuntu设置静态ip

- 查询网卡设备的名字

```shell
songhuan@ubuntu  ~  ifconfig
docker0   Link encap:以太网  硬件地址 02:42:6c:10:55:60
         inet 地址:172.17.0.1  广播:172.17.255.255  掩码:255.255.0.0
         UP BROADCAST MULTICAST  MTU:1500  跃点数:1
         接收数据包:0 错误:0 丢弃:0 过载:0 帧数:0
         发送数据包:0 错误:0 丢弃:0 过载:0 载波:0
         碰撞:0 发送队列长度:0
         接收字节:0 (0.0 B)  发送字节:0 (0.0 B)

enp0s5    Link encap:以太网  硬件地址 00:1c:42:38:03:e2
         inet 地址:10.211.55.7  广播:10.211.55.255  掩码:255.255.255.0
         inet6 地址: fdb2:2c26:f4e4:0:ace3:a3d9:ecbe:ee72/64 Scope:Global
         inet6 地址: fe80::f4fd:5ca3:81ae:a8d6/64 Scope:Link
         inet6 地址: fdb2:2c26:f4e4:0:38f8:d749:bb51:4f9a/64 Scope:Global
         UP BROADCAST RUNNING MULTICAST  MTU:1500  跃点数:1
         接收数据包:10206 错误:0 丢弃:0 过载:0 帧数:0
         发送数据包:5790 错误:0 丢弃:0 过载:0 载波:0
         碰撞:0 发送队列长度:1000
         接收字节:10182180 (10.1 MB)  发送字节:541353 (541.3 KB)

lo        Link encap:本地环回
         inet 地址:127.0.0.1  掩码:255.0.0.0
         inet6 地址: ::1/128 Scope:Host
         UP LOOPBACK RUNNING  MTU:65536  跃点数:1
         接收数据包:771 错误:0 丢弃:0 过载:0 帧数:0
         发送数据包:771 错误:0 丢弃:0 过载:0 载波:0
         碰撞:0 发送队列长度:1000
         接收字节:61624 (61.6 KB)  发送字节:61624 (61.6 KB)
```

网卡设备的名字为：enp0s5

- 修改配置文件

```shell
sudo vim /etc/network/interfaces.d/enp0s5

auto enp0s5 #使用之前查询的网卡设备名
iface enp0s5 inet static #enp0s5这个接口使用静态ip
address 192.168.10.221 #ip地址
netmask 255.255.255.0 #子网掩码
gateway 192.168.10.1 #网关
dns-nameservers 192.168.10.1 223.5.5.5 #dns服务地址
```

- 刷新ip

```
systemctl restart networking.service #networking.service 需存在
或者
sudo /etc/init.d/networking restart
```
