# Cookie和Session

会话是指一个客户端浏览器与web服务器之间连续发生的一系列请求和响应的过程。一个用户在某网站上的整个购物过程就是一个会话。

HTTP协议是一种无状态的协议，因此web服务器本身无法区分前一次请求和后一次请求是否来自同一个浏览器。为了让web服务器能知道哪些请求是来自同一个浏览器，这就需要浏览器对其发出的每个请求消息都进行标识，属于同一个会话中的请求消息都附带着同样的标识号，这个标识号就称之为**会话ID（SessionID）。**

**SessionID是web服务器为每个客户端浏览器分配的一个唯一代号，它通常是在web服务器接收到某个浏览器的第一次访问时产生的，并随同响应信息一道发送给浏览器，浏览器则在以后发出的访问请求消息中都带有一条信息：我的代号（SessionID）是xxx**，这样web服务器就鞥呢识别出这次请求是来自哪个客户端浏览器了。

会话ID可以通过Cookie在请求消息中进行传递，也可以作为请求URL的附加参数进行传递。

此外，我们还可以在web端往Session域中存储一些关于该会话的基本信息，比如用户姓名，所属单位等。

## Cookie介绍

Cookie是在浏览器访问web服务器的某个资源时，由web服务器在**HTTP响应头**中附带传送给浏览器的一片数据。浏览器可以决定是否保存Cookie数据。一旦浏览器保存了Cookie，那么浏览器在以后每次访问该web服务器时，都应在HTTP请求头中将这片数据会送给web服务器。

web服务器通过在HTTP响应消息中增加Set-Cookie响应头字段将Cookie信息发送给浏览器，浏览器则通过在HTTP请求消息中增加Cookie强求头字段将Cookie回传给web服务器。

**Cookie集合本质上来说就是一个Map集合，一个Cookie其实就是Map中的一个element。**一般来说每个站点最多存放20个Cookie，每个Cookie的大小限制为4KB。

如果没有设置Cookie的有效时间，接受它的浏览器进程只将该Cookie保存在自己的内存空间中，在该浏览器进程关闭时，它里面保存的所有Cookie也将随之消失。

**SessionID**本质就是一个保存在Cookie集合中的一个Cookie。例如，当用户登录成功后，web服务端会产生一个标识该用户身份的SessionID，然后把SeesionID放入到Cookie集合中传递给浏览器。浏览器在以后每次访问该web服务器时，都自动在请求消息头中将SeesionID放入到Cookie中，随着请求一起发送给web服务器，web服务器凭借Session就能分辨出当前请求是由哪个用户发出的。

## Cookie的创建

前面说到，Cookie本质上就是Map，因此Cookie也遵循Key-Value的形式。Cookie的Key是根据规范拥有既定值的，也就是说，开发者不能随意设置Cookie的key，只能使用Cookie规范中提供的Key。

目前有Set-Cookie和Set-Cookie2两种规范，Cookie2提供的Key更多。Cookie本质上会转换为一定格式的字符串。例如：

```java
Set-Cookie2:user=admin;Version=2;Path=/sina
```

Cookie的Key只能由ASCII字符组成，Web服务器采用某种编码格式将Value编码成可打印的ASCII字符。个人建议：不要往Cookie的值里写入中文字符。

**Cookie2规范种可用的Key-Value详见《深入体验JavaWeb开发内幕-核心基础》P371页。**

## Cookie的存储

Cookie一般保存在客户端，如果没有设置了Cookie的有效时间，则Cookie临时存储在浏览器进程的内存中，浏览器关闭后，Cookie会随之销毁。如果设置了Cookie有效时间，则Cookie保存在硬盘上，在到期之前，即使浏览器关闭，Cookie依然不会消失。

## Cookie作为数据传输载体

**1. web服务端创建Cookie后，会把Cookie放入到响应头中传递到客户端。多个Cookie信息只能通过一个Cookie请求头字段回送给客户端。**

**2. 如果浏览器接受了web服务器的Cookie信息后，它将存储Cookie信息，并在以后对该web服务器的每次访问请求中都使用一个Cookie请求头字段将Cookie信息会送给Web服务器，多个Cookie信息只能通过一个Cookie请求头字段会送给Web服务器**。

浏览器每次向服务器发送请求时，都要根据下面的规则，决定是否发送Cookie请求头字段，以及在Cookie请求头字段中附带哪些Cookie信息：

* 请求的服务端主机名是否与某个存储Cookie的Domain属性匹配。
* 请求的端口号是否在该Cookie的Port属性列表中。
* 请求的资源路径是否在该Cookie的Path属性指定的目录及子目录中。
* 该Cookie的有效期是否已过。