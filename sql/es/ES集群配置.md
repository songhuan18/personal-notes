### ES集群配置

#### 修改配置文件
```sh
vim elasticsearch.yml
# 配置一下信息
cluster.name: my-es # 集群名
node.name: node-1 # 节点名
network.host: 0.0.0.0 # 对外暴露的host，0.0.0.0时暴露给外网
http.port: 9200 # 对外访问的端口号，默认为9200
transport.tcp.port: 9300 # 集群间通信的端口号，默认为9300
discovery.zen.ping.unicast.hosts: ["10.211.55.11:9300","10.211.55.13:9300", "10.211.55.14:9300"] # 集群的ip集合，可指定端口，默认为9300
discovery.zen.minimum_master_nodes: 3 # 最少的主节点个数，为了防止脑裂，最好设置为(总结点数/2 + 1)个
http.cors.enabled: true
http.cors.allow-origin: "*"
bootstrap.memory_lock: false
bootstrap.system_call_filter: false
```
> 注意，如果ES整个文件夹是拷贝的，最好把data数据目录全部删除
