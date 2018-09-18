
##### 登陆mysql
```
mysql -u root -q
```
##### 创建新数据库
```
create database newDB
```
##### 创建用户
创建用户：username，只能本地访问
```
create user username@'localhost' identified by 'password(1234)';
```
创建用户：username，可以远程访问
```
create user username@'%' identified by 'password(1234)';
```
##### 修改用户密码
以username为例
```
set password for 'username'@'=password'
```
##### 授权
授予username管理newDB的所有权限（远程）
```
grant all privileges on database.*@'%' to username@‘%’ identified by '1234';
```
授予username全部数据权限，并修改密码
```
grant all on *.* to 'username'@'%' identified by '123456';
```
