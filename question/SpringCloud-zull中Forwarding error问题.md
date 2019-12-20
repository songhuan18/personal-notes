#### 问题描述
通过SpringCloud zuul 调用其他服务报错：
```java
com.netflix.zuul.exception.ZuulException: Forwarding error
at org.springframework.cloud.netflix.zuul.filters.route.RibbonRoutingFilter.handleException(RibbonRoutingFilter.java:158) ~[spring-cloud-netflix-c
at org.springframework.cloud.netflix.zuul.filters.route.RibbonRoutingFilter.forward(RibbonRoutingFilter.java:133) ~[spring-cloud-netflix-core-1.1.
at org.springframework.cloud.netflix.zuul.filters.route.RibbonRoutingFilter.run(RibbonRoutingFilter.java:79) ~[spring-cloud-netflix-core-1.1.6.REL
at com.netflix.zuul.ZuulFilter.runFilter(ZuulFilter.java:112) ~[zuul-core-1.1.0.jar!/:1.1.0]
at com.netflix.zuul.FilterProcessor.processZuulFilter(FilterProcessor.java:197) ~[zuul-core-1.1.0.jar!/:1.1.0]
at com.netflix.zuul.FilterProcessor.runFilters(FilterProcessor.java:161) ~[zuul-core-1.1.0.jar!/:1.1.0]
at com.netflix.zuul.FilterProcessor.route(FilterProcessor.java:120) ~[zuul-core-1.1.0.jar!/:1.1.0]
at com.netflix.zuul.ZuulRunner.route(ZuulRunner.java:96) ~[zuul-core-1.1.0.jar!/:1.1.0]
at com.netflix.zuul.http.ZuulServlet.route(ZuulServlet.java:116) ~[zuul-core-1.1.0.jar!/:1.1.0]
at com.netflix.zuul.http.ZuulServlet.service(ZuulServlet.java:81) ~[zuul-core-1.1.0.jar!/:1.1.0]
```
熔断超时导致，默认返回结果时间为1000ms

设置：
```yml
hystrix:
  command:
    default:
      execution:
        timeout:
        isolation:
          thread:
            timeoutInMilliseconds: 60000

ribbon:
  ReadTimeout: 60000
  connection-timeout: 3000
```
启动之后配置未生效

SpringBoot和SpringCloud版本如下
```xml
<groupId>org.springframework.boot</groupId>
<artifactId>spring-boot-starter-parent</artifactId>
<version>1.5.9.RELEASE</version>
</parent>
<dependencyManagement>
<dependencies>
    <dependency>
        <groupId>org.springframework.cloud</groupId>
        <artifactId>spring-cloud-dependencies</artifactId>
        <version>Edgware.RELEASE</version>
        <type>pom</type>
        <scope>import</scope>
    </dependency>
    <dependency>
        <groupId>org.projectlombok</groupId>
        <artifactId>lombok</artifactId>
        <version>1.12.6</version>
    </dependency>
</dependencies>
</dependencyManagement>
```
原因：SpringCloud的Edgware.RELEASE版本有bug，将版本改为：Edgware.SR4即可
