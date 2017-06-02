# 第一步：引入jar包

SpringMVC在做json解析时，必须依赖jackson相关的jar包。

```java
jackson-core-asl-1.9.7.jar
jackson-core-lgpl-1.9.7.jar
jackson-mapper-asl-1.9.7.jar
jackson-mapper-lgpl-1.9.7.jar
```

# 第二步：不拦截静态资源，引入jsonConverter

一般我们都使用jquery的ajax来提交json格式的数据，因此必须在webApplicationContext.xml中进行配置，使得SpringMVC不对静态资源进行拦截。

此外，SpringMVC默认并没有引入json相关的转换器，因此必须显式地手工引用。

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
	xmlns:p="http://www.springframework.org/schema/p"
    xmlns:context="http://www.springframework.org/schema/context"
    xmlns:mvc="http://www.springframework.org/schema/mvc" 
    xmlns:util="http://www.springframework.org/schema/util"
    
    xsi:schemaLocation="http://www.springframework.org/schema/beans
        http://www.springframework.org/schema/beans/spring-beans-3.0.xsd
         http://www.springframework.org/schema/context  
        http://www.springframework.org/schema/context/spring-context-3.0.xsd
         http://www.springframework.org/schema/util 
         http://www.springframework.org/schema/util/spring-util-3.0.xsd
        http://www.springframework.org/schema/mvc 
        http://www.springframework.org/schema/mvc/spring-mvc-3.0.xsd"
        >
	<context:component-scan base-package="com.lyn" />
  
    <!-- 下面两句，使得SpringMVC不会对静态资源进行引用 -->
	<mvc:annotation-driven  />
	<mvc:default-servlet-handler />  
    
	<bean class="org.springframework.web.servlet.view.InternalResourceViewResolver" 
		p:prefix="/WEB-INF/view/" p:suffix=".jsp" />
    
  <!-- 引入json转换器。注意，还要在顶部引入util和mvc相关的声明信息 -->
	<bean class="org.springframework.web.servlet.mvc.annotation.AnnotationMethodHandlerAdapter" 
		p:messageConverters-ref="messageConverters" />
	<util:list id="messageConverters" >
		<bean class="org.springframework.http.converter.BufferedImageHttpMessageConverter" />
		<bean class="org.springframework.http.converter.ByteArrayHttpMessageConverter" />
		<bean class="org.springframework.http.converter.StringHttpMessageConverter" />
		<bean class="org.springframework.http.converter.xml.XmlAwareFormHttpMessageConverter" />
		<bean class="org.springframework.http.converter.json.MappingJacksonHttpMessageConverter" />
	</util:list>
</beans>
```

# 第三步：编写Controller和model

```java
//UserController.java
@Controller
@RequestMapping("/user")
public class UserController {
	@RequestMapping(value="/loginView") 
	public String loginView() {
		System.out.println("loginView");
		return "user/login";
	}

	//严格来说，HttpEntity和ResponseEntity都应该用泛型
	@RequestMapping(value="/login")
	public ResponseEntity login(HttpEntity<User> requestEntity) {
		User user = requestEntity.getBody();
		if(user.getUsername().equals("admin")) {
			return new ResponseEntity(user, HttpStatus.OK);
		}
		else {
			Message message = new Message();
			message.setError("用户名不是管理员");
			return new ResponseEntity(message, HttpStatus.OK);
		}
	}
}

//Model：User.java
public class User {
	private String username;
	private String password;
	//省略getter/setter
}

//Model：Message.java
public class Message {
	private String error;
	//省略getter/setter
}
```

# 第四步：login.jsp前端异步提交

前端还是像以前一样，使用`<base href="<%=basePath%>">`的方式来引用静态资源。注意，SpringMVC要求前端封装的JSON字符串格式与struts2要求的格式不相同：

```
//SpringMVC要求的格式
{username: "admin", password: "123"}

//struts2要求的格式
{"user":{"username":"admin","password":"123"}}
```

```java
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>

<head>
<base href="<%=basePath%>">
<title>dca登录页面</title>

<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<!--jQuery js-->
<script src="js/miniui3.5/jquery-1.6.2.min.js" type="text/javascript"></script>
<!--MiniUI-->
<link href="js/miniui3.5/miniui/themes/default/miniui.css"
	rel="stylesheet" type="text/css" />
