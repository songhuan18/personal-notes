#### 环境准备
- 系统环境：Ubuntu16.04 x86_64
- 内核
```
Distributor ID:	Ubuntu
Description:	Ubuntu 16.04.3 LTS
Release:	16.04
Codename:	xenial
```
- jdk1.8.181
- hadoop版本：hadoop-2.7.2
- 三台虚拟机，ip分别为：192.168.10.237、192.168.10.211、192.168.10.236
- hostname分别对应为：hadoop237、hadoop211、hadoop238

#### 下载
```sh
cd /usr/local/bin
sudo wget https://releases.hashicorp.com/consul/1.4.0/consul_1.4.0_linux_amd64.zip
```
#### 解压
```sh
sudo unzip consul_1.4.0_linux_amd64.zip
sudo rm -f consul_1.4.0_linux_amd64.zip
```
#### 创建以下目录
```sh
sudo mkdir -p /etc/consul.d/scripts
sudo mkdir /var/consul
```
#### 创建秘钥
```sh
consul keygen
```
> 保存起来，等下会用

#### 创建配置文件
```sh
sudo vim /etc/consul.d/config.json
# 在文件中增加以下内容
{
    "advertise_addr": "当前机器ip",
    "bind_addr": "当前机器ip",
    "bootstrap_expect": 3,
    "client_addr": "0.0.0.0",
    "datacenter": "zh-Central",
    "data_dir": "/var/consul",
    "domain": "consul",
    "enable_script_checks": true,
    "dns_config": {
        "enable_truncate": true,
        "only_passing": true
    },
    "enable_syslog": true,
    "encrypt": "goplCZgdmOFMZ2Q43To0jw==",# 上一步生成的秘钥，每台服务器上的encrypt一样
    "leave_on_terminate": true,
    "log_level": "INFO",
    "rejoin_after_leave": true,
    "retry_join": [
      "192.168.10.237",
      "192.168.10.211",
      "192.168.10.236"
    ],
    "server": true,
    "start_join": [
        "192.168.10.237",
        "192.168.10.211",
        "192.168.10.236"
    ],
    "ui": true
}
```
#### 创建consul service
```sh
sudo vim /etc/systemd/system/consul.service
# 新增一下内容
[Unit]
Description=Consul Startup process
After=network.target

[Service]
Type=simple
ExecStart=/bin/bash -c '/usr/local/bin/consul agent -config-dir /etc/consul.d/'
TimeoutStartSec=0

[Install]
WantedBy=default.target
```
#### 重新加载system daemons
```sh
sudo systemctl daemon-reload
```
#### 启动consul
```sh
sudo systemctl start consul
```
#### 查看集群状态
```sh
/usr/local/bin/consul members
```
> 按照上述步骤依次在另外两台机器上启动

#### 访问consul ui
```
http://consul_ip:8500/ui
```
