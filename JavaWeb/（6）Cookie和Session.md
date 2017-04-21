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
## Session的跟踪机制

## Session生命周期：创建

## Session生命周期：销毁

