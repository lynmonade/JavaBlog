# 请求HttpServletRequest

HTTP请求消息分为三个部分：请求行（请求URL）、请求消息头、消息正文（实体内容）。HttpServletRequest是专用于HTTP协议的ServletRequest子接口，它用于封装HTTP请求消息，增加了获取HTTP协议专有的头信息的方法，只会Cookies和Session跟踪，以及获取HTTP请求消息参数的功能。

## 获取请求参数

### GET请求方式传递参数

* 在浏览器地址栏输入URL
* 超链接
* <form>表单GET方式提交
* Ajax中GET方式提交

在上述4种情况下，浏览器将向服务端发出GET请求，请求参数会跟在URL地址后面。拼接在URL后面的参数串也叫做Query String。***当使用非Ajax的方式进行GET提交时，浏览器都自动使用当前页面的编码格式对提交参数进行URL编码***。

**GET方式适用于提交普通类型的数据，并且这些数据只用于查询，而不会涉及后端的写入操作。**

如果参数太长（URL地址最大长度是1KB），或者提交的参数是二进制文件，或者提交包含密码的数据，则应该使用POST方式。

下面展示了表单中GET方式提交时的请求信息，请求参数直接拼接在URL后面，请求头中没有content-length字段。此外也没有任何请求实体内容。

```java
GET /newservlet/ServletA?username=%E8%BF%99%E7%A7%8D&submit=%E6%8F%90%E4%BA%A4%E6%9F%A5%E8%AF%A2%E5%86%85%E5%AE%B9 HTTP/1.1
Accept: application/x-ms-application, image/jpeg, application/xaml+xml, image/gif, image/pjpeg, application/x-ms-xbap, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*
Referer: http://localhost:8080/newservlet/test.html
Accept-Language: zh-CN
User-Agent: Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; WOW64; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; InfoPath.3; .NET4.0C; .NET4.0E)
Accept-Encoding: gzip, deflate
Host: localhost:8080
Connection: Keep-Alive
```

### POST请求

* <form>表单POST方式提交
* Ajax中POST方式提交

在上述4种情况下，浏览器将向服务端发出POST请求，请求参数将放在请求的实体内容中，而不是放在URL后面，实体内容也叫做**posted form data**。form表单的enctype属性有两个值：`application/x-www-form-urlencoded`和`multipart/form-data`。

`application/x-www-form-urlencoded`是enctype属性的默认值，专门用于提交普通类型的数据，适用于GET、POST方式提交。后端可以使用`getParameter(String name)`获取参数值。

`multipart/form-data`用于提交二进制数据，让你提交的数据包含二进制文件，则必须把enctype的值设置为它。`multipart/form-data`仅适用于POST方式提交.。此外，后端无法使用`getParameter(String name)`获取参数值。

下面展示了表单中POST方式提交时的请求信息，请求参数放在请求实体内容，请求URL没有变化，此外还包含content-length消息头，用于表示实体内容的大小。

```java
POST /newservlet/ServletA HTTP/1.1
Accept: application/x-ms-application, image/jpeg, application/xaml+xml, image/gif, image/pjpeg, application/x-ms-xbap, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*
Referer: http://localhost:8080/newservlet/test.html
Accept-Language: zh-CN
User-Agent: Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; WOW64; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; InfoPath.3; .NET4.0C; .NET4.0E)
Content-Type: application/x-www-form-urlencoded
Accept-Encoding: gzip, deflate
Host: localhost:8080
Content-Length: 89
Connection: Keep-Alive
Cache-Control: no-cache

username=%E8%BF%99%E4%B8%AA&submit=%E6%8F%90%E4%BA%A4%E6%9F%A5%E8%AF%A2%E5%86%85%E5%AE%B9
```

### 科普：URL编码

> RFC3986文档规定，Url中只允许包含英文字母（a-zA-Z）、数字（0-9）、-_.~4个特殊字符以及所有保留字符。

URL编码其实是字符集编码的百分号表示形式，用以适应URL地址的格式。**在使用URL编码时，必须指定编码格式。**比如**中国**二字，使用UTF-8编码后的值用十六进制表示为：`e4b8ade59bbd`，其中e4, b8, ad, e5, 9b, bd分别表示一个字节。UTF-8使用三个字节表示常见的中文字，因此中国二字需要六个字节来表示。**URL编码就是在字符集编码之后，在每个字节前后加上%的形式：即%e4%b8%ad%e5%9b%bd**。

### 例子：从表单常用控件中获取普通数据

下面的例子介绍了从表单的按钮、单行文本、多行文本、单选按钮、复选框、列表框中获取数据：

**按钮**

