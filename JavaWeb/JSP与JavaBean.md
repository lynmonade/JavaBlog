# JSP与JavaBean

## JSP基本语法

### JSP模板元素(HTML)

即JSP中的HTML内容。模板元素均在`_jspService`方法中使用out.write()方法输出。

```html
<body>
    <form>
    </form>
</body>
```

### JSP脚本元素<%%>

嵌套在`<%%>`中的java代码。在翻译后的Servlet中，脚本元素被放到`_jspService()`方法中。脚本元素可以引用JSP的内置对象。

```
<%
String currentTime = new java.util.Date().toString();
%>
```

### JSP声明<%!%>

嵌套在`<%!%>`中的代码，在翻译后的Servlet中，JSP声明放在_jspService()方法之外。**因此JSP声明中的变量将变为成员变量，方法变成实例方法。**

```
<html>
	<body>
        <%!
        String str = "成员变量";
        public String method() {
            return "实例方法";
        }
        %>
        <%=str %> <br>
        <%=method() %>
	</body>
</html>
```

### JSP表达式<%=%>

嵌套在`<%=%>`中的表达式。当我们讲要输出的变量、表达式嵌套在`%=%`后，就可以向客户端输出这个变量或表达式的运算结果。JSP表达式中的变量或表达式的计算结果将被转换成一个字符串，然后被插入进整个JSP页面输出结果的相应位置处。注意，在JSP表达式中嵌套的变量或表达式后面不能有分号。在翻译后的Servlet中，嵌在<%=%>之中的JSP表达式会被放到`_jspService()`方法中，并使用out.print()方法输出。

```html
<input type="text" value=<%=username%> />
```

## JSP运行原理

JSP本质上来说就是Servlet，因此也遵循<servlet-mapping>的原则。JSP的映射关系默认定义在tomcat的全局配置文件中：`%TOMCAT_HOME%/conf/web.xml`。

```xml
<servlet>
    <servlet-name>jsp</servlet-name>
    <servlet-class>org.apache.jasper.servlet.JspServlet</servlet-class>
    <init-param>
        <param-name>fork</param-name>
        <param-value>false</param-value>
    </init-param>
    <init-param>
        <param-name>xpoweredBy</param-name>
        <param-value>false</param-value>
    </init-param>
    <load-on-startup>3</load-on-startup>
</servlet>

<servlet-mapping>
    <servlet-name>jsp</servlet-name>
    <url-pattern>*.jsp</url-pattern>
    <url-pattern>*.jspx</url-pattern>
</servlet-mapping>
```

在访问jsp页面时，请求交由JspServlet进行处理，它就是tomcat中的JSP引擎。当JSP页面第一次被访问时，JSP引擎将它翻译成一个Servlet类，接着再把Servlet类编译成class文件，然后再由Web容器像调用普通Servlet程序一样来装载和解释执行这个由JSP页面翻译成的Servlet类。如果在翻译或编译过程中出现语法错误，则JSP引擎将中断翻译或编译过程，并将错误信息发送给客户端。翻译产生的Servlet类和编译产生的class文件放在`%TOMCAT_HOME%\work\Catalina\localhost\%PROJECT_NAME%\org\apache\jsp\`目录下。

JSP页面只有在第一次被访问时才需要被翻译成Servlet类。对于该JSP的后续访问，Web容器将直接调用其翻译好的Servlet类。JSP每次被访问时，JSP引擎默认都会检测该JSP文件的和class文件的修改时间，如果JSP上次编译后又发生了修改，则JSP引擎将重新翻译该JSP文件。

### 分析JSP所生成的Servlet代码

这是home.jsp文件的源码：

```jsp
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Insert title here</title>
</head>
<body>
<!-- JSP声明 -->
<%!
String objectVar = "成员变量";
public String objectMethod() {
	return "实例方法";
}
%>

<!--JSP脚本元素-->
<%
String url = request.getProtocol();
System.out.println(application.getRealPath("/"));
%>

