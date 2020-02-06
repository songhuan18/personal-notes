#### Java运行无法找到主类
问题描述：直接通过java 类名 运行会报：`找不到或无法加载主类`

解决办法，采用以下命令：
```sh
java -classpath /usr/local/acme/classes com.acme.example.Foon
# 说明：/usr/local/acme/classes 为编译后存放class文件的地址
```
解决地址：`https://stackoverflow.com/questions/18093928/what-does-could-not-find-or-load-main-class-mean`
