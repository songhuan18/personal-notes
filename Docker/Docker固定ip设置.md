##### Docker默认三种网络类型
```sh
NETWORK ID          NAME                DRIVER              SCOPE
d0dbe111df16        bridge              bridge              local
01eeadb7b45c        host                host                local
161ba633fda4        none                null                local
```
##### 创建桥接网络
```sh
ocker network create --driver bridge my_bridge
```
##### 启动容器指定固定ip
```sh
docker run -it --network  my_bridge --ip 172.18.0.1 --name tracker01 sh/tracker:0.0.1 bash
```
> 注意：运行以上命令报错 docker: Error response from daemon: user specified IP address is supported only when connecting to networks with user configured subnets.

##### 创建桥接网络 指定网段
```sh
docker network create --subnet=172.18.0.0/16 fastdfs-docker
```
