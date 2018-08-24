##### 直接运行
```shell
java -jar aap.jar
```
##### 后台运行方式
```shell
java -jar app.jar &
```
& 表示在后台运行，当前ssh窗口不被锁定，但是当窗口关闭时，程序终止运行

##### nohup方式运行
```shell
nohup java -jar app.jar &
```
 默认将程序的输出重定向到nohup.out文件中，如果需要指定文件输出，执行以下命令即可：
 ```shell
 nohup java -jar app.jar > file.log &
 ```
 使用jobs可以显示当前后台运行的任务
 ```shell
 ubuntu@ubuntu-1604-211:~/java/jar$ jobs
[1]   Running                 nohup java -Xms256m -Xmx256m -jar service-registry-1.0-SNAPSHOT.jar &
[3]-  Running                 nohup java -Xms256m -Xmx256m -jar fastdfs-1.0-SNAPSHOT.jar &
[4]+  Running                 nohup java -Xms256m -Xmx256m -jar giraffe-gateway-1.0-SNAPSHOT.jar &
 ```
 如 fg 1 表示将后台任务回调到前台，后面跟的事后台任务对应的任务号
 ```shell
ubuntu@ubuntu-1604-211:~/java/jar$ fg 1
nohup java -Xms256m -Xmx256m -jar service-registry-1.0-SNAPSHOT.jar
 ```
 > 注意：如果将后台任务回调到前台之后，想继续将该任务放在后台运行，可使用快捷键 ctrl + z

 fg：将进程搬到前台运行
 bg：将进程搬到后台运行

 使用快捷键 ctrl + c 即结束当前任务
