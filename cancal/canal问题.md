### canal 版本 1.1.4

##### 修改canal_admin默认密码
问题描述：修改canal_admin默认密码导致canal_server无法注册上，canal_admin一直报权限错误。<br>
具体错误如下：
```
something goes wrong when doing authentication: auth failed for user:admin
```
canal_server已经启动成功，并且在server端的配置也把对应的`canal.admin.passwd`密码修改，但是还报错。<br>
解决办法：
```
修改canal_local.properties配置文件中的canl_admin.password密码。
修改canal_local.properties配置文件中的canal.admin.manager地址
```
##### instance报错parse row data failed
背景描述：因为使用zk做了持久化，然后把对应的canal的持久化节点(otter)直接删除，并且将canal-server和canal-admin停服一段时间。如果在停服这一段时间，表结构有改动就会导致`parse row data failed`这个错误。<br>
解决办法：
```
在canal-server中找到conf下对应的instance配置，并删除h2.mv.db文件.
或者直接将canl-server直接删除重新启动
```
还有一种解决办法就是在删除`otter`节点之前，先记录下对应的位点信息，然后在重新启动instance的时候配置如下信息：
```
# position info
canal.instance.master.address=127.0.0.1:3306
canal.instance.master.journal.name=
canal.instance.master.position=
canal.instance.master.timestamp=
canal.instance.master.gtid=
```