<!--JSP表达式-->
<%=objectMethod() %>
<input type="text" value=<%=objectVar%> />
</body>
</html>
```

经过web引擎翻译后，.jsp文件被翻译成.java文件：

```java
package org.apache.jsp;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;

public final class home_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent {


String objectVar = "成员变量";
public String objectMethod() {
	return "实例方法";
}

  private static final JspFactory _jspxFactory = JspFactory.getDefaultFactory();

  private static java.util.List _jspx_dependants;

  private javax.el.ExpressionFactory _el_expressionfactory;
  private org.apache.AnnotationProcessor _jsp_annotationprocessor;

  public Object getDependants() {
    return _jspx_dependants;
  }

  public void _jspInit() {
    _el_expressionfactory = _jspxFactory.getJspApplicationContext(getServletConfig().getServletContext()).getExpressionFactory();
    _jsp_annotationprocessor = (org.apache.AnnotationProcessor) getServletConfig().getServletContext().getAttribute(org.apache.AnnotationProcessor.class.getName());
  }

  public void _jspDestroy() {
  }

  public void _jspService(HttpServletRequest request, HttpServletResponse response)
        throws java.io.IOException, ServletException {

    PageContext pageContext = null;
    HttpSession session = null;
    ServletContext application = null;
    ServletConfig config = null;
    JspWriter out = null;
    Object page = this;
    JspWriter _jspx_out = null;
    PageContext _jspx_page_context = null;


    try {
      response.setContentType("text/html; charset=utf-8");
      pageContext = _jspxFactory.getPageContext(this, request, response,
      			null, true, 8192, true);
      _jspx_page_context = pageContext;
      application = pageContext.getServletContext();
      config = pageContext.getServletConfig();
      session = pageContext.getSession();
      out = pageContext.getOut();
      _jspx_out = out;

      out.write("\r\n");
      out.write("<html>\r\n");
      out.write("<head>\r\n");
      out.write("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">\r\n");
      out.write("<title>Insert title here</title>\r\n");
      out.write("</head>\r\n");
      out.write("<body>\r\n");
      out.write("<!-- JSP声明 -->\r\n");
      out.write("\r\n");
      out.write("\r\n");
      out.write("<!--JSP脚本元素-->\r\n");

String url = request.getProtocol();
System.out.println(application.getRealPath("/"));

      out.write("\r\n");
      out.write("\r\n");
      out.write("<!--JSP表达式-->\r\n");
      out.print(objectMethod() );
      out.write("\r\n");
      out.write("<input type=\"text\" value=");
      out.print(objectVar);
      out.write(" />\r\n");
      out.write("</body>\r\n");
      out.write("</html>");
    } catch (Throwable t) {
      if (!(t instanceof SkipPageException)){
        out = _jspx_out;
        if (out != null && out.getBufferSize() != 0)
          try { out.clearBuffer(); } catch (java.io.IOException e) {}
        if (_jspx_page_context != null) _jspx_page_context.handlePageException(t);
        else log(t.getMessage(), t);
      }
    } finally {
      _jspxFactory.releasePageContext(_jspx_page_context);
    }
  }
}
```

从上面的翻译过程，我们可以得出以下结论：

**（1）HTML内容（模板元素）翻译后，在`_jspService()`方法中使用`out.write()`方法打印出来。**

**（2）JSP脚本元素翻译后，将原封不动地作为java代码放入_jspService()方法中。**

**（3）JSP声明翻译后，变量将变为home_jsp的成员变量，而方法将变为home_jsp的实例方法。**

**（4）JSP表达式翻译后，在在`_jspService()`方法中使用`out.print()`方法打印出来。**

**（5）在_jspService()方法中，有两个方法形参：HttpServletRequest, HttpServletResponse。以及七个局部变量，它们共同组成了JSP的九个内置对象。因此我们在能在JSP脚本元素中直接使用这些对象。**

## JSP的3个编译指令

JSP指令元素是为了JSP引擎而设计，它们并不直接产生任何可见输出，只是告诉引擎如何处理JSP页面的其余部分。

### page指令

page指令用于说明JSP页面的页面属性，一个JSP页面可以包含多个page指令。常用的属性包括：import、contentType、pageEncoding、errorPage。

```jsp
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*, java.io.*" %>
```

**（1）import属性**

导入指定的类或者包。注意JSP引擎自动导入了下列包：

- java.lang.*
- javax.servlet.*
- javax.servlet.jsp.*
- javax.servlet.http.*

**（2）contentType属性**

设置JSP的文本内容和字符集编码。

**（3）pageEncoding属性**

设置JSP源文件中字符所用的字符集编码。还可指定response响应正文的字符集编码。注意，pageEncoding设置字符集编码的优先级比contentType的优先级高。

**（4）errorPage属性**

用于设置发生异常时，跳转到哪个页面。errorPage属性必须使用相对路径。并且它会覆盖web.xml中设置的全局异常处理页面。下面是一个例子，首先需要在发生错误的页面home.jsp中通过errorPage属性指定错误跳转页面error.jsp。此外，我们还会对error.jsp设置属性`isErrorPage=true`。

```jsp
<!--home.jsp-->
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*" errorPage="error.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
<%
int b = 2/0; //错误，跳转至error.jsp
%>
</body>
</html>


<!--error.jsp-->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>
这是错误页面
</body>
</html>
```

### include指令

include指令用于通知JSP引擎在翻译当前JSP页面时将其他文件中的内容合并进当前JSP页面转换成的Servlet源文件中，这种在源文件级别进行引入的方式称之为**静态引入**。

```jsp
<%@ include file="including.jsp" %>
```

被引入的文件必须遵循JSP语法，一般来说可以是JSP文件，也可以是普通的HTML文件。但为了见名知义，JSP规范建议使用.jspf（JSP fragments）作为静态引入文件的扩展名。如果被引入的文件发生了变化，则tomcat会自动重新编译当前JSP页面。

需要注意的是，引入文件与被引入文件是在被JSP引擎翻译成Servlet的过程中进行合并的，而不是先合并源文件后再对合并的结果进行翻译。**两个页面最终会被融合成一个页面，因此被包含页面甚至不需要是一个完整的页面（最终被翻译为一个Servlet文件）。**

在使用静态引入时需要特别小心**字符集编码**和**引入路径**的问题：

（1）在将JSP文件翻译成Servlet源文件时，JSP引擎将合并被引入的文件与当前JSP页面中的指令元素（page指令的pageEncoding和import属性除外）。因此除了pageEncoding和import之外，其他指令元素的属性在两个页面中必须一致。此外，必须显式地在两个页面中设置contentType和pageEncoding属性。因此个人建议：

* 在两个页面中都显式地设置contentType和pageEncoding属性，并且值一致（保持编码格式一致可以少很多坑）
* 大小写敏感。因此属性值的大小写必须一致，UTF-8和utf-8会被认为是不同的值。

（2）file的属性值如果以`/`开头，则表示绝对路径，此时等价于web项目根目录（WebRoot）。如果不以`/`开头，则表示相对路径，即相对于当前jsp文件。**注意，file的属性值是基于物理文件路径，而不是基于页面的映射路径，这也是属性被命名为file的原因。**

静态include一般用于页面的模块化分层，比如可以把导航栏作为单独页面，使用静态include融合成一个页面。如果被嵌入的文件经常改变，则建议使用动态include`<jsp:include>`。下面是静态导入的例子：

```jsp
<!--home.jsp-->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" errorPage="error.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Insert title here</title>
</head>
<body>
这是home.jsp中的文本内容<br>
<%@ include file="staticInclude2.jsp" %>
</body>
</html>


<!--staticInclude.jsp-->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%!
int a = 120;
%>
这是通过静态导入后，被包含的页面<%=a %>
```

```java
//翻译后的home_jsp.java
//请注意，staticInclude2.jsp并没有被tomcat翻译，因此在tomcat中也找不到其翻译后的servlet，
//这也验证了两个文件最终融合成一个也面的说法
package org.apache.jsp;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import java.util.*;

public final class home_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent {


int a = 120;

