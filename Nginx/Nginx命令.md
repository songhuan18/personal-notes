### Nginx使用命令
> nginx安装目录是在/etc/nginx 

#### nginx启动
```shell
/usr/sbin/nginx
```
#### nginx配置文件语法检查
```shell
nginx -t -c /etc/nginx/nginx.conf
```
#### nginx重启
```shell
nginx -s reload -c /etc/nginx/nginx.conf
#或
/usr/nginx/sbin/nginx -s reload
```
##### 重新加载配置文件
```sh
nginx -s reload -c /etc/nginx/nginx.conf
```
