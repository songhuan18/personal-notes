#### 查看JVM参数地址
```
https://docs.oracle.com/javase/8/docs/technotes/tools/unix/java.html
```
#### 查看初始化堆内存
```sh
jinfo -flag InitialHeapSize pid
```
#### 查看最大堆内存
```sh
jinfo -flag MaxHeapSize pid
```
#### 查看JVM设置的默认垃圾收集器
```sh
java -XX:+PrintCommandLineFlags -version
# 或者
java -XX:+PrintFlagsFinal -version | grep :
```
