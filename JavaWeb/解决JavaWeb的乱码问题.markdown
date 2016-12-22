# 解决JavaWeb的乱码问题
本文旨在介绍一些实战经验来避免乱码问题，关于编码相关的理论知识，可以参考这位大神写的系列文章：[字符集与编码](https://my.oschina.net/goldenshaw/blog?catalog=536953)。这里只列出一些容易混淆的概念：

1. 字符集定义了有哪些字符可以用，并且定义了用哪个码点（code point）来表示字符。字符集编码定义了如何用二进制数据表示该码点。
2. ASCII，ISO-8859-1，GBK既表示字符集，也表示字符集编码格式。
3. unicode是字符集，不是字符集编码格式。unicode基本包含了所有字符。
4. UTF-8，UTF-16，UTF-32是字符集编码格式，不是字符集，他们用于对unicode所包含的字符进行编码。
5. Base64编码是可逆的，他只能用于编码，不能用于加密敏感信息。
6. ANSI严格来说并不是一种编码规则，它表示：根据当前操作系统以及操作系统的语言，选择对应的编码规则进行编码。例如，对于简体中文的Windows操作系统，ANSI代表GBK。在繁体中文Windows操作系统中，ANSI代表Big5。在日文Windows操作系统中，ANSI代表Shift_JIS 编码。

## 编码与解码
编码：选择特定的编码格式，把字符、字符串转换成二进制数据。解码：选择特定的解码格式，把二进制数据转换成字符、字符串。

```java
//把"中国"二字按照UTF-8编码后，得到二进制数组。
byte[] binary = "中国".getBytes("UTF-8");

//把二进制数组按照UTF-8解码后，得到对应的字符串
String str = new String(binary, "UTF-8");
```
## 乱码
乱码的本质就是，使用了A编码方式进行编码，但接着却使用B编码方式来解码。这样就会造成乱码。编码和解码在有些情况下是可逆的，也就是说本身背后的二进制数据的精度并未丢失。这时你只需要再重新编码，然后解码，就可以还原出正确的字符串。可以参考"在浏览器表单中提交中文参数"的章节。但有时编码和解码是不可逆的，因为背后二进制数据在编码时精度丢失了，这时..我也不懂怎么办了。一般经验是，尽量选择包含字符比较全的字符集编码，这样精度不容易丢失，比如UTF-8，GBK，UTF-16。

## 在浏览器表单中提交中文参数
在浏览器中通过form表单提交参数时，如果参数含有中文，则很可能会造成乱码。这是因为浏览器本身会自动对中文进行编码，而web容器又会自动对传过来的值进行解码。这两个“自动操作”往往特别坑爹。

### 实验1
在form表单中分别用get和post方式提交中文参数值，然后在Servlet中通过`getParameter()`获取参数值。其中HTML页面采用UTF-8编码（通过meta标签指定），web容器使用tomcat。首先，无论使用get还是post方式，浏览器将按照当前显示页面时所采用的的字符集编码来对URL进行编码。接着，编码之后的二进制数据被传递到servlet中，tomcat默认采用ISO-8859-1编码方式对二进制数据进行解码，而在servlet中调用`request.getParameter();`将获得解码后的中文。

![在浏览器表单中提交中文参数](http://ww1.sinaimg.cn/mw690/0065Y1avgw1faymyq2klkj30ut04ajt9.jpg)

此时你会发现，`request.getParameter();`的值是乱码。因为浏览器采用UTF-8对中文进行编码，而tomcat则使用ISO-8859-1进行解码，编码和解码的格式不一致，所以造成乱码。

一种解决方案是在servlet中把`request.getParameter();`的返回值使用ISO-8859-1重新编码，来获得浏览器当初使用UTF-8编码的二进制数据。然后再对二进制数据采用UTF-8进行解码。这样就能避免乱码。

```java
String p1 = new String(request.getParameter("p1").getBytes("ISO-8859-1"),"UTF-8");
```

另一种解决方案是修改tomcat默认的编码格式，让tomcat自动采用UTF-8进行解码：`URIEncoding="UTF-8"`

```xml
//在%TOMCAT_HOME%/conf/server.xml文件中设置：
<Connector port="8080" protocol="HTTP/1.1" 
connectionTimeout="20000" redirectPort="8443" URIEncoding="UTF-8" />
```

### 实验2
在请求转发或者重定向中传递中文字符时，我们必须手工对中文参数进行编码，否则获取参数时会乱码。

```java
//DispatchServlet.java
public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
	String p1 = "中国";
	String p1_encoded = java.net.URLEncoder.encode(p1,"utf-8"); //(1)使用UTF-8对中文编码
	RequestDispatcher rd = request.getRequestDispatcher("/DisplayServlet?p1="+p1_encoded);
	rd.forward(request, response);
}

//RedirectServlet.java
public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
	String p1 = "中国";
	String p1_encoded = java.net.URLEncoder.encode(p1,"utf-8"); //(2)使用UTF-8对中文编码
	response.sendRedirect("DisplayServlet?p1="+p1_encoded);
}

//DisplayServlet.java
public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
	String p1 = new String(request.getParameter("p1").getBytes("ISO-8859-1"), "UTF-8");
	System.out.println(p1);
}

/*
访问：
http://localhost:8080/encode/DispatchServlet，DisplayServlet可以获取"中国"二字。
http://localhost:8080/encode/RedirectServlet，DisplayServlet可以获取"中国"二字。
如果去掉(1),(2)语句，直接把中文拼接到url上，则DisplayServlet会获取到乱码。
*/
```

## request.setCharacterEncoding()
request.setCharacterEncoding()用于设置使用哪种编码格式对提交的参数进行解码。如果在`getParameter()`之前调用`request.setCharacterEncoding()`，则servlet将采用`setCharacterEncoding()`中的编码格式进行解码，而不再采用tomcat配置文件中默认的编码格式。

需要特别注意的是，`request.setCharacterEncoding()`指定的编码格式只对post提交的参数起效果，对get方式提交到方式没有效果。

## 设置文件的编码/解码格式
我们可以IDE或者文本编辑器里，可以设置该文件的编码格式：

![在编辑器里设置文件编码格式](http://ww4.sinaimg.cn/mw690/0065Y1avgw1fazoz42cn4j30da0gfgoa.jpg)

大家不要被**编码格式**四个字给蒙蔽了，其实在编辑器中设置的编码格式不仅用于编码，也用于解码。当我们往文件中写入字符，然后CTRL+S保存时，编辑器会根据当前文件的编码格式，对字符进行编码，转为对应的二进制数据，并把二进制数据保存在硬盘上。当我们用编辑器打开一份文件时，编辑器会自行选择一种**它认为最匹配的编码方式**，对文件中的二进制数据进行解码，并把解码后的字符呈现出来。

不同的编辑器选择的**最匹配的编码方式**有可能是不一样的。比如在notepad++中第一次打开一个html文件，notepad++会选择HTML文件中<meta>标签指定的编码格式进行解码。而myeclipse则会根据项目的编码格式，以及preferences中的设置，选择相应的编码格式来解码。

## 在HTML、JSP中显式的指定编码格式
在HTML和JSP中，强烈建议使用下面的语句，显式的说明文档的编码格式。这样有助于IDE、文本编辑器、浏览器在加载文档时，正确选择该编码格式进行解码。如果忽略了这些语句，程序在加载文档时只能像无头苍蝇一样低效地猜测文档的编码格式了，何必呢。

```html
//HTML
<meta http-equiv="content-type" content="text/html; charset=UTF-8">

//JSP
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
```

## 经验小结
* 安装完MyEclipse后，设置项目和文件的编码方式为UTF-8，[设置方法]()
* 修改tomcat配置文件：%TOMCAT_HOME%/conf/server.xml，把编码格式设置为UTF-8：`<Connector port="8080" protocol="HTTP/1.1" URIEncoding="UTF-8"/>`。
* 像后端传递参数时，最好手动对URL进行URLEncode，指定使用UTF-8进行编码。而不是依赖于浏览器对URL的自动编码。
* 编写HTML、JSP页面时，显式地设置`meta`、`pageEncoding`为UTF-8。



# Reference
* [字符集与编码](https://my.oschina.net/goldenshaw/blog?catalog=536953)
* [浏览器是如何确定html文件编码的？](http://blog.csdn.net/cjdx123456/article/details/31807775)
* [浏览器URL编码](http://www.cnblogs.com/haitao-fan/p/3399018.html)
* [全面使用 UTF-8](http://disksing.com/utf8everywhere)
* [UTF-16与UCS-2的区别](http://demon.tw/programming/utf-16-ucs-2.html)
* [为什么有的代码要用 base64 进行编码？](https://segmentfault.com/q/1010000000801988)
* [Base64编码原理与应用
](http://blog.xiayf.cn/2016/01/24/base64-encoding/)
* [为什么要使用base64编码，有哪些情景需求？](https://www.zhihu.com/question/36306744/answer/71626823)
* [&#x开头的是什么编码呢，知乎的回答](https://www.zhihu.com/question/21390312)
* [「带 BOM 的 UTF-8」和「无 BOM 的 UTF-8」有什么区别？网页代码一般使用哪个？](https://www.zhihu.com/question/20167122)

