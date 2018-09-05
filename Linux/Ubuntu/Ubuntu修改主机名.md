# 修改主机名

## 脚本使用
```sh
sudo bash host.sh <新主机名> <原主机名>
# 示例
sudo bash host.sh ubuntu-1604-005 ubuntu
```
## 脚本内容
```sh
HOSTNAME=$1
OLD=$2
OLD=${OLD:-ubuntu}
sudo hostnamectl set-hostname $HOSTNAME
sudo sed -i "s/${OLD}/${HOSTNAME}/g" /etc/hosts
cat /etc/hosts
```
