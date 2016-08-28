#servlet映射
创建web project名为test。创建一个servlet名为MyServlet。myEclipse会自动生成web.xml的servlet配置信息：

```XML
<servlet>
    <servlet-name>MyServlet</servlet-name>
    <servlet-class>com.lyn.MyServlet</servlet-class>
</servlet>

<servlet-mapping>
    <servlet-name>MyServlet</servlet-name>
    <url-pattern>/print</url-pattern>
</servlet-mapping>
```

部署到tomcat中，访问http://localhost:8080/test/print就可以访问到MyServlet了。

#web.xml标签介绍
#### \<servlet-name>
serlvet的id，xml全局唯一。

#### \<servlet-class> 
对应Servlet类，必须使用全路径。

#### \<url-pattern>
表示ProjectPath之后跟着的路由地址:http://localhost:8080/projectpath/xxx。\<url-pattern>还可以使用\*号路径格式，例如\*.do, /action/*.do

####\<load-on-startup>
表示是否在启动的时候就加载这个servlet(实例化并调用其init()方法)：

* 它的值必须是一个整数，表示servlet应该被载入的顺序
* 当值为0或者大于0时，表示容器在应用启动时就加载并初始化这个servlet；
* 当值小于0或者没有指定时，则表示容器在该servlet被选择时才会去加载。
* 正数的值越小，该servlet的优先级越高，应用启动时就越先加载。
* 当值相同时，容器就会自己选择顺序来加载。

```xml
<servlet>
   <servlet-name>dwr-invoker</servlet-name>
   <servlet-class>com.MyServlet</servlet-class>
   
   <load-on-startup>1</load-on-startup>
</servlet>
```

####\<init-param>
该标签可以在servlet初始化时，传入参数。并在servlet端获取参数值。

```xml
<init-param>
    <param-name>debug</param-name>
    <param-value>true</param-value>
</init-param>

//在servlet中获取参数值
this.getServletConfig().getInitParameter("debug");
```

####\<welcome-file-list>
该标签用于设置项目默认访问路径，即访问http://localhost:8080/projectpath时跳转到的页面。这个标签中不能使用servlet作为跳转路径。

```xml
<welcome-file-list>
    <welcome-file>index.jsp</welcome-file>
</welcome-file-list>
```

#缺省Servlet
在<%TOMCAT_HOME%>\conf\web.xml中，有一个servlet名为default。

```xml
<servlet>
    <servlet-name>default</servlet-name>
    <servlet-class>org.apache.catalina.servlets.DefaultServlet</servlet-class>
    <init-param>
        <param-name>debug</param-name>
        <param-value>0</param-value>
    </init-param>
    <init-param>
        <param-name>listings</param-name>
        <param-value>false</param-value>
    </init-param>
    <load-on-startup>1</load-on-startup>
</servlet>

<servlet-mapping>
    <servlet-name>default</servlet-name>
    <url-pattern>/</url-pattern>
</servlet-mapping>
```

这个servlet的作用是把静态资源的内容按字节原封不动地读出来，并传递给客户端。同时生成一些相应消息头字段。如果把这个servlet注释掉，你将无法访问项目中的静态资源。

#servlet中组件的关系
##servlet
就是你编写的servlet类。
##servlet引擎
tomcat，jetty。你编写的servlet类将通过web.xml的配置，在servlet引擎启动时加载到引擎中，或者说是让tomcat可以调用你编写的代码。
##servlet容器
也就是web容器，也就是你创建的web项目。

其实，更多时候我们会提另一个概念：**web容器**。因为web项目最终也会被加载tomcat中，所以我们可以近似的认为： 

```java
web容器 = servlet引擎 + serlvet容器
```

##ServletConfig
可以理解为web.xml的对象表示。里面包含了web.xml中的配置信息。当项目启动时，会创建一个唯一的ServletConfig对象，servlet持有ServletConfig对象的引用，因此可以在servlet中使用ServletConfig对象。

##ServletContext
即web项目的对象表示。ServletConfig持有ServletContext对象的引用。

##HttpServletRequest,HttpServletResponse
这两个都是接口，具体实现类由servlet引擎厂家提供，比如tomcat，这些厂家必须严格遵循接口的入参、出参、方法名。servlet只需要使用接口引用来操作request、response即可。

#Servlet接口
##init方法
servlet接口中有两个init方法，`init(ServletConfig config)`和`init()`。当servlet被Web容器创建以后，就调用`init(ServletConfig config)`方法，把ServletConfig传入Servlet中。而开发者只需要覆盖init()方法就能实现自定义的初始化的工作。其实，GenericServlet已经实现了`init(ServletConfig config)`： 

```java
public void init(ServletConfig config) throws ServletException {
    this.config = config;
    init();
}
```

所以说，开发者只需覆盖init()方法，web容器会在调用init(ServletConfig config)方法时，接着调用init()方法。可以把`init(ServletConfig config)`看做是designate method，`init()`看作是secondary method。

##service方法
servlet接口有一个service方法：`public void service(ServletRequest req, ServletResponse res)`。HttpServlet类实现了接口中service方法：

```java
//实现servlet接口中的service方法
	public void service(ServletRequest req, ServletResponse res)
			throws ServletException, IOException {
		HttpServletRequest request = (HttpServletRequest)req;
		HttpServletResponse response = (HttpServletResponse)res;
		service(request, response); //HttpServlet另外提供一个service方法，以满足Http的需要
	}
```

同时，HttpServlet还提供了另一个service方法：`protected void service(HttpServletRequest req, HttpServletResponse resp)`。这样，web容器调用接口定义的service方法时，就会顺带调用HttpServlet提供的重载service方法。API中也说到，我们无需覆盖HttpServlet提供的重载service方法。

##destroy方法
destroy在web容器卸载serlvet之前被调用。可以再里面做一些资源清理工作，比如关闭数据库连接，关闭I/O。GenericServlet已经实现了该方法，子类一般不需要覆盖这个方法。

##getServletConfig方法
获取通过init方法传进来的那个ServletConfig对象。

##getServletInfo方法
返回servlet的描述信息，比如作者、版本号、版权等。

##doXXX方法
doXXX对应Http协议中的各种请求方式。serlvet接口的service方法作为所有请求的总入口，在内部调用重载的service方法，重载的service方法在内部会自行判断请求方式，并调用对应doXXX方法。因此开发者只需实现对应的doXXX方法即可。如果使用了并未实现的请求方式，则会报405错误。

#ServletContext接口
每个web项目粉笔用一个ServletContext对象表示。ServletContext接口定义了ServletContext对象需要对外提供的方法，servlet对象通过这些方法与servlet容器进行通信。Servlet引擎为每个Web应用程序都创建一个对应的ServletContext对象，ServletContext对象呗包含在ServletConfig对象中。