```html
<form  method="GET">
	<input type="button" name="button1" value="mybutton" />
	<input type="submit" name="submit" value="submit1" />
	<input type="submit" name="submit" value="submit2" />
	<input type="submit" value="noname" />
	<input type="reset" name="reset" vavlue="reset" />
</form>

//点击mybutton或reset按钮，地址栏URL不变化。
//点击submit1:按钮：地址栏URL：http://localhost:8080/newservlet/test.html?submit=submit1
////点击submit2:按钮：地址栏URL：http://localhost:8080/newservlet/test.html?submit=submit2
//点击noname按钮，地址栏URL：http://localhost:8080/newservlet/test.html?
```

* 普通的button和reset按钮的值是不会传递到后端的。
* 创建submit按钮时，name和value属性最好都设置，这样submit的name和value也会拼在URL后面。即使是同名的submit按钮，浏览器也能区分，后端只需根据value值区分即可。

**单行文本、多行文本**

```html
<form  method="GET">
	<input type="text" name="text1" value="value1" /> <br>
	<textarea name="textarea1" cols="20" rows="5" >中国</textarea> <br>
	<input type="submit" />
</form>

//点击提交按钮，地址栏URL：http://localhost:8080/newservlet/test.html?text1=value1&textarea1=%E4%B8%AD%E5%9B%BD
//请求所有文本，点击提交按钮，地址栏URL：http://localhost:8080/newservlet/test.html?text1=&textarea1=
```

* 不管干单行、多行文本框中是否有内容，设置了name属性的文本框的数据总会作为参数传递。
* 如果没有内容，则传递一个空字符串作为数据。

**单选框、复选框**

```html
<form method="GET">
多选框
	<input type="checkbox" name="checkbox1" value="1">checkbox1:1
	<input type="checkbox" name="checkbox1" value="2">checkbox1:2
	<input type="checkbox" name="checkbox2">checkbox2<br>
单选框
	<input type="radio" name="radio1" value="1">radio1:1 
	<input type="radio" name="radio1" value="2">radio1:2 
	<input type="radio" name="radio2">radio2<br> 
	<input type="submit">
</form>

//选中第一个和第三个复选框，URL地址栏为：http://localhost:8080/newservlet/test.html?checkbox1=1&checkbox2=on
//选中所有的复选框，URL地址为：http://localhost:8080/newservlet/test.html?checkbox1=1&checkbox1=2&checkbox2=on
//选中第一个单选框和第三个单选框，URL地址为：http://localhost:8080/newservlet/test.html?radio1=1&radio2=on
```

* 只有被选中的单选框、复选框才会作为参数拼接在URL后面
* URL拼接参数时，允许出现同名的复选框，这是参数列表会出现同名参数。但不允许出现同名的单选框，其实你也无法选中同名的单选框。
* 没有设置value的单选框、复选框，则默认值为on

**下拉框**

```html
<form method="GET">
<select name="select1"  multiple="multiple">
	<option value="">--不选--</option>
	<option>java</option>
	<option value="1">c</option>
	<option value="2">jsp</option>
</select><br>
<input type="submit" />
</form>

//直接点击提交按钮，地址栏URL：http://localhost:8080/newservlet/test.html?
//按住ctrl键，选择java、c、jsp，点击提交，地址栏URL:http://localhost:8080/newservlet/test.html?select1=java&select1=1&select1=2
```

* 如果没有做出选择，就不会提交任何参数，就像没有任何下拉框一样。
* 进行多选时，每一个选项都将作为一个参数，参数名称都是select的name属性值，而参数值是option的value属性值，如果没有value属性，则取option的标题作为参数值。

### 例子：表单提交隐藏字段和图片字段

```html
<form method="GET">
	<input type="hidden" name="hidden1" value="hidden1">
	<input type="image" name="image1" src="http://ww1.sinaimg.cn/mw690/0065Y1avgw1fbabotiqdoj30up0f2acp.jpg" />
</form>

//单击图片任意位置，地址栏URL：http://localhost:8080/newservlet/test.html?hidden1=hidden1&image1.x=335&image1.y=110
```

隐藏字段总是会作为参数进行传递，而点击图时的x、y坐标也作为参数传递。

### 例子：使用js防止重复提交表单

```html
<script type="text/javascript">
var isCommited = false;
function checkPost() {
	if(!isCommited) {
		isCommited=true;
		return true;
	}
	else {
		alert("不能重复提交表单");
		return false;
	}
}
</script>
<form action="ServletA" method="POST" onsubmit="return checkPost()">
	<input type="text" name="username" >
	<input type="submit" value="submit"/>
</form>
```

### 在后端获取普通类型的参数

HttpServletRequest类定义了一系列getParameter方法，用于获取`application/x-www-form-urlencoded`格式的参数值（包括GET和POST方式）。这些方法会对参数进行分解和提取，并自动对提取的参数进行URL解码。

