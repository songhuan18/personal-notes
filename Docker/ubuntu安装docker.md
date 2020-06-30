##### 卸载旧版本
```sh
sudo apt-get remove docker \
               docker-engine \
               docker.io
```
##### 使用 APT 安装
```sh
sudo apt-get update

sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
```
> 在安装过程中如果出现：The following packages have unmet dependencies:
 curl : Depends: libcurl3-gnutls (= 7.47.0-1ubuntu2.14) but 7.58.0-2ubuntu3.2 is to be installed
E: Unable to correct problems, you have held broken packages.

##### 解决办法
```sh
#执行以下命令
sudo apt-get purge  libcurl3-gnutls
sudo apt-get install curl
```

##### 修改国内源
```sh
curl -fsSL https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu/gpg | sudo apt-key add -
```
##### 将docker软件源加入source.list
```sh
sudo add-apt-repository \
    "deb [arch=amd64] https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu \
    $(lsb_release -cs) \
    stable"
```
##### 安装 Docker CE
```sh
sudo apt-get update
sudo apt-get install docker-ce
```
##### 启动 Docker CE
```sh
sudo systemctl enable docker
sudo systemctl start docker
```
##### 将当前用户加入 docker 组
```sh
sudo usermod -aG docker $USER
```
