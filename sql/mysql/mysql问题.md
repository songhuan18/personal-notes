##### 1、新增一条数据一直无法新增新增成功
问题描述：新增一条数据，一直卡住，直到50s(mysql默认死锁检测时间)死锁检测并报错。<br>
猜测：针对新增的这条数据，有可能某一个字段建了索引，而且是唯一索引。另外的事务在执行的时候，开启了事务，一直没有提交事务，所以导致新增的数据一直无法成功。<br>
解决办法：通过命令查看是否存在一直在执行的事务
```
SELECT * from information_schema.INNODB_TRX;
```
借助阿里云的rds SQL洞察工具通过线程号查询是否存在有未提交的事务<br>
根据线程号，kill掉对应的线程
```
kill 线程id
```
导致原因：当事务开启后，Java服务直接重启了，导致事务一直挂起。

##### 2、mysql字符集不一致导致索引失效
表1：demeter_order，字符集：utf8<br>
表2：demeter_merchant_account_bill_detail，字符集：utf8mb4<br>
两张表的外键为：order_number，并且创建了索引
```SQL
-- 索引失效(Q1)
explain select a.`statement_date` from demeter_order a
  join demeter_merchant_account_bill_detail b on a.order_no=b.order_number
 where b.id = 3428;
-- 会用索引(Q2)
explain select b.`statement_date` from demeter_order a
  join demeter_merchant_account_bill_detail b on a.order_no=b.order_number
 where a.id = 1339950;
-- 查看索引是否生效，可以通过mysql命令行工具，使用show warnings\G查看更多信息
```
通过以上的命令查看，发现是因为字符集的不同导致的，针对Q1，通过过滤条件查询出对应的order_number
的字符集是utf8mb4，那么再通过join查询的时候，会通过函数将demeter_order表里面的order_number字段转换成utf8mb4导致索引失效。而Q2，只会把通过条件查询出来的order_number(常量)，通过函数转换成utf8mb4，所以最终会使用到索引。<br>
通过 show warnings\G 分析如下
```
mysql> show warnings\G;
*************************** 1. row ***************************
  Level: Note
   Code: 1003
Message: /* select#1 */ select `biaoguoworks`.`a`.`statement_date` AS `statement_date` from `biaoguoworks`.`demeter_order` `a` join `biaoguoworks`.`demeter_merchant_account_bill_detail` `b` where ((convert(`biaoguoworks`.`a`.`order_no` using utf8mb4) = '162102230296701'))
1 row in set (0.00 sec)

```
```
mysql> show warnings\G;
*************************** 1. row ***************************
  Level: Note
   Code: 1003
Message: /* select#1 */ select `biaoguoworks`.`b`.`statement_date` AS `statement_date` from `biaoguoworks`.`demeter_order` `a` join `biaoguoworks`.`demeter_merchant_account_bill_detail` `b` where ((convert('932102240297451' using utf8mb4) = `biaoguoworks`.`b`.`order_number`))
1 row in set (0.00 sec)
```
##### 3、Mysql并发Insert，然后Update造成死锁
场景描述，首先创建一张表，并新增一条记录。表字段`name`作为唯一索引，表结构如下：
```SQL
CREATE TABLE `t_account` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `age` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `account` int(11) NOT NULL,
  `address` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_name` (`name`) USING BTREE,
  KEY `idx_age` (`age`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
INSERT INTO `test`.`t_account`(`age`, `name`, `account`, `address`) VALUES (20, 'zs', 1000000, '成都市');
```
业务场景：先新增记录，如果发现已经存在，则catch异常并修改该记录。如果是在多线程并发访问的情况下会造成死锁。<br>
首先在数据库中查找Innodb status，在Innodb status中会记录上一次死锁的信息，输入以下命令即可：
```SQL
show engine innodb status;
```
死锁信息如下：
```
------------------------
LATEST DETECTED DEADLOCK
------------------------
2021-03-25 09:32:03 0x7f77600d8700
*** (1) TRANSACTION:
TRANSACTION 190864, ACTIVE 0 sec starting index read
mysql tables in use 1, locked 1
LOCK WAIT 5 lock struct(s), heap size 1136, 3 row lock(s)
MySQL thread id 199, OS thread handle 140151024609024, query id 3022 10.211.55.2 root updating
UPDATE t_account  SET address='河南省'

 WHERE name = 'zs'
*** (1) WAITING FOR THIS LOCK TO BE GRANTED:
RECORD LOCKS space id 145 page no 4 n bits 72 index uk_name of table `test`.`t_account` trx id 190864 lock_mode X locks rec but not gap waiting
Record lock, heap no 2 PHYSICAL RECORD: n_fields 2; compact format; info bits 0
 0: len 2; hex 7a73; asc zs;;
 1: len 8; hex 800000000000001d; asc         ;;

*** (2) TRANSACTION:
TRANSACTION 190863, ACTIVE 0 sec starting index read
mysql tables in use 1, locked 1
6 lock struct(s), heap size 1136, 3 row lock(s)
MySQL thread id 198, OS thread handle 140150689335040, query id 3023 10.211.55.2 root updating
UPDATE t_account  SET address='北京市'

 WHERE name = 'zs'
*** (2) HOLDS THE LOCK(S):
RECORD LOCKS space id 145 page no 4 n bits 72 index uk_name of table `test`.`t_account` trx id 190863 lock mode S
Record lock, heap no 2 PHYSICAL RECORD: n_fields 2; compact format; info bits 0
 0: len 2; hex 7a73; asc zs;;
 1: len 8; hex 800000000000001d; asc         ;;

*** (2) WAITING FOR THIS LOCK TO BE GRANTED:
RECORD LOCKS space id 145 page no 4 n bits 72 index uk_name of table `test`.`t_account` trx id 190863 lock_mode X locks rec but not gap waiting
Record lock, heap no 2 PHYSICAL RECORD: n_fields 2; compact format; info bits 0
 0: len 2; hex 7a73; asc zs;;
 1: len 8; hex 800000000000001d; asc         ;;

*** WE ROLL BACK TRANSACTION (1)
------------
```
原因分析：因为在插入的时候发生了唯一键冲突，要判断是否发生唯一键冲突，必须进行一次当前读，所以会把加锁的过程分为两步，会先申请`共享锁`，然后再申请排它锁。如果在并发情况下，多个事务陷入了冲突，那么他们一定都会申请到`共享锁`，这个时候再申请排他锁的时候就会出现互相等待(死锁)，这个时候Mysql会选择牺牲掉其中一些事务，让其中的一个完成。
