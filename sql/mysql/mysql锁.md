#### 增加表锁
```sh
lock table 表名字 read(write), 表名字2 read(write), 其它;
```
#### 查看加过锁的表
```sh
show open tables;
```
#### 释放锁
```sh
unlock tables;
```
#### 并发事物处理带来的问题
更新丢失(Lost Update)、脏读(Dirty Reads)、不可重复读(Non-Repeatable Reads)、幻读(Phantom Reads)
#### 事物隔离级别
读数据一致性及允许的并发副作用隔离级别 | 读数据一致性 | 脏读 | 不可重复读 | 幻读
--- | --- | --- | --- | ---
未提交读(Read uncommitted) | 最低级别，智能保证不读取物理上的损坏数据 | 是 | 是 | 是
已提交读(Read committed) | 语句级 | 否 | 是 | 是
可重复读(Repeatable read) | 事物级 | 否 | 否 | 是
可序列化(Serializable) | 最高级别，事物级 | 否 | 否 | 否

数据库的事物隔离越严格，并发副作用越小，但付出的代价越大，因为事物的隔离实质上就是使事物在一定程度上“串行化”进行，这显然与“并发”是矛盾的。不同的应用对读一致性和事物隔离程度的要求也是不同的，比如许多应用对“不可重复读”和”幻读”并不敏感，可能更关心数据并发访问的能力。

#### 查看当前数据库事物隔离级别
```sh
show variables like 'tx_isolation'
```
#### 设置事物隔离级别
```sh
# 设置当前会话隔离级别
set session transaction isolation level read committed;
# 设置全局隔离级别
set global transaction isolation level read committed;
```
#### 什么是间隙锁
当我们用范围条件而不是相等条件检索数据，并请求共享或排他锁时，InnoDB会给符合条件的已有数据记录的索引项加锁，对于键值在条件范围内但并不存在的记录，叫做“间隙（GAP）”，InnoDB也会对这个“间隙”加锁，这种锁机制就是所谓的间隙锁（Next-Key锁）。
#### 间隙锁危害
因为Query执行过程中通过范围查找的话，他会锁定整个范围内所有的索引值，即使这个键值并不存在。间隙锁有一个比较致命的弱点，就是当锁定一个范围键值之后，即使某些不存在的键值也会被无辜的锁定，而造成在锁定的时候无法插入锁定键值范围内的任何数据。在某些场景下这可能会性能造成很大的危害。
#### 锁定某一行
```sql
begin;
select * from test_lock where a = 1 for update;
```
#### 查看行锁定详情
```sql
show status like 'innodb_row_lock%';
```
字段说明：
- Innodb_row_lock_current_waits：当前正在等待锁定的数量
- Innodb_row_lock_time：从系统启动到现在锁定总时间长度（重要）
- Innodb_row_lock_time_avg：每次等待所花平均时间（重要）
- Innodb_row_lock_time_max：从系统启动到现在等待最长的一次所花时间
- Innodb_row_lock_waits：系统启动后到现在总共等待的次数（重要）

#### 结论
Innodb存储引擎由于实现了行级锁定，虽然在锁定机制的实现方面所带来的性能损耗可能比表级锁定会更高一些，但是在整体并发处理能力方面要远远优于MyISAM的表级锁定的。当系统并发量较高的时候，Innodb的整体性能和MyISAM相比就会有比较明显的优势了。

但是，Innodb的行级锁定同样也有其脆弱的一面，当我们使用不当的时候，可能会让Innodb的整体性能表现不仅不能比MyISAM高，甚至可能会更差。
