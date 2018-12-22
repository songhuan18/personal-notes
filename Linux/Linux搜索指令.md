##### find指令
- 基本语法

  find [搜索范围] [选项]

- 选项说明

  -name 按照指定的文件名查找模式查找文件，可以使用通配符 * ?<br>
  -user 查找属于指定用户名所有文件
  -size 按照指定的文件大小查找文件

应用实例：

- 案例1：根据名称查找/home目录下的hello.txt文件
```sh
find /home -name hello.txt
```
- 案例2：按拥有者：查找/opt目录下，用户名称为 nobody的文件
```sh
find /opt -user nobody
```
- 案例3：查找整个linux系统下大于10M的文件（+n 大于  -n小于   n等于）
```sh
find / -size +10M
```
- 案例4：查找整个linux系统下以.txt文件结尾的文件
```sh
fin / -name *.txt
```
##### locaate指令
locate指令可以快速定位文件路径。locate指令利用事先建立的系统中所有文件名称及路径的locate数据库实现快速定位给定的文件。Locate指令无需遍历整个文件系统，查询速度较快。为了保证查询结果的准确度，管理员必须定期更新locate时刻。
- 基本语法

  locate 搜索文件

- 特别说明

  由于locate指令基于数据库进行查询，所以第一次运行前，必须使用updatedb指令创建locate数据库。

- 案例1：使用locate 指令快速定位 hello.txt 文件所在目录
```sh
updatedb
locate hello.txt
```
##### grep指令和管道符号|
grep过滤查找，管道符“|”表示将前一个命令的处理结果输出传递给后面的命令处理。
- 基本语法

  grep [选项] 查找的内容 源文件

- 常用选项

  -n 显示匹配行及行号
  -i 互略字母大小写

- 案例1: 请在 /etc/profile 文件中，查找  "if"  所在行，并且显示行号
```sh
# [在/etc/profile 中查找 if ,并显示行，区别大小写]
cat /etc/profile | grep -n if
# [在/etc/profile 中查找 if ,并显示行，不区别大小写]
cat /etc/profile | grep -ni if
```
