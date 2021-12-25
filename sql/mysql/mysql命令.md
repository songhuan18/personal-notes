#### 查看mysql提供的存储引擎
```sh
show engines;
```
#### 查看mysql当前默认的存储引擎
```sh
show variables like '%storage_engine%';
```
#### MyISAM和InnoDB对比
对比项 | MyISAM | InnoDB
--- | --- | ---
主外键 | 不支持 | 支持
事物 | 不支持 | 支持
行表锁 | 表锁，即使操作一条记录也会锁住整个表，不适合高并发操作 | 行锁，操作时只锁某一行，不对其它行有影响，适合高并发操作
缓存 | 只缓存索引，不缓存真实数据 | 不仅缓存索引还要缓存真实数据，对内存要求较高，而且内存大小对性能有决定性的影响
表空间 | 小 | 大
关注点 | 性能 | 事物
默认安装 | Y | Y

##### mysql查看锁等待超时时间
```
show variables like 'innodb_lock_wait_timeout';
```
##### 设置当前session锁等待超时时间
```
set Innodb_lock_wait_timeout = 5;
```
##### 设置全局锁等待超时时间
```
set global innodb_lock_wait_timeout=50;
```
##### 查看当前会话是否自动提交事务
```
show variables like 'autocommit';
```
##### 设置当前会话为自动提交事务
```
set autocommit = 1
```
> 0：非自动提交事务，对应 OFF   1：自动提交事务，对应为 ON

##### 查看是否主动监测死锁
```
show variables like 'innodb_deadlock_detect';
```
##### 查看binlog文件列表
```
show binary logs;
```
##### 查看指定binlog文件的内容
```
show binlog events in 'mysql-bin.000001';
```
##### mysqldump导出数据
```
mysqldump -h127.0.0.1 -P3306 -uroot -proot --add-locks=0 --no-create-info --single-transaction  --set-gtid-purged=OFF test t --where="id>0" --result-file=/t.sql
```
- –single-transaction 的作用是，在导出数据的时候不需要对表 test.t 加表锁，而是使用 START TRANSACTION WITH CONSISTENT SNAPSHOT 的方法；
- –add-locks 设置为 0，表示在输出的文件结果里，不增加" LOCK TABLES t WRITE;" ；
- –no-create-info 的意思是，不需要导出表结构；
- –set-gtid-purged=off 表示的是，不输出跟 GTID 相关的信息；
- –result-file 指定了输出文件的路径，其中 client 表示生成的文件是在客户端机器上的。

##### 查看正在执行的事务
```sh
SELECT * from information_schema.INNODB_TRX;
```
##### 查看锁执行详情
```sh
show engine innodb status;
```
##### 查看最大连接数
```
show variables like '%max_connections%';
```
##### 设置最大连接数(全局)
```
set GLOBAL max_connections = 200;
```
##### 设置当前session最大连接数
```
set session max_connections = 200;
```
##### 查看binlog是否打开
```
show variables like '%log_bin%';
```
##### binlog刷盘时机
对于InnoDB存储引擎而言，只有在事务提交时才会记录biglog，此时记录还在内存中，那么biglog是什么时候刷到磁盘中的呢？mysql通过sync_binlog参数控制biglog的刷盘时机，取值范围是0-N
- 0：不去强制要求，由系统自行判断何时写入磁盘；
- 1：每次commit的时候都要将binlog写入磁盘；
- N：每N个事务，才会将binlog写入磁盘。

```
# 查看刷盘时机
show variables like '%sync_binlog%';
```
