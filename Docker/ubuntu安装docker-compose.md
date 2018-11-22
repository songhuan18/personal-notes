##### 安装docker-compose
```sh
sudo curl -L "https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m)"  -o /usr/local/bin/docker-compose
cd /usr/local/bin
sudo mv ./docker-compose /usr/bin/docker-compose
sudo chmod +x /usr/bin/docker-compose
```
##### 卸载docker-compose
```sh
sudo rm /usr/local/bin/docker-compose
```