```
//获取不同名参数，如果参数没有值，则返回空字符串
String getParameter(String name)
//获取同名参数
String[] getParameterValues(String name)
//获取所有参数名，同名参数只占一个enum
Enumeration getParameterNames()
//获取所有参数和值，并放到map中。同名参数，则参数名作为key，value为参数值数组
Map getParameterMap()
```

### 在后端获取二进制数据的参数

如果用户在表单中上传了文件，则必须使用request的如下两个方法获取流对象，并用流来读取文件，这与Java的I/O思想是一致的。

```java
ServletInputStream getInputStream() //字节流
BufferedReader getReader() //字符流
```

在获取字符流之前，可以使用`setCharacterEncoding(String env)`方法设置字符集编码格式。如果没有设置编码格式，并且请求消息中也没有显式地指定字符集编码，则默认使用ISO-8859-1对获得上传的二进制数据进行编码。

在获取二进制文件时，字节流和字符流只能二选一。在选择方面，如果上传的是普通文本文件，并且需要在后端读取文本内容，则建议使用字符流。如果上传的是文件需要原封不动地存储到文件系统或者数据库中，那么应该使用字节流。

如果用户既提交了普通数据，又上传了文件，则只能使用流来获取普通数据和文件数据，绝不能投机取巧地使用`getParameter()`来获取普通数据。

**文件上传的例子**

```html
<form action="ServletA" method="POST" enctype="multipart/form-data">
<input type="text" name="username" /><br>
文件1：<input type="file" name="file1"><br>
<input type="submit" />
</form>
```

```java
protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	System.out.println(request.getParameter("username"));
	ServletInputStream sis = request.getInputStream();
	String filePath = getServletContext().getRealPath("/body.out");
	System.out.println(filePath);
	FileOutputStream fos = new FileOutputStream(filePath);
	byte[] buf = new byte[1024];
	int len = sis.read(buf, 0, 1024);
	while(len!=-1) {
		fos.write(buf);
		len = sis.read(buf, 0, 1024);
	}
	fos.close();
	sis.close();
}
```

在上面的例子中，如果使用`application/x-www-form-urlencoded`的格式提交参数，则参数会放在尸体内容中。注意观察，上传的文件只是简单的把文件名作为值，查看tomcat可知，文件中的二进制数据根本没有上传到tomcat中，

```html
//application/x-www-form-urlencoded下的实体内容
username=CC&file1=file.file
```

当改为`enctype="multipart/form-data"`后，文件上传成功，但在Servlet中使用`request.getParameter("username")`获取普通类型参数时，返回的是null。原因是，修改form的提交格式后，请求实体内容也发生了改变，这样的实体内容也叫做Request PayLoad：

```
------WebKitFormBoundaryMHeiqMDVAOFz54qz
Content-Disposition: form-data; name="username"

Roger
------WebKitFormBoundaryMHeiqMDVAOFz54qz
Content-Disposition: form-data; name="file1"; filename="file.file"
Content-Type: application/octet-stream


------WebKitFormBoundaryMHeiqMDVAOFz54qz--
```

实体内容分为两个部分，上半部分描述了text参数类型，`Content-Disposition`用于描述数据的基本属性，接着两个回车换行，然后是普通参数的值。下半部分描述了则是上传的文件。此外，tomcat中获取的文件数据与上传的文件也不完全相同，而是增加了许多PayLoad的信息，下面是tomcat中的获得的上传文件：

```
-----------------------------7e1a7b6b072a
Content-Disposition: form-data; name="username"

Roger
-----------------------------7e1a7b6b072a
Content-Disposition: form-data; name="file1"; filename="C:\Users\Roger\Desktop\file.file"
Content-Type: text/plain

read my file plz.
-----------------------------7e1a7b6b072a--
```

因此，想要实现我们期望的文件上传，最好借助Apache的`commons-fileupload.jar`包。

## 科普：Base64

Base64编码可以将任意一组字节转换为较长的常见文本字符序列，从而可以合法地作为首部字段值。Base64编码将用户输入或二进制数据，打包成一种安全格式，将其作为HTTP首部字段的值发送出去，而无须担心其中包含会破坏HTTP分析程序的冒号、换行符或二进制值。

**Base64最重要的用途就是把二进制数据编码为ASCII格式的文本，这样便可以放到HTTP请求和响应中进行传输。**

## 获取请求头信息（没啥大用）

浏览器在发送请求时，会自动创建许多请求头，并放到request请求中，我们在后端可以查看这些请求头信息。

```java
protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	Enumeration headerNames = request.getHeaderNames();
	while(headerNames.hasMoreElements()) {
	//所有的请求头
	String headerName = (String)headerNames.nextElement();
}
```

常用的与请求头相关的方法包括：

