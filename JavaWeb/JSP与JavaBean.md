# JSP与JavaBean

## JSP基本语法

### JSP模板元素

即JSP中的HTML内容。模板元素均在`_jspService`方法中使用out.write()方法输出。

```html
<body>
    <form>
    </form>
</body>
```

### JSP脚本元素

嵌套在`<%%>`中的java代码。在翻译后的Servlet中，脚本元素被放到`_jspService()`方法中。脚本元素可以引用JSP的内置对象。

```
<%
String currentTime = new java.util.Date().toString();
%>
```

### JSP声明

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

### JSP表达式

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

也就是说，在访问jsp页面时，请求交由JspServlet进行处理，它就是tomcat中的JSP引擎。当JSP页面第一次被访问时，JSP引擎将它翻译成一个Servlet类，接着再把Servlet类编译成class文件，然后再由Web容器像调用普通Servlet程序一样的方式来装在和解释执行这个由JSP页面翻译成的Servlet类。如果在翻译或编译过程中出现语法错误，则JSP引擎将中断翻译或编译过程，并将错误信息发送给客户端。翻译产生的Servlet类和编译产生的class文件放在`%TOMCAT_HOME%\work\Catalina\localhost\encode\org\apache\jsp\`目录下。

JSP页面只有在第一次被访问时才需要被翻译成Servlet类。对于该JSP的后续访问，Web容器将直接调用其翻译好的Servlet类。JSP每次被访问时，JSP引擎默认都会检测该JSP文件的和class文件的修改时间，如果JSP字上次编译后又发生了修改，则JSP引擎将重新翻译该JSP文件。

### 分析JSP所生成的Servlet代码

### 它就是一个Servlet

生产的Servlet类的类名是MyJsp_jsp，即JSPNAME_jsp的格式。该类继承了org.apache.jasper.runtime.HttpJspBase类，该类是HttpServlet的一个子类。

### JSP内置对象

_jspService()方法中内置很多有用的对象，所以我们才能直接在<%%>中使用request, response, sesssion这些对象。

```Java
public void _jspService(final javax.servlet.http.HttpServletRequest request, final javax.servlet.http.HttpServletResponse response)
        throws java.io.IOException, javax.servlet.ServletException {

    final javax.servlet.jsp.PageContext pageContext;
    javax.servlet.http.HttpSession session = null;
    final javax.servlet.ServletContext application;
    final javax.servlet.ServletConfig config;
    javax.servlet.jsp.JspWriter out = null;
    final java.lang.Object page = this;
    javax.servlet.jsp.JspWriter _jspx_out = null;
    javax.servlet.jsp.PageContext _jspx_page_context = null;
    //...
}
```

## JSP的三个动作指令

JSP指令元素是为了JSP引擎而设计，它们并不直接产生任何可见输出，只是告诉引擎如何处理JSP页面的其余部分。

### page指令

page指令用于说明JSP页面的页面属性，常用的属性包括：

**import属性**

导入指定的类或者包。注意JSP引擎自动导入了下列包：

- java.lang.*
- javax.servlet.*
- javax.servlet.jsp.*
- javax.servlet.http.*

**errorPage属性**

用于设置发生异常时，跳转到哪个页面。errorPage属性必须使用相对路径。并且它会覆盖web.xml中设置的全局异常处理页面。

**contentType属性**

设置JSP的文本内容和字符集编码。

**pageEncoding属性**

设置JSP源文件中字符所用的字符集编码。还可指定response响应正文的字符集编码。注意，pageEncoding设置字符集编码的优先级比contentType的优先级高。

```
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
```

### include指令

### taglib指令

## JSP的七个动作指令



## JSP中的九个内置对象

### 七个常用对象

### out对象

### pageContext对象

## JSP标签

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



## JSP小技巧

### JSP中文乱码问题

JSP乱码问题五花八门，都是由于不按规范设置造成的，具体原因就不分析了。这里给出给出**规范的设置**，包你以后都不会乱码：

1.尽量不要使用contentType来指定编码格式，应该使用page指令的pageEncoding属性显式地指定编码格式，另外，建议使用UTF-8，全球通用。

```
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
```

2.在web.xml中设置全局的jsp编码格式：

```
<jsp-config>
	<jsp-property-group>
		<url-pattern>/jsp/*</url-pattern>
		<page-encoding>UTF-8</page-encoding>
	</jsp-property-group>
</jsp-config>
```

其中，关于设置编码格式的优先级：pageEncoding > jsp-config > contentType > 采用ISO-8859-1

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



## 神的分隔线******************************************************



## 3. 那些年遇到的坑
### 3.1 JSP编码格式
在_jspService()方法中的开始部分，tomcat帮我们生成了一行代码：`response.setContentType("text/html;charset=UTF-8");`，用于设置响应信息的编码格式，tomcat是根据JSP中`<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>`进行设置的。

### 3.6 out对象
带缓存功能的PrintWriter。


