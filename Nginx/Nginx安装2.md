##### 环境准备
- 系统环境：Ubuntu16.04 x86_64
- 内核
```
Distributor ID:	Ubuntu
Description:	Ubuntu 16.04.3 LTS
Release:	16.04
Codename:	xenial
```
#### 下载nginx
```sh
wget http://nginx.org/download/nginx-1.14.2.tar.gz
```
#### 解压
```sh
tar -zxvf nginx-1.14.2.tar.gz
```
> ubuntu上安装nginx需依赖PCRE库、zlib库、OpenSSL库

#### 安装依赖库
```sh
sudo apt-get -y install libpcre3 libpcre3-dev zlib1g-dev openssl libssl-dev
```
#### 编译nginx
进入到nginx目录
```sh
./configure --prefix=安装目录
#编译
make
#安装
make install
```
