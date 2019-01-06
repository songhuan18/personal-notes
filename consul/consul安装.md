#### 下载
```sh
sudo wget https://releases.hashicorp.com/consul/1.4.0/consul_1.4.0_linux_amd64.zip
```
#### 解压到指定目录
```sh
sudo unzip -d ../setups consul_1.4.0_linux_amd64.zip
```
#### 设置PATH
```sh
sudo mv ../setups/consul /usr/local/bin
```
#### 启动consul
```sh
sudo consul agent -dev -client 0.0.0.0 -ui &
```
