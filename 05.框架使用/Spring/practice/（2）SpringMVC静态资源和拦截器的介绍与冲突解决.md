# 静态资源处理

对于css、js、image等这些静态资源来说，我们不需要SpringMVC拦截他们，而是应该让tomcat的default servlet直接返回这些资源。因此必须对SpringMVC进行配置，让它不拦截这些静态资源，具体方法有两种：

**方法一：**<mvc:default-servlet-handler/>

```xml
<mvc:annotation-driven  />
<mvc:default-servlet-handler/>
```

**方法二：**<mvc:resources>

```xml
<mvc:annotation-driven  />
<mvc:resources mapping="/css/**" location="/css/" />
<mvc:resources mapping="/image/**" location="/image/" />
<mvc:resources mapping="/js/**" location="/js/" />
```

一般我会直接在WebRoot下面创建image、css、js三个文件夹。上面的mapping属性表示前端的引用路径，location表示后端的引用路径。此时前端路径`http://localhost:8080/projectname/js/jquery/jquery-1.6.2.js`就会映射到`WebRoot/js/..子目录`下。

```html
//前端
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<script src="js/jquery/jquery-1.6.2.js" type="text/javascript"></script>
</head>
<body>
</body
</html>
  
//后端
WebRoot
  image
  css
  js
    jquery
  	  jquery-1.6.2.js
```

# 拦截器的使用

SpringMVC的自定义拦截器必须继承`HandlerInterceptorAdapter`类。该类有三个方法，你们根据需要选择覆盖他们：

```java
//在请求到达controller方法前执行
public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler);

//在完成controller方法后，进行view渲染之前执行
public void postHandle(HttpServletRequest request,HttpServletResponse response, Object handler,
	ModelAndView modelAndView);
	
//在view渲染完成后执行
public void afterCompletion(HttpServletRequest request, HttpServletResponse response, 
	Object handler, Exception ex);
```

用得最多的就是`preHandle()`方法。如果`return true`则表示继续执行下一个拦截器或者controller方法，如果`return false`则表示不再执行下一个拦截器，也不再执行controller方法，这是通常会调用重定向访问一个特定页面。下面是一个例子：

```java
public class TokenInterceptor extends HandlerInterceptorAdapter  {
	@Override
	public boolean preHandle(HttpServletRequest request,
			HttpServletResponse response, Object handler) throws Exception {
		
		String token = getTokenFromCookie(request);
		
        if(token!=null) { //该请求存在token
        	JWTUtil jwtUtil = new JWTUtil();
    		Claims claims = jwtUtil.parseToken(token);
    		if(claims!=null) {
    			//trust this claim
    			System.out.println("token验证成功，用户"+claims.getSubject()+"具有访问权限");
    			return true;
    		}
    	}
        String contentPath = request.getContextPath();
	    response.sendRedirect(contentPath+"/error/tokenInvalid");  
	    return false;
    }
}
```

在webApplicationContext.xml中这样配置拦截器：

（1）`<mvc:mapping path="/**" />`表示TokenInterceptor拦截器会对`http://localhost:8080/projectname/XXX`以及子路径`http://localhost:8080/projectname/XXX/YYY/`进行拦截。（简单来说就是对所有请求都拦截）

（2）`<mvc:exclude-mapping path="/loginAction"/>`表示请求`http://localhost:8080/projectname/loginAction`不会被TokenInterceptor所拦截。**（排除拦截）。注意，排除拦截的标签只有在SpringMVC3.2+版本才会效果，如果是之前的老版本，则只能在preHandle()方法中自行从request中解析请求路径，排除拦截。**

网上有的人说只需把顶部声明改为`http://www.springframework.org/schema/mvc/spring-mvc-3.2.xsd`。即强制改为3.2版本就行了，但我试了下不行，还是得老老实实升级jar包，jar包版本与顶部声明对应才可以。