<script src="js/miniui3.5/miniui/miniui.js" type="text/javascript"></script>
</head>
<style type="text/css">
body {
	width: 100%;
	height: 100%;
	margin: 0;
	overflow: hidden;
	padding-left: 10px;
	font-size: 13px;
	background-image: url(image/background-login.png);
}

h1 {
	font-size: 20px;
	font-family: Verdana;
}

h4 {
	font-size: 16px;
	margin-top: 25px;
	margin-bottom: 10px;
}

.description {
	padding-bottom: 30px;
	font-family: Verdana;
}

.description h3 {
	color: #CC0000;
	font-size: 16px;
	margin: 0 30px 10px 0px;
	padding: 45px 0 8px;
	border-bottom: solid 1px #888;
}
.errorText {
	font-size : 10px;
	color: blue;
}
</style>
<body>
	<div id="loginWindow" class="mini-window" title="用户登录"
		style="width:360px;height:165px;" showModal="true"
		showCloseButton="false">

		<div id="loginForm" style="padding:15px;padding-top:10px;">
			<table>
				<tr>
					<td><label for="username$text">帐号：</label></td>
					<td><input name="username" errorMode="none"
						onvalidation="onUserNameValidation" class="mini-textbox" />
					</td>
					<td id="username_error" class="errorText"></td>
				</tr>
				<tr>
					<td><label for="pwd$text">密码：</label></td>
					<td><input name="password" errorMode="none"
						onvalidation="onPwdValidation" class="mini-password" /></td>
					<td id="password_error" class="errorText"></td>
				</tr>
				<tr>
					<td></td>
					<td style="padding-top:5px;">
						<a id="loginBtn" onclick="onLoginClick" class="mini-button" style="width:50px;">登录</a> 
						<a onclick="onRegisterClick" class="mini-button" style="width:50px;">注册</a>
					</td>
				</tr>
				<tr>
					<td id="displayResult" class="errorText"></td>
				</tr>
			</table>
		</div>
	</div>

	<script type="text/javascript">
	mini.parse();
	var isAdmin = false;
    var loginWindow = mini.get("loginWindow");
    loginWindow.show();
	//用于把json字符串拼接成对象形式
	function jsonStringWrapper(key, json) {
		var keyWrapper ='\"' + key + '\":';
		return "{" + keyWrapper + json + "}";
	}
	
	//登录按钮响应回车按键
	$("body").keydown(function() {
        if (event.keyCode == "13") {//keyCode=13是回车键
            $("#loginBtn").click();
        }
    });
	
	//登录事件
    function onLoginClick(e) {
        var form = new mini.Form("#loginWindow");
        form.validate();
        if (form.isValid() == false) return;

        var data = form.getData();
        var json = mini.encode(data);
        var jsonString = jsonStringWrapper("user", json);
        $.ajax({
            type:"POST",
            data:json,
            url:"user/login",
            dataType:"json",
            contentType:"application/json",
            success:function(data,textStatus) {
            	console.log(data);
            	if(data.username!=null) { //是管理员
            		$("#displayResult").text("用户名="+data.username);
            	}
            	
            	else if(data.error!=null) { //不是管理员
            		$("#displayResult").text("错误信息="+data.error);
            	}
            }
        });
    }
	
	//用户名非空验证
    function onUserNameValidation(e) {
    }
	
	//密码长度验证
    function onPwdValidation(e) {
    }
    </script>

</body>
</html>

```

# 第五步：web.xml

这里没有特殊配置。

```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://java.sun.com/xml/ns/javaee" xsi:schemaLocation="http://java.sun.com/xml/ns/javaee http://java.sun.com/xml/ns/javaee/web-app_2_5.xsd" id="WebApp_ID" version="2.5">
  <servlet>
  	<servlet-name>springmvc</servlet-name>
  	<servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
  	<init-param>
  		<param-name>contextConfigLocation</param-name>
  		<param-value>/WEB-INF/classes/webApplicationContext.xml</param-value>
  	</init-param>
  	<load-on-startup>1</load-on-startup>
  </servlet>
  <servlet-mapping>
  	<servlet-name>springmvc</servlet-name>
  	<url-pattern>/</url-pattern>
  </servlet-mapping>
</web-app>
```
