##### mac安装gradle
```sh
brew install gradle
```
安装时报错：
```sh
Error: The following directories are not writable by your user:
/usr/local/share/man/man8

You should change the ownership of these directories to your user.
  sudo chown -R $(whoami) /usr/local/share/man/man8
```
解决办法：
```sh
1.进入目录
cd /usr/local/share/man
drwxr-xr-x  61 songhuan  admin   2.0K  7 13 11:18 man1
drwxr-xr-x   2 songhuan  admin    68B  9 28 21:09 man2
drwxr-xr-x   2 songhuan  admin    68B  9 28 21:09 man3
drwxr-xr-x   2 songhuan  admin    68B  9 28 21:09 man4
drwxr-xr-x   9 songhuan  admin   306B  7 13 11:18 man5
drwxr-xr-x   2 songhuan  admin    68B  9 28 21:09 man6
drwxr-xr-x  11 songhuan  admin   374B  7 13 11:18 man7
drwxr-xr-x   7 root      admin   238B 12 10  2017 man8
-rw-r--r--   1 root      admin   4.7K  9 25 09:40 whatis
2.改变man8所属为songhuan
sudo chown -R songhuan man8
```
##### mac gradle镜像加速
在目录/Users/songhuan/.gradl下添加init.gradle

init.gradle文件内容：
```
allprojects{
    repositories {
        def ALIYUN_REPOSITORY_URL = 'http://maven.aliyun.com/nexus/content/groups/public'
        def ALIYUN_JCENTER_URL = 'http://maven.aliyun.com/nexus/content/repositories/jcenter'
        all { ArtifactRepository repo ->
            if(repo instanceof MavenArtifactRepository){
                def url = repo.url.toString()
                if (url.startsWith('https://repo1.maven.org/maven2')) {
                    project.logger.lifecycle "Repository ${repo.url} replaced by $ALIYUN_REPOSITORY_URL."
                    remove repo
                }
                if (url.startsWith('https://jcenter.bintray.com/')) {
                    project.logger.lifecycle "Repository ${repo.url} replaced by $ALIYUN_JCENTER_URL."
                    remove repo
                }
            }
        }
        maven {
                url ALIYUN_REPOSITORY_URL
            url ALIYUN_JCENTER_URL
        }
    }
}
```
##### mac下载的依赖包所在位置
```
/Users/songhuan/.gradle/caches/modules-2/files-2.1
```
