#### redis压测
```sh
redis-benchmark -h 127.0.0.1 -p 6379 -c 100 -n 10000
```
模拟100个并发，发送10000个请求

#### 测试存取大小为100字节的数据包
```sh
redis-benchmark -h 127.0.0.1 -p 6379 -q -d 100
```
#### 测试set,lpush的操作性能
```sh
redis-benchmark -t set,lpush -q -n 100000
```
#### 测试某些数值存取的性能
```sh
redis-benchmark -n 100000 -q script load "redis.call('set','foo','bar')"
```
