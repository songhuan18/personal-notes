### 问题描述
Java 实体对象中定义字段类型为LocalDateTime，Mysql类型为datetime，通过MyBatis进行映射的时候报错，报错如下：
```
org.springframework.dao.InvalidDataAccessApiUsageException: Error attempting to get column 'happen_time' from result set.  Cause: java.sql.SQLFeatureNotSupportedException
; null; nested exception is java.sql.SQLFeatureNotSupportedException
	at org.springframework.jdbc.support.SQLExceptionSubclassTranslator.doTranslate(SQLExceptionSubclassTranslator.java:96) ~[spring-jdbc-5.1.8.RELEASE.jar:5.1.8.RELEASE]
	at org.springframework.jdbc.support.AbstractFallbackSQLExceptionTranslator.translate(AbstractFallbackSQLExceptionTranslator.java:72) ~[spring-jdbc-5.1.8.RELEASE.jar:5.1.8.RELEASE]
	at org.springframework.jdbc.support.AbstractFallbackSQLExceptionTranslator.translate(AbstractFallbackSQLExceptionTranslator.java:81) ~[spring-jdbc-5.1.8.RELEASE.jar:5.1.8.RELEASE]
	at org.mybatis.spring.MyBatisExceptionTranslator.translateExceptionIfPossible(MyBatisExceptionTranslator.java:73) ~[mybatis-spring-2.0.1.jar:2.0.1]
	at
  .....
```
Environment：
```
druid-spring-boot-starter: 1.1.20
mybatis-plus-boot-starter: 3.1.2
mysql-connector-java: 8.0.15
```
之前在网上找资料看到有通过引用mybatis-typehandlers-jsr310，并在对应的属性上配置@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
```
<!--<dependency>-->
    <!--<groupId>org.mybatis</groupId>-->
    <!--<artifactId>mybatis-typehandlers-jsr310</artifactId>-->
    <!--<version>1.0.2</version>-->
<!--</dependency>-->
```
其实造成这个原因主要是druid的bug问题，只需要将`druid`的版本改为`1.1.21`(包括)之上就好了
