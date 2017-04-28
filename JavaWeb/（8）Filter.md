# Filter

Filter（过滤器）是Servlet规范2.3中新增的技术，其基本功能就是对Servlet容器调用Servlet的过程进行拦截，从而在Servlet进行响应处理的前后实现一些特殊功能。例如：验证访问者的身份，修改Servlet容器传递给Servlet的请求消息，修改Servlet会送给Servlet容器的响应结果等等。在官方API文档中也提到了Filter的应用：

1. Authentication Filters登录身份认证
2. Logging and Auditing Filters日志与审计
3. Image conversion Filters图片转换
4. Data Compression Filters数据压缩
5. Encryption Filters加密
6. Tokenizing Filters身份凭据
7. Filters that trigger resource access events资源访问权限
8. XSL/T filters
9. Mime-type chain Filter

## Filter基本工作原理

Filter程序是一个实现了`javax.servlet.Filter`接口的Java类，与Servlet类似，它也是由Servlet容器进行调用和执行的。Filter需要在web.xml中进行注册，并设置它所能拦截的资源。

Filter可以看作是Servlet容器与Servlet类通信线路上的一道关卡，它可以对Servlet容器发送给Servlet程序的请求和Servlet程序会送给Servlet容器的响应进行拦截。Filter可以决定是否将请求继续传递给Servlet程序，以及是否对请求和响应信息进行修改。

当Servlet容器开时调用某个Servlet类时，如果发现已经注册了一个Filter对该Servlet进行拦截，那么S而Vlet容器将不再直接调用Servlet的service方法，而是调用Filter的doFilter方法，再由doFilter方法决定是否调用Servlet的service方法。

