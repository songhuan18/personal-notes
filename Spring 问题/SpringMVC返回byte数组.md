#### 问题描述
SpringMVC 返回byte数组时，最终无法进入到被@ControllerAdvice修饰的类，也就是无法进入方法beforeBodyWriteInternal()，返回其他对象或者基本类型则正常。

#### 解决问题
- 跟踪对返回值处理的源码

第一步，调用org.springframework.web.method.support.HandlerMethodReturnValueHandlerComposite#handleReturnValue方法
```java
	@Override
	public void handleReturnValue(Object returnValue, MethodParameter returnType,
			ModelAndViewContainer mavContainer, NativeWebRequest webRequest) throws Exception {

		HandlerMethodReturnValueHandler handler = selectHandler(returnValue, returnType);
		if (handler == null) {
			throw new IllegalArgumentException("Unknown return value type: " + returnType.getParameterType().getName());
		}
		// 执行该方法
		handler.handleReturnValue(returnValue, returnType, mavContainer, webRequest);
	}
```
第二步，调用org.springframework.web.servlet.mvc.method.annotation.RequestResponseBodyMethodProcessor#handleReturnValue方法

源码：
```java
	@Override
	public void handleReturnValue(Object returnValue, MethodParameter returnType,
			ModelAndViewContainer mavContainer, NativeWebRequest webRequest)
			throws IOException, HttpMediaTypeNotAcceptableException, HttpMessageNotWritableException {

		mavContainer.setRequestHandled(true);
		ServletServerHttpRequest inputMessage = createInputMessage(webRequest);
		ServletServerHttpResponse outputMessage = createOutputMessage(webRequest);

		// Try even with null return value. ResponseBodyAdvice could get involved.
		// 可以处理空值
		// 执行该方法
		writeWithMessageConverters(returnValue, returnType, inputMessage, outputMessage);
	}
```
第三步，调用org.springframework.web.servlet.mvc.method.annotation.AbstractMessageConverterMethodProcessor#writeWithMessageConverters方法

部分源码：
```java
if (selectedMediaType != null) {
	selectedMediaType = selectedMediaType.removeQualityValue();
	for (HttpMessageConverter<?> messageConverter : this.messageConverters) {
		if (messageConverter instanceof GenericHttpMessageConverter) {
			if (((GenericHttpMessageConverter) messageConverter).canWrite(
					declaredType, valueType, selectedMediaType)) {
				outputValue = (T) getAdvice().beforeBodyWrite(outputValue, returnType, selectedMediaType,
						(Class<? extends HttpMessageConverter<?>>) messageConverter.getClass(),
						inputMessage, outputMessage);
				if (outputValue != null) {
					addContentDispositionHeader(inputMessage, outputMessage);
					((GenericHttpMessageConverter) messageConverter).write(
							outputValue, declaredType, selectedMediaType, outputMessage);
					if (logger.isDebugEnabled()) {
						logger.debug("Written [" + outputValue + "] as \"" + selectedMediaType +
								"\" using [" + messageConverter + "]");
					}
				}
				return;
			}
		}
		// 如果返回的是byte数组，执行到该if判断时，返回的true，所以继续向下执行
		else if (messageConverter.canWrite(valueType, selectedMediaType)) {
			outputValue = (T) getAdvice().beforeBodyWrite(outputValue, returnType, selectedMediaType,
					(Class<? extends HttpMessageConverter<?>>) messageConverter.getClass(),
					inputMessage, outputMessage);
			if (outputValue != null) {
				addContentDispositionHeader(inputMessage, outputMessage);
				((HttpMessageConverter) messageConverter).write(outputValue, selectedMediaType, outputMessage);
				if (logger.isDebugEnabled()) {
					logger.debug("Written [" + outputValue + "] as \"" + selectedMediaType +
							"\" using [" + messageConverter + "]");
				}
			}
			return;
		}
	}
}
```
第四步，调用rg.springframework.web.servlet.mvc.method.annotation.Request.ResponseBodyAdviceChain#processBody
```java
@SuppressWarnings("unchecked")
private <T> Object processBody(Object body, MethodParameter returnType, MediaType contentType,
    Class<? extends HttpMessageConverter<?>> converterType,
    ServerHttpRequest request, ServerHttpResponse response) {

  for (ResponseBodyAdvice<?> advice : getMatchingAdvice(returnType, ResponseBodyAdvice.class)) {
    if (advice.supports(returnType, converterType)) {
      // 如果执行，最终可执行被@ControllerAdvice所修饰的类中的方法
      body = ((ResponseBodyAdvice<T>) advice).beforeBodyWrite((T) body, returnType,
          contentType, converterType, request, response);
    }
  }
  return body;
}

```
回到第三步，如果else if 判断执行为true，那么messageConverter.getClass()获取的类型为：
org.springframework.http.converter.ByteArrayHttpMessageConverter，而第四步源码中converterType的类型必须为：org.springframework.http.converter.json.MappingJackson2HttpMessageConverter，否则if判断为false，无法执行beforeBodyWrite，因而也就无法执行方法beforeBodyWriteInternal(),如果SpringMVC最终返回值是byte数组，那么converType的类型为：org.springframework.http.converter.ByteArrayHttpMessageConverter，最终导致if判断为false，所以最后终无法调用到beforeBodyWriteInternal()方法
- 解决办法

原调用方法：
```java
@GetMapping("/byte")
public byte[] getImageByte(String groupName, String remoteFileName) {
    byte[] bytes = fastDFSClient.getImageBytes(groupName, remoteFileName);
    return bytes;
}
```
将返回的byte数组，封装在一个对象里面返回，然后就可以正常调用ByteArrayHttpMessageConverter，最终导致if判断为false，所以最后终无法调用到方法beforeBodyWriteInternal()方法了。

修改之后：
```java
@GetMapping("/byte")
public ImageByteVo getImageByte(String groupName, String remoteFileName) {
    byte[] bytes = fastDFSClient.getImageBytes(groupName, remoteFileName);
    return new ImageByteVo().setImageByte(bytes);
}
```
ImageByteVo 对象
```java
@Data
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
public class ImageByteVo {
    private byte[] imageByte;
}

```
