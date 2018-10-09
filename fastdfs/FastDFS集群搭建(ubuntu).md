#### 环境准备
- 系统环境：Ubuntu16.04
- 内核：Linux ubuntu-1604-220 4.4.0-87-generic #110-Ubuntu SMP Tue Jul 18 12:55:35 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux
- 内存：1G
- 6台服务器
- 安装包：
  ```
  # 以下所有安装包建议都放在/usr/local/src目录下，方便管理，以下安装均为源码安装
  FastDFS
  libfastcommon
  nginx
  fastdfs-nginx-module
  ```
  #### 按照以下网络开始部署
  ![image](http://wx2.sinaimg.cn/mw690/e922c07bgy1ft88jc31lvj20x60v0tb4.jpg)
  #### 开始安装
- 在安装之前先确定依赖库和工具都已安装
```shell
// 编译环境
sudo apt update
sudo apt -y install git gcc g++ make automake autoconf libtool
sudo apt -y install libpcre3 libpcre3-dev
sudo apt -y install openssl libssl-dev
sudo apt -y install zlib1g zlib1g.dev
```
> 注意：在安装FastDFS之前必须先安装libfastcommon类库，否则会导致安装出错

- 安装libfastcommon类库
```shell
// 切换到安装目录准备下载安装
cd /usr/local/src (可选)
sudo git clone https://github.com/happyfish100/libfastcommon.git --depth 1
cd libfastcommon/
sudo ./make.sh
sudo ./make.sh install
```  
#### 安装FastDFS tracker(192.168.10.220/221，安装多个tracker server方式一样)
> 源码安装
- 创建跟踪服务器数据目录
```shell
mkdir -p /fastdfs/tracker
```
> 注意：也是在/usr/local/src目录下

- 安装tracker
```shell
sudo git clone https://github.com/happyfish100/fastdfs.git --depth 1
cd fastdfs/
sudo ./make.sh
sudo ./make.sh install
#配置文件准备
sudo cp /etc/fdfs/tracker.conf.sample /etc/fdfs/tracker.conf
```
- tracker.conf配置
```shell
sudo vim /etc/fdfs/tracker.conf
#需要修改的内容如下
port=22122  # tracker服务器端口（默认22122,一般不修改）
base_path=/fastdfs/tracker  # 存储日志和数据的根目录（最开始已创建）
```

- 启动tracker服务
```shell
#启动tracker服务
sudo /usr/bin/fdfs_trackerd /etc/fdfs/tracker.conf
#设置开机自启动
sudo apt -y install sysv-rc-conf
sudo sysv-rc-conf fdfs_trackerd on #开机自动启动tracker服务
```
- 确认tracker是否启动成功（查看端口22122是否开始监听）
```shell
sudo netstat -unltp | grep fdfs
```
如果启动成功，如下：

![image](http://wx3.sinaimg.cn/mw690/e922c07bgy1ftcmh9vnwxj21b603wq3m.jpg)

#### 安装FastDFS storage(192.168.10.222/223/224/225)


- 创建存储服务器数据目录
```shell
sudo mkdir -p /fastdfs/storage
```
>注意：也是在/usr/local/src目录下

- 编译环境
```shell
sudo apt update
sudo apt -y install git gcc g++ make automake autoconf libtool
sudo apt -y install libpcre3 libpcre3-dev
sudo apt -y install openssl libssl-dev
sudo apt -y install zlib1g zlib1g.dev
```
> 同安装tracker一样，也得先安装libfastcommon类库

- 安装storage(源码安装)
```shell
sudo git clone https://github.com/happyfish100/fastdfs.git --depth 1
cd fastdfs/
sudo ./make.sh
sudo ./make.sh install
#配置文件准备
sudo cp /etc/fdfs/storage.conf.sample /etc/fdfs/storage.conf
```

- storage配置
```shell
sudo vim /etc/fdfs/storage.conf
#需要修改的内容如下
port=23000  # storage服务端口（默认23000,一般不修改）
group_name=group1                   # 组名（第一组为group1，第二组为group2，依次类推...）
base_path=/fastdfs/storage  # 数据和日志文件存储根目录(目录最开始已创建)
store_path0=/fastdfs/storage           #第一个存储目录，第二个存储目录起名为：store_path1=xxx，其它存储目录名依次类推...
store_path_count=1                  # 存储路径个数，需要和store_path个数匹配
tracker_server=192.168.0.xxx:22122  # tracker服务器IP和端口
##tracker_server=192.168.0.yyy:22122 #(多台tracker_server)
http.server_port=8888  # http访问文件的端口(默认8888,看情况修改,和nginx中保持一致)
```

- 启动storage
```shell
#启动storage服务
sudo /usr/bin/fdfs_storaged /etc/fdfs/storage.conf
#设置开机自启动
sudo apt -y install sysv-rc-conf
sudo sysv-rc-conf fdfs_storaged on
```

- 确认storage是否启动成功（查看端口23000是否开始监听）
```shell
sudo netstat -unltp | grep fdfs
```

如果启动成功，如下：

![image](http://wx3.sinaimg.cn/mw690/e922c07bgy1ftcoka2v6cj21cg040js9.jpg)

确认启动成功之后，运行fdfs_monitor查看storage服务器是否已经登记到tracker服务器

> 可以在任一存储节点上使用如下命令查看集群的状态信息

```shell
sudo /usr/bin/fdfs_monitor /etc/fdfs/storage.conf
```

如果出现ip_addr = Active, 则表明storage服务器已经登记到tracker服务器，如下：
```
group count: 1

Group 1:
group name = group1
disk total space = 9949 MB
disk free space = 7538 MB
trunk free space = 0 MB
storage server count = 1
active server count = 1
storage server port = 23000
storage HTTP port = 8888
store path count = 1
subdir count per path = 256
current write server index = 0
current trunk file id = 0

	Storage 1:
		id = 192.168.10.222
		ip_addr = 192.168.10.222  ACTIVE
		http domain =
		version = 5.12
		join time = 2018-07-17 11:02:50
		up time = 2018-07-17 11:20:26
		total storage = 9949 MB
		free storage = 7538 MB
		upload priority = 10
		store_path_count = 1
```
#### 在storage上安装Nginx模块
在storage上安装nginx主要是为了提供http的访问服务，同事解决group中storage服务器的同步延迟问题。
> 注意：fastdfs-nginx-module模块只需要安装到storage上。

- 安装fastdfs-nginx-module

```shell
sudo git clone https://github.com/happyfish100/fastdfs-nginx-module.git --depth 1
sudo cp /usr/local/src/fastdfs-nginx-module/src/mod_fastdfs.conf /etc/fdfs
```

- 安装nginx

```shell
sudo wget http://nginx.org/download/nginx-1.12.2.tar.gz
sudo tar -zxvf nginx-1.12.2.tar.gz
cd nginx-1.12.2/
## 添加fastdfs-nginx-module模块
sudo ./configure --add-module=/usr/local/src/fastdfs-nginx-module/src/
```
configure 成功输出结果：
```
Configuration summary
  + using system PCRE library
  + OpenSSL library is not used
  + using system zlib library

  nginx path prefix: "/usr/local/nginx"
  nginx binary file: "/usr/local/nginx/sbin/nginx"
  nginx modules path: "/usr/local/nginx/modules"
  nginx configuration prefix: "/usr/local/nginx/conf"
  nginx configuration file: "/usr/local/nginx/conf/nginx.conf"
  nginx pid file: "/usr/local/nginx/logs/nginx.pid"
  nginx error log file: "/usr/local/nginx/logs/error.log"
  nginx http access log file: "/usr/local/nginx/logs/access.log"
  nginx http client request body temporary files: "client_body_temp"
  nginx http proxy temporary files: "proxy_temp"
  nginx http fastcgi temporary files: "fastcgi_temp"
  nginx http uwsgi temporary files: "uwsgi_temp"
  nginx http scgi temporary files: "scgi_temp"

 # 打印信息未贴完
```
- 接下来执行make和make install

```shell
sudo make
sudo make install
```
- 配置fastdfs-nginx-module

```shell
sudo vim /etc/fdfs/mod_fastdfs.conf
## 需修改的内容如下
base_path=/fastdfs/storage  #保存日志的目录
tracker_server=192.168.10.xxx:22122
## tracker_server=192.168.10.yyy:22122
group_name=group1 #当前服务器的group名
url_have_group_name = true # 文件url中是否有group名
store_path_count=1 #存储路径个数，需要和store_path个数匹配
store_path0=/fastdfs/storage #存储路径
group_count=2 #设置组的个数（两个组group1，group2）
```
- 在末尾增加两个组的信息（mod_fastdfs.conf）

```
[group1]
group_name=group1
storage_server_port=23000
store_path_count=1
store_path0=/fastdfs/storage

[group2]
group_name=group2
storage_server_port=23000
store_path_count=1
store_path0=/fastdfs/storage
```

- 建立M00至存储目录的符号连接

```shell
sudo ln -s /fastdfs/storage/data /fastdfs/storage/data/M00
ll /fastdfs/storage/data/M00
```
输出如下信息：

![image](http://wx2.sinaimg.cn/mw690/e922c07bgy1fss37hxw17j217404iwfo.jpg)

- 配置nginx.config

```shell
sudo vim /usr/local/nginx/conf/nginx.conf
#添加如下配置
server {
    listen       8888;    ## 该端口为storage.conf中的http.server_port相同
    server_name  localhost;
    location ~/group[1-2]/M00 {
        root /fastdfs/storage/data;
        ngx_fastdfs_module;
    }
    error_page   500 502
    503 504  /50x.html;
    location = /50x.html {
    root   html;
    }
}
```
复制fastdfs中的http.conf、mime.types文件到/etc/fdfs

```shell
sudo cp /usr/local/src/fastdfs/conf/http.conf /usr/local/src/fastdfs/conf/mime.types /etc/fdfs/
```
- 运行nginx

启动nginx，确认启动是否成功。（查看是否对应端口8888是否开始监听)

```shell
ubuntu@ubuntu-1604-222:sudo /usr/local/nginx/sbin/nginx
ngx_http_fastdfs_set pid=9219
ubuntu@ubuntu-1604-222:sudo netstat -unltp | grep nginx
tcp        0      0 0.0.0.0:8888            0.0.0.0:*               LISTEN      9220/nginx: master
```
也可查看nginx的日志是否启动成功或是否有错误。

```shell
cat /usr/local/nginx/logs/error.log
```
> 在error.log中没有错误，既启动成功。可以打开浏览器，能直接访问到nginx首页

- 将nginx设为开机启动

```shell
sudo vim /lib/systemd/system/nginx.service
#服务描述性配置
[Unit]
cription=nginx
After=network.target
#服务相关配置
[Service]
Type=forking
#启动
ExecStart=/usr/local/nginx/sbin/nginx
#重启
ExecReload=/usr/local/nginx/sbin/nginx -s reload
#停止
ExecStop=/usr/local/nginx/sbin/nginx -s quit
PrivateTmp=true

[Install]
WantedBy=multi-user.target
```
设置开机启动

```shell
systemctl enable nginx.service
```
#### 在tracker上安装nginx

在tracker上安装nginx主要是为了提供http访问的反响代理、负载均衡以及缓存服务

- 安装nginx

```shell
sudo wget http://nginx.org/download/nginx-1.12.2.tar.gz
sudo tar -zxvf nginx-1.12.2.tar.gz
cd nginx-1.12.2/
sudo ./configure --prefix=/usr/local/nginx
```
configure 成功输出结果：

```
Configuration summary
  + using system PCRE library
  + OpenSSL library is not used
  + using system zlib library

  nginx path prefix: "/usr/local/nginx"
  nginx binary file: "/usr/local/nginx/sbin/nginx"
  nginx modules path: "/usr/local/nginx/modules"
  nginx configuration prefix: "/usr/local/nginx/conf"
  nginx configuration file: "/usr/local/nginx/conf/nginx.conf"
  nginx pid file: "/usr/local/nginx/logs/nginx.pid"
  nginx error log file: "/usr/local/nginx/logs/error.log"
  nginx http access log file: "/usr/local/nginx/logs/access.log"
  nginx http client request body temporary files: "client_body_temp"
  nginx http proxy temporary files: "proxy_temp"
  nginx http fastcgi temporary files: "fastcgi_temp"
  nginx http uwsgi temporary files: "uwsgi_temp"
  nginx http scgi temporary files: "scgi_temp"

 # 打印信息未贴完
```
- 接下来执行make和make install
```shell
sudo make
sudo make install
```

- 配置nginx.conf

```shell
sudo vim /usr/local/nginx/conf/nginx.conf
# nginx.conf配置信息
worker_processes  4;                  #根据CPU核心数而定
events {
    worker_connections  65535;        #最大链接数
    use epoll;                        #新版本的Linux可使用epoll加快处理性能
}
http {
    #设置group1的服务器
    upstream fdfs_group1 {
        server 192.168.10.222:8888 weight=1 max_fails=2 fail_timeout=30s;
        server 192.168.10.223:8888 weight=1 max_fails=2 fail_timeout=30s;
    }
    #设置group2的服务器
    upstream fdfs_group2 {
        server 192.168.10.224:8888 weight=1 max_fails=2 fail_timeout=30s;
        server 192.168.10.225:8888 weight=1 max_fails=2 fail_timeout=30s;
    }

   server {
        #设置服务器端口
        listen       8888;
        #设置group1的负载均衡参数
        location /group1/M00 {
            proxy_pass http://fdfs_group1;
        }
        #设置group2的负载均衡参数
        location /group2/M00 {
            proxy_pass http://fdfs_group2;
        }
      }

    }
```
- 运行nginx

启动nginx，确认启动是否成功。（查看是否对应端口8888是否开始监听)
```shell
sudo /usr/local/nginx/sbin/nginx
```
```shell
ubuntu@ubuntu-1604-220:/usr/local/src/nginx-1.12.2$ sudo netstat -unltp | grep nginx
tcp        0      0 0.0.0.0:8888            0.0.0.0:*               LISTEN      4136/nginx
```

> 可以打开浏览器，能直接访问到nginx首页

- 将nginx设为开机启动

```shell
sudo vim /lib/systemd/system/nginx.service
#服务描述性配置
[Unit]
cription=nginx
After=network.target
#服务相关配置
[Service]
Type=forking
#启动
ExecStart=/usr/local/nginx/sbin/nginx
#重启
ExecReload=/usr/local/nginx/sbin/nginx -s reload
#停止
ExecStop=/usr/local/nginx/sbin/nginx -s quit
PrivateTmp=true

[Install]
WantedBy=multi-user.target
```
设置开机启动

```shell
systemctl enable nginx.service
```
尝试上传一个文件到FastDFS，然后访问试试。先配置client.conf文件。

```shell
cp /etc/fdfs/client.conf.sample  client.conf
vim /etc/fdfs/client.conf
```
修改以下参数：

```
base_path=/fastdfs/tracker  #日志存放路径
tracker_server=192.168.10.220:22122        
http.tracker_server_port=8888
```
开始测试：
```
#保存后测试,返回ID表示成功
ubuntu@ubuntu-1604-220:~$ fdfs_upload_file /etc/fdfs/client.conf /home/ubuntu/test.txt
group2/M00/00/00/wKgK4FtNuRyAI6FZAAAADBGgifM210.txt
```

参考：http://www.ityouknow.com/fastdfs/2017/10/10/cluster-building-fastdfs.html

#### 集群搭建遇到的一些问题（CentOS7 上遇到的一些问题）

- ip_addr 状态不对
> 我在查看storage服务器是否已经登记到tracker服务器时，发现有一台服务器出现ip_addr = 192.168.10.3 WAIT_SYNC

在tracker服务器上从集群中删除storage
```shell
cp /etc/fdfs/client.conf.sample /etc/fdfs/client.conf
## client.conf配置
vim /etc/fdfs/client.conf
base_path=/fastdfs/tracker
tracker_server=192.168.10.1:22122
```
执行以下命令将storage从集群中删除
```shell
## 从集群中删除节点
/usr/bin/fdfs_monitor /etc/fdfs/client.conf delete group1 192.168.10.3
## 在192.168.10.3storage服务器上删除数据文件
rm -rf /fastdfs/storage/data
## 重启节点
/usr/bin/fdfs_storaged /etc/fdfs/storage.conf restart
```

- 测试图片无法访问

搭建完成之后，访问http://192.168.10.224:8888/group2/M00/00/00/wKgK31s12yOAK5ZaAADbGksvdEM146.png，地址图片总是报404无法找到，跟踪到storage服务器，查看nginx的error日志发现如下；

```
cat /usr/local/nginx/logs/error.log

[2018-06-29 15:07:32] ERROR - file: /usr/local/src/fastdfs-nginx-module/src//common.c, line: 1093, file: /fastdfs/store/data/00/00/wKgK3ls12JGABDdPAADbGksvdEM700.png not exist
```
问题1：/fastdfs/store/data地址写错，应该是/fastdfs/storage/data
问题2：nginx启动的时候默认会以nobody用户来启动，这样的话就权限访问/root/fastdfs/data的权限。
修改方案：
```
vim /usr/local/nginx/conf/nginx.conf
# 修改nobody为root
user root
```
重启nginx即可：

```shell
/usr/local/nginx/sbin/nginx -s reload
```
- storage的状态始终是WAIT_SYNC

按照第一个问题步骤，将storage存储服务器中将自身节点删除，并重新加入，但是还是无法解决问题。

查看另外一台storage存储服务器(192.168.10.2)的日志，发现报错：ERROR - file: storage_sync.c, line: 2745, connect to storage server 192.168.10.2:23000 fail, errno: 113, error info: No route to host。两台服务器无法实现通信。

最后解决办法：关闭了192.168.10.3这台服务器上的防火墙

疑问：23000端口我已经开启了，但是为什么还是无法访问。问题是解决了但是未找到原因。我认为这应该不是fastdfs的问题，可能是Linux自身问题。
