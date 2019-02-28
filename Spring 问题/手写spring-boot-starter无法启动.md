#### 问题描述
自己手写了一个spring-boot-starter无法启动，自动装配采用构造方法的方式，代码如下：
```Java
private final PermissionProperties permissionProperties;
private final RestTemplate restTemplate;

@Autowired
public PermissionAutoConfiguration(PermissionProperties permissionProperties, RestTemplate restTemplate) {
    this.permissionProperties = permissionProperties;
    this.restTemplate = restTemplate;
}
```
> 将final去掉之后还是无法启动

修改代码之后可以正常启动，代码如下：
```java
@Autowired
private PermissionProperties permissionProperties;
@Autowired
private RestTemplate restTemplate;
```
不知道什么原因导致的
