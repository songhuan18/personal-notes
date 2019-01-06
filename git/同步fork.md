### 同步fork
fork了别人仓库之后，同步更新作者的代码到本地。
#### 配置
在你通过上游仓库同步你的fork之前，你必须配置一个remote指向你的上游仓库
- 添加一个远程指向你的上游仓库
```sh
git remote add upstream https://github.com/spring-projects/spring-framework.git
```
- 通过上游仓库获取分支和提交
```sh
git fetch upstream
```
- 切换到本地主分支
```sh
git checkout master
```
- 把 upstream/master 分支合并到本地 master 上
```sh
git merge upstream/master
```
> 至此，完成将源仓库代码更新到了本地
