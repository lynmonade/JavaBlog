# 实验环境

1. 参数格式
  1. 参数包含中文
  2. 参数包含特殊字符
2. 传值方式
   1. href传值
   2. 浏览器地址栏传值
   3. form表单传值
   4. ajax传值
3. 前端encode工具
   1. encodeURI
   2. encodeURIComponent
   3. mini.encode
   4. 不encode
4. 后端解码工具类
   1. java.net
   2. 不解码
5. tomcat配置
   1. 设置URIEncoding="utf-8"
   2. 不做任何设置
6. 后端技术框架
   1. servlet
   2. jfinal




# 实验记录(在chrome下实验)

## 实验1

参数包含中文，前端不encode，后端不decode，servlet。

### 1.1 href传值+tomcat不设置 

结果：中文乱码。

```java
//前端
href="http://localhost:8080/jsservlet/MyServlet?id=中国"
//后端
String id = request.getParameter("id"); //乱码
```

### 1.2 浏览器地址栏传值+tomcat不设置

结果：乱码

### 1.3 浏览器地址栏传值+tomcat设置URIEncoding

结果：成功获取中文

### 1.4 href传值+tomcat设置URIEncoding

结果：成功获取中文

### 1.5 html页面设置charset=GBK+tomcat设置URIEncoding=UTF-8

结果：乱码

## 结论1

如果url的参数值包含中文，则浏览器会使用html页面设置的charset，自动对中文参数值进行编码。

在后端，tomcat的设置URIEncoding=XXX只影响GET请求，href和浏览器地址栏传值都属于GET请求。如果未对tomcat进行设置，则tomcat默认使用ISO8859-1进行解码，因此getParameter()中文参数值肯定会乱码。所以都会对tomcat显式地设置URIEncoding="UTF-8"，这样getParameter()就不会乱码了。

使用超链接时，后面不要拼接参数，因为jfinal无法映射到action，看来这也是一个best practice。

jfinal的getPara()效果与getParameter()完全一样，所以jfinal对GET的解码也是要依赖于tomcat里的设置。















