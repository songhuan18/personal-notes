#### 问题描述
SpringMVC 返回byte数组时，最终无法进入到被@ControllerAdvice修饰的类，也就是无法进入方法beforeBodyWriteInternal()，返回对象或者其他基本类型则正常。

#### 解决问题
- 调试源码

```java
方法调用：org.springframework.web.servlet.mvc.method.annotation.Request.ResponseBodyAdviceChain#processBody
@SuppressWarnings("unchecked")
private <T> Object processBody(Object body, MethodParameter returnType, MediaType contentType,
    Class<? extends HttpMessageConverter<?>> converterType,
    ServerHttpRequest request, ServerHttpResponse response) {

  for (ResponseBodyAdvice<?> advice : getMatchingAdvice(returnType, ResponseBodyAdvice.class)) {
    if (advice.supports(returnType, converterType)) {
      body = ((ResponseBodyAdvice<T>) advice).beforeBodyWrite((T) body, returnType,
          contentType, converterType, request, response);
    }
  }
  return body;
}

```
converterType的类型必须为：org.springframework.http.converter.json.MappingJackson2HttpMessageConverter，否则if判断为false，无法执行beforeBodyWrite，因而也就无法执行方法beforeBodyWriteInternal(),如果SpringMVC最终返回值是byte数组，那么converType的类型为：org.springframework.http.converter.ByteArrayHttpMessageConverter，最终导致if判断为false，所以最后终无法调用到beforeBodyWriteInternal()方法
- 解决办法

将返回的byte数组，封装在一个对象里面返回，然后就可以正常调用ByteArrayHttpMessageConverter，最终导致if判断为false，所以最后终无法调用到方法beforeBodyWriteInternal()方法了。