```java
String getHeader(String name);
Enumeration getHeaders(String name);
Enumeration getHeaderNames();
int getIntHeader(String name);
long getDateHeader(String name);
String getContentType();
String getContentLength();//获取实体内容的长度
String getCharacterEncoding(); //获取字符流所用的编码格式，有setCharacterEncoding()方法决定
```

**请求头的应用例子：利用Referer请求头阻止盗链**

非法盗链是指不从本网站中访问该Servlet，而是在其他网站中使用超链接来访问该Servlet。比如你的网站是`http://localhost:8080/newprojcet`，正常的访问方式是通过`http://localhost:8080/newproject/test.html`中的超链接来跳转到Servlet。但如果另一个页面http://172.16.9.9/otherproject/download.html`中的超链接也跳转到你的Servlet，这就发生了盗链。阻止盗链的本质就是确保你的Servlet只能从你的网站中被调用。

```java
protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	response.setContentType("text/html;charset=utf-8");
	PrintWriter out = response.getWriter();
	
	String referer = request.getHeader("referer"); //用户的地址页
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+
			request.getContextPath()+"/";
	if(referer!=null && referer.startsWith(basePath)) {
		out.print("往本网站的链接中下载");
	}
	else {
		out.print("非法盗链！");
	}
}
```

```html
<!--test.html-->
<body>
	<a href="ServletA" >下载<a>
</body>
```

如果打开`http://localhost:8080/newproject/test.html`，并点击超链接，这就是正常的访问效果。用工具查看也可发现，请求信息中包含请求头：`Referer:http://localhost:8080/newservlet/test.html`。如果你直接在浏览器地址栏中访问`http://localhost:8080/newservlet/ServletA`，则是非法盗链，因为此时请求头中并不包含Referer头信息。

**不要太相信请求头，很多时候请求头是可以伪造的。**

## 利用Request域传递数据

## 获取请求URL地址信息（没啥大用）

**获取请求类型：GET、POST、DELETE等**

```java
String method = request.getMethod();
```

**获取请求URI：**即位于URL的主机和端口之后，参数部分之前的内容

```java
//访问：http://localhost:8080/myproject/servlet/ReportServlet?username=cc&dept=IT
//得到URI=/servlet/ReportServlet
String requestURI = request.getRequestURI();
```

**获得请求参数：**获得URL中请求参数的部分，返回结果并没有被解码，如果没有参数，则返回null。

```java
//访问：http://localhost:8080/myproject/servlet/ReportServlet?username=cc&dept=IT
//得到queryString=username=cc&dept=IT
String requestURI = request.getQueryString();
```

**获取请求协议名和版本**

```java
String protocal = request.getProtocol(); //HTTP/1.1
```

**获取web项目名称路径**

```java
//我的部署项目名称是myproject，所以返回值是/myproject
String contextPath = request.getContextPath();
```

**获取请求URL中的额外路径信息**

在MVC框架中，客户端的所有请求都指向一个座位中央控制器的Servlet，其他各个JSP页面则座位请求URL中的额外路径部分，由这个Servlet根据额外路径信息去调用其他各个JSP页面。只要在web.xml中将某个Servlet映射成一个通配符形式的路径，例如`/controller/*`，然后就可以使用`/controller/one.jsp`、`/controller/two.jsp`等多个路径来访问这个Servlet，其中的`/one.jsp`和`/two.jsp`就是额外路径信息。可以让这些额外路径信息正好是web服务器上的其他资源名称。

```java
String getPathInfo()
```

**获取求URL中的额外路径信息在硬盘上的真实物理路径**

```java
String getPathTranslated()
```

**获取<url-pattern>映射路径中，不含通配符的部分**

```java
<url-pattern>/servletmap/*</url-pattern>
String servletPath = request.getServletPath(); //返回/servletmap
```

## 获取网络连接信息（没啥大用）

```java
protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	String remoteAddr = request.getRemoteAddr(); //获取客户端ip
	String remoteHost =request.getRemoteHost(); //获取刻客户端主机名
	int remotePort = request.getRemotePort(); //获取客户端端口号
	
	String localName = request.getLocalName(); //获取服务端主机名
	int localPort = request.getLocalPort(); //获取服务端端口号
	String serverName = request.getServerName(); //当前请求所指向的主机名，没搞懂
	int serverPort = request.getServerPort(); //当前请求所指向的端口号，没搞懂
	
	String scheme = request.getScheme(); //请求协议协议名：http、https、ftp
	StringBuffer requestURL = request.getRequestURL(); //请求完整URL，不包括参数部分
}

//输出
/*
0:0:0:0:0:0:0:1
0:0:0:0:0:0:0:1
2113
0:0:0:0:0:0:0:1
8080
localhost
8080
http
http://localhost:8080/myproject//servletmap/one.jsp
*/
```

