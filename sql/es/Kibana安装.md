### Kibana安装

##### 环境准备
- 系统环境：Ubuntu16.04 x86_64
- 内核
```
Distributor ID:	Ubuntu
Description:	Ubuntu 16.04.3 LTS
Release:	16.04
Codename:	xenial
```
- kibana-6.6.0

##### 下载和安装
```sh
wget https://artifacts.elastic.co/downloads/kibana/kibana-6.6.0-linux-x86_64.tar.gz
wget https://artifacts.elastic.co/downloads/kibana/kibana-6.6.0-linux-x86_64.tar.gz.sha512
shasum -a 512 -c kibana-6.6.0-linux-x86_64.tar.gz.sha512
tar -zxvf kibana-6.6.0-linux-x86_64.tar.gz
cd kibana-6.6.0-linux-x86_64/
```
##### 配置kibana
```sh
vim kibana.yml
#添加如下配置
server.port: 5601
server.host: "0.0.0.0"
elasticsearch.hosts: ["http://10.211.55.11:9200"]
```
##### 后台启动
```sh
nohup ./bin/kibana &
```
