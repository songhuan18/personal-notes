##### 制作镜像
```sh
docker build -t proxy .
```
##### 启动容器
```sh
docker run  -p 8388:8388 --name proxy -d -e PASSWORD=your_password  --restart=always  proxy:latest
```
