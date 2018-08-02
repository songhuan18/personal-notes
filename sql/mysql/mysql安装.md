> CentOs7 安装mysql

##### 下载地址
- server
```
wget https://downloads.mysql.com/archives/get/file/MySQL-server-5.5.48-1.linux2.6.x86_64.rpm
```
- client
```
wget https://downloads.mysql.com/archives/get/file/MySQL-client-5.5.48-1.linux2.6.x86_64.rpm
```

##### 检查当前系统是否安装了mysql

```shell
rpm -qa | grep -i MySQL
```
##### 安装mysql服务端
> 注意提示

```shell
rpm -ivh https://downloads.mysql.com/archives/get/file/MySQL-client-5.5.48-1.linux2.6.x86_64.rpm
# -ivh 其中i代表install，v代表日志，h是hash，代表进度条
```
提示信息：
```
警告：MySQL-server-5.5.48-1.linux2.6.x86_64.rpm: 头V3 DSA/SHA1 Signature, 密钥 ID 5072e1f5: NOKEY
准备中...                          ################################# [100%]
正在升级/安装...
   1:MySQL-server-5.5.48-1.linux2.6   ################################# [100%]
180731 13:56:27 [Note] /usr/sbin/mysqld (mysqld 5.5.48) starting as process 2052 ...
180731 13:56:27 [Note] /usr/sbin/mysqld (mysqld 5.5.48) starting as process 2059 ...

PLEASE REMEMBER TO SET A PASSWORD FOR THE MySQL root USER !
To do so, start the server, then issue the following commands:

/usr/bin/mysqladmin -u root password 'new-password'
/usr/bin/mysqladmin -u root -h localhost.localdomain password 'new-password'

Alternatively you can run:
/usr/bin/mysql_secure_installation

which will also give you the option of removing the test
databases and anonymous user created by default.  This is
strongly recommended for production servers.

See the manual for more instructions.

Please report any problems at http://bugs.mysql.com/
```

#### 安装mysql客户端

```shell
rpm -ivh MySQL-client-5.5.48-1.linux2.6.x86_64.rpm
```
