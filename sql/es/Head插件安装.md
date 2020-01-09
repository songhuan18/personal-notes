##### 安装node和npm环境
```sh
wget https://nodejs.org/download/release/v8.13.0/node-v8.13.0-linux-x64.tar.gz
tar -zxvf node-v8.13.0-linux-x64.tar
解压后的路径：/apps/svr/node-v8.13.0
建立软连接
ln -s /apps/svr/node-v8.13.0/bin/node /usr/bin/node
ln -s /apps/svr/node-v8.13.0/bin/npm /usr/bin/npm
执行完后 运行 node -v 和 npm -v 分别就可以看到node 的版本为8.13.0 npm为6.4.1
```
##### 安装Head插件
```sh
下载地址：https://github.com/mobz/elasticsearch-head/
git clone git://github.com/mobz/elasticsearch-head.git
cd elasticsearch-head
npm install（修改下npm源： npm config set registry https://registry.npm.taobao.org ） 或者使用： npm install cnpm -g --	registry=https://registry.npm.taobao.org
注意：//如果使用了 cnpm  那么就要 用 cnpm install（如果没有建立软连接还需要指定cnpm所在的位置： ../node-v8.13.0/bin/cnpm install ）
npm run start  
访问：http://你的ip:9100/
```
