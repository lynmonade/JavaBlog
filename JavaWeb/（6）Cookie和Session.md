# Cookie和Session

## 会话机制的诞生

HTTP协议是一种无状态的协议，因此web服务器本身无法区分前一次请求和后一次请求是否来自同一个浏览器。

单纯地使用HTTP协议无法实现**会话机制**。会话是指一个客户端浏览器与web服务器之间连续发生的一系列请求和响应的过程。一个用户在某网站上的整个购物过程就是一个会话。所以有人就想了一个办法：

> web服务器为每个客户端浏览器分配的一个唯一代号，它通常是在web服务器接收到某个浏览器的第一次访问时产生的，并随同响应信息一道发送给浏览器，浏览器则在以后发出的访问请求消息中都带有一条信息：我的代号是xxx，这样web服务器就能识别出这次请求是来自哪个客户端浏览器了。这个代号也称为**会话ID（SessionID）。**

SessionID会在web服务端创建，在web服务端和客户端浏览器各保存一份。当浏览器发起请求时，web服务端根据传入的SessionID与web服务端存储的SessionID进行比对，就知道该请求用户是否来自新的会话，或者来自已有的会话。

为了让SessionID能在服务端和客户端之间传递，因此都会把SessionID作为Cookie的一个属性项。也就是说，**Cookie可以看做是SessionID的传输通道和承载容器**。

后端在调用`request.getSeesion()`时，会自动创建一个Session和Cookie，并把SessionID作为属性项放入Cookie中。最后自动把Cookie放入到响应消息头中回传给浏览器。

