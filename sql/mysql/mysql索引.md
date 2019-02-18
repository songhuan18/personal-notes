#### MySQL索引
MySQL官方对索引的定义为：索引是帮助MySQL高效获取数据的数据结构。可以得到索引的本质：索引是数据结构。`你可以理解为“排好序的快速查找数据结构”`

一般来说索引本身也很大，不可能全部存储在内存中，因此索引往往以索引文件的形式存储在磁盘上

我们平常所说的索引，如果没有特别指明，都是指B树（多路搜索树，并不一定是二叉的）结构组织的索引。其中聚集索引，次要索引，覆盖索引，符合索引，前缀索引，唯一索引默认都是使用B+树索引，统称索引。当然，除了B+树这种类型的索引之外，还有哈希索引（hash index）等。

#### 创建索引
```sh
create [unique] index indexName on mytable(colunmname(length));
# 或者
alter mytable add [unique] index indexName on (columnname(length));
```
#### 删除索引
```sh
drop index indexName on mytable
```
#### 查看索引
```sh
show index from tableName;
```
