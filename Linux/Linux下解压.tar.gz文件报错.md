##### Linux下解压.tar.gz文件时报错，遇到问题如下：
```shell
执行 $ tar -zxvf xxxx.tar.gz 命令时，
提示以下信息：
　　gzip： stdin： not in gzip format
　　tar： Child returned status 1
　　tar： Error is not recoverable： exiting now
```
原因：这个压缩包没有用gzip格式压缩，所以不用加z指令

解决办法：
```shell
使用 $ tar -xvf xxxx.tar.gz 命令（即去掉z参数）
```
