# linux 初始配置

tumx 包管理器直接装

**查看防火墙状态，若是第一次打开防火墙时一定要添加ssh端口 ufw allow ssh**

快捷安装v2ray

- bash <(curl -L -s [https://install.direct/go.sh](https://install.direct/go.sh))
- sudo vim /etc/v2ray/config.json 修改客户端配置文件
- service v2ray stop
- service v2ray start
- alias setproxy='export ALL_PROXY=socks5://127.0.0.1:1081'
alias sethttp='export http_proxy="[http://127.0.0.1:8001](http://127.0.0.1:8001/)"; export HTTP_PROXY="[http://127.0.0.1:8001](http://127.0.0.1:8001/)"; export https_proxy="[http://127.0.0.1:8001](http://127.0.0.1:8001/)"; export HTTPS_PROXY="[http://127.0.0.1:8001](http://127.0.0.1:8001/)"'
alias unsetproxy="unset ALL_PROXY"   (后续追加 alias 到 .zshrc)
- curl [https://www.google.com](https://www.google.com) 测试是否成功（注意防火墙设置）

    

zsh 

[https://github.com/robbyrussell/oh-my-zsh/wiki/Installing-ZSH](https://github.com/robbyrussell/oh-my-zsh/wiki/Installing-ZSH)

centos

rpm -Uvh http://mirror.ghettoforge.org/distributions/gf/gf-release-latest.gf.el7.noarch.rpm
rpm --import http://mirror.ghettoforge.org/distributions/gf/RPM-GPG-KEY-gf.el7
yum -y remove zsh
yum -y --enablerepo=gf-plus install zsh

ohmyzsh

 [https://ohmyz.sh/](https://ohmyz.sh/)

p10k

 [https://github.com/romkatv/powerlevel10k](https://github.com/romkatv/powerlevel10k)

zsh-autosuggestions 

[https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md](https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md)

zsh-syntax-highlighting

[https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md](https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md)

（可选）furacode 本地终端字体

7th vim 

[https://github.com/dofy/7th-vim#install](https://github.com/dofy/7th-vim#install)

update VIM for centos

    rpm -Uvh http://mirror.ghettoforge.org/distributions/gf/gf-release-latest.gf.el7.noarch.rpm
    rpm --import http://mirror.ghettoforge.org/distributions/gf/RPM-GPG-KEY-gf.el7
    
    yum -y remove vim-minimal vim-common vim-enhanced
    yum -y --enablerepo=gf-plus install vim-enhanced sudo

autojump (centos yum install autojump-zsh,插件添加autojump)

- Debian, Ubuntu, Linux Mint
- All Debian-derived distros require manual activation for policy reasons, please see
- cat /`usr/share/doc/autojump/README.Debian`

sshkey 改端口，publickey 登录。禁用密码登录。（防火墙开新端口）