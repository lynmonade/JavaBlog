# 初识log4j

## 一个简单的例子

先搭建一个集成了log4j的J2SE项目来玩玩：

第一步： 新建一个JAVA项目名为log4jtest，把log4j-1.2.14.jar放入项目的build path

第二步：编写log4j.properties文件,并放到src目录下

```properties
#低  ALL < DEBUG < INFO <WARN < ERROR < FATAL < OFF 高

#定义log4j全局日志的输出级别，源码日志的输出级别会覆盖全局配置
log4j.rootLogger=DEBUG,2console,2file

#定义源码日志的输出级别，这里定义的是INFO级别
log4j.logger.com.lyn=DEBUG

#目的地1：控制台，接受的日志界别是DEBUG级别
log4j.appender.2console=org.apache.log4j.ConsoleAppender
log4j.appender.2console.Threshold=DEBUG
log4j.appender.2console.layout=org.apache.log4j.PatternLayout
log4j.appender.2console.layout.ConversionPattern=%-d{MM-ddHH:mm:ss}-[%p][%c{3}]%m%n

#目的地2：文件，接受的日志界别是INFO级别
log4j.appender.2file=org.apache.log4j.FileAppender
log4j.appender.2file.File=logs/mylog.log
log4j.appender.2file。Append=true
log4j.appender.2file.Threshold=INFO
log4j.appender.2file.layout=org.apache.log4j.TTCCLayout
```

第三步：在src下新建包com.lyn，在包下新建类Client.java：

```java
package com.lyn;
import org.apache.log4j.Logger;
public class Client {
	private static Logger logger = Logger.getLogger(Client.class);
	public static void main(String[] args) {
		//低 ALL < DEBUG < INFO <WARN < ERROR < FATAL < OFF 高
		logger.debug("This is debug message");//debug级别的输出日志
		logger.info("This is info message");//info级别的输出日志
		logger.warn("This is warn message");//warn级别的输出日志
		logger.error("This is error message");//error级别的输出日志
	}
}
```

运行程序，你会发现控制台会输出如下信息。刷新项目，你会发现在项目根目录下多出一个logs/mylog.log文件，内容如下：

```java
//控制台输出
07-0510:25:23-[DEBUG][com.lyn.Client]This is debug message
07-0510:25:23-[INFO][com.lyn.Client]This is info message
07-0510:25:23-[WARN][com.lyn.Client]This is warn message
07-0510:25:23-[ERROR][com.lyn.Client]This is error message

//logs/mylog.log文件的内容
[main] INFO com.lyn.Client - This is info message
[main] WARN com.lyn.Client - This is warn message
[main] ERROR com.lyn.Client - This is error message
```

上面的例子可以总结为一句话：**log4j可以按照既定的日志等级和输出格式，把源码中的日志内容输出到指定的日志接收目的地。**

我们可以类别Java的I/O，假设以程序作为基准，当运行程序并执行到这一句时`logger.debug("This is debug message");`程序会把日志数据读到输入流中。而控制台、文件就是输出流的目的地。至于你在其他文章上看到的日志等级、日志格式等配置，都只是对日志数据的处理过滤，就像I/O中的过滤流。本质上执行I/O操作（日志读取、写入）的还是底层的节点流。

![]()

# 深入分析log4j.properties

## 日志等级

这一块网上很多文章说的比较模糊。其实日志等级分为三部分：输入等级、输出等级，真实日志等级。只有当真实日志等级同时匹配输入等级和输出等级时，该日志才会写入到对应的日志输出目的地。

在逻辑上，log4j的日志等级共有5个，加上左右两边的开关（ALL、OFF）共7个：（下） ALL < DEBUG < INFO <WARN < ERROR < FATAL < OFF （上）。

假设输入等级是DEBUG及以上（即支持DEBUG、INFO、WARN、ERROR、FATAL），而输出等级也是DEBUG及以上。当你使用`logger.debug("This is debug message");`语句时表示真实日志等级是debug，此时输入等级和输出等级都能包住真实日志等级，因此该日志可以被写入到目的地。

![]()

如果把输出等级改为INFO及以上，则输出等级无法包住真实日志等级，这导致日志无法被写入到目的地。

![]()

输入等级和输出等级可以进行全局配置，也可以针对某一源码包、输出目的地进行局部配置。局部配置会覆盖全局配置。

```java
#全局输入等级和输出等级为INFO,此外，还定义了两个目的地：2console,2file
log4j.rootLogger=INFO,2console,2file

#定义com.lyn包下的.java文件的输入等级为DEBUG，这会覆盖全局配置。
log4j.logger.com.lyn=DEBUG

#针对目的地1控制台进行详细的配置
#设置名为2console的目的地是控制台
log4j.appender.2console=org.apache.log4j.ConsoleAppender
#设置控制台的输出等级为DEBUG，这会覆盖全局配置
log4j.appender.2console.Threshold=DEBUG
#设置日志格式采用自定义方式
log4j.appender.2console.layout=org.apache.log4j.PatternLayout
#设置具体的自定义格式
log4j.appender.2console.layout.ConversionPattern=%-d{MM-ddHH:mm:ss}-[%p][%c{3}]%m%n
```

