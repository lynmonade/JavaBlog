# ServletConfig和ServletContext

## ServletConfig

> A servlet configuration object used by a servlet container to pass 
> information to a servlet during initialization. 

**从名字就可以看出，ServletConfig代表Servlet的配置信息。*每一个Servlet都有自己独立的配置信息，配置信息写在web.xml中，Servlet通过ServletConfig来读取配置信息，配置信息也叫做初始化参数。**

从代码层面来说，Servlet类持有ServletConfig作为成员变量。我们可以在web.xml中通过`<Servlet>`标签定义Servlet，同时还能通过`<init-param>`标签定义Servlet初始化参数。这种参数是Servlet级别的，每个Servlet都可以拥有自己的初始化参数。（另一种初始化参数是Context级别的，`<context-param>`标签定义，整个项目共享访问这些参数，稍后介绍。）

当Web容器启动时，Servlet一同被初始化，此时会把ServletConfig会作为参数传递到Servlet的初始化函数中。这样，我们就可以通过ServletConfig来读取Servlet初始化参数。

```java
//Servlet的初始化函数
public void init(ServletConfig config) throws ServletException {
    this.config = config;
    init();
}
```

**ServletConfig接口方法**

```java
//获取初始化参数
String getInitParameter(String name)
Enumeration getInitParameterNames()

//获取全局的ServletContext
ServletContext getServletContext()

//获取该Servlet在web.xml中定义的名称
String getServletName()
```

```java
//获取Servlet初始化参数的例子
//web.xml
<servlet>
	<servlet-name>CompanyNameServlet</servlet-name>
	<servlet-class>com.blit.CompanyNameServlet</servlet-class>
	<init-param>
		<param-name>name</param-name>
		<param-value>alpha</param-value>
	</init-param>
	<init-param>
		<param-name>ip</param-name>
		<param-value>127.0.0.1</param-value>
	</init-param>
	</servlet>
	<servlet-mapping>
	<servlet-name>CompanyNameServlet</servlet-name>
	<url-pattern>/CompanyNameServlet</url-pattern>
</servlet-mapping>
      
//CompanyNameServlet.java
protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    System.out.println(getServletConfig().getInitParameter("name")); //alpha
    System.out.println(getServletConfig().getInitParameter("ip")); //127.0.0.1
    System.out.println(getServletConfig().getServletName()); //CompanyNameServlet
}
```

## ServletContext

**ServletContext代表Web项目本身。**ServletContext提供了如下功能：

* 获取web.xml中定义的全局共享的初始化参数
* 作为共享内存，用来存储application域下的变量
* 提供**获取path**和**I/O**相关的功能
* RequestDispatcher请求转发相关功能
* 获取Web项目本身的一些基本信息
* 提供log日志相关的方法
* 多个web项目之间互相访问

### 获取Context初始化参数

Context初始化参数通过`<context-param>`标签在web.xml中定义，全部Servlet共享一份相同的context初始化参数。

```java
String getInitParameter(String name) 
Enumeration getInitParameterNames()
```

**例子**

```java
//web.xml
<context-param>
  <param-name>address</param-name>
  <param-value>kings road</param-value>
</context-param>
<context-param>
  <param-name>job</param-name>
  <param-value>developer</param-value>
</context-param>

//Servlet
protected void doGet(HttpServletRequest request, HttpServletResponse response) 
	throws ServletException, IOException {
	System.out.println(getServletContext().getInitParameter("address"));
	System.out.println(getServletContext().getInitParameter("job"));
}
```

### application域存储变量

```
Object getAttribute(String name)
Enumeration getAttributeNames()
void setAttribute(String name, Object object)
void removeAttribute(String name)
```

### 获取path和I/O相关的功能

```java
Set getResourcePaths(String path) //获取path目录下所有的file
InputStream getResourceAsStream(String path) //获取path对应的file，并转为InputStream
String getRealPath(String path) //获取项目目录下文件的完整物理路径(针对tomcat部署目录)

String getContextPath() //获取JavaWeb项目名称，返回值一般是/projectname
URL getResource(String path) //获取path对应的file，并封装为JNDI格式的URL，不是很常用，一般使用getResourceAsStream()
```

