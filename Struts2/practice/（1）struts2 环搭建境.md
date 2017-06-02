# struts2环境搭建

本文以struts2.2.1为例，介绍如何搭建struts2开发环境。

## 第一步：下载并引入jar包

首先去官网下载struts2.2.1，并在项目中引入如下jar包：

* struts2-core-2.2.1.jar
* xwork-core-2.2.1.jar
* commons-fileupload-1.2.1.jar
* commons-io-1.3.2.jar
* freemarker-2.3.16.jar
* ognl-3.0.jar
* javassist-3.7.ga.jar：这个jar包需要另外下载，struts2中并未提供

## 第二步：配置web.xml文件

通过配置filter实现struts2的启动，让struts2拦截所有请求。

```
<filter>
	<filter-name>struts2</filter-name>
	<filter-class>org.apache.struts2.dispatcher.ng.filter.StrutsPrepareAndExecuteFilter</filter-class>
</filter>
<filter-mapping>
	<filter-name>struts2</filter-name>
	<url-pattern>/*</url-pattern>
</filter-mapping>
```

## 第三步：配置struts.xml文件

在src目录下创建一个struts.xml文件（可以从struts2提供的demo中拷贝一份过来）。并在其中配置常量和action。

```
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE struts PUBLIC
    "-//Apache Software Foundation//DTD Struts Configuration 2.0//EN"
    "http://struts.apache.org/dtds/struts-2.0.dtd">
<!-- struts2配置文件根元素 -->
<struts>
	<!-- 配置struts2常量 -->
	<!-- 指定全局国际化资源文件 -->
	<constant name="struts.custom.i18n.resources" value="mess_zh_CN" />
	<!-- 指定国际化编码所使用的字符集 -->
	<constant name="struts.i18n.encoding" value="UTF-8" />
	
	<!-- 所有Action定义都应该放在 package下 -->
	<package name="cc" extends="struts-default">
		<action name="login" class="com.LoginAction">
			<!-- 定义三个逻辑视图和物理视图之间的映射 -->
			<result name="input">/login.jsp</result>
			<result name="error">/error.jsp</result>
			<result name="success">/welcome.jsp</result>
		</action>
	</package>
		
</struts>
```

## struts2流程

![](http://wx3.sinaimg.cn/mw690/0065Y1avgy1ff8hezaqeqj30qt0bpq67.jpg)