##### Spring获取配置文件信息入口
```
org.springframework.boot.SpringApplication#run(java.lang.String...)
org.springframework.boot.SpringApplication#prepareEnvironment
org.springframework.boot.SpringApplicationRunListeners#environmentPrepared
org.springframework.boot.SpringApplicationRunListener#environmentPrepared
org.springframework.context.event.SimpleApplicationEventMulticaster#multicastEvent(org.springframework.context.ApplicationEvent)
....
org.springframework.boot.context.config.ConfigFileApplicationListener.Loader#getSearchLocations()
```