![](http://wx3.sinaimg.cn/mw690/0065Y1avgy1fes4n4se1dj30rj088ad0.jpg)

![](http://wx1.sinaimg.cn/mw690/0065Y1avgy1fes4nec7fsj30s208841x.jpg)

## Cookie生命周期：创建

一个Cookie本质上来说就是一个Map。根据Cookie所遵循的规范（Cookie规范和Cookie2规范），Cookie可以包含若干个属性项，属性项类似于Map中的键-值对，但其中的key是由Cookie规范所决定的，开发者不能使用未定义的key。以Cookie2规范来说，它可用的属性项key包括：NAME、Version、Comment、CommentURL、Discard、Domain、Max-Age、Path、Port、Secure。详见Cookie属性项详解的章节。

```java
Set-Cookie2:email=lyn@hotmail.com;Version=1;Path=/
```

![](http://wx1.sinaimg.cn/mw690/0065Y1avgy1fesw0vlnxkj30oz09pad6.jpg)

Cookie的Key-Value只能由ASCII字符组成，Web服务器采用某种编码格式将Key-Value编码成可打印的ASCII字符。个人建议：不要往Cookie中写入中文字符。

Cookie是在web服务端创建的，Cookie会在下列两种情况下被创建：

**1.显式地创建Cookie对象，并添加到response响应头中：**

```java
protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {	
	Cookie ckName = new Cookie("name", "lyn");
	Cookie ckNickname = new Cookie("nickname", "lemon");
	ckNickname.setMaxAge(60*60*24*365);
	Cookie ckEmail = new Cookie("email", "lyn@hotmail.com");
	Cookie ckPhone = new Cookie("phone", "139");
	response.addCookie(ckName);
	response.addCookie(ckNickname);
	response.addCookie(ckEmail);
	response.addCookie(ckPhone);
}
```

**2.创建Session后，自动创建一个Cookie，并把SessionID放入Cookie中，KEY为JSESSIONID，VALUE=SessionID：**

```java
HttpSession session = request.getSession();
```

![](http://wx2.sinaimg.cn/mw690/0065Y1avgy1fese84oqzdj30jy02wmx4.jpg)

## Cookie生命周期：持久化

虽然Cookie是在服务端常见的，但其实是在客户端进行持久化存储的。Cookie在服务端创建后就被放入响应消息头中，随着响应一起传递给浏览器。

**1.如果该Cookie显式设置了销毁时间（通过Expires或者Max-Age属性设置），则在销毁时间到来之前，Cookie会一直保存在客户端计算机的硬盘中 ，即使浏览器关闭了，该Cookie也依然保存在客户端计算机的硬盘上。**

**2.如果该Cookie没有设置销毁时间，则Cookie保存在浏览器进程的内存空间中，如果浏览器关闭了，则Cookie也随之被销毁。**

一般来说浏览器可以为每个站点最多存放20个Cookie，每个Cookie的大小限制为4KB。

## Cookie生命周期：传输

在前面提到，Cookie在服务端创建后，会通过响应消息头传递到客户端。此时，多个Cookie信息通过多个Set-Cookie请求头字段回送给客户端。（也有一些浏览器是把多个Cookie放到一个Set-Cookie头字段中的，每个Cookie用逗号分隔，但这是一种不规范的 形式）

![](http://wx3.sinaimg.cn/mw690/0065Y1avgy1ferutuomqaj30oq0dgt9q.jpg)

浏览器的每次访问请求中都使用一个Cookie请求头字段将Cookie信息会送给服务端，多个Cookie信息只能通过一个Cookie请求头字段传送给服务端。

![](http://wx3.sinaimg.cn/mw690/0065Y1avgy1feruwnr5f8j30oq0bt751.jpg)

浏览器每次向服务器发送请求时，都要根据下面的规则，决定是否发送Cookie请求头字段，以及在Cookie请求头字段中附带哪些Cookie信息：

- 请求的服务端主机名是否与某个存储Cookie的Domain属性匹配。
- 请求的端口号是否在该Cookie的Port属性列表中。
- 请求的资源路径是否在该Cookie的Path属性指定的目录及子目录中。
- 该Cookie的有效期是否已过。



## Cookie属性项详解

**1.Comment=value**

用于描述这个Cookie的用途。这能用于Version 0规范的Cookie。

```java
public void setComment(String purpose)
public String getComment()
```

**2.Discard**

Discard属性没有属性值部分，它用于通知浏览器关闭时无条件地删除该Cookie信息。如果没有设置这个属性，浏览器删除Cookie的行为由Max-Age决定。

**3.Domain=value**

Domain的格式遵循RFC 2109规范，Domain的名称以.开头，例如`.foo.com`,这意味着Cookie对于`www.foo.com`有效，但对`a.b.foo.com`无效。

Domain属性的默认值是当前主机名，浏览器以后只有在访问与当前主机名完全相同的web服务器时，才会将这个Cookie会送给该服务器。Domain属性设置值是不区分大小写的。

**4.Max-Age=value**

用于指定Cookie在客户端保持有效的时间。value部分是秒为单位的十进制整数。

* value等于0表示：Cookie传递给浏览器后立即删除该Cookie。这样就可以让客户端的Cookie立刻失效。
* value大于0表示：Cookie会保存在客户端硬盘中，知道没有超过指定秒数之前，这个Cookie都保持有效。
* value小于0或者未设置Max-Age属性表示：浏览器将Cookie保存在内存中，浏览器关闭时Cookie也随之销毁。

**5.Path=value**

Path属性用于指定Cookie对服务器上的哪个URL目录和其子目录有效。该属性的默认值是产生Set-Cookie2头字段时的那个请求URL地址所在的目录。如果没有显式地设置Path属性，浏览器以后再访问当前请求URL地址所在的目录及其子目录下的任何资源时都将回传该Cookie信息。Path属性值区分大小写。

Path属性经常会用到，下面给出一个小例子：

SerlvetD用于在后端创建Cookie，对应的映射路径是：`http://localhost:8080/cookie/D/ServletD`

ServletB用于打印后端获取到的Cookie，对应的映射路径是：`http://localhost:8080/cookie/B/ServletB`

```java
//ServletD
protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	Cookie ckPhone = new Cookie("phone", "139");
	Cookie ckEmail = new Cookie("email", "lyn@hotmail.com");
	response.addCookie(ckPhone);
	response.addCookie(ckEmail);
}

//ServletB
protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	response.setContentType("text/html;charset=utf-8");
	PrintWriter out = response.getWriter();
	
	Cookie[] cookies = request.getCookies();
	if(cookies==null || cookies.length==0) {
		out.print("请求头中没有附带cookie");
		return;
	}
	for(int i=0; i<cookies.length; i++) {
		Cookie cookie = cookies[i];
		System.out.println(cookie.getName()+"="+cookie.getValue());
	}
}
```

第一步：在浏览器里访问ServletD，由于没有显式的设置Cookie的path属性，cookie的path值为ServletD所在目录，即`/D`。此时，后端创建的Cookie通过响应头返回给前端。

![](http://wx2.sinaimg.cn/mw690/0065Y1avgy1fet99oemb6j30o30av0tg.jpg)



第二步：在浏览器里通过`http://localhost:8080/cookie/B/ServletB`访问ServletB，此时ServletB所在的目录是`/B`，由于第一步浏览器获得的cookie的path目录是`/D`，因此浏览器并不会把cookie传输给这个服务端，请求头中不包含Cookie的信息。

![](http://wx3.sinaimg.cn/mw690/0065Y1avgy1fet99ny9gtj30ou0au0tf.jpg)

第三步：修改Servlet，为ckPhone这个cookie显示地设置path属性：

```java
//表示该cookie的path属性为该web项目根目录，即http://localhost:8080/cookie/
ckPhone.setPath("/");
```

第四步：再次通过`http://localhost:8080/cookie/D/ServletD`访问ServletD，覆盖浏览器端的Cookie。然后通过`http://localhost:8080/cookie/B/ServletB`访问ServletB。此时会发现ckPhone这个cookie被放到了请求头中，而ckEmail依然没有放到请求头中，这是因为我们已经把ckPhone的path修改为web项目根目录了。

![](http://wx4.sinaimg.cn/mw690/0065Y1avgy1fet9lvh2afj30p30arjs2.jpg)

**6.Port=[="portlist"]**

Port属性用于指定浏览器通过哪些端口访问Web服务器时，Cookie才有效，端口号列表中的每个端口号之间用`,`分隔，整个端口号列表必须用双引号引起来。默认值是任意端口。

**7.Secure**

Secure属性没有属性值部分，它用于通知浏览器在回传这个Cookie信息时，应使用安全的方式访问服务器，以保护Cookie中的机密和认证信息。如果没有设置Secure属性，浏览器可以用非安全的方式发送这个Cookie信息。

**8.Version=value**

Version属性用于指定Cookie内容所遵循的版本格式，version=0表示Set-Cookie，而version=1可以使用。

**一般来说，如果两个Cookie的名字相同，Domain属性值、Path属性值也相同，那么可以认为这两个代表的是同一个信息，新的Cookie将替换以前的Cookie。**

## 在服务端获取请求消息头中的Cookie

```java
protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	response.setContentType("text/html;charset=utf-8");
	PrintWriter out = response.getWriter();
	for(int i=0; i<cookies.length; i++) {
		String key = cookies[i].getName();
		String value = cookies[i].getValue();
		out.println(key+"="+value+"<br>");
	}
}
```
## 使用Base64编码解决Cookie中文问题

如果你希望往Cookie中使用中文，则必须在服务端先对Cookie使用Base64编码，然后放入响应消息头中。同样地，当你在服务端获取客户端传过来的中文Cookie时，也要进行Base64解码才能读取Cookie的内容。

```java
protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	response.setContentType("text/html;charset=utf-8");
	PrintWriter out = response.getWriter();
	Calendar cal = Calendar.getInstance();
	SimpleDateFormat format = new SimpleDateFormat("yyyy年MM月dd日 HH时mm分ss秒");
	String formatTime = format.format(cal.getTime());
	
	//Apache Common Codec
	BCodec base64Coder = new BCodec("UTF-8");
	try {
		formatTime = base64Coder.encode(formatTime); //base64编码
	} catch (EncoderException e1) {
		e1.printStackTrace();
	}
	Cookie ck = new Cookie("time", formatTime);
	response.addCookie(ck);
	
	Cookie[] cks = request.getCookies();
	if(cks==null) {
		out.println("Cookie中没有存储最新时间");
		return;
	}
	for(int i=0; i<cks.length; i++) {
		Cookie cookie = cks[i];
		if(cookie.getName().equals("time")) {
			String value = cookie.getValue();
			try {
				String time = base64Coder.decode(value); //base64解码
				out.print("现在的时间是："+time);
			} catch (DecoderException e) {
				e.printStackTrace();
			}
		}
	}
}
```

![](http://wx1.sinaimg.cn/mw690/0065Y1avgy1fevn4yz5b3j30pl0anaar.jpg)

## 利用Cookie实现Session跟踪

使用Cookie后没我们可以实现将上一次请求的状态信息传递到下一次请求中。但如果传递的信息过多，这回降低网络传输效率，并且每个站点的Cookie大小和数量均由限制。**解决方案就是：引入Session跟踪机制**。

**在系统设计时，系统U需要限定一个会话只能从某个Servlet中开始，而不能从其他Servlet开始。例如：Web站点要求只有用户登录成功后才能真正开启与客户端的会话过程。**首先，用户只能先访问LoginServlet，LoginServlet中将使用`request.getSession()`来为本次请求创建一个HttpSession对象，并把一些基础信息保存在Session域中，然后自动把SessionID回传给给浏览器。接着浏览器发起另一个请求访问OrderServlet，同时把SessionID放入到请求头中。服务端把传入的SessionID与服务端存储的SessionID进行对比，以判断该请求是否在会话中。

**这样做的好处是：客户端只需持有一个SessionID，而其他的基础信息保存在后端的Session域中。后端只需功过SessionID就可以区分不同的会话请求。**

![](http://wx3.sinaimg.cn/mw690/0065Y1avgy1feu2dfna0ej30pz0d6jvx.jpg)



## 利用URL重写实现Session跟踪

这个用的比较少，因为现在浏览器一般都默认开启Cookie的，但还是有必要学习一下。当客户端关闭Cookie机制后，服务端依然可以通过Set-Cookie响应头消息头把JSESSIONID传递给客户端，但客户端无法通过请求消息头把JSESSIONID传递给服务端。这时我们就需要利用URL重写，把JSESSIONID拼接到URL后面。URL重写涉及两个方法：

```java
//用于对超链接和form表单的action属性中设置的URL进行重写
String encodeURL(String url)
//用于对要传递给response.sendRedirect方法的URL进行重写
String encodeRedirectURL(String url)
```

**例子**

```java
protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	response.setContentType("text/html;charset=utf-8");
	PrintWriter out = response.getWriter();
	Cookie ckPhone = new Cookie("phone", "139");
	Cookie ckEmail = new Cookie("email", "lyn@hotmail.com");
	response.addCookie(ckPhone);
	response.addCookie(ckEmail);
	HttpSession session = request.getSession();
	
	out.println("<html>");
	out.println("<body>");
	out.println("<a href='" + 
			response.encodeURL("ServletE") + 
			"'>访问SerlvetE</a>");
	out.println("</body>");
	out.println("</html>");
}
```

**第一步：访问ServletD，普通Cookie和JSESSIONID正常的写入到响应头中。**

![](http://wx1.sinaimg.cn/mw690/0065Y1avgy1fevhj629ywj30pa0axaap.jpg)

**第二步：通过超链接访问ServletE，JSESSIONID拼接到URL后面，并且无法再传递普通Cookie。**

![](http://wx1.sinaimg.cn/mw690/0065Y1avgy1fevhj5blw8j30ot0aejrx.jpg)

## Session生命周期：创建

服务端会在下列两种情况下创建Session对象：

1. 请求消息头中不包含SessionID，这种情况一般发生在某个客户端浏览器首次访问某个能开启会话功能的Servlet时，例如LoginServlet
2. 请求的请求头或者URL中包含SessionID，但该SessionID与后端存储的SessionID不匹配。这种情况发生在浏览器超时后再次访问服务端。

创建Session的方法有两个：

```java
HttpSession getSession()
HttpSession getSession(boolean create)
```

第一个方法表示：如果传入的sessionID与后端存储的sessionID不匹配，则创建一个新的Session对象，并把sessionID放入到Cookie中回传给浏览器。如果匹配，则直接返回匹配的Session对象。该方法一般用于LoginServlet这样的会话入口。

第二个方法表示：当参数为true时，则其效果与第一个方法相同。当反诉为false时，如果sessionID不匹配，则返回null，并不会创建新的Session对象。如果匹配，则返回匹配的Session对象。该方法一般用于非会话入口的Servlet。

## Session生命周期：销毁

当用户关闭浏览器后，服务端的Session对象并不会被销毁，因为服务端根本无法检测到客户端浏览器是否关闭。Session对象只能在下面两种情况下被销毁：

1. 从客户端最后一次发送请求的时间后，如果超过了服务端所配置的超时时间，则服务端自动销毁该Session对象。
2. 在服务端显式地调用`session.invalidate();`，强制销毁该session。

**超时时间配置**

超时时间可以在`%TOMCAT_HOME/conf/web.xml%`中配置，此时对tomcat下所有的web项目都起作用。也可以在web项目下的web.xml中单独配置，此时该配置会覆盖tomcat的全局配置，仅应用于该web项目。

```xml
<session-config>
	<session-timeout>30</session-timeout>
</session-config>
```

此外，我们也可以单独对某一个Session设置他的超时时间（从最后一次请求开始计算）。

```java
//单位是秒，如果参数是负数，则表示session永远不会被超时销毁
void setMaxInactiveInterval(int interval)
int getMaxInactiveInterval()
```



## Session生命周期：查看状态

```java
//HttpSession
String getId(); //获取sessionID
long getCreationTime(); //获取session创建时间
long getLastAccessedTime(); //获取客户端在回话中，最后一次发送请求的时间
boolean isNew(); //判断session是否是刚刚新创建的

//HttpServletRequest
boolean isRequestedSessionIdValid(); //判断请求消息中的sessionID是否能匹配后端存储的某个Session
String getRequestedSessionId(); //获取请求消息中的sessionID
boolean isRequestedSessionIdFromCookie(); //判断请求中的sessionID是否来自于请求消息头中的cookie
boolean isRequestedSessionIdFromURL(); //判断请求中的sessionID是否来自于请求消息的URL中


```

## Session域存储

前面说到，为了减少Cookie的传输数量，因此可以把一些基本信息存储在Session域中。来自同一客户端的一组访问才能共享同一个Session对象，即只在同一会话中有效。

```java
//不存在属性则创建，存在则替换，如果value为null，则等价于删除属性
void setAttribute(String name, Object value)
//获取属性
Object getAttribute(String name)
Enumeration getAttributeNames()
//删除属性
void removeAttribute(String name)
```

## Session的持久化管理

**Session持久化：**Session对象创建后，会保存在tomcat内存中。为了提高内存利用率，我们通常会将暂时不活动但又未超时的session对象转移到文件系统或数据库中存储，一旦服务端需要使用它们，再将它们从文件系统或数据库中装载进内存。

当把Session对象保存到文件系统或数据库中时，需要采用序列化的方式将Session对象中的每个属性对象保存到文件系统或数据库中。当把Session对象从文件系统或数据库中装载进内存时，需要采用反序列化。因此存储在Session对象中的每个属性对象都必须是实现了Serializable接口的对象。

**Tomcat中的Session持久化管理**

当在服务端创建Session后，Session便保存在tomcat的内存中。此时如果tomcat正常的关闭，则在关闭之前，tomcat会把内存中的Session对象进行序列化，并保存在`%TOMCAT_HOME%/work/Catalina/%主机名%/PROJECT_NAME/SESSIONS.ser`文件中。当tomcat重新启动后，会对SESSIONS.ser进行反序列化，得到session对象，并载入到tomcat内存中。浏览器就可以继续进行之前的会话了。

Tomcat提供了两个类来实现Session的持久化管理：

```java
org.apache.catalina.session.StandardManager
org.apache.catalina.session.PersistentManager
```

StandardManager类便实现了把session对象序列化到SESSIONS.ser、反序列化SESSIONS.ser得到session对象的功能。PersisentManager