![](http://wx1.sinaimg.cn/mw690/0065Y1avgy1fewgl91c90j30p809h0vo.jpg)

在`Filter.doFilter()`方法中不能直接调用`Servlet.service()`方法，而是应该调用`FilterChain.doFilter()`方法来间接调用`Servlet.service()`方法。我们只需要在`FilterChain.doFilter()`语句前后增加一些代码，就可以实现在Servlet进行响应处理的前后实现一些特殊功能。

**Filter链的概念**

在web.xml中我们可以注册读个Filter，每个Filter都可以对一个或多个Servlet进行拦截，甚至多个FIlter可以对他同一个Filter进行拦截。当请求到来时，web容器将多个Filter组成一个Filter链。在上一个`Filter.doFilter()`中调用`FilterChain,doFilter()`将激活下一个Filter的doFilter方法，最后一个Filter的doFilter方法中调用的`Filter.doFilter()`将激活`Servlet.service()`方法。

Filter链中的各个Filter的拦截顺序与它们在应用程序的web.xml文件中的映射顺序一致。只要Filter链中有任意一个Filter没有调用`FilterChain.doFilter()`方法，那么`Servlet.service()`方法将不会执行。

![](http://wx1.sinaimg.cn/mw690/0065Y1avgy1fewgnvcocfj30tc09htc9.jpg)



## Filter相关的三个接口

Filter相关的三个接口包括：Filter接口、FilterChain接口、FilterConfig接口：

```java
//Filter接口
void init(FilterConfig filterConfig)
void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
void destroy()
```

`init()`方法与`Servlet.init()`方法非常类似，它是一个钩子方法，当Filter创建完毕后就会调用`init()`方法，开发者可以把自定义的初始化内容放入`init()`方法中。

`destroy()`方法也是一个钩子方法，当Filter销毁之前会调用`destroy()`方法，开发者可以把自定义的销毁内容（比如关闭I/O）放入`destroy()`方法中。

当请求到来时，web容器就会调用`doFilter()`方法拦截请求，该方法传入了request、response、filterChain三个参数，因此我们便可以在该方法中对请求和响应进行处理，并调用`FilterChain.doFilter()`方法激活下一个Filter（或者间接激活`Servlet.service()`）。

```java
//FilterChain
void doFilter(ServletRequest request, ServletResponse response)
```

FilterChain方法仅包含一个`doFilter()`方法，如果Filter链中还有下一个Filter，则`doFilter()`方法将激活下一个Filter的`doFilter()`方法.如果Filter链中已没有下一个Filter，则`doFilter()`方法将激活`Servlet.service(）`方法。

```java
//FilterConfig
ServletContext getServletContext()
String getFilterName()
String getInitParameter(String name)
Enumeration getInitParameterNames()
```

我们可以在web.xml中为每一个Filter都配置一些初始化参数。接着就可以使用FilterConfig类来获取Filter的初始化参数。FilterConfig类与ServletConfig类的作用非常类似。

## 在web.xml中配置Filter

### Filter映射规则

Filter的映射规则由两方面决定：映射方式和请求方式。

**1.映射方式：我们可以通过URL来映射拦截的资源，也可以通过Servlet名称来设置拦截的Servlet。**

```xml
<!--URL映射拦截-->
<filter-mapping>
	<filter-name>FilterA</filter-name>
	<url-pattern>/home/ServletA</url-pattern>
</filter-mapping>

<!--Servlet名称拦截-->
<filter-mapping>
	<filter-name>FilterA</filter-name>
	<servlet-name>ServletA</servlet-name>
</filter-mapping>

<servlet>
    <description></description>
    <display-name>ServletA</display-name>
    <servlet-name>ServletA</servlet-name>
    <servlet-class>com.ServletA</servlet-class>
</servlet>
<servlet-mapping>
    <servlet-name>ServletA</servlet-name>
    <url-pattern>/ServletA</url-pattern>
</servlet-mapping>

```

**2.请求方式：Servlet容器调用一个资源的方式有以下4种：**

* 通过正常的访问强求资源（filter默认只对这种请求进行拦截）：对应标签`<dispatcher>REQUEST</dispatcher>`
* 通过`RequestDispatcher.include()`方法调用：对应标签`<dispatcher>INCLUDE</dispatcher>`
* 通过`RequestDispatcher.forward()`方法调用：对应标签`<dispatcher>FORWARD</dispatcher>`
* 作为错误响应资源调用：对应标签`<dispatcher>ERROR</dispatcher>`

```
<filter-mapping>
	<filter-name>FilterA</filter-name>
	<url-pattern>/ServletA</url-pattern>
	<dispatcher>REQUEST</dispatcher>
	<dispatcher>INCLUDE</dispatcher>
	<dispatcher>FORWARD</dispatcher>
	<dispatcher>ERROR</dispatcher>
</filter-mapping>
```

### Filter链的构造顺序

我们可以在web.xml中定义多个Filter来过滤同一个Servlet，而过滤顺序依赖于Filter链中Filter的构造顺序，web容器将从上到下读取web.xml文件，并按照下面的顺序构造Filter链：

1. 将通过<url-pattern>元素匹配的Filter加入到联众，如果有多个通过<url-pattern>元素匹配的Filter，则按照它们在web.xml中的配置顺序依次加入。
2. 将通过<servlet-name>元素匹配的Filter加入到链中，如果有多个通过<servlet-name>元素匹配的Filter，则按照它们在web.xml中的配置顺序依次加入。

根据上面的规则，这里给出一个例子，FilterA和FilterB同于对ServletA进行过滤，过滤顺序是：FilterA-->FilterB-->ServletA。

```XML
<filter>
	<display-name>FilterA</display-name>
	<filter-name>FilterA</filter-name>
	<filter-class>com.FilterA</filter-class>
	<init-param><!--filter初始化参数-->
		<param-name>charset</param-name>
		<param-value>utf-8</param-value>
        <param-name>company</param-name>
		<param-value>IT</param-value>
	</init-param>
</filter>
<!--filter和filter-mapping要紧挨着来定义-->
<!--先定义filter, 再定义filter-mapping-->
<filter-mapping>
	<filter-name>FilterA</filter-name>
	<url-pattern>/ServletA</url-pattern>
</filter-mapping>
<!--调用顺序是FilterA-->FilterB,所以FilterA定义在前面,FilterB定义在后面-->
<filter>
	<display-name>FilterB</display-name>
	<filter-name>FilterB</filter-name>
	<filter-class>com.FilterB</filter-class>
</filter>
<filter-mapping>
	<filter-name>FilterB</filter-name>
	<url-pattern>/*</url-pattern>
</filter-mapping>

<servlet>
	<description></description>
	<display-name>ServletA</display-name>
	<servlet-name>ServletA</servlet-name>
	<servlet-class>com.ServletA</servlet-class>
</servlet>
<servlet-mapping>
	<servlet-name>ServletA</servlet-name>
	<url-pattern>/ServletA</url-pattern>
</servlet-mapping>
```



### 特殊情况：一个Filter多次拦截Servlet

如果我们在web.xml中为同一个配置多个映射mapping，并且多个mapping均能匹配这个请求。此时该Filter就会被调用多次。这种情况需要特别留意。

```xml
<filter>
	<display-name>FilterA</display-name>
	<filter-name>FilterA</filter-name>
	<filter-class>com.FilterA</filter-class>
	<init-param>
		<param-name>charset</param-name>
		<param-value>utf-8</param-value>
	</init-param>
</filter>
<filter-mapping>
	<filter-name>FilterA</filter-name>
	<url-pattern>/ServletA</url-pattern>
</filter-mapping>
<filter-mapping>
	<filter-name>FilterA</filter-name>
	<url-pattern>/*</url-pattern>
</filter-mapping>
<filter-mapping>
	<filter-name>FilterA</filter-name>
	<servlet-name>ServletA</servlet-name>
</filter-mapping>
```

### 一些建议

* 必须先定义<filter>标签，再定义<filter-mapping>标签。因为web.xml的读取是从上至下的。
* <filter-mapping>应紧跟着对应的<filter>标签，不要分离开来定义。
* 尽量采用<url-pattern>来配置映射

