##### cut
cut的工作就是“剪”，具体的说就是在文件中负责剪切数据用的。cut 命令从文件的每一行剪切字节、字符和字段并将这些字节、字符和字段输出。
##### 基本用法
cut [选项参数] filename<br>
说明：默认分隔符是制表符
##### 选项参数说明
选项参数 | 功能
--- | ---
-b | 以字节为单位进行分割。这些字节位置将忽略多字节字符边界，除非也指定了-n标志
-d | 自定义分隔符，按照指定分隔符隔列
-f | 列号，提取第几列，与-d一起使用
-n | 取消分割多字节字符。`仅和-b标志一起使用`。如果字符的最后一个字节落在由-b标志的参数指示范围之内，该字符将被写出；否则排除该字符
##### 数据准备
```sh
vim cut.txt
zhan san
li si
wang wu
zhao liu
wo wo
```
- -b支持形如1-2的写法，而且多个定位之间用逗号隔开例子
```sh
⚡ root@songhuan  ~/shell  cut -b 1-2,8 cut.txt
zhn
li
wa
zhu
wo
```
> 注意：cut命令如果使用了-b选项，那么执行命令时，cut会把-b后面的所有定位进行从小到大的排序

- 例子
```sh
# -2表示从第一个字节到第二个字节
⚡ root@songhuan  ~/shell  cut -b -2 cut.txt
zh
li
wa
zh
wo
# 2-表示从第三个字节到行尾
⚡ root@songhuan  ~/shell  cut -b 2- cut.txt
han san
i si
ang wu
hao liu
o wo
# 如果是-2,2-是输出整行
⚡ root@songhuan  ~/shell  cut -b -2,2- cut.txt
zhan san
li si
wang wu
zhao liu
wo wo
```

##### 切割cut.txt第一列
```sh
⚡ root@songhuan  ~/shell  cut -d " " -f 1 cut.txt
zhan
li
wang
zhao
wo
```
##### 切割cut.txt获取第二、三列
```sh
⚡ root@songhuan  ~/shell  cut -d " " -f 2,3 cut.txt
san
si
wu
liu
wo
```
##### 在cut.txt文件中切割出zhan
```sh
⚡ root@songhuan  ~/shell  cat cut.txt | grep zhan | cut -d " " -f 1
zhan
```
##### 在cut.txt中获取第一行第一列
```sh
⚡ root@songhuan  ~/shell  cut -d " " -f 1 cut.txt | sed -n "1p"
zhan
```