`log4j.rootLogger=INFO,2console,2file`，rootLogger的第一个值为INFO，它表示设置输入等级和输出等级的全局配置为INFO及以上等级。全局配置不能省略。后面跟着的2console、2file则表示两个日志目的地的引用，便于后面对目的地进行更详细的配置。

`log4j.logger.com.lyn=DEBUG`表示com.lyn包下的java源码的输入等级为DEBUG及以上。

`log4j.appender.2console.Threshold=DEBUG`表示把2console的输出等级设置为DEBUG及以上等级。




## appender目的地
程序产生日志后，我们可以把日志写入到多个目的地中，比如控制台、普通文件、每日文件、限制大小的文件等等。












日志目的地输出等级可以在两个地方配置：

1. 全局配置
2. 单个目的地配置，这会覆盖全局配置

**全局配置**
`log4j.rootLogger=DEBUG,2console,2file`。这一句表示全局输出等级为DEBUG。此外还定义了两个日志输出目的地：2cosole、2file，他们遵循全局输出等级DEBUG。

**注意，这里设置的等级表示DEBUG及以上等级。**也就是说，2console、2file这两个目的地可以接收输入等级为DEBUG, INFO, WARN, ERROR, FATAL的日志。即大于等于的概念。

**单个目的地配置**
```properties
#目的地1：控制台，接收的日志界别是DEBUG级别
log4j.appender.2console=org.apache.log4j.ConsoleAppender
log4j.appender.2console.Threshold=DEBUG
```



# log4j接管tomcat日志

## 步骤

第一步：编写log4j.properties/log4j.xml配置文件

第二步：去tomcat官网下载两个jar包，注意tomcat的版本号，比如我的是tomcat7.0.37，所以去[这里下载](http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.37/bin/extras/),

* tomcat-juli.jar
* tomcat-juli-adapters.jar

第三步：更新tomcat的文件：（建议用重命名的方式保留原文件）

* tomcat-juli.jar放到TOMCAT_HOME/bin下面
* tomcat-juli-adapters.jar、log4j-1.2.14.jar、log4j.properties/log4j.xml放到TOMCAT_HOME/lib下面

第四步：修改tomcat配置文件（非常重要）：TOMCAT_HOME/conf/context.xml的`<Context>`修改为`<Context swallowOutput="true">`

第五步：删除TOMCAT_HOME/conf/logging.properties文件。

第六步：把log4j-1.2.14.jar引入到项目的build path中。把log4j.properties/log4j.xml放到项目的src目录下。

## 注意事项：

（1）如果你在eclipse已经引入了tomcat，然后再去做`<Context swallowOutput="true">`修改的话，这样是无法生效的，只要你在eclipse的tomcat上点一下clean，TOMCAT_HOME/conf/context.xml文件又会恢复原样。最好的做法是：把原先在eclipse中配置的tomcat删除，接着修改tomcat配置文件，最后在eclipse添加tomcat。

（2）开发阶段把日志打印到eclipse的控制台，日志等级为DEBUG。部署阶段把日志写到TOMCAT_HOME/logs/XXX.log文件，日志等级为INFO。

（3）无论日志打印到哪，都建议在log4j.properties配置文件中保留**把日志打印到控制台**的配置。

# log4j的基本概念








# log4j环境搭建
* 第一步：在项目中引入log4j的jar包，就一个jar包。
* 第二步：编写log4j.properties/log4j.xml文件，放在src目录下。（网上也有现成的）

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


# Reference

* [Tomcat下使用Log4j 接管 catalina.out 日志文件生成方式：](http://blog.csdn.net/liuxiao723846/article/details/50880158)
* [比较全面的log4j配置](http://www.zhimengzhe.com/bianchengjiaocheng/qitabiancheng/147187.html)
* [log4j的详细配置（最省心完美配置）](http://www.cnblogs.com/juddhu/archive/2013/07/14/3189177.html)
* [logger4j.properties和log4j.xml的常用配置（干货）](https://my.oschina.net/hebad/blog/322578)
* [log4j 日志脱敏处理 + java properties文件加载](http://www.cnblogs.com/yangw/p/6172140.html)
* [log4j为不同的level设置不同的输出](http://smartvessel.iteye.com/blog/743220)
* [log4j配置文件位置详解](http://blog.csdn.net/lifuxiangcaohui/article/details/11042375)
* [log4j使用介绍](http://swiftlet.net/archives/683)
* 