```xml
<!--配置拦截器, 多个拦截器,顺序执行 -->  
<mvc:interceptors>    
<mvc:interceptor>    
	<!-- 匹配的是url路径， 如果不配置或/**,将拦截所有的Controller -->  
	<mvc:mapping path="/**" />  
	<mvc:exclude-mapping path="/"/>
	<mvc:exclude-mapping path="/loginAction"/>
	<mvc:exclude-mapping path="/error/**"/>
	<mvc:exclude-mapping path="/js/**"/>
	<mvc:exclude-mapping path="/image/**"/>
	<mvc:exclude-mapping path="/css/**"/>
	<bean class="com.lyn.rbac.user.interceptor.TokenInterceptor"></bean>    
</mvc:interceptor>  
```

**拦截器循环拦截的问题**

struts2中的拦截器方法可以直接返回视图的逻辑地址实现请求转发。而SpringMVC只能通过HttpServletRequest的请求转发实现，有点原始。（重定向则通过response实现）。

在SpringMVC的拦截其中进行请求转发或重定向时，拦截器会再次拦截请求转发、重定向的请求（暂时称为第二次请求），如果第二次请求又被拦截器拦截，则会发生拦截自循环的问题。

例子：假设`/loginView`用于访问登录视图，现有一个token拦截器对全部请求都拦截。如果请求中不含token，则跳转至登录页`/loginView`，如果请求包含token，则跳转至首页`/home`。

1. 当用户第一次访问`/loginView`时， token拦截器拦截请求并发现请求中不带token。
2. 由于上一步不带token，因此拦截器决定请求转发或重定向至登录页`loginView`。
3. 无论上一步发生的是请求转发还是重定向，SpringMVC都认为是一次新的请求，此时拦截器再次拦截上一步的请求，又发现请求中没有token，因此拦截器又决定请求转发或重定向至登录页`loginView`。这样就发生了无限循环拦截的问题。

**解决办法是：**对于像`/loginView`这样的请求，应该排除出token拦截器的拦截，然后在controller方法中自行判断跳转到哪个视图。

# 拦截器与静态资源标签冲突的问题

```xml
<mvc:annotation-driven  />
<mvc:resources mapping="/css/**" location="/css/" />
<mvc:resources mapping="/image/**" location="/image/" />
<mvc:resources mapping="/js/**" location="/js/" />
	
<mvc:interceptors>    
    <mvc:interceptor>    
        <mvc:mapping path="/**" />  
        <mvc:exclude-mapping path="/"/>
        <mvc:exclude-mapping path="/loginAction"/>
        <bean class="com.lyn.rbac.user.interceptor.TokenInterceptor"></bean>    
    </mvc:interceptor>  
    
</mvc:interceptors>
```

`<mvc:mapping path="/**" /> `会拦截所有的请求，包括静态资源的请求，这时即使你配置了不拦截静态资源，静态资源依然逃不过拦截器的法网。**解决办法是，把静态资源的路径也加入到拦截器的排除名单中。**

```xml
<mvc:annotation-driven  />
<mvc:resources mapping="/css/**" location="/css/" />
<mvc:resources mapping="/image/**" location="/image/" />
<mvc:resources mapping="/js/**" location="/js/" />
	
<mvc:interceptors>    
    <mvc:interceptor>    
        <mvc:mapping path="/**" />  
        <mvc:exclude-mapping path="/"/>
        <mvc:exclude-mapping path="/loginAction"/>
        <mvc:exclude-mapping path="/error/**"/>
		
        <mvc:exclude-mapping path="/js/**"/> <!-- 排除静态资源拦截 -->
        <mvc:exclude-mapping path="/image/**"/> <!-- 排除静态资源拦截 -->
        <mvc:exclude-mapping path="/css/**"/> <!-- 排除静态资源拦截 -->
        <bean class="com.lyn.rbac.user.interceptor.TokenInterceptor"></bean>    
    </mvc:interceptor>    
</mvc:interceptors>
```

# /、/*、/**的区别

```xml
<!--以拦截器配置为例-->
<!--仅拦截http://localhost:8080/projectname/的请求-->
<mvc:mapping path="/" />   

<!--仅拦截http://localhost:8080/projectname/XXX的请求-->
<mvc:mapping path="/*" />

<!--
拦截所有请求：
包括http://localhost:8080/projectname/
http://localhost:8080/projectname/XXX
http://localhost:8080/projectname/XXX/YYY/...
-->
<mvc:mapping path="/**" />   
```



