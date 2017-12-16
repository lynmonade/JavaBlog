# （4）Servlet

## Servlet配置与初始化

要想使我们创建的Servlet具备业务处理能力，必须在web.xml中为Servlet配置映射关系，把浏览器中URL与Servlet关联起来，配置方式如下：

```XML
<servlet>
	<servlet-name>FirstServlet</servlet-name>
	<servlet-class>com.servlet.FirstServlet</servlet-class>
	<init-param>
		<param-name>debug</param-name>
		<param-value>true</param-value>
	</init-param>
	<load-on-startup>1</load-on-startup>
</servlet>
<servlet-mapping>
		<servlet-name>FirstServlet</servlet-name>
		<url-pattern>/FirstServlet</url-pattern>
</servlet-mapping>
```

**<servlet-name>**

定义了Servlet的名称，这个名称在web.xml中全局唯一。

**<servlet-class>**

定义了Servlet类的全路径，必须包含包名。

**<url-pattern>**

定义了URL的映射，即使用http://localhost:8080/myproject/FirstServlet就能访问到该Servlet，注意，我们可以定义多个URL来映射同一个Servlet。

**<init-param> 可选**

定义了Servlet的初始化参数，在Servlet中我们可以使用`getServletConfig().getInitParameter("debug");`来访问初始化参数。

**<load-on-startup> 可选**

表示是否在服务器启动时就加载该servlet(实例化并调用其init()方法)：

- 它的值必须是一个整数，表示servlet应该被载入的顺序
- 当值为0或者大于0时，表示容器在应用启动时就加载并初始化这个servlet；
- 当值小于0或者没有指定时，则表示容器在该servlet被选择时才会去加载。
- 正数的值越小，该servlet的优先级越高，应用启动时就越先加载。
- 当值相同时，容器就会自己选择顺序来加载。

**再介绍一个标签<welcome-file-list>**

该标签用于设置项目默认访问路径，即访问http://localhost:8080/myproject时跳转到的页面。这个标签中不能使用servlet作为跳转路径。

```xml
<welcome-file-list>
    <welcome-file>index.jsp</welcome-file>
</welcome-file-list>
```

## Servlet生命周期

![](http://wx2.sinaimg.cn/mw690/0065Y1avgy1fegm88gpstj30t009aq3u.jpg)

**创建和初始化**

Servlet会根据web.xml中的`<load-on-startup>`属性来决定是否随tomcat启动一起创建，创建Servlet与创建普通Java类是一样的：使用构造函数创建。

`init(ServletConfig config)`方法是接受ServletConfig作为参数，并初始化Servlet。而`init()`方法是钩子方法，这也是开发人员在Servlet创建和初始化过程中，唯一有必要重写的方法，在`init()`中提供自定义的初始化信息，容器会保证`init()`在Servlet初始化中得到调用，原因如下：

```java
public void init(ServletConfig config) throws ServletException {
    this.config = config;
    init();
}
```

**处理请求**

当容器接收到请求时，先由service方法进行处理。Servlet中有两个serivce()方法：`service(ServletRequest req, ServletResponse res)`定义在Servlet接口中，而`service(HttpServletRequest request, HttpServletResponse response)`定义在HttpServlet类中。请求到来时，先由Servlet接口中的service方法处理请求，它其实并没有做什么实质性工作，而是把ServletRequest和ServletResponse强制转换为HttpServletRequest和HttpServletResponse。然后调用HttpServlet类中的service方法，该service方法会根据请求的类型（GET/POST），调用对应的doXXX方法。开发人员无需重写这两个service方法，只需重写doXXX方法，实现业务逻辑。

```java
//实现servlet接口中的service方法
public void service(ServletRequest req, ServletResponse res)
		throws ServletException, IOException {
	HttpServletRequest request = (HttpServletRequest)req;
	HttpServletResponse response = (HttpServletResponse)res;
	service(request, response); //HttpServlet提供一个service方法，以满足Http的需要
}
```

**销毁Servlet**

当tomcat关闭时，容器提供`destroy()`钩子方法，开发人员可以重写该方法，把销毁资源的代码放入其中。

## 获取Servlet信息和初始化参数

HttpServlet类实现了ServletConfig接口，因此Servlet也具备ServletConfig的能力。

```java
//获取初始化参数
String getInitParameter(String name)
Enumeration getInitParameterNames()

//获取全局的ServletContext
ServletContext getServletContext()

//获取该Servlet在web.xml中定义的名称
String getServletName()

//此外，Servlet也拥有一个获取自身信息的方法，很少用
String getServletInfo()
```



## 获取ServletConfig和ServletContext

```java
//Servlet中可以直接获取ServletConfig和ServletContext的实例
ServletConfig getServletConfig()
ServletContext getServletContext()
```

## 记录日志

```java
//这两个方法会把错误信息写到tomcat的servlet log file中，但具体file在哪，我没找到...
void log(Exception exception,String msg)
void log(String message,Throwable throwable)
```