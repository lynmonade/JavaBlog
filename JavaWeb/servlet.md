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
每个web项目粉笔用一个ServletContext对象表示。ServletContext接口定义了ServletContext对象需要对外提供的方法，servlet对象通过这些方法与servlet容器进行通信。Servlet引擎为每个Web应用程序都创建一个对应的ServletContext对象，ServletContext对象被包含在ServletConfig对象中。

##获取web应用程序的初始化参数
在server.xml文件和web.xml文件中都可以为某个web应用程序设置若干初始化参数，ServletContext接口中定义了获取这些初始化参数信息的一些方法。为web应用程序设置初始化参数的好处在于不需要修改Servlet源程序，就可以改变整个web应用程序范围内的一些参数信息。例如，一个web应用程序中的多个serlvet都要输出当前站点的名称，二这个web应用程序可能会交给多个公司去使用，如果将公司名称作为web应用程序的初始化参数进行设置，那么只需要在web.xml文件中修改公司名称，所有servlet输出的公司名称就都会随之更改。

```java
<!-- 在server.xml中配置-->
<Context path="/myproject" reloadable="true">
    <Parameter name="companyName" value="lynTech" override="false">
</Context>

<!--也可以在web.xml中配置-->
<Web-app>
    <context-param>
        <param-name>companyName</param-name>
        <param-value>lynTech</param-value>
    </context-param>
</Web-app>

//servlet中获取参数值
this.getServletContext().getInitParameter("companyName")
```

`override`用于指定web.xml中设置的同名初始化参数是否覆盖server.xml的设置，如果为false，表示不允许覆盖，如果为true，表示允许覆盖。

##记录日志
ServletContext接口中定义了两个重载的log方法。GenericServlet类中也定义了两个log方法，它们分别调用ServletContext对象中对应的log方法。这样在servlet中就可以直接调用ServletContext的log方法。

```java
public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {		
    //刻意制造一个异常
	try{
		int x =3/0;
	}
	catch(Exception e) {
		log("int x=3/0, exception happened");
	}
}
```

如果是在myeclipse中测试，会发现myeclipse控制台将输出错误信息。如果不依赖myeclipse而直接使用tomcat，则需要在server.xml中配置log信息的存放位置、log文件的文件名等。

##application域范围的属性
由于一个web应用程序中的所有serlvet都共享同一个ServletContext对象，所以，ServletContext对象也被成为application对象（web应用程序对象）。application对象内部有一个hashmap对象，用于存储application对象的属性。所有的servlet都能访问application对象的属性，application对象的属性可以被当做该web应用程序范围内的全局变量使用。

```java
//4个常用方法
ServletContext context = this.getServletContext();
//获得所有key
Enumeration enumeration = context.getAttributeNames();
		
//根据key，获得指定value
Object value = context.getAttribute("key");
		
//删除某个属性
context.removeAttribute("key");
		
//增加某个属性：
//最后遵循与包名同样的命名习惯
//如果属性名已存在，则用新值替换旧值。如果属性设置值为null，则等价于removeAttribute("key")
context.setAttribute("key", "value");
```

##访问web项目里的文件
###getResourcePaths方法
返回一个set对象，其中包含某个资源目录中的所有子目录和文件的路径名称。每个路径名称都以整个web应用程序的根目录的形式表示，即都用"/"开头，其中的每一个目录路径的最后也都有一个"/"结尾。请看下面的例子：

