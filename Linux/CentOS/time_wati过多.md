/etc/sysctl.conf 里面加4句

net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_tw_reuse = 1 #表示开启重用。允许将TIME-WAIT sockets重新用于新的TCP连接，默认为0，表示关闭
net.ipv4.tcp_tw_recycle = 1 #表示开启TCP连接中TIME-WAIT sockets的快速回收，默认为0，表示关闭。
net.ipv4.tcp_fin_timeout = 30 #修改系統默认的 TIMEOUT 时间

> 警告：对于服务端来说，在NAT环境中，开启net.ipv4.tcp_tw_recycle = 1配置可能导致校验时间戳递增，从而影响业务，不建议开启该功能。关于这四个内核参数的更多介绍，请参考以下内容：
net.ipv4.tcp_syncookies=1：开启SYN的cookies，当出现SYN等待队列溢出时，启用cookies进行处理。
net.ipv4.tcp_tw_reuse=1：允许将TIME-WAIT的socket重新用于新的TCP连接。如果新请求的时间戳，比存储的时间戳更大，则系统将会从TIME_WAIT状态的存活连接中选取一个，重新分配给新的请求连接。
net.ipv4.tcp_tw_recycle=1：开启TCP连接中TIME-WAIT的sockets快速回收功能。需要注意的是，该机制也依赖时间戳选项，系统默认开启tcp_timestamps机制，而当系统中的tcp_timestamps和tcp_tw_recycle机制同时开启时，会激活TCP的一种行为，即缓存每个连接最新的时间戳，若后续的请求中时间戳小于缓存的时间戳时，该请求会被视为无效，导致数据包会被丢弃。特别是作为负载均衡服务器的场景，不同客户端请求经过负载均衡服务器的转发，可能被认为是同一个连接，若客户端的时间不一致，对于后端服务器来说，会发生时间戳错乱的情况，因此会导致数据包丢失，从而影响业务。
net.ipv4.tcp_fin_timeout=30：如果socket由服务端要求关闭，则该参数决定了保持在FIN-WAIT-2状态的时间。

然后执行 /sbin/sysctl -p 让参数生效


netstat -n | awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}'

##### 查看当前TIME_WAIT数
```
netstat -ano | grep TIME_WAIT | wc -l
```

查看Linux系统最大追踪TCP连接数量
```
sysctl -a | grep ipv4.ip_conntrack_max
```
统计TCP连接数
```
netstat -anp |grep tcp |wc -l
```
统计CLOSE_WAIT状态的TCP连接
```
netstat -atn|grep CLOSE_WAIT|wc -l
```
查看TIME_WAIT状态的连接数量
```
netstat -n | awk '/^tcp/ {++y[$NF]} END {for(w in y) print w, y[w]}'
```

#### 无法在本地网络环境通过SSH连接Linux实例。

执行以下命令，修改配置文件。
```
vi /etc/sysctl.conf
```
添加如下内容
```
net.ipv4.tcp_tw_recycle=0
net.ipv4.tcp_timestamps=0
```
