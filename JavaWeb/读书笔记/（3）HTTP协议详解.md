# HTTP协议详解

## HTTP1.0与HTTP1.1比较

对于HTTP1.0，浏览器访问一个包含有许多图像的网页文件的整个过程需要多次请求和响应。每次请求和响应都需要建立一个单独的连接，每次连接只是传输一个文档和图像，上一次和下一次请求完全分离，这就导致浏览器获得一个包含许多图像的网页文件时需要与Web服务器建立多次连接。即使图像文件很小，单客户端和服务器端每次建立和关闭连接也是一个费时的过程，会验证影响客户和服务器的性能。

为了克服HTTP1.0的缺陷，HTTP1.1支持持久连接，在一个TCP连接上可以传送多个HTTP请求和响应，减少了建立和关闭连接的消耗和延迟。一个包含许多图像的网页文件的多个请求和应答可以在一个连接中传输，但每个单独的网页文件的请求和应答仍然需要使用各自的连接。HTTP1.1还允许客户端不用等待上一次请求结果返回，就可以发出下一次请求，但服务器端必须按照接收到客户端请求的先后顺序依次回送响应结果，以保证客户端能够区分出每次请求的响应内容。

## 请求消息

一个完整的请求消息包括：一个请求行、若干消息头、以及实体内容。其中的一些消息头和实体内容都是可选的，消息头和实体内容之间要用空行隔开。

1. 请求行：即请求URL地址
2. 消息头：即header信息
3. 实体内容：也叫做请求体，比如表单中提交的内容。

请求行包括三个部分：请求方式、资源路径、以及所使用的HTTP协议版本。各部分用空格隔开，语法格式为：`请求方式 资源路径 HTTP版本号<CRLF>`。其中<CRLF>表示回车和换行这两个字符的组合。

## 响应消息

一个完整的响应消息包括一个状态行、若干消息头、以及实体内容。其中一些消息头和实体内容也是可选的。消息头和实体内容之间要用空行隔开。

1. 状态行：200,404之类的
2. 若干消息头：即header信息
3. 实体内容：也叫做响应体，比如返回给json数据。

状态行中包含三个部分：HTTP协议版本号、一个表示成功或错误的整数代码（状态码）和对状态码进行描述的文本信息。各部分用空格隔开，语法格式为：`HTTP版本号 状态码 原因描述<CRLF>`

## 消息头

按照其作用分类，消息头又可以分为通用信息头、请求头、响应头、实体头四类。

- 通用信息头：既能用于请求信息中，也能用于响应信息中心，但与被传输的实体内容没有关系的常用消息头，比如Date、Pragma
- 请求头：用于在请求消息中向服务器传递附加信息，主要包括客户机可以接受的数据类型、压缩方法、语言，以及客户计算机上保留的Cookie信息和发出该请求的超链接源地址等。
- 响应头：用于在响应消息中向客户端传递附加消息，包括服务程序的名称、要求客户端进行认证的方式、请求的资源已移动到的新地址等。
- 实体头：用作实体内容的元信息，描述了实体内容的属性，包括实体信息的类型、长度、压缩算法、最后一次修改的时间和数据的有效期等。

许多请求头字段都允许客户端在值部分指定多个可接受的选项，有时甚至可以对这些选项的首选项进行排名，多个项之间以逗号分隔。

## get和post传递参数

GET方式传递参数时，参数拼接在请求行的URL地址后面。而POST方式传递参数时，参数放在实体内容中。在使用POST方式提交表单时，必须设置为并将Content-Length消息头设置为实体内容的长度。如果表单只提交普通数据，则设置为`<form enctype="application/x-www-form-urlencode">`，这也是表单默认的设置。如果表单包含文件上传，则设置为`<form enctype="multipart/form-data">`。

## 通用消息头

Cache-Control、Connection、Date、Pragma、Trailer、Transfer-Encoding、Upgrade、Via、Warning

## 请求头

Accept、Accept-Charset、Accept-Encoding、Accept-Language、Authorization、Expect、From、Host、If-Match、If-Modified-Since、If-None-Match、If-Range、If-Unmodified-Since、Max-Forwards、Proxy-Authorization、Range、Referer、TE、User-Agent

## 响应头

Accept-Range、Age、Etag、Location、Proxy-Authenticate、Retry-After、Server、Vary、WWW-Authenticate

## 实体头

Allow、Content-Encoding、Content-Language、Content-Length、Content-Location、Content-MD5、Content-Range、Content-Type、Expires、Last-Modified

## 扩展头

在HTTP消息中，也可以使用一些在HTTP1.1正式规范里没有定义的头字段，这些头字段统称为自定义的HTTP头或者扩展头，它们通常被当做是一种实体头处理。现在流行的浏览器实际上都支持Cookie、Set-Cookie、Refresh和Content-Disposition等几个常用的扩展头字段。