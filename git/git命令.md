##### git忽略某个文件(discard)
```sh
git checkout -- fileName
```

### 通过Token在gitlab上拉取代码
> 不通过密码和公钥拉取代码

- 在git上配置访问令牌
- 拉取代码的地址为：git clone http://<username>:<deploy_token>@gitlab.example.com/tanuki/awesome_project.git
```
#示例地址：
git clone http://songhuan:sMrt5TK2KsEDa1XxGsKE@192.168.10.200/hy/lysh/hy-lysh-merchant-manage.git
```
