##### 环境准备
- 系统环境：Ubuntu16.04 x86_64
- 内核
```
Distributor ID:	Ubuntu
Description:	Ubuntu 16.04.3 LTS
Release:	16.04
Codename:	xenial
```

##### 添加nginx签名
```sh
vim nginx_signing.key
# 添加一下内容
-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v2.0.22 (GNU/Linux)
mQENBE5OMmIBCAD+FPYKGriGGf7NqwKfWC83cBV01gabgVWQmZbMcFzeW+hMsgxH
W6iimD0RsfZ9oEbfJCPG0CRSZ7ppq5pKamYs2+EJ8Q2ysOFHHwpGrA2C8zyNAs4I
QxnZZIbETgcSwFtDun0XiqPwPZgyuXVm9PAbLZRbfBzm8wR/3SWygqZBBLdQk5TE
fDR+Eny/M1RVR4xClECONF9UBB2ejFdI1LD45APbP2hsN/piFByU1t7yK2gpFyRt
97WzGHn9MV5/TL7AmRPM4pcr3JacmtCnxXeCZ8nLqedoSuHFuhwyDnlAbu8I16O5
XRrfzhrHRJFM1JnIiGmzZi6zBvH0ItfyX6ttABEBAAG0KW5naW54IHNpZ25pbmcg
a2V5IDxzaWduaW5nLWtleUBuZ2lueC5jb20+iQE+BBMBAgAoAhsDBgsJCAcDAgYV
CAIJCgsEFgIDAQIeAQIXgAUCV2K1+AUJGB4fQQAKCRCr9b2Ce9m/YloaB/9XGrol
kocm7l/tsVjaBQCteXKuwsm4XhCuAQ6YAwA1L1UheGOG/aa2xJvrXE8X32tgcTjr
KoYoXWcdxaFjlXGTt6jV85qRguUzvMOxxSEM2Dn115etN9piPl0Zz+4rkx8+2vJG
F+eMlruPXg/zd88NvyLq5gGHEsFRBMVufYmHtNfcp4okC1klWiRIRSdp4QY1wdrN
1O+/oCTl8Bzy6hcHjLIq3aoumcLxMjtBoclc/5OTioLDwSDfVx7rWyfRhcBzVbwD
oe/PD08AoAA6fxXvWjSxy+dGhEaXoTHjkCbz/l6NxrK3JFyauDgU4K4MytsZ1HDi
MgMW8hZXxszoICTTiQEcBBABAgAGBQJOTkelAAoJEKZP1bF62zmo79oH/1XDb29S
YtWp+MTJTPFEwlWRiyRuDXy3wBd/BpwBRIWfWzMs1gnCjNjk0EVBVGa2grvy9Jtx
JKMd6l/PWXVucSt+U/+GO8rBkw14SdhqxaS2l14v6gyMeUrSbY3XfToGfwHC4sa/
Thn8X4jFaQ2XN5dAIzJGU1s5JA0tjEzUwCnmrKmyMlXZaoQVrmORGjCuH0I0aAFk
RS0UtnB9HPpxhGVbs24xXZQnZDNbUQeulFxS4uP3OLDBAeCHl+v4t/uotIad8v6J
SO93vc1evIje6lguE81HHmJn9noxPItvOvSMb2yPsE8mH4cJHRTFNSEhPW6ghmlf
Wa9ZwiVX5igxcvaIRgQQEQIABgUCTk5b0gAKCRDs8OkLLBcgg1G+AKCnacLb/+W6
cflirUIExgZdUJqoogCeNPVwXiHEIVqithAM1pdY/gcaQZmIRgQQEQIABgUCTk5f
YQAKCRCpN2E5pSTFPnNWAJ9gUozyiS+9jf2rJvqmJSeWuCgVRwCcCUFhXRCpQO2Y
Va3l3WuB+rgKjsQ=
=EWWI
-----END PGP PUBLIC KEY BLOCK-----
```
最后执行以下命令：
```sh
sudo apt-key add nginx_signing.key
```
##### 添加nginx源
```sh
sudo vim /etc/apt/sources.list
# 添加一下内容
deb http://nginx.org/packages/ubuntu/ xenial nginx
deb-src http://nginx.org/packages/ubuntu/ xenial nginx
```
##### Nginx安装
```sh
sudo apt-get update
# 安装指定版本
sudo apt-get -y install nginx=1.12.2-1~xenial
```
##### 查看Nginx版本
```sh
# 只显示版本
nginx -v
# 显示nginx的版本，编译器版本和配置参数
nginx -V
```

##### Nginx安装目录详解

路径 | 类型 | 作用
--- | --- | ---
/etc/logrotate.d/nginx | 配置文件 | Nginx日志轮转，用于logrotate服务的日志切割
/etc/nginx<br>/etc/nginx/nginx.conf<br>/ect/nginx/conf.d<br>/etc/nginx/conf.d/default.conf | 目录、配置文件 | Nginx主配置文件
/etc/nginx/fastcgi_params<br>/etc/nginx/uwsgi_params<br>/etc/nginx/scgi_params | 配置文件 | cgi配置相关，fastcgi配置
/etc/nginx/koi-utf<br>/etc/nginx/koi-win<br>/etc/nginx/win-utf | 配置文件 | 编码转换映射转化文件
/etc/nginx/mime.types | 配置文件 | 设置http协议的Content-Type与扩展名对应关系
/lib/systemd/system/nginx-debug.service<br>/lib/systemd/system/nginx.service<br>/etc/init.d/nginx<br>/etc/init.d/nginx-debug | 配置文件 | 用于配置系统守护进程管理器管理方式
/usr/sbin/nginx<br>/usr/sbin/nginx-debug | 命令 | Nginx服务的启动管理的终端命令
/var/cache/nginx | 目录 | Nginx的缓存目录
/var/log/nginx | 目录 | Nginx的日志目录

##### Nginx配置文件详解
```sh
vim /etc/nginx/nginx.conf
```
##### 启动Nginx
```sh
service nginx start
# 或者
sudo /etc/init.d/nginx start
```
##### 停止Nginx
```sh
service stop nginx
```
##### 对Nginx配置文件检查
```sh
nginx -t -c /etc/nginx/nginx.conf
# 参数说明
-t 对配置文件的检查
-c 对配置路径的检查
```
##### 重新加载配置文件
```sh
nginx -s reload -c /etc/nginx/nginx.conf
```
