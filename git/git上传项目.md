##### 说明
首先保证GitHub或者GitLab上已创建好项目，只是需要将本地项目Push到GitHub或者GitLab即可
#### 1. 上传
进入到对应的项目文件，按顺序执行以下命令
```shell
git init
git add .
git commit -m '这是我的第一次提交'
git remote add origin https://github.com/Asltw/personal-notes.git
git push origin master
```
如果执行git remote add origin https://github.com/Asltw/personal-notes.git，出现错误：
```
fatal: remote origin already exists
```
则执行以下命令
```shell
git remote rm origin
```
再往后继续执行
```shell
git remote add origin https://github.com/Asltw/personal-notes.git
```
如果再报错，则执行以下命令：
```shell
git pull origin master
```
#### 2. 删除GitHub或GitLab上多余的文件
进入到对应项目文件夹，执行以下命令删除文件(是在Master上进行的操作)
```shell
git rm -r --cached  文件
```
最后执行
```shell
git pull origin master
git push origin master
```
#### 3. 解决在SmartGit上无法Pull项目
或者报错
```
Can't update: no tracked branch
No tracked branch configured for branch master.
To make your branch track a remote branch call, for example,git branch --set-upstream master
```
执行如下命令
```shell
git branch --set-upstream-to=origin/master
```
