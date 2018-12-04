
> Docker版本：Docker version 18.09.0

##### 开启远程api
1. 编辑/lib/systemd/system/docker.service文件
```sh
sudo vim /lib/systemd/system/docker.service
# 将 ExecStart=/usr/bin/dockerd -H unix:// 修改为：
ExecStart=/usr/bin/dockerd -H unix:///var/run/docker.sock -H tcp://0.0.0.0:2375
```
##### 重启服务
```sh
sudo systemctl daemon-reload
sudo service docker restart
```
在浏览器输入：http://ip:2375/images/json 即可访问到所有镜像
