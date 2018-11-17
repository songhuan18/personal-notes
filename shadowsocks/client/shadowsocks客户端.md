> 背景：阿里云服务器拉取github上的代码很慢，所以配置git代理

##### 制作镜像
```sh
docker build -t proxy .
```
##### 启动容器
```sh
docker run -d --name proxy -p 8888:8123 -p 6666:1080 -e PORT=VPN_PORT -e IP=VPN_SERVER -e PASSWORD=VPN_PASSWORD proxy:latest
```
##### 设置git使用代理
```sh
# 设置http代理
git config --global http.proxy http://127.0.0.1:8888
# 设置socket5代理
git config --global https.proxy 'socks5://127.0.0.1:1080'
```
##### 删除http代理
```sh
git config --global --unset http.proxy
```
