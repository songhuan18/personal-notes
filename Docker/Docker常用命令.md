### Why Docker
- 更轻量：给予容器的虚拟化，仅包含业务运行所需的runtime环境，CentOS/Ubuntu基础镜像仅170M、左右；宿主机可部署100~1000个容器
- 更高效：无操作系统虚拟化开销
  - 计算：轻量，无额外开销
  - 存储：系统盘aufs/dm/overlayfs；数据盘volume
  - 网络：宿主机网络，NS隔离
- 更敏捷、更灵活：
  - 分层的存储和包管理，devops理念
  - 支持多种网络配置

##### 查看docker版本信息
```shell
docker version
```
##### 查看docker信息
```shell
docker info
```
##### docker帮助命令
```shell
docker --help
```
> 镜像相当于我们Java中的类，一个镜像可以生成多个容器实例

##### 列出本地主机上的镜像
```shell
docker images
参数说明：
-a 列出本地所有的镜像
-q 只显示镜像ID
--digests 显示镜像摘要信息
--no-trunc 显示完整的镜像信息
```
##### 查找某个镜像
```shell
docker search 某个镜像的名字
参数说明：
--no-trunc 显示完整的镜像描述
-s 列出收藏不小于指定值的镜像
--automated 只列出automated build类型的镜像
```
##### 下载镜像
```shell
docker pull 某个镜像的名字
指定下载某个版本的镜像：
docker pull 某个镜像的名字[:TAG]
```
##### 删除镜像
```shell
docker rmi 某个镜像的名字
参数说明：
-f 强制删除镜像

docker rmi 某个镜像的名字 #删除单个镜像
docker rmi 某个镜像的名字 某个镜像的名字 ... #删除多个镜像
docker rmi $(docker images -qa) #删除全部镜像
```
##### 删除镜像名和TAG为none的镜像
```shell
docker rmi -f $(docker images -f "dangling=true" -q)
```
> 在docker中有镜像才能创建容器，这是根本前提

##### 新建并启动容器(启动交互式容器)
```shell
docker run -it ....
docker run [options]
参数说明：
--name="容器新名字" 为容器指定一个名字
-d 在后台运行，并返回容器ID，即启动守护式容器
-i 以交互模式运行容器，通常与-t同时使用
-t 为容器重新分配一个伪输入终端，通常与-i同时使用
-P 随机指定端口映射
-p 指定端口映射，有以下四种格式：
  ip:hostPort:containerPort
  ip::containerPort
  hostPort:containerPort
  containerPort
```

#### 列出docker中运行的所有容器
```shell
docker ps
参数说明：
-a 列出当前所有正在运行的容器+历史上运行过的容器
-l 显示最近创建的容器
-n 显示最近n个创建的容器
-q 静默模式，只显示容器编号
--no-trunc 不截断输出
```
#### 退出容器
```shell
exit #容器停止运行
ctrl+P+Q #容器不停止退出
```
#### 启动容器
```shell
docker start containerID
```
#### 停止容器
```shell
docker stop containerID
```
#### 重启容器
```shell
docker restart containerID
```
#### 强制停止容器
```shell
docker kill containerID
```
#### 删除已停止的容器
```shell
docker rm containerID
## 一次性删除多个容器
docker rm $(docker ps -qa)
docker ps -qa | xargs docker rm
```
##### 新建并启动容器(启动守护式容器)
```shell
docker run -d ....
docker run [options]
参数说明：
--name="容器新名字" 为容器指定一个名字
-d 在后台运行，并返回容器ID，即启动守护式容器
-i 以交互模式运行容器，通常与-t同时使用
-t 为容器重新分配一个伪输入终端，通常与-i同时使用
-P 随机指定端口映射
-p 指定端口映射，有以下四种格式：
  ip:hostPort:containerPort
  ip::containerPort
  hostPort:containerPort
  containerPort
```
> 注意，运行 docker run -d centos，然后docker ps 发现容器已经退出，很重要的要说明一点：Docker容器后台运行，就必须要有一个前台进程。容器运行的命令如果不是那些一直挂起的命令（如top，tail），就是会自动退出的。这个是docker的机制问题，比如你的web容器，我们以nginx为例，正常情况下，我们配置启动服务只需要启动响应的service即可。例如：service nginx start
但是这样做，nginx为后台进程模式运行，就导致docker前台没有运行的应用，这样的容器后台启动后，会立即自杀，因为他觉得没事做了，所以，最佳的解决方案是，将你要运行的程序以前台进程的方式运行。

#### 查看容器日志
```shell
docker logs [options] 容器ID
参数说明：
-t 加入时间戳
-f 跟随最新的日志打印
--tail n n代表数字，显示最后多少条
```
#### 查看容器内运行的进程
```shell
docker top containerID
```
#### 查看容器内部细节
```shell
docker inspect containerID
```
#### 重新进入容器
> 注意：重新进去容器，是指以交互式启动容器，然后通过ctrl+P+Q（容器不停止退出）退出容器，然后再次进入容器

```shell
docker exec -it containerID /bin/bash
或者
docker attach containerID
```
功能上exec 比 attach 更强大，exec可以在容器外面直接执行命令。exec 是在容器中打开新的终端，并且可以启动新的进程。attach 直接进入容器启动命令的终端，不会启动新的进程

#### 从容器内拷贝文件到主机上
```shell
docker cp 容器ID:容器内的文件路径 目的主机路径
```
#### 从主机拷贝文件到容器
```shell
docker cp 主机文件路径 容器ID:容器内文件路径
```
#### 查看数据卷挂载
```sh
docker volume ls
```
#### 查看数据卷挂载详情
```sh
docker volume inspect VOLUM_NAME
```
#### docker删除所有悬空镜像，但不会删除未使用镜像
```sh
docker rmi -f $(docker images -f "dangling=true" -q)
```
#### 保存镜像
```sh
docker save [OPTIONS] IMAGE [IMAGE...]
参数说明：
--output, -o Write to a file, instead of STDOUT
例子：
docker save busybox > busybox.tar
docker save --output busybox.tar busybox
```
#### 加载镜像
```sh
docker load [OPTIONS]
参数说明：
--input, -i 从文件加载而非STDIN
--quiet, -q 静默加载（默认为false）
例子：
docker load < busybox.tar.gz
docker load --input fedora.tar
```
#### 创建桥接网络
```sh
docker network create --driver bridge isolated_nw
```
