nacos获取配置比较重要的类
```java
DynamicServerListLoadBalancer.class
NacosServerList.class NacosServerList#getServers
```
##### 定时更新元数据信息
默认30秒
```java
com.netflix.loadbalancer.PollingServerListUpdater#start
com.netflix.loadbalancer.ServerListUpdater.UpdateAction#doUpdate
```
##### nacos配置类
```java
com.alibaba.cloud.nacos.NacosConfigBootstrapConfiguration
```

##### 心跳监测类
```java
com.alibaba.nacos.client.naming.beat.BeatReactor
```
##### 如何自己修改源码后打包nacos
```
mvn -Prelease-nacos -Dmaven.test.skip=true clean install -U
```
