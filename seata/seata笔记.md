##### io.seata.codec.protobuf.generated不存在，导致seata server启动不了?
本地执行下: ./mvnw clean install -DskipTests=true (Mac,Linux) 或 mvnw.cmd clean install -DskipTests=true (Win), 参考issues/2438,相关代码在0.8.1已经移除

##### 如何自己修改源码后打包seata-server?
- 删除 distribution 模块的bin、conf和lib目录
- ./mvnw clean install -DskipTests=true(Mac,Linux) 或 mvnw.cmd clean install -DskipTests=true(Win) -P release-seata。
- 在 distribution 模块的 target 目录下解压相应的压缩包即可。
