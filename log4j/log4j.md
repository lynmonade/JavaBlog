# log4j环境搭建
* 第一步：在项目中引入log4j的jar包，就一个jar包。
* 第二步：编写log4j.properties文件，放在src目录下。（网上也有现成的）

```java
//一个简单的例子
public class Client {
	private static Logger logger = Logger.getLogger(Client.class);
	public static void main(String[] args) {
		//debug级别的信息
		logger.debug("This is debug message");
		//info级别的信息
		logger.info("This is info message");
		//error级别的信息
		logger.error("This is error message");
	}
}

//log4j.properties
log4j.rootLogger=debug,appender1
log4j.appender.appender1=org.apache.log4j.ConsoleAppender
log4j.appender.appender1.layout=org.apache.log4j.TTCCLayout
```
# log4j基本概念
log4j主要包含3个部分：

1. 日志信息的优先级
2. 日志信息的输出目的地
3. 日志信息的输出格式

## 优先级
低 ALL < DEBUG < INFO <WARN < ERROR < FATAL < OFF 高

```properties
log4j.rootLogger = 2console, 2file

# 表示优先级大于等于INFO，即INFO, WARN, ERROR, FATAL, OFF
log4j.appender.2file.Threshold = INFO
```


## 目的地：
* Logger - 日志写出器，供程序员输出日志信息
* Appender - 日志目的地，把格式化好的日志信息输出到指定的地方去
* ConsoleAppender - 目的地为控制台的 Appender
* FileAppender - 目的地为文件的 Appender
* RollingFileAppender - 目的地为大小受限的文件的 Appender
* Layout - 日志格式化器，用来把程序员的 logging request 格式化成字符串
* PatternLayout - 用指定的 pattern 格式化 logging request 的 Layout

```java
org.apache.log4j.ConsoleAppender（控制台），
org.apache.log4j.FileAppender（文件），
org.apache.log4j.DailyRollingFileAppender（每天产生一个日志文件），
org.apache.log4j.RollingFileAppender（文件大小到达指定尺寸的时候产生一个新的文件），
org.apache.log4j.WriterAppender（将日志信息以流格式发送到任意指定的地方）
```

## 格式化
```java
org.apache.log4j.HTMLLayout（以 HTML 表格形式布局），
org.apache.log4j.PatternLayout（可以灵活地指定布局模式），
org.apache.log4j.SimpleLayout（包含日志信息的级别和信息字符串），
org.apache.log4j.TTCCLayout（包含日志产生的时间、线程、类别等等信息）
```
# 常用配置
```properties
log4j.rootLogger = 2console, 2file, 2dailyfile, 2maxfile

# ALL < DEBUG < INFO <WARN < ERROR < FATAL < OFF

# to console
log4j.appender.stdout = org.apache.log4j.ConsoleAppender
log4j.appender.stdout.Target = System.out
log4j.appender.stdout.layout = org.apache.log4j.PatternLayout
log4j.appender.stdout.layout.ConversionPattern =  %d{ABSOLUTE} %5p %c{ 1 }:%L - %m%n

# to normal file
log4j.appender.2file = org.apache.log4j.DailyRollingFileAppender
log4j.appender.2file.File = logs/normal_log.log
log4j.appender.2file.Append = true
# means bigger than INFO: INFO, WARN, ERROR, FATAL, OFF
log4j.appender.2file.Threshold = INFO
log4j.appender.2file.layout = org.apache.log4j.PatternLayout
log4j.appender.2file.layout.ConversionPattern = %-d{yyyy-MM-dd HH:mm:ss}  [ %t:%r ] - [ %p ]  %m%n

# to daily file
log4j.appender.2dailyfile = org.apache.log4j.DailyRollingFileAppender
log4j.appender.2dailyfile.File = logs/daily_error.log 
log4j.appender.2dailyfile.Append = true
# means bigger than ERROR: ERROR, FATAL, OFF
log4j.appender.2dailyfile.Threshold = ERROR 
log4j.appender.2dailyfile.layout = org.apache.log4j.PatternLayout
log4j.appender.2dailyfile.layout.ConversionPattern = %-d{yyyy-MM-dd HH:mm:ss}  [ %t:%r ] - [ %p ]  %m%

# to max file
log4j.appender.2maxfile=org.apache.log4j.RollingFileAppender 
log4j.appender.2maxfile.Threshold=ERROR 
log4j.appender.2maxfile.File=logs/rolling.log 
log4j.appender.2maxfile.Append=true 
log4j.appender.2maxfile.MaxFileSize=3KB
log4j.appender.2maxfile.MaxBackupIndex=1 
log4j.appender.2maxfile.layout=org.apache.log4j.PatternLayout 
log4j.appender.2maxfile.layout.ConversionPattern= %-d{yyyy-MM-dd HH:mm:ss}  [ %t:%r ] - [ %p ]  %m%
```

# log4j接管tomcat日志

## 步骤

第一步：编写log4j.properties配置文件

第二步：去tomcat官网下载下面两个jar包，注意tomcat的版本号，比如我的是tomcat7.0.37，所以去[这里下载](http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.37/bin/extras/),

* tomcat-juli.jar
* tomcat-juli-adapters.jar

第三步：更新tomcat的文件：（注意保留原文件）

* tomcat-juli.jar放到TOMCAT_HOME/bin下面
* tomcat-juli-adapters.jar、log4j-1.2.14.jar、log4j.properties放到TOMCAT_HOME/lib下面

