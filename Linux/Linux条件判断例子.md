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
