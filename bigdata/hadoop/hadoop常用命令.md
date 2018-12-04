## hadoop常用命令

##### 帮助命令
```sh
# 如：rm
hadoop fs -help rm
```
##### 在HDFS上创建目录
```sh
hadoop fs -mkdir -p /user/yg
```
##### 显示目录信息
```sh
hadoop fs -ls /
# 或
hadoop fs -ls /user/yg
```
##### 从本地剪切黏贴到HDFS
```sh
hadoop fs -moveFromLocal test.txt /user/yg
```
##### 追加一个文件到已经存在的文件末尾
```sh
hadoop fs -appendToFile append.txt /user/yg/test.txt
```
##### 显示文件内容
```sh
hadoop fs -cat /user/yg/test.txt
```
##### 修改文件所属权限
```sh
hadoop fs -chmod 777 /user/yg/test.txt
hadoop fs -chgrp -R hadoop /user/yg
hadoop fs -chown ubuntu:ubuntu /user/yg/test.txt
```
##### 从本地文件系统中拷贝文件到HDFS路径
```sh
hadoop fs -copyFromLocal README.txt /
```
##### 从HDFS拷贝文件到本地
```sh
hadoop fs -copyToLocal /user/yg/test.txt ./
```
##### 从HDFS的一个路径拷贝到HDFS的另外一个路径
```sh
hadoop fs -cp /user/yg/test.txt /user
```
##### 在HDFS目录中移动文件
```sh
hadoop fs -mv /user/test.txt /
```
##### 从HDFS下载文件到本地
```sh
hadoop fs -get README.md ./
```
> 等同于copyToLocal

##### 合并下载多个文件
> 比如/user/yg/ 目录下有多个文件需要同时下载:test1.txt,test2.txt,test3.txt....

```sh
hadoop fs -getmerge /user/yg/* ./
```
##### 从本地上传文件到HDFS
```sh
hadoop fs -put ubuntu.txt /user/yg
```
> 功能等同于copyFromLocal

##### 显示一个文件的末尾
```sh
hadoop fs -tail /user/yg/ubuntu.txt
```
##### 删除文件或文件夹
```sh
hadoop fs -rm /user/yg/ubuntu.txt
```
##### 删除空目录
```sh
hadoop fs -mkdir /test
hadoop fs -rmdir /test
```
##### 统计文件的大小信息
```sh
hadoop fs -du -s -h /user/yg/
# 或
hadoop fs -du -h /user/yg
```
##### 设置HDFS中文件的副本数量
```sh
hadoop fs -setrep 10 /user/yg/test.txt
```
> 这里设置的副本数只是记录在NameNode的元数据中，是否真的会有这么多副本，还得看DataNode数量。如果只有3个节点，那么最多也只有三个副本
