### Nginx使用命令
####1. nginx启动
```shell
/usr/sbin/nginx
```
####2. nginx配置文件语法检查
```shell
nginx -t -c /etc/nginx/nginx.conf
```
####3. nginx重启
```shell
nginx -s reload -c /etc/nginx/nginx.conf
#或
/usr/nginx/sbin/nginx -s reload
```
