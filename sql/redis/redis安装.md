### redis安装

##### 环境准备
- 系统环境：Ubuntu16.04 x86_64
- 内核
```
Distributor ID:	Ubuntu
Description:	Ubuntu 16.04.3 LTS
Release:	16.04
Codename:	xenial
```
- redis-3.0.4

##### 下载
```sh
sudo wget http://download.redis.io/releases/redis-3.0.4.tar.gz
```
##### 解压
```sh
sudo tar -zxvf redis-3.0.4.tar.gz -C ../setups/
```
##### 安装
```sh
# 准备
sudo apt-get update
sudo apt-get gcc g++ make cmake
# 开始安装
cd redis-3.0.4/
sudo make && make install
```
##### redis.conf修改
```sh
sudo vim redis.conf
将daemonize no 改为：daemonize yes
```
##### redis基本操作
```sh
songhuan@hadoop11:/opt/setups/redis-3.0.4$ redis-server redis.conf # 启动redis
songhuan@hadoop11:/opt/setups/redis-3.0.4$ redis-cli -p 6379 # 客户端连接
127.0.0.1:6379> ping
PONG
127.0.0.1:6379>
```
##### redis关闭
```sh
# 通过以下命令关闭报错
redis-cli -p 6379 shutdown
# 错误信息：(error) ERR Errors trying to SHUTDOWN. Check logs.
# 最后通过kill关闭
kill -9 11698(pid)
```
