swagger
--------
访问地址: http://host:port/swagger-ui.html

开关项： "springdoc.api-docs.enabled" IN context.properies


设置本地配置文件
--------------
在 resources/config 下建立 local 目录，并酌情建立 app,context,server 三个 properties 文件（类似config/test）. 

该目录不会同步到 git 远端仓库，故不会对其他开发人员产生影响。

另在启动项目时需加上参数 spring.profiles.active=local

供参考的 context.properties

```properties
# 增加上下文配置项或覆盖上级 context.properties 的同名配置项

        logging.level.com.whjryf=DEBUG
        #It turned out if I set the following property empty, the file logging is disabled:
        logging.file=
        # Logging pattern for the console
        logging.pattern.console=%clr(%d{yy-MM-dd HH:mm:ss}){faint} %clr(%5p) %clr(-%marker-){faint} %clr(%-60.60logger{79}){cyan} %clr(:){faint} %m%n

        # 有色控制台日志必须的配置项
        spring.output.ansi.enabled=always

        swagger.enabled=true
```
