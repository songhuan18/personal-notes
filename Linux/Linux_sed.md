##### sed
sed是一种流编辑器，它一次处理一行内容。处理时，把当前处理的行存储在临时缓冲区中，称为“模式空间”，接着用sed命令处理缓冲区中的内容，处理完成后，把缓冲区的内容送往屏幕。接着处理下一行，这样不断重复，直到文件末尾。文件内容并没有改变，除非你使用重定向存储输出。
##### 基本用法
sed [选项参数] 'command' filename
##### 选项参数说明

选项参数 | 功能
--- | ---
-e | <script文件>或--expression=<script文件> 以选项中指定的script来处理输入的文本文件
-f | <script文件>或--file=<script文件> 以选项中指定的script文件来处理输入的文本文件
-h或--help | 显示帮助
-n或--quiet或--silent | 仅显示script处理后的结果
V或--version | 显示版本信息
-i | 直接修改读取文件内容，而不是输出到终端
##### 命令功能描述
命令 | 功能描述
--- | ---
a | 新增， a 的后面可以接字串，而这些字串会在新的一行出现(目前的下一行)
c | 取代， c 的后面可以接字串，这些字串可以取代 n1,n2 之间的行
d | 删除，因为是删除啊，所以 d 后面通常不接任何东西
i | 插入， i 的后面可以接字串，而这些字串会在新的一行出现(目前的上一行)
p | 打印，亦即将某个选择的数据印出。通常 p 会与参数 sed -n 一起运行
s | 取代，可以直接进行取代的工作哩！通常这个 s 的动作可以搭配正规表示法！例如 1,20s/old/new/g 就是啦
##### 数据准备
```sh
vim sed.txt
zhang san
xiao hong
li si
wang wu
zhao liu
```
##### 将'mei nv'插入到sed.txt第二行
```sh
⚡ root@songhuan  ~/shell  sed '2a mei nv' sed.txt
zhang san
xiao hong
mei nv
li si
wang wu
zhao liu
```
>注意：sed.txt文件中的内容并不会改变

##### 删除sed.txt文件所有包含zhang的行
```sh
⚡ root@songhuan  ~/shell  sed '/zhang/d' sed.txt
xiao hong
li si
wang wu
zhao liu
```
>注意：sed.txt文件中的内容并不会改变

##### 将sed.txt文件中的zhang替换为song
```sh
⚡ root@songhuan  ~/shell  sed 's/zhang/song/g' sed.txt
song san
xiao hong
li si
wang wu
zhao liu
```
>注意：`g`表示global，全部替换，sed.txt文件中的内容并不会改变

##### 将sed.txt文件中的第一行删除，并xiao替换为song
```sh
⚡ root@songhuan  ~/shell  sed -e '1d' -e 's/xiao/song/g' sed.txt
song hong
li si
wang wu
zhao liu
```
>注意：sed.txt文件中的内容并不会改变

##### 删除第二行到最后一行
```sh
sed '2,$d' sed.txt
```
##### 将sed.txt文件中的zhang替换为song
```sh
sed -i 's/zhang/song/g' sed.txt
```
> 注意：sed.txt文件中的内容会改变
