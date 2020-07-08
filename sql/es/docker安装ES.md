##### 拉取es镜像
```
docker pull elasticsearch:7.4.2
```
##### 创建需要挂载的文件夹
```sh
mkdir config data plugins
```
##### 设置任意ip可访问
```sh
echo "network.host: 0.0.0.0" >> elasticsearch.yml
```
##### 创建docker-compose.yml文件
```sh
version: '2.3'
services:
  sh_elasticsearch:
    image: elasticsearch:7.4.2
    container_name: sh_elasticsearch
    restart: 'always'
    ports:
      - "9200:9200"
      - "9300:9300"
    environment:
      - discovery.type=single-node
      - ES_JAVA_OPTS=-Xms512m -Xmx512m
    volumes:
      - /home/songhuan/docker/elasticsearch/config/elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml
      - /home/songhuan/docker/elasticsearch/data:/usr/share/elasticsearch/data
      - /home/songhuan/docker/elasticsearch/plugins:/user/share/elasticsearch/plugins
```
##### 如果直接启动出日志报错无权限访问
```java
"Caused by: java.nio.file.AccessDeniedException: /usr/share/elasticsearch/data/nodes",
```
##### 修改文件访问权限
```sh
chmod -R 777 /home/songhuan/docker/elasticsearch/data
```
##### 测试是否启动成功
访问地址：localhost:9200