  private static final JspFactory _jspxFactory = JspFactory.getDefaultFactory();

  private static java.util.List _jspx_dependants;

  static {
    _jspx_dependants = new java.util.ArrayList(1);
    _jspx_dependants.add("/staticInclude2.jsp");
  }

  private javax.el.ExpressionFactory _el_expressionfactory;
  private org.apache.AnnotationProcessor _jsp_annotationprocessor;

  public Object getDependants() {
    return _jspx_dependants;
  }

  public void _jspInit() {
    _el_expressionfactory = _jspxFactory.getJspApplicationContext(getServletConfig().getServletContext()).getExpressionFactory();
    _jsp_annotationprocessor = (org.apache.AnnotationProcessor) getServletConfig().getServletContext().getAttribute(org.apache.AnnotationProcessor.class.getName());
  }

  public void _jspDestroy() {
  }

  public void _jspService(HttpServletRequest request, HttpServletResponse response)
        throws java.io.IOException, ServletException {

    PageContext pageContext = null;
    HttpSession session = null;
    ServletContext application = null;
    ServletConfig config = null;
    JspWriter out = null;
    Object page = this;
    JspWriter _jspx_out = null;
    PageContext _jspx_page_context = null;


    try {
      response.setContentType("text/html; charset=UTF-8");
      pageContext = _jspxFactory.getPageContext(this, request, response,
      			"error.jsp", true, 8192, true);
      _jspx_page_context = pageContext;
      application = pageContext.getServletContext();
      config = pageContext.getServletConfig();
      session = pageContext.getSession();
      out = pageContext.getOut();
      _jspx_out = out;

      out.write("\r\n");
      out.write("\r\n");
      out.write("<html>\r\n");
      out.write("<head>\r\n");
      out.write("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">\r\n");
      out.write("<title>Insert title here</title>\r\n");
      out.write("</head>\r\n");
      out.write("<body>\r\n");
      out.write("这是home.jsp中的文本内容<br>\r\n");
      out.write('\r');
      out.write('\n');
      out.write("\r\n");
      out.write("这是通过静态导入后，被包含的页面");
      out.print(a );
      out.write("\r\n");
      out.write("</body>\r\n");
      out.write("</html>");
    } catch (Throwable t) {
      if (!(t instanceof SkipPageException)){
        out = _jspx_out;
        if (out != null && out.getBufferSize() != 0)
          try { out.clearBuffer(); } catch (java.io.IOException e) {}
        if (_jspx_page_context != null) _jspx_page_context.handlePageException(t);
        else log(t.getMessage(), t);
      }
    } finally {
      _jspxFactory.releasePageContext(_jspx_page_context);
    }
  }
}
```

### taglib指令

用于定义和访问自定义标签。

## JSP的7个动作指令（JSP标签）

JSP默认提供了七个动作指令，用于完成各种通用的JSP页面功能。由于动作元素采用XML的语法格式，因此动作指令也称为JSP标签。我们也可以开发自定义的标签。

动作指令与编译指令不同，编译指令是通知Servlet引擎的处理消息，它通常在JSP翻译成Servlet时起作用。而动作指令是运行时的动作，动作指令通常可替换成JSP脚本，因此我们可以把动作指令理解为JSP脚本的简化写法。

### <jsp:include>

即**动态引入**，作用类似于`RequestDispatcher.include()` 方法，指令语法如下，在设置page属性值时需要注意：page属性值基于页面的映射路径，因此得名page。如果以`/`开头，则表示绝对路径，基于当前web项目根目录（WebRoot）。如果不以`/`开头，则表示相对路径，相对于当前页面的映射路径。

```jsp
<jsp:include page="/myview/jsp2.jsp" />
```

下面来说说动态引入和动态引入的区别：

（1）静态引入会把两个页面融合成一个Servlet，tomcat最终只生成一个翻译好的Servlet。而动态引入会使得tomcat单独翻译这两个页面，得到两个Servlet，并通过如下方式引入页面：

```java
out.write("这是jsp1.jsp的内容<br>\r\n");
org.apache.jasper.runtime.JspRuntimeLibrary.include(request, response, "/myview/jsp2.jsp", out, false);
```

（2）静态引入中，被引入页面的编译指令会生效，而动态引入中的编译指令会被忽略，并且仅引入body中的内容。

（3）静态引入会在页面翻译期间发生，并把两个页面融合成一个Servlet。而动态引入则对两个页面的翻译毫无影响，动态引入只发生在JSP被访问时。

（4）动态引入可以接收参数，其page属性值也可以是表达式。而静态引入不支持参数传递，也不支持表达式属性值。注，传递参数需要使用`<jsp:param>`标签。

（5）动态引入中，被引入页面不能修改响应头、响应状态码，如果有这样的语句，也将会被忽略。

（6）动态引入和静态引入都可以用于页面结构分层。都可以用于引入copyright页面。

（7）就效率来说，静态引入的效率比动态引入的效率要高，因此静态引入只翻译一次，而动态引入需要翻译两次。但就灵活性来说，动态引入更为灵活，一旦被引入页面修改，了只需重新翻译被引入页面即可，这样的修改对于当前页面来说是透明的。

![](http://wx2.sinaimg.cn/mw690/0065Y1avgy1ff7da9a8lgj30kx065jsy.jpg)

![](http://wx3.sinaimg.cn/mw690/0065Y1avgy1ff7da8ec77j30kx0ajmzi.jpg)



### <jsp:forward>

该动作指令用于实现请求转发，本质上是调用了`pageContext.forward()`方法。此时，不再输出当前页面中的内容，而直接输出转发到的页面。

其page属性值基于页面的映射路径，因此得名page。如果以`/`开头，则表示绝对路径，基于当前web项目根目录（WebRoot）。如果不以`/`开头，则表示相对路径，相对于当前页面的映射路径。

```jsp
<!--jsp1.jsp-->
<body>
这是jsp1.jsp前面的内容
<jsp:forward page="../view2/jsp2.jsp" />
这是jsp1.jsp后面的内容
</body>

<!--jsp2.jsp-->
<body>
这是jsp2.jsp的内容
</body>

//最终浏览器只输出：这是jsp2.jsp的内容
```

### <jsp:param>

该动作指令用于传递参数。当使用`<jsp:include>`或`<jsp:forword>`时，如果需要向下一页面传递参数，则可以使`用<jsp:param>`标签,可以使用多个`<jsp:param>`标签来传递多个参数。具体语法如下：

```jsp
<jsp:forward page="/view2/jsp2.jsp">
	<jsp:param name="province" value="广西" />
</jsp:forward>
```

### <jsp:plugin>

用于引入Java Applet，现在毛用没有。

## JSP中的9个内置对象

JSP中的9个内置对象可以直接在`<%%>`中直接使用，因为JSP规范对它们进行了默认初始化，其中，request、response是`_jspService()`方法的形参，而其他对象则是`_jspService()`方法的局部变量。

1. application：它是ServletContext类的实例。
2. config：它是ServletConfig类的实例。
3. exception：Throwable的实例，只有当编译指令page的`isErrorPage=true`时，才能使用该实例。
4. out：JspWriter的实例，代表JSP页面的输出流，用于输出内容，形成HTML页面。它非常类似于PrintWriter。
5. page：其类型就是翻译得到的Servlet类，也就是Servlet中的this，能用page的地方就可用this。其代表该页面本身，通常没啥大用处。
6. pageContxt：PageContext的实例，该对象代表JSP页面上下文，使用该对象可以访问页面中的共享数据。
7. request：HttpServletRequest的实例。
8. response：HttpServletResponse的实例。
9. session：HttpSession的实例。

下面重点介绍out对象和pageContext对象。

### out对象

out是JspWriter的实例，它相当于一种带缓存功能的PrintWriter。out对象相当于插入到PrintWriter对象前面的缓冲报装类对象，只有向out对象中写入了内容，且满足如下任何一个条件时，out对象才去调用`response.getWriter()`获得PrintWriter，并将out对象的缓冲区中的内容真正写入到Servlet引擎提供的缓冲区中：

* 设置page指令的buffer属性关闭了out对象的缓存功能
* 写入到out对象中的内容充满了out对象缓冲区
* 整个JSP页面结束

JSP规范进制在JSP页面中直接调用`response.getWriter()`和`response.getOutputStream()`。具体例子如下：

**例子1**

```jsp
<%
out.println("use JspWriter <br>");
response.getWriter().println("use PrintWriter <br>");
%>

//输出结果
use PrintWriter
use JspWriter
```

尽管`out.println()`语句位于`response.getWriter().println()`之前，但它的输出内容却位于后者输出内容之后。这是因为`out.println`语句只是把内容写入到了out对象的缓冲区中，知道整个JSP页面结束时，out对象才把它的缓冲区里面的内容真正写入到Servlet引擎提供的缓冲区中。而`response.getWriter().println()`语句则是直接把内容写入到了Servlet引擎提供的缓冲区中。

**例子2**

```jsp
<body>
<%
ServletOutputStream sos = response.getOutputStream();
sos.println("use ServletOutputStream");
%>
</body>
```

上面的例子会报错，查看翻译得到的Servlet可知，在`_jspService()`方法中，首先创建out对象，它是JspPrinter类型，而out对象可以看作自带缓存的PrintWriter，即out对象是一个字符流，我们使用out对象来写入HTML的内容。接着我们又从response中获得了字节流ServletOutputStream。由于在向response中写入数据时，只能选择一种写入方式（字节流或者字符流，不能同时选择两者），因此程序出错了。

```java
public void _jspService(HttpServletRequest request, HttpServletResponse response)
throws java.io.IOException, ServletException {
	//...
	JspWriter out = null;
	Object page = this;
	JspWriter _jspx_out = null;
	PageContext _jspx_page_context = null;
	try {
	  response.setContentType("text/html; charset=UTF-8");
	  pageContext = _jspxFactory.getPageContext(this, request, response,
				null, true, 8192, true);
	  _jspx_page_context = pageContext;
	  out = pageContext.getOut();
	  _jspx_out = out;

	  out.write("\r\n");
	  out.write("<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">\r\n");
	  out.write("<html>\r\n");
	  out.write("<head>\r\n");
	  out.write("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">\r\n");
	  out.write("<title>Insert title here</title>\r\n");
	  out.write("</head>\r\n");
	  out.write("<body>\r\n");

	ServletOutputStream sos = response.getOutputStream();
	sos.println("use ServletOutputStream");
      
	  out.write("\r\n");
	  out.write("</body>\r\n");
	  out.write("</html>");
	} catch (Throwable t) {
	  //...
	  }
	} finally {
	  _jspxFactory.releasePageContext(_jspx_page_context);
	}
}
```

### pageContext对象

pageContext对象是`javax.servlet.jsp.PageContext`类的实例对象，PageContext是`javax.servlet.jsp.JspContext`的子类。pageContext对象封装了当前JSP页面的运行信息。pageContext的用途如下：

（1）pageContext提供了获取其他JSP内置对象的方法，同时还封装了一些便捷的方法，让我们可以更加方便的调用JSP内置对象的相关方法。

```
abstract  ServletRequest getRequest()
abstract  ServletContext getServletContext()
abstract  void forward(String relativeUrlPath)
abstract  void include(String relativeUrlPath)
//...
```

（2）pageContext封装了部分page指令的属性设置。在`JspFactory.getPageContext()`方法的后四个参数是JSP引擎根据JSP页面中的page指令设置的属性来生成的。

（3）pageContext提供了page级别的存储域，通过`setAttribute()`和`getAttribute()`方法在存储域中读写数据。一般用于：**JSP页面与它调用的普通Java类之间传递对象信息。**

## EL表达式

EL表达式的基本语法格式为`${表达式}`，它可以出现在JSP自定义标签和标准标签的属性值中，也可以出现在模板元素中，将其计算结果插入当前输出流中。EL表达式的一些特点：

- 简化代码。其实EL能做到的，JSP脚本片段+JSP表达式都能做到。
- 自动把null转为""
- 自动进行数据类型转换

```
${param.user}

${customerBean.address.country}

${cookie.user}
```

## 脚本元素标签和指令标签（毛用没有）

JSP2.0加入了脚本元素标签来代替JSP脚本元素、JSP声明、JSP表达式，又加入了指令标签来代替编译指令。这种形式的代替只是为了简化代码，并没有什么神奇的功效。

```java
//脚本元素标签
<% code %>可替换为<jsp:scriptlet> code </jsp:scriptlet>
<%! code %>可替换为<jsp:declaration> code </jsp:declaration>
<%= expression %>可替换为<jsp:expression> expression </jsp:expression>

//指令标签
<%@ page import="java.util.*" %>可替换为<jsp:directive.page import="java.util.*" />
<%@ include file="b.jspf" %>可替换为<jsp:directive.include file="b.jspf" />
```

## JSP奇巧淫技

### 定义全局的错误页面

我们可以在web.xml中定义全局的错误跳转页面，可以把HTTP错误代码或者java的异常类型作为错误捕获依据。此外，我们还能在jsp中通过page指令errorPage属性，为每一个jsp设置错误跳转页面，errorPage的设置会覆盖全局的设置。

```xml
<error-page>
	<error-code>500</error-code>
	<location>/500_error.jsp</location>
</error-page>

<!--如果同时定义，则<exception-type>的捕获优先级更高，因为它更精确 -->
<error-page>
    <exception-type>java.lang.ArithmeticException</exception-type>
    <location>/cal_error.jsp</location>
</error-page>
```

### JSP中文乱码问题

JSP乱码问题五花八门，都是由于不按规范设置造成的，具体原因就不分析了。这里给出给出**规范的设置**，包你以后都不会乱码：

**（1）必须：每个JSP都显式地指定page编译指令contextType和pageEncoding属性。建议使用UTF-8，全球通用。**

```jsp
<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
```

**（2）可选：在web.xml中设置全局的jsp编码格式为UTF-8。注意，经测试，（1）和（2）中的编码格式必须一致，否则tomcat会报错。**

```xml
<jsp-config>
	<jsp-property-group>
		<url-pattern>/jsp/*</url-pattern>
		<page-encoding>UTF-8</page-encoding>
	</jsp-property-group>
</jsp-config>
```

其中，关于设置编码格式的优先级：jsp-config  >> pageEncoding >> contentType >> 采用ISO-8859-1

### JSP自定义URL映射

在项目web.xml中，可以自定义map映射，把请求交由jsp来处理。

```xml
<servlet>
	<servlet-name>newServlet</servlet-name>
	<jsp-file>/MyJsp.jsp</jsp-file>
</servlet>
<servlet-mapping>
	<servlet-name>newServlet</servlet-name>
	<url-pattern>/mapjsp.html</url-pattern>
</servlet-mapping>
```

### 动作指令的中文编码问题

<jsp:forward>、<jsp:include>的url中均可以传递中文参数，传递方式有两种：1.在URL后面直接拼接参数、2.使用<jsp:param>标签。他们的编码格式均由`request.getCharacterEncoding()`决定，因此在传递中文参数前，必须显式地调用`request.setCharacterEncoding("UTF-8")`指定编码格式：

```jsp
<%
request.setCharacterEncoding("UTF-8");
%>
<jsp:forward page="/view2/jsp2.jsp?country=中国">
	<jsp:param name="province" value="广西" />
</jsp:forward>
```

### 关闭JSP自动编译

在生产环境中让JSP引擎对JSP的每次访问都检测它是否发生了修改，需要额外的运行开销。因此可以使用下面的设置关闭自动检测。

```xml
<servlet>
        <servlet-name>jsp</servlet-name>
        <servlet-class>org.apache.jasper.servlet.JspServlet</servlet-class>
		<init-param>
			<param-name>development</param-name>
			<param-value>false</param-value> <!--默认是true，表示开启检测。false表示关闭检测-->
		</init-param>
        <!--.....-->
    </servlet>
```

### JSP特殊字符转义处理

详见《深入体验JavaWeb开发内幕-核心基础》8.2.7章节


