> 一定要切换到root下操作一下步骤

##### 修改/etc/passwd用户信息文件
```sh
vim /etc/passwd
#admin:x:503:501::/home/admin:/bin/bash
#把用户名admin改成rest
#test:x:503:501::/home/test:/bin/bash
```
##### 修改/etc/shadow用户密码文件
```sh
vim /etc/shadow
#admin:Dnakfw28zf38w:8764:0:168:7:::
#由于密码加密方式存放，只修改用户名即可（密码不变）
#test:Dnakfw28zf38w:8764:0:168:7:::
```
##### 修改/etc/group用户组文件
```sh
vim /etc/group
#admin:x:1:root,bin,admin
#修改admin组为test组
#test:x:1:root,bin,test
```
##### 更改家目录
```sh
mv /home/admin /home/test 
```
