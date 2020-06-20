##### 安装docker-compose
```sh
sudo curl -L "https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
# 如果下载太慢，可以改用已下地址
sudo curl -L "https://get.daocloud.io/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose
```
##### 卸载docker-compose
```sh
sudo rm /usr/local/bin/docker-compose
```
