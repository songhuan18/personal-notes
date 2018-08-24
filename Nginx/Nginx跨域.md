##### nginx跨域配置
只需要在nginx配置文件里加入以下配置即可开启跨域

```config
location / {  
    add_header Access-Control-Allow-Origin *;
}
```
说明：* 代表任何域都可以访问，可以改成只允许某个域访问，比如：Access-Control-Allow-Origin:http:://www.xxx.com

以上的配置虽然开启了跨域请求，但是只支持GET HEAD POST OPTIONS请求，使用DELETE发起跨域请求时，浏览器出于安全考虑会先发起OPTIONS请求，服务器端接收到的请求方式就变成了OPTIONS，所以引起了服务器的405 Method Not Allowed。

解决办法：对OPTIONS请求进行处理
```config
if ($request_method = 'OPTIONS') {
    add_header Access-Control-Allow-Origin *;
    add_header Access-Control-Allow-Methods GET,POST,PUT,DELETE,OPTIONS;
    #其他头部信息配置，省略...
    return 204;
}
```
##### 完整配置
```config
add_header Access-Control-Allow-Origin *;// 放到配置文件的server {}里
location / {
    if ($request_method = 'OPTIONS') {
        add_header Access-Control-Allow-Origin *;
        add_header Access-Control-Allow-Methods GET,POST,PUT,DELETE,OPTIONS;
        return 204;
    }
    root   html;
    index  index.html index.htm;
}
```
