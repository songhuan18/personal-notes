> hadoop版本2.7.2
##### 问题1
> hadoop 按照官方文档跑示例报错：Error: JAVA_HOME is not set and could not be found.

解决办法：更改hadoop文件下etc/hadoop/hadoop-env.sh
```sh
export JAVA_HOME=${JAVA_HOME} # 更改之前
export JAVA_HOME=/opt/setups/jdk1.8.0_181 # 更改之后
```
