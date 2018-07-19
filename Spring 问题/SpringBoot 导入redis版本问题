#### 问题描述
> SpringBoot版本为1.5.9

在pom.xml文件中加入依赖，如下：
```xml
<dependency>
     <groupId>org.springframework.boot</groupId>
     <artifactId>spring-boot-starter-redis</artifactId>
 </dependency>
```
发现依赖无法下载到maven本地仓库，仓库里面只有一个"unknow"的文件

> 在1.5版本就无法向上面这样引用依赖，在1.4版本的日志更新中有这样一段说明

```
Renamed starters
The following starters have been renamed, the old ones will be removed in Spring Boot 1.5

spring-boot-starter-ws → spring-boot-starter-web-services
spring-boot-starter-redis → spring-boot-starter-data-redis
```
上面大体的意思就是：以下的starters已经被重新命令，老的版本在1.5会被移除掉。

当使用1.5+版本的时候应该用如下依赖：
```xml
<dependency>
       <groupId>org.springframework.boot</groupId>
       <artifactId>spring-boot-starter-data-redis </artifactId>
</dependency>
```
