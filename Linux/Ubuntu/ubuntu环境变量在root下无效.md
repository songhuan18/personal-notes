##### 问题描述
在普通用户切换到root用户时，无法加载/etc/profile。

解决办法：
```sh
#切换到root用户下
vim /root/.bashrc
source /etc/profile # 在末尾加上
```
