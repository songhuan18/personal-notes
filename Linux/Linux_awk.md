#### awk
一个强大的文本分析工具，把文件逐行的读入，以空格为默认分隔符将每行切片，切开的部分再进行分析处理。
#### 基本用法
awk [选项参数] ‘pattern1{action1}  pattern2{action2}...’ filename
pattern：表示AWK在数据中查找的内容，就是匹配模式
action：在找到匹配内容时所执行的一系列命令
#### 选项参数说明
选项参数 | 功能
--- | ---
-F | 指定输入文件分隔符
-v | 赋值一个用户定义变量
#### 案例实操
- 数据准备
```sh
cp /etc/passwd .
```
- 搜索passwd文件以root开头所在的行，并输出该行的第7列
```sh
awk -F : '/^root/{print $7}' passwd
```
- 搜索passwd文件以root关键字开头的所有行，并输出该行的第1列和第7列，中间以“，”号分割
```sh
awk -F : '/^root/{print $1","$7}' passwd
```
- 只显示/etc/passwd的第一列和第七列，以逗号分割，且在所有行前面添加列名user，shell在最后一行添加"xiaoming，/bin/xiaoming"
```sh
awk -F : 'BEGIN{print "user,shell"}{print $1","$7} END{print "xiaoming,/bin/xiaoming"}' passwd
```
> 注意：BEGIN 在所有数据读取行之前执行；END 在所有数据执行之后执行

- 将passwd文件中的用户id(第三列)增加数值1并输出
```sh
awk -v i=1 -F: '{print $3+i}' passwd
```

#### awk的内置变量
变量 | 说明
--- | ---
FILENAME | 文件名
NR | 已读的记录数
NF | 浏览记录的域的个数
#### 案例实操
- 统计passwd文件名，每行的行号，每行的列数
```sh
awk -F: '{print "filename:" FILENAME ",linenumber:" NR ",columns:" NF}' passwd
```
- 切割IP
```sh
ifconfig eth0 | grep "inet addr" | awk -F: '{print $2}' | awk -F " " '{print $1}'
```
- 查询sed.txt中空行所在的行号
```sh
awk '/^$/{print NR}' sed.txt
```
