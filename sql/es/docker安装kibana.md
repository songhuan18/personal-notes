##### 拉取kibana镜像
```sh
docker pull kibana:7.4.2
```
##### 创建docker-compose.yml文件
```sh
version: '2.3'
services:
  sh_kibana:
    image: kibana:7.4.2
    container_name: sh_kibana
    restart: 'always'
    ports:
     - 5601:5601
    environment:
     - ELASTICSEARCH_HOSTS=10.211.55.6
```