#### 获取path目录下所有的file

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

#### 读取配置文件

`getResourceAsStream()`返回连接到某个资源上的InputStream对象，这个方法实际上是打开了getResource方法返回的URL对象的输入流，并返回这个输入流对象供程序直接去读取数据，它的参数传递规则与getResource方法完全一样。我们可以使用getResourceAsStream方法访问web项目中的配置文件。

访问web项目中的配置文件有两种方式：

1. 使用ServletContxt接口提供的getResourceAsStream方法。此时，配置文件可以防止在/myproject中任何子目录下。
2. 使用ClassLoader提供的getResourceAsStream方法。此时，配置文件只能放在src及其子目录中或者说是WEB-INF/classes及其子目录中(src编译后对应的就是WEB-INF/classes目录)。

```java
//第一种方法：使用getResourceAsStream
InputStream inputStream = this.getServletContext().getResourceAsStream("/WEB-INF/classes/config.properties"); //相对于/projectname目录
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

在servlet中，不要使用FileInputStream类来访问资源，因为web项目在部署是位置是可以变化的，而FileInputStream是使用绝对路径来访问文件。因此在myeclipse中，配置文件一般都放在src目录下，或者放在WebRoot/WEB-INF目录中。千万不要直接放在WebRoot根目录下。因为浏览器可以用敲URL的方式直接访问到WebRoot下的资源，但不能访问WEB-INF到的资源。

#### 把相对路径转为物理绝对路径

```java
// D:\workspace\eclipse4x\apache-tomcat-6.0.44\webapps\myproject\
getServletContext().getRealPath("/"); 

// D:\workspace\eclipse4x\apache-tomcat-6.0.44\webapps\myproject\WEB-INF
getServletContext().getRealPath("/WEB-INF"); 
```

#### 其他方法

```java
// /projectname
getServletContext().getContextPath();

// jndi:/localhost/myproject/
this.getServletContext().getResource("/").toString(); 
// jndi:/localhost/myproject/index.jsp
this.getServletContext().getResource("/index.jsp").toString(); 
```

### 请求转发

**详见《请求转发与重定向》**

### 获取Web项目本身的一些基本信息 

```java
//获取Java Servlet API的大版本号，比如2.5就返回2
int getMajorVersion()

//获取文件的MIME类型，比如"text/html"，"image/gif"
String getMimeType(String file)
  
//获取Java Servlet API的小版本号，比如2.5就返回5
int getMinorVersion()

//获取Servlet容器的名称和版本号信息
String getServerInfo()
  
//获取项目部署后的名称，一般来说就是项目名称（项目名称与部署后的名称可以不一样）
String getServletContextName()
```

**例子**

```java
protected void doGet(HttpServletRequest request, HttpServletResponse response) 
		throws ServletException, IOException {
	int majorVersion = getServletContext().getMajorVersion(); //2
	int minorVersion = getServletContext().getMinorVersion(); //5
	String mimeType = getServletContext().getMimeType("/WEB-INF/classes/download/more.png"); //image/png
	String serverInfo = getServletContext().getServerInfo(); //Apache Tomcat/6.0.35
	String servletContextName = getServletContext().getServletContextName(); //myproject
}
```

### 记录日志

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
//eclipse控制台输出：
//信息: AServlet: int x=3/0, exception happened
```

如果是在Eclipse中测试，会发现Eclipse控制台将输出错误信息。如果不依赖Eclipse而直接使用tomcat，则需要在server.xml中配置log信息的存放位置、log文件的文件名等。

### 多个web项目之间互相访问

SerlvetContext定义了getContext方法。该方法用来获得某个URL所对应的ServletContext对象，传递给getContext方法的路径字符串必须以"/"作为起始字符，"/"代表的是整个web服务器的根目录，即`http://localhost:8080`，而不是某个web项目的根目录。

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

# 

