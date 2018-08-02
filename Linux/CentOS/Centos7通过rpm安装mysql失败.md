> 问题描述通过rpm安装mysql失败

错误信息：
```
警告：MySQL-server-5.5.48-1.linux2.6.x86_64.rpm: 头V3 DSA/SHA1 Signature, 密钥 ID 5072e1f5: NOKEY
准备中...                          ################################# [100%]
	file /usr/share/mysql/charsets/README from install of MySQL-server-5.5.48-1.linux2.6.x86_64 conflicts with file from package mariadb-libs-1:5.5.56-2.el7.x86_64
	file /usr/share/mysql/charsets/Index.xml from install of MySQL-server-5.5.48-1.linux2.6.x86_64 conflicts with file from package mariadb-libs-1:5.5.56-2.el7.x86_64
	file /usr/share/mysql/charsets/armscii8.xml from install of MySQL-server-5.5.48-1.linux2.6.x86_64 conflicts with file from package mariadb-libs-1:5.5.56-2.el7.x86_64
	file /usr/share/mysql/charsets/ascii.xml from install of MySQL-server-5.5.48-1.linux2.6.x86_64 conflicts with file from package mariadb-libs-1:5.5.56-2.el7.x86_64
	file /usr/share/mysql/charsets/cp1250.xml from install of MySQL-server-5.5.48-1.linux2.6.x86_64 conflicts with file from package mariadb-libs-1:5.5.56-2.el7.x86_64
```

##### 原因
MariaDB是MySQL的一个分支，两个版本不能同时兼容

##### 解决办法

1. 列出所有被安装的MariaDB安装包
```shell
root@localhost /opt/setups rpm -qa | grep mariadb
mariadb-libs-5.5.56-2.el7.x86_64
```

2. 卸载
```shell
rpm -e --nodeps mariadb-libs-5.5.56-2.el7.x86_64
```
