### Elasticsearch安装

##### 环境准备
- 系统环境：Ubuntu16.04 x86_64
- 内核
```
Distributor ID:	Ubuntu
Description:	Ubuntu 16.04.3 LTS
Release:	16.04
Codename:	xenial
```
- elasticsearch-6.6.0
- 必须要有Java环境

#### 下载和安装
```sh
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.6.0.tar.gz
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.6.0.tar.gz.sha512
shasum -a 512 -c elasticsearch-6.6.0.tar.gz.sha512
tar -zxvf elasticsearch-6.6.0.tar.gz
cd elasticsearch-6.6.0/
```

> 注意，在启动之前需要配置参数，否则可能无法启动

```sh
#设置内核参数
sudo vim /etc/sysctl.conf
添加如下内容:
fs.file-max=65536
vm.max_map_count=262144 #至少为262144
sysctl -p 刷新下配置，sysctl -a查看是否生效 
# 设置资源参数
sudo vim /etc/security/limits.conf
# 添加一下内容：
* soft nofile 65536
* hard nofile 131072
* soft nproc  2048
* hard nproc  4096
#修改用户最大线程数，至少为4096，针对ubuntu
sudo vim /etc/security/limits.d/90-nproc.conf #如果没有该文件则新增
#添加如下内容
*               soft    nproc           4096
*               hard    nproc           4096
```
> 如果是测试机，有可能会出现内存不够，建议将内存调小

```sh
vim jvm.options
# 改为以下配置
-Xms256m
-Xmx256m
```

##### 后台运行
```sh
./bin/elasticsearch -d
```
##### 停止elasticsearch
```sh
kill -15 pid
```