![getResourcePaths](http://ww1.sinaimg.cn/large/0065Y1avgw1f7gfbi8lxmj30jy04g74v.jpg)

```java
//左图
Set set = this.getServletContext().getResourcePaths("/");
for(Object obj : set) {
	System.out.println(obj);
}
/*
打印结果
/index.jsp
/WEB-INF/
/META-INF/
*/


//右图
Set set = this.getServletContext().getResourcePaths("/WEB-INF");
for(Object obj : set) {
	System.out.println(obj);
}
/*
打印结果
/WEB-INF/lib/
/WEB-INF/classes/
/WEB-INF/web.xml
*/
```

注意，这里得到的路径都是tomcat/webapp/下的prject路径形式，而不是workspace下的路径形式。

其实两者的路径格式也非常类似：你可以观察一下，`%TOMCAT_HOME%/webapp/myproject/`目录与`myeclipse_workspace/myproject/WebRoot/`目录中的内容是一样的。

###getResource方法

```java
this.getServletContext().getResource("/").toString(); //jndi:/localhost/myproject/
this.getServletContext().getResource("/index.jsp").toString(); //jndi:/localhost/myproject/index.jsp
```

###getResourceAsStream方法
返回连接到某个资源上的InputStream对象，这个方法实际上是打开了getResource方法返回的URL对象的输入流，并返回这个输入流对象供程序直接去读取数据，它的参数传递规则与getResource方法完全一样。我们可以使用getResourceAsStream方法访问web项目中的配置文件。

###访问web项目中的配置文件
访问web项目中的配置文件有两种方式：

1. 使用ServletContxt接口提供的getResourceAsStream方法。此时，配置文件可以防止在/myproject中任何子目录下。
2. 使用ClassLoader提供的getResourceAsStream方法。此时，配置文件只能放在src及其子目录中或者说是WEB-INF/classes及其子目录中(src编译后对应的就是WEB-INF/classes目录)。

```java
//第一种方法：使用getResourceAsStream
InputStream inputStream = this.getServletContext().getResourceAsStream("/WEB-INF/classes/config.properties");
Properties props = new Properties();
props.load(inputStream);
System.out.println("username="+props.getProperty("username"));
System.out.println("password="+props.getProperty("password"));
		
//第二种方法：使用ClassLoader.get
InputStream inputStream2 = getClass().getResourceAsStream("/config.properties");
Properties props2 = new Properties();
props2.load(inputStream2);
System.out.println("username="+props2.getProperty("username"));
System.out.println("password="+props2.getProperty("password"));
```

注意，`getServletContext().getResourceAsStream()`的根目录是`%TOMCAT_HOME%/webapp/myprojcet`，而`ClassLoader.getResourceAsStream()`的根目录是`%TOMCAT_HOME%/webapp/myprojcet/WEB-INF/classes/`。你可以这么理解，前者是ServletContext提供的方法，访问根路径当然是整个web项目，而后者是ClassLoader提供的方法，访问的根路径只能是.class文件所在目录。

在servlet中，不要使用FileInputStream类来访问资源，因为web项目在部署是位置是可以变化的，而FileInputStream是使用绝对路径来访问文件。因此在myeclipse中，配置文件一般都放在src目录下，或者放在WebRoot/WEB-INF目录中。千万不要直接放在WebRoot根目录下。因为浏览器可以用敲URL的方式直接访问到WebRoot下的资源，但不能访问WEB-INF到的资源。

##返回虚拟路径映射的本地路径

```java
//D:\workspace\myeclipse8.6\apache-tomcat-6.0.44\webapps\myproject\
this.getServletContext().getRealPath("/"); 

//D:\workspace\myeclipse8.6\apache-tomcat-6.0.44\webapps\myproject\WEB-INF
this.getServletContext().getRealPath("/WEB-INF"); 
```

使用该方法时，必须以"/"作为起始符，表示当前web项目的根目录。

##web项目之间的访问
SerlvetContext定义了getContext方法。该方法用来获得某个URL所对应的ServletContext对象，传递给getContext方法的路径字符串必须以"/"作为起始字符，这个"/"代表的是整个web服务器的根目录，而不是某个web项目的根目录。

```java
ServletContext context = getServletContext().getContext("/");
if(context!=null) {
	System.out.println(context.getRealPath(""));
}
else {
	System.out.println("getContext fail");
}
```

如果想在projectA中访问projectB中的内容，则必须在server.xml中给projectB配置crossContext属性：

```xml
<Context path="/otherproject" reloadable="true" crossContext="true" />
```

#HttpServletResponse接口
http响应消息是由状态行、一个或多个响应头、实体内容顺序组成的。

##setStatus方法
该方法用于设置http响应消息的状态吗，并生成响应状态行。web服务器默认会自动生成对应的响应状态行，开发者无需再serlvet中显式地调用该方法生成状态行。

##sendError方法
该方法用于发送表示错误信息的状态码，一般是404。他有两个重载的方法。

```java
public void sendError(int code); //只能发送错误信息的状态码
public void sendError(int code, String message); //发送错误信息的状态码，还能发送错误提示信息
```

##构建响应消息头
###header相关方法
HttpServletResponse中有几个关于header的方法，用于构建响应消息头：

```java
addHeader(String name, String value);
setHeader(String name, String value);

addIntHeader(String name, int value);
setIntHeader(String name, int value);

addDateHeader(String name, long date);
setDateHeader(String name, long date);
```

其中，addXXX和setXXX都用于增加一个新的头字段。区别是：set方法将用新的设置值取代原来的值，而add方法则是增加一个同名响应头。因为HTTP响应消息中允许同一名称的头字段出现多次。

###setContentLength方法
setContentLength方法用于设置响应消息的实体内容大小，单位是字节。一般servlet不需要调用该方法设置content-length头字段，因为serlvet引擎在像客户端实际输出响应内容时，它可以自动设置content-length头字段或采用chunked传输编码方式。

###setContextType方法
该方法用于设置servlet输出内容的MIME类型。对于HTTP协议来说，就是设置content-type响应头字段的值。如果像客户端发送的是jpeg格式的图片，则应设置为`"image/jpeg"`，如果是xml文本，则设置为`"text/xml"`，如果是html文件，则设置为`"text/html"`。servlet引擎默设置的输出内容类型为`"text/plain"`。所以我们需要在serlvet中显式地调用该方法设置输出类型。

另外，我们还可以使用该方法设置编码类型，比如`"text/html; charset=GB2312"`。如果没有在MIME类型后面设置编码类型，切使用`response.getWriter()`的方式输出文本内容时，tomcat默认使用ISO8859-1字符集编码。

所以说，setContextType具有两个功能：

* 设置返回内容的MIME类型
* 设置返回文本内容的字符编码类型

###setCharacterEncoding方法
该方法用于设置输出内容的字符集编码类型。用该方法设置的编码类型并不会出现在content-type中，但他依然会`response.getWriter()`的输出编码格式起作用。此外，在这里设置编码格式的优先级比setContentType和setLocale要高。在这里设置的字符编码格式会覆盖setContentType方法的设置。

###浏览器定时刷新，定时跳转至其他页面

```java
//2秒后自动刷新
response.setHeader("Refresh", "2");

//2秒后跳转至其他页面
response.setHeader("Refresh", "2;URL=http://www.baidu.com");
```

###禁止亮蓝旗缓存当前文档内容
有三个HTTP响应头字段都可以禁止浏览器缓存当前页面：

```java
response.setDateHeader("Expires", 0);
response.setHeader("Cache-Control", "no-cache");
response.setHeader("Pragma", "no-cache");
```

并不是所有浏览器都能完全支持上面三个响应头，所以最好是同时使用上面三个响应头。只要浏览器能支持其中任何一种形式，就能禁止浏览器缓存当前页面。

###使用<meta>标签模拟响应消息头
对于不会java代码的HTML网页制作者，我们也可是使用HTML语言提供的<meta>标签的`http-equiv`属性来在HTML文档中模拟HTML响应消息头，实现上面的"禁止缓存"，"设置编码格式"等功能。

```html
<head>
    <!--设置编码格式-->
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    
    <!--禁止缓存-->
    <meta http-equiv="Expires" content="0">
    <meta http-equiv="Cache-Control" content="no-cache">
    <meta http-equiv="Pragma" content="no-cache">
    
    <!-- 定时调转至其他页面 -->
	<meta http-equiv="Refresh" content="2;url=http://www.baidu.com">
</head>
```

##创建响应正文
ServletResponse中一些方法返回servlet引擎提供的输出流对象，再由serlvet通过这个输出流对象将响应正文写入到serlvet引擎中，最终输出至浏览器界面。使用getOutputStream和getWriter

servlet引擎实现了ServletResponse接口，并提供了字节输出流和字符输出流来供Servlet程序选择。其中getOutputStream方法用于返回Servlet引擎创建的字节输出流对象。getWriter方法用于返回servlet引擎创建的字符输出流对象。两个方法相互排斥，调用其中一个后，就不能再调用另一个了。

getOutputStream方法返回ServletOutputStream对象，如果serlvet要输出二进制格式的响应正文，应该使用该方法。

getWriter方法返回PrintWriter对象，专门用于输出内容全为文本字符的文档。

在service方法结束后，servlet引擎将检查getWriter或getOutputStream方法返回的输出流对象是否已经掉过close方法，如果没有，serlvet引擎将调用close方关闭输出流。但开发者最好还是自己手工调用close方法，以便尽快释放资源。

###输出缓冲区
servlet程序输出的HTTP消息的响应正文不是直接发送到客户端，而是首先被写入到了servlet引擎提供的一个输出缓冲区中，这个缓冲区就像一个临时的蓄水池，直接输出缓冲区被填满或者servlet程序已经写入了所有的响应内容，缓冲区中的内容才会被servlet引擎发送到客户端。使用输出缓冲区后，servlet引擎就可以将响应状态行、各响应头和响应正文严格按照HTTP消息的位置顺序进行调整后再输出到客户端，特别是可以自动对Content-Length头字段进行设置和调整。如果在提交响应到客户端时，输出缓冲区中已经装入了所有的响应内容，servlet引擎将计算响应正文部分的大小并自动设置content-length头字段。如果在提交响应到客户端时，输出缓冲区中装入的内容只是全部响应内容的一部分，那么servlet引擎将无法再计算content-length头字段的值，它将使用HTTP1.1的chunked编码方式（通过设置Transfer-Encoding头字段来指定）传输响应内容，这样就不用设置content-length头字段了。

###输出缓冲区的相关方法
####setBufferSize方法
用于设置期望的输出缓冲区大小。servlet引擎实际使用的值不一定等于该值，但不会小于该值。

####getBufferSize方法
返回servlet引擎实际使用的缓冲区大小。

####flushBuffer方法
用于将输出缓冲区的内容强制输出到客户端，如果这是当前响应的第一次向客户端实际输出数据，响应状态行和各个响应头也会被输出到客户端。

####reset方法
用于清空缓冲区的内容，以及清空设置的响应状态码和各个响应头。如果当前响应已经向客户端输出过部分内容，这个方法将抛出IlegalStateException异常。要注意区分flushBuffer和reset方法的差异，前者是将缓冲区的内容提前提交给客户端后腾出缓冲区空间，后者是将缓冲区的内容作废后腾出缓冲区空间。

####isCommited方法
判断是否已经提交了部分响应内容到客户端，如果已经提交了，则返回true，否则返回false。




