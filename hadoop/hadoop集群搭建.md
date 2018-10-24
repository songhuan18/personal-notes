##### 环境准备
- 系统环境：Ubuntu16.04 x86_64
- 内核
```
Distributor ID:	Ubuntu
Description:	Ubuntu 16.04.3 LTS
Release:	16.04
Codename:	xenial
```
- jdk1.8.1
- hadoop版本：hadoop-2.7.2
- 三台虚拟机，ip分别为：10.211.55.11、10.22.55.13、10.211.55.14

> Java环境变量和Hadoop环境变量不再追述

将原来搭建好的hadoop拷贝至另外两台。具体可以[参考](hadoop搭建.md)
##### 集群分发脚本
> 用来分发机器上的文件，比如说A机器上修改了配置文件，需要分发到B和C机器上，那么久可以使用一下脚本

在当前用户下进行操作
```sh
mkdir bin
cd bin/
touch xsync #创建分发脚本文件
chmod a+x xsync
vim xsync
```
分发脚本的内容：
```sh
#!/bin/bash
#1 获取输入参数个数，如果没有参数，直接退出
pcount=$#
if((pcount==0))
   then
     echo no args;
     exit;
fi

#2 获取文件名称
p1=$1
fname=`basename $p1`
echo fname=$fname

#3 获取上级目录到绝对路径
pdir=`cd -P $(dirname $p1); pwd`
echo pdir=$pdir

#4 获取当前用户名称
user=`whoami`
hostname=$(hostnamectl --static)
#5 循环
for host in 11 13 14
   do
      if [ "$hostname" == "hadoop$host" ]
         then
           continue
      fi
      echo ------------------- hadoop$host --------------
      rsync -rvl $pdir/$fname $user@hadoop$host:$pdir
   done
```
举例：比如将当前用户目录下的bin分发到另外两台机器上，执行以下命令：
```sh
bin/xsync bin/
```
##### 集群配置
- 集群部署规划

| hadoop11 | hadoop13 | hadoop14
--- | --- | --- | ---
HDFS | NameNode<br>DataNode | DataNode | SecondaryNameNode<br>DataNode
YARN | NodeManager | ResourceManager<br>NodeManager | NodeManager

- 配置集群
