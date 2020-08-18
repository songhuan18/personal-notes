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
