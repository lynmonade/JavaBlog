#Socket编程

Socket对象表示：一个发送到远端程序的请求。,socket中封装了inputStream和outputStream，我们便可以从inputStream获取请求的具体信息，比如请求行，请求请求行、请求头、请求体。我们还可以返回的数据通过I/O写入到outputStream中，让socket带回到客户端。

ServerSocket对象表示：一个正在等着接收请求的服务器。（比如tomcat）。

一般用host/hostName + port可以唯一表示一个远端程序。

host是ip地址：127.0.0.1
hostName是域名：localhost

## 创建Socket对象
创建Socket对象涉及两步：1. 用Socket绑定地址和端口。2.设置timeout。

```
//方法1
Socket s = new Socket("132.163.4.103", 13);
//设置超时时间，10000毫秒=10秒
s.setSoTimeout(10000);

//方法2
Socket s = new Socket("time-b.timefreq.bldrdoc.gov", 13); 
s.setSoTimeout(10000);

//方法3
Socket s = new Socket();
SocketAddress sa = new InetSocketAddress("time-b.timefreq.bldrdoc.gov", 13);
s.connect(sa, 10000);
```

host表示域名，hostAddress表示域名背后的IP地址。一个域名背后可以映射多个IP地址，也就是传说中的负载均衡。