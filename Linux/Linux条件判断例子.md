##### 判断根分区使用率是否大于10%
```shell
#!/bin/bash
#VolGroup-lv_root 为获取根分区这一行的关键字
TEST=$(df -h | grep VolGroup-lv_root | awk '{print $5}' | cut -d "%" -f 1)
if [ $TEST -ge 10 ]
  then
    echo "/ ge 10%"
fi
```
##### 判断用户输入的是否是一个目录
```shell
#!/bin/bash
read -t 30 -p "please input a dir：" FILE
if [ -d $FILE ]
  then
    echo "这是一个目录"
  else
    echo "这不是一个目录"
fi
```
##### 判断apache是否启动
```shell
#!/bin/#!/usr/bin/env bash
TEST=$(ps aux | grep httpd | grep -v grep) #grep -v grep：过滤不显示带有关键字grep的行
if [ -n $TEST ]
  then
    echo "$(date) httpd is ok!" >> /tmp/autostart-acc.log
  else
    /etc/rc.d/init.d/httpd start &>/dev/null
    echo "$(data) restart httpd!!" >> /tmp/autostart-err.log
fi
```
##### 批量解压缩文件
```shell
#!/bin/#!/usr/bin/env bash
cd /root/test
ls *.tar.gz > ls.log
ls *.tgz >> ls.log
for i in $(cat ls.log)
  do
    tar -zxf $i &>/dev/null
  done
rm -rf /root/test/ls.log
```
##### 从1加到100
```shell
#!/bin/bash
s=0
for((i=1;i<=100;i=i+1))
  do
    s=$(($s+$i))
  done
echo "The sum is $s"
```
