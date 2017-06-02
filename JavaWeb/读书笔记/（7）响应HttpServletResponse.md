# 响应HttpServletResponse

> ServletResponse API:
>
> Defines an object to assist a servlet in sending a response to the client. The servlet container creates a `ServletResponse` object and passes it as an argument to the servlet's `service` method. 
>
> To send binary data in a MIME body response, use the [`ServletOutputStream`](../../javax/servlet/ServletOutputStream.html) returned by [`getOutputStream()`](../../javax/servlet/ServletResponse.html#getOutputStream()). To send character data, use the `PrintWriter` object returned by [`getWriter()`](../../javax/servlet/ServletResponse.html#getWriter()). To mix binary and text data, for example, to create a multipart response, use a `ServletOutputStream` and manage the character sections manually. 
>
> The charset for the MIME body response can be specified explicitly using the [`setCharacterEncoding(java.lang.String)`](../../javax/servlet/ServletResponse.html#setCharacterEncoding(java.lang.String)) and [`setContentType(java.lang.String)`](../../javax/servlet/ServletResponse.html#setContentType(java.lang.String)) methods, or implicitly using the [`setLocale(java.util.Locale)`](../../javax/servlet/ServletResponse.html#setLocale(java.util.Locale)) method. Explicit specifications take precedence over implicit specifications. If no charset is specified, ISO-8859-1 will be used. The `setCharacterEncoding`, `setContentType`, or `setLocale` method must be called before `getWriter` and before committing the response for the character encoding to be used. 

HttpServletResponse实现了ServletResponse接口，因此不妨先看一下ServletResponse的API介绍：**ServletResponse最重要的工作就是协助Servlet，把处理好的数据发送给客户端浏览器**。如果发送的是二进制数据，则需要借助`ServletOutputStream getOutputStream()`，如果是发送字符数据，则需要借助`PrintWriter getWriter()`,如果既包含二进制数据，又包含文本数据，则使用`ServletOutputStream getOutputStream()`，此时开发者需手工处理字节到字符的编码问题，这和I/O是一模一样的。此外还提供了设置编码格式的相关方法。

> HttpServletResponse API:
>
> Extends the ServletResponse interface to provide HTTP-specific functionality in sending a response. For example, it has methods to access HTTP headers and cookies. 
>
> The servlet container creates an HttpServletResponse object and passes it as an argument to the servlet's service methods (doGet, doPost, etc). 
>

HttpServletResponse实现了ServletResponse接口，**并依据HTTP协议的要求，增加了设置响应消息头、cookie信息等**。tomcat会自动创建HttpServletResponse对象，并作为方法参数传递到Servlet的doXXX方法中。

## 设置响应头

```java
void addHeader(String name, String value)
void addIntHeader(String name, int value)
void addDateHeader(String name, long date)
void setHeader(String name, String value)
void setIntHeader(String name, int value)
void setDateHeader(String name, long date)
```

add和set方法都可以用于设置响应头。如果该名字的Header不存在，add和set都将创建一个新的Header。如果改名字的Header已存在，add会新增一个同名Header，而set会替换原有Header。

```java
//设置响应内容大小，开发人员无需显式调用
void setContentLength(int len)

//设置响应内容的MIME类型，如果响应内容是文本，还可以同时设置字符编码格式，常用
void setContentType(String type) 

//设置编码格式，优先级最高，常用
void setCharacterEncoding(String charset)
  
//设置、读取本地化信息，很少用
void setLocale(Locale loc)
Locale getLocale()
  
//设置cookie
void addCookie(Cookie cookie)
```

**实用例子**

```java
//2秒后刷新当前servlet，如果配置了URL，则访问另一页面
response.setHeader("Refresh", "2");
response.setHeader("Refresh", "2;URL=http://www.baidu.com"); //访问另一个

//禁止浏览器缓存当前文档内容：有三个HTTP响应头字段都可以禁止浏览器缓存当前页面：
//并不是所有浏览器都能完全支持上面三个响应头，所以最好是同时使用上面三个响应头。只要浏览器能支持其中任何一种形式，就能禁止浏览器缓存当前页面。
response.setDateHeader("Expires", 0);
response.setHeader("Cache-Control", "no-cache");
response.setHeader("Pragma", "no-cache");

//设置MIME类型和字符集编码格式
response.setContentType("text/html; charset=GB2312");

//设置字符集编码格式
response.setCharacterEncoding("UTF-8");
```

**通过<meta>标签来设置响应头**

利用HTTP消息的响应头字段，可以让浏览器完成各种有用的功能，但这需要通过编写Web服务端程序来实现。如果不会服务端编程的普通HTML页面制作者也想借助HTTP消息的响应头字段来实现一些特殊功能，那该怎么办呢？为此，HTML语言中专门定义了<meta>标签的http-equiv属性来在HTML文档中模拟HTTP响应消息头，当浏览器读取到HTML文档中具有http-equiv属性的<meta>标签时，它会用与处理Web服务器发送的响应消息头一样的方式来进行处理。这样，静态HTML页面的制作者不用编写Web服务器端的程序，就可以在静态HTML页面中实现HTTP响应消息头的功能了。

注意，在response中设置的优先级高于<meta http-equiv>的优先级，因此，如果两边如果都进行了设置，则以response中的设置为准。

```HTML
<!--禁止缓存-->
<meta http-equiv="Expires" content="0">
<meta http-equiv="Cache-Control" content="no-cache">
<meta http-equiv="Pragma" content="no-cache">

<!-- 定时刷新、调转至其他页面 -->
<meta http-equiv="Refresh" content="2;url=http://www.baidu.com">

<!--设置编码MIME类型和字符集编码格式-->
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
```

## 响应正文内容：输出字符数据

如果响应正文是字符数据，则应该使用字符流来输出内容。如果响应正文是二进制数据，则应该使用字节流来输出内容。这与I/O的思想是一样的。

```java
//获取字符流Writer
PrintWriter out = response.getWriter();
```

如果你熟悉Java的I/O，则应该记得，PrintWriter是对Writer的曾庆，它提供了许多重载方法，让我们很方便的把各种数据类型的数据写入目的地。PrintWriter内部维护了一个Writer成员变量，其相关写入方法的调用，最终都会转化为Writer的write操作。这里所说的目的地一般就是浏览器。

1. 我们可以向目的地写入普通的文本内容。这时浏览器就像普通的文本编辑器一样原封不动的显示这些内容。
2. 我们也可以向目的地写入HTML文本内容。由于浏览器可以解析HTML文本内容，这时浏览器就会把这些内容渲染成为HTML页面。

```java
protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    //获取PrintWriter之前，先设置编码格式
	response.setContentType("text/html; charset=UTF-8");
	PrintWriter out = response.getWriter();
	out.println("中国"); //输出普通文本
	
    //输出HTML文本内容
	out.println("<html><head></head><body>");
	out.println("<b>地球</b>");
	out.println("</body></html>");
}
```

当你对同一个response对象多次调用getWriter()方法时，获取到的都是同一个PrintWriter对象。此外，`PrintWriter.print()`和`PrintWriter.println()`的区别在于输出到浏览器的内容是否带有换行，**但浏览器不会显示这个换行。**这个换行主要是为了增强浏览器接收到的源文件的可读性。

## 响应正文内容：输出二进制数据

**缓冲区的概念**

servlet程序输出的HTTP消息的响应正文不是直接发送到客户端，而是首先被写入到了servlet引擎提供的一个输出缓冲区中，这个缓冲区就像一个临时的蓄水池，直接输出缓冲区被填满或者servlet程序已经写入了所有的响应内容，缓冲区中的内容才会被servlet引擎发送到客户端。使用输出缓冲区后，servlet引擎就可以将响应状态行、各响应头和响应正文严格按照HTTP消息的位置顺序进行调整后再输出到客户端，特别是可以自动对Content-Length头字段进行设置和调整。 

在输出二进制数据时，一般我们都使用缓冲区。

**设置缓冲区**

我们可以通过`response.setBufferSize(int size)`方法设置缓冲区大小，size的单位是byte。实际的缓冲区空间不会小于你设置的值。当我们设置的缓冲区空间小于8192（8kb）时（比如0,甚至负数），web容器会自动设置缓冲区空间为8192。这主要是为了提高空间资源利用率。该方法必须在写入响应正文内容之前调用。

**缓冲区相关方法**

```java
//设置缓冲区大小，单位是byte
void setBufferSize(int size)
//获取缓冲区大小
int getBufferSize()
//将缓冲区中的内容强制输出到客户端，啥时候调用？我一直没搞懂
void flushBuffer()throws IOException
//清空缓冲区、状态码、响应头信息
void reset()
//仅清空缓冲区
void resetBuffer()
//判断是否已经提交了部分响应内容到客户端
boolean isCommitted()
```

**例子**

```java
//让用户下载名为myfile.txt的文件，在下载前往文件中写入文本内容
protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("application/x-msdownload");
		response.addHeader("Content-Disposition", "attachment;filename=myfile.txt");
		ServletOutputStream out = response.getOutputStream();
		out.write("this is my first download line".getBytes());
		out.write("我是中文行".getBytes());
		out.close();
	}

//利用缓冲区下载mp4文件（这代码在下载大文件时有点问题）
protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	//获取网站部署路径(通过ServletContext对象)，用于确定下载文件位置，从而实现下载  
	String path = getServletContext().getRealPath("/");  
	
	//设置输出缓冲区大小
	response.setBufferSize(1024*10);
	ServletOutputStream out = response.getOutputStream();

	//1.设置文件ContentType类型，这样设置，会自动判断下载文件类型  
	response.setContentType("multipart/form-data");
	String downloadFileName = "movie.mp4";
	//2.设置文件头：最后一个参数是设置下载文件名(movie.mp4)  
	response.setHeader("Content-Disposition", "attachment;fileName="+downloadFileName);  
	

	//通过文件路径获得File对象(假如此路径中有一个movie.mp4文件)  
	File file = new File(path + "WEB-INF/download/" + downloadFileName);  

	try {  
		FileInputStream inputStream = new FileInputStream(file);  
		//3.通过response获取ServletOutputStream对象(out)  
		int b = 0;  
		byte[] buffer = new byte[1024*10];  
		while (b != -1){
			b = inputStream.read(buffer);
			//4.写到输出流(out)中  
			out.write(buffer,0,b);  
		}  
		inputStream.close();  
		out.close();  
		out.flush();  

	} catch (IOException e) {  
		e.printStackTrace();  
	}  
}
```

## 用URL-rewriting方式来管理Session

如果客户端浏览器关闭了cookie，则后端必须使用URL来传递Session信息，此时就需要下面两个方法，具体用户详见《Cookie和Session》：

```java
String encodeURL(String url)
String encodeRedirectURL(String url)
```

