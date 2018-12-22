##### 查询系统整体磁盘使用情况
```sh
df -lh
```
##### 查询指定目录磁盘占用情况
```sh
du -h /目录
参数说明：
-s 指定目录占用大小汇总
-h 带计量单位
-a 含文件
--max-depth=1 子目录深度
-c 列出明细的同时，增加汇总值
```
示例：查询/opt目录的磁盘占用情况，深度为1
```sh
du -ach --max-depth=1 /opt
```
##### 磁盘情况-工作实用指令
- 统计/home文件夹下文件的个数
```sh
ls -l /home | grep "^-" | wc -l
```
- 统计/home文件夹下目录的个数
```sh
ls -l /home | grep "^d" | wc -l
```
- 统计/home文件夹下文件的个数，包括子文件夹里的
```sh
ls -l /home | grep "^-" | wc -l
```
- 统计/home文件夹下目录的个数，包括子文件夹
```sh
ls -lR /home | grep "^d" | wc -l
```
- 以树状显示/home结构
```sh
tree
# 如果该命令不存在，centos可以通过yum安装，ubuntu可以通过apt-get安装
```
##### Linux查看io读写
```sh
iotop
# 如果该命令不存在，centos可以通过yum安装，ubuntu可以通过apt-get安装
```
