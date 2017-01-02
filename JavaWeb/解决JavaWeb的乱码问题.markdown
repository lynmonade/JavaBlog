# 解决JavaWeb的乱码问题

## 1. 容易混淆的概念
本文旨在介绍一些实战经验来避免乱码问题，关于编码相关的理论知识，可以参考这位大神写的系列文章：[字符集与编码](https://my.oschina.net/goldenshaw/blog?catalog=536953)。这里只列出一些容易混淆的概念：

1. 字符集定义了有哪些字符可以用，并且定义了用哪个码点（code point）来表示字符。字符集编码定义了如何用二进制数据表示该码点。
2. ASCII，ISO-8859-1，GBK既表示字符集，也表示字符集编码格式。
3. unicode是字符集，不是字符集编码格式。unicode基本包含了所有字符。
4. UTF-8，UTF-16，UTF-32是字符集编码格式，不是字符集，他们用于对unicode所包含的字符进行编码。
5. Base64编码是可逆的，他只能用于编码，不能用于加密敏感信息。
6. ANSI严格来说并不是一种编码规则，它表示：根据当前操作系统以及操作系统的语言，选择对应的编码规则进行编码。例如，对于简体中文的Windows操作系统，ANSI代表GBK。在繁体中文Windows操作系统中，ANSI代表Big5。在日文Windows操作系统中，ANSI代表Shift_JIS编码。

### 1.1 编码与解码
编码：选择特定的编码格式，把字符、字符串转换成二进制数据。解码：选择特定的解码格式，把二进制数据转换成字符、字符串。

```java
//把"中国"二字按照UTF-8编码后，得到二进制数组。
byte[] binary = "中国".getBytes("UTF-8");

//把二进制数组按照UTF-8解码后，得到对应的字符串
String str = new String(binary, "UTF-8");
```
### 1.2 乱码
乱码的本质就是，使用了A编码方式进行编码，但接着却使用B编码方式来解码。这样就会造成乱码。编码和解码在有些情况下是可逆的，也就是说本身背后的二进制数据的精度并未丢失。这时你只需要再重新编码，然后解码，就可以还原出正确的字符串。可以参考"在浏览器表单中提交中文参数"的章节。但有时编码和解码是不可逆的，因为背后二进制数据在编码时精度丢失了，这时..我也不懂怎么办了。一般经验是，尽量选择包含字符比较全的字符集编码，这样精度不容易丢失，比如UTF-8，GBK，UTF-16。






## 2. 常见的坑

### 2.1 浏览器如何对页面进行解码
对于HTML和JSP页面，浏览器优先使用response中设置的编码格式，response中的编码格式可以使用`response.setChracterEncoding("UTF-8")`或者`response.setContentType("text/html;charset=UTF-8");`来指定。如果没有显式指定response的编码格式，则浏览器采用HTML和JSP页面中所指定的编码格式对页面进行解码。

在HTML和JSP中，强烈建议使用下面的语句，显式的说明文档的编码格式。这样有助于IDE、文本编辑器、浏览器在加载文档时，正确选择该编码格式进行解码。如果忽略了这些语句，程序在加载文档时只能像无头苍蝇一样低效地猜测文档的编码格式了，何必呢。

```html
//HTML
<meta http-equiv="content-type" content="text/html; charset=UTF-8">

//JSP
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
```

此外，用户还可以强制改变浏览器的编码格式，选择指定的编码格式对页面进行解码。

### 2.2 浏览器如何对表单提交的参数进行编码
无论是get请求，还是post请求，浏览器都会自动对表单提交的参数进行编码，再传递给web服务器。浏览器在显示页面文档时，需要使用**某种字符集编码（由“1.浏览器如何对页面进行解码”决定）**来对页面内容进行解码。同样的，浏览器也使用该字符集编码对表单提交的参数进行编码。

> 浏览器对参数的编码方式 == 浏览器当初对页面使用的解码方式

此外，笔者在chrome50.0和firefox50.1版本上做过测试：对于Servlet Path, Path Info, Query String，浏览器均采用**浏览器当初对页面使用的解码方式**对它们进行编码。不过还是建议Servlet Path和Path Info使用ASCII字符。

![URL组成](http://ww4.sinaimg.cn/mw690/0065Y1avgw1fba24rbntyj30s5085gmk.jpg)

### 2.3 web服务器如何对参数进行解码
后端对参数的方式由各个应用服务器厂商所决定，J2EE规范并没有强制要求。对于tomcat来说，默认使用ISO-8859-1进行解码。如果需要使用其他的编码格式，则必须修改配置文件或者手工指定编码格式。

#### 2.3.1 修改tomcat的默认的解码格式
由于ISO-8859-1不支持中文，因此建议修改tomcat的配置文件，把默认的解码格式修改为UTF-8：

```
// %TOMCAT_HOME/conf/server.xml%
<Connector port="8080" protocol="HTTP/1.1" 
connectionTimeout="20000" redirectPort="8443" 
URIEncoding="UTF-8" useBodyEncodingForURI="true"/>
```

其中，`URIEncoding="UTF-8"`表示使用UTF-8对get方式提交的参数进行解码。`URIEncoding="UTF-8"`并不会影响post方式提交参数的解码方式。

#### 2.3.2 request.setCharacterEncoding()
`request.setCharacterEncoding()`用于指定编码格式对post方式提交的参数进行解码。`request.setCharacterEncoding()`必须在`getParameter()`之前调用才会起效果。

此外，在上一小节中tomcat的配置文件还有一个属性设置需特别注意：`useBodyEncodingForURI="true"`。它表示`request.setCharacterEncoding()`的设置也将对get方式提交的query string参数起效果，并且其优先级比URIEncoding更高。

#### 2.3.3 tomcat检查header中的content-type
其实还有一个有意思的现象：对post提交的参数，tomcat在解析parameter参数集合之前会获取Header的content-type请求头，并检查这个content-type的charset值。但在默认情况下浏览器在提交form表单时，提交的content-type是不会含有charset信息的。

#### 2.3.4 HTTP Header的编解码
Http Header包含Cookie redirectPath等信息，同样会涉及编解码问题。tomcat默认使用ISO-8859-1进行编解码。然而我们并不能设置Header编解码格式。所以如果你想往Header中写入中文字符，则必须使用URLEncoder("UTF-8")先进行编码后再写入Header。

#### 2.3.5 用两张神图来概括上面的知识
![请求资源的编码-解码过程](http://ww4.sinaimg.cn/mw690/0065Y1avgw1fbabou7eo4j30ng084abv.jpg)

![GET/POST的编码-解码过程](http://ww1.sinaimg.cn/mw690/0065Y1avgw1fbabotiqdoj30up0f2acp.jpg)

### 2.4. 请求转发/重定向包含中文参数
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

### 2.5 JDBC的编码格式设置
访问数据库都会通过通过JDBC驱动来完成的，用JDBC来存取数据要和数据库的内置编码保持一致，以MySQL为例，可以通过JDBC URL来指定：url="jdbc:mysql://localhost:3306/DB?useUnicode=true&characterEncoding=UTF-8"。

### 2.6 设置文件的编码/解码格式
我们可以IDE或者文本编辑器里，可以设置该文件的编码格式：

![在编辑器里设置文件编码格式](http://ww4.sinaimg.cn/mw690/0065Y1avgw1fazoz42cn4j30da0gfgoa.jpg)

大家不要被**编码格式**四个字给蒙蔽了，其实在编辑器中设置的编码格式不仅用于编码，也用于解码。当我们往文件中写入字符，然后CTRL+S保存时，编辑器会根据当前文件的编码格式，对字符进行编码，转为对应的二进制数据，并把二进制数据保存在硬盘上。当我们用编辑器打开一份文件时，编辑器会自行选择一种**它认为最匹配的编码方式**，对文件中的二进制数据进行解码，并把解码后的字符呈现出来。

不同的编辑器选择的**最匹配的编码方式**有可能是不一样的。比如在notepad++中第一次打开一个html文件，notepad++会选择HTML文件中<meta>标签指定的编码格式进行解码。而myeclipse则会根据项目的编码格式，以及preferences中的设置，选择相应的编码格式来解码。

### 2.7 JS中的编码问题
详见《深入分析JavaWeb技术内幕》的3.5小节。

### 2.8 一种不正常的正确编码
![一种不正常的正确编码](http://ww2.sinaimg.cn/mw690/0065Y1avgw1fbacnpfbaxj30vn0i9422.jpg)

## 3. code Snippet
```Java
/**
 * Description:把字节byte转化为十六进制表示，可用来查看urlencode之后的效果
 * @params: 字节数组
 * @return:String
 */
public static String bytesToHexString(byte[] src){  
    StringBuilder stringBuilder = new StringBuilder("");  
    if (src == null || src.length <= 0) {  
        return null;  
    }  
    for (int i = 0; i < src.length; i++) {  
        int v = src[i] & 0xFF; //很重要
        if(i<src.length-1) {
        	stringBuilder.append("%"); //分隔符
        }
        String hv = Integer.toHexString(v);  
        if (hv.length() < 2) {  
            stringBuilder.append(0);  
        }
        stringBuilder.append(hv);
	       
    }  
    return stringBuilder.toString();  
}


/**
 * Description:查看字符串使用指定编码格式编码后的值。功能类似于urlencode
 * @params:src:需要编码的字符串, charsetName:编码格式
 * @return:String:编码后的值，返回值用十六进制表示。
 */
public static String toCharsetHex(String src, String charsetName) {
	if(!Charset.isSupported(charsetName)) {
		System.out.println("不是有效的编码格式");
		return null;
	}
	try {
		return bytesToHexString(src.getBytes(charsetName));
	} catch (UnsupportedEncodingException e) {
		e.printStackTrace();
		System.out.println("出现异常!!");
		return null;
	}
}


//编码和解码
String str = "中国";
byte[] b = str.getBytes("UTF-8"); //使用UTF-8对字符串进行编码
String str2 = new String(b, str); //使用UTF-8对字节数组进行解码

```

## 4. 经验小结
* 安装完MyEclipse后，设置项目和文件的编码方式为UTF-8，[设置方法]()
* 修改tomcat配置文件：设置`URIEncoding="UTF-8" useBodyEncodingForURI="true"`。
* 对于请求转发、重定向，最好手动对URL进行URLEncode，指定使用UTF-8进行编码。对于超链接、get/post提交参数，心里一定要非常清晰的知道**浏览器当初对页面使用的解码方式**，因为这是参数的编码方式。
* 在后端合理使用这三个方法：`request.setCharacterEncoding(), response.setContentType, response.setCharacterEncoding()`。
* 编写HTML、JSP页面时，显式地设置`<meta>, <%page>`为UTF-8。
* 对于不同国家站点的表单提交数据，可以在表单中使用一个隐藏字段表示站点的编码格式，这样在servlet中就可以使用对应的方式进行解码。
* `string.getByte("");`所使用的编码格式由操作系统决定，因此不建议使用该方式，而应该显式的指定编码格式：`string.getByte("UTF-8");`
* 当发现中文变成?，很可能就是错误地使用了ISO-8859-1编码导致的。
* 在安装数据库时，最好选择UTF-8的编码格式。（中文windows下安装oracle时默认是GBK）。


## 5. Reference
* [《深入体验Java Web开发内幕-核心基础》 第六章：HttpServletRequest的应用]()
* [《深入分析Java Web技术内幕》 第三章：深入分析Java Web中的中文编码问题]()
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