第四步：修改tomcat配置文件（非常重要）：TOMCAT_HOME/conf/context.xml的`<Context>`修改为`<Context swallowOutput="true">`

第五步：删除TOMCAT_HOME/conf/logging.properties文件。

第六步：把log4j-1.2.14.jar引入到项目的build path中。把log4j.properties放到项目的src目录下。

## 注意事项：

（1）如果你在eclipse已经引入了tomcat，然后再去做`<Context swallowOutput="true">`修改的话，这样是无法生效的，只要你在eclipse的tomcat上点一下clean，TOMCAT_HOME/conf/context.xml文件又会恢复原样。最好的做法是：把原先在eclipse中配置的tomcat删除，接着修改tomcat配置文件，最后在eclipse添加tomcat。

（2）开发阶段把日志打印到eclipse的控制台，日志等级为DEBUG。部署阶段把日志写到TOMCAT_HOME/logs/XXX.log文件，日志等级为INFO。

（3）无论日志打印到哪，都建议在log4j.properties配置文件中保留**把日志打印到控制台**的配置。

## log4j.properties推荐配置

```properties
#定义根级别
log4j.rootLogger=INFO,info,warn,error,debug
 
#指定org.springframework包下面的类的日志级别为debug
#log4j.logger.org.springframework=DEBUG
#log4j.logger.org.apache.ibatis=DEBUG
log4j.logger.com.lyn=DEBUG
 
#控制台输出生成阶段注释
log4j.appender.debug=org.apache.log4j.ConsoleAppender
log4j.appender.debug.Threshold=DEBUG
log4j.appender.debug.layout=org.apache.log4j.PatternLayout
log4j.appender.debug.layout.ConversionPattern=%-d{MM-ddHH:mm:ss}-[%p][%c{3}]%m%n
#log4j.appender.debug.filter.infoFilter.LevelMin=DEBUG
#log4j.appender.debug.filter.infoFilter.LevelMax=DEBUG

###info级别输出
log4j.appender.info=org.apache.log4j.DailyRollingFileAppender
log4j.appender.info.File=${catalina.home}/logs/infrastructure/info.log
log4j.appender.info.Append=true
log4j.appender.info.Threshold=info
log4j.appender.info.layout=org.apache.log4j.PatternLayout
log4j.appender.info.layout.ConversionPattern=%-d{MM-ddHH:mm:ss}-[%p][%c]%m%n
log4j.appender.info.datePattern='.'yyyy-MM-dd
#Buffer单位为字节，默认是8K，IOBLOCK大小默认也是8K
#log4j.appender.info.BufferSize=8192
#log4j.appender.info.BufferedIO=true
#定制过滤器只过滤info级别
log4j.appender.info.filter.infoFilter=org.apache.log4j.varia.LevelRangeFilter
log4j.appender.info.filter.infoFilter.LevelMin=INFO
log4j.appender.info.filter.infoFilter.LevelMax=INFO
 
###warn级别输出
log4j.appender.warn=org.apache.log4j.DailyRollingFileAppender
log4j.appender.warn.File=${catalina.home}/logs/infrastructure/warn.log
log4j.appender.warn.Append=true
log4j.appender.warn.Threshold=warn
log4j.appender.warn.layout=org.apache.log4j.PatternLayout
log4j.appender.warn.layout.ConversionPattern=%-d{MM-ddHH:mm:ss}-[%p][%c]%m%n
log4j.appender.warn.datePattern='.'yyyy-MM-dd
#Buffer单位为字节，默认是8K，IOBLOCK大小默认也是8K
#log4j.appender.warn.BufferSize=8192
#log4j.appender.warn.BufferedIO=true
#定制过滤器只过滤warn级别
log4j.appender.warn.filter.warnFilter=org.apache.log4j.varia.LevelRangeFilter
log4j.appender.warn.filter.warnFilter.LevelMin=WARN
log4j.appender.warn.filter.warnFilter.LevelMax=WARN

###error级别输出
log4j.appender.error=org.apache.log4j.DailyRollingFileAppender
log4j.appender.error.File=${catalina.home}/logs/infrastructure/error.log
log4j.appender.error.Append=true
log4j.appender.error.Threshold=error
log4j.appender.error.layout=org.apache.log4j.PatternLayout
log4j.appender.error.layout.ConversionPattern=%-d{MM-ddHH:mm:ss}-[%p][%c]%m%n
log4j.appender.error.datePattern='.'yyyy-MM-dd
#Buffer单位为字节，默认是8K，IOBLOCK大小默认也是8K
#log4j.appender.error.BufferSize=8192
#log4j.appender.error.BufferedIO=true
#定制过滤器只过滤error级别
log4j.appender.error.filter.errorFilter=org.apache.log4j.varia.LevelRangeFilter
log4j.appender.error.filter.errorFilter.LevelMin=ERROR
log4j.appender.error.filter.errorFilter.LevelMax=ERROR
```

# Reference

* [Tomcat下使用Log4j 接管 catalina.out 日志文件生成方式：](http://blog.csdn.net/liuxiao723846/article/details/50880158)
* [比较全面的log4j配置](http://www.zhimengzhe.com/bianchengjiaocheng/qitabiancheng/147187.html)
* [log4j的详细配置（最省心完美配置）](http://www.cnblogs.com/juddhu/archive/2013/07/14/3189177.html)
* [logger4j.properties和log4j.xml的常用配置（干货）](https://my.oschina.net/hebad/blog/322578)