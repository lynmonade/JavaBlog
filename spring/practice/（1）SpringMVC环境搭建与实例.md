# 第一步：引入jar包

```java
org.springframework.web.servlet-3.0.5.RELEASE.jar
org.springframework.web-3.0.5.RELEASE.jar
org.springframework.core-3.0.5.RELEASE.jar
org.springframework.context-3.0.5.RELEASE.jar
org.springframework.beans-3.0.5.RELEASE.jar
org.springframework.asm-3.0.5.RELEASE.jar
org.springframework.aop-3.0.5.RELEASE.jar
org.springframework.expression-3.0.5.RELEASE.jar
com.springsource.org.aopalliance-1.0.0.jar
com.springsource.org.apache.commons.logging-1.1.1.jar
com.springsource.org.apache.log4j-1.2.15.jar
aspectjweaver-1.7.4.jar
log4j-1.2.14.jar //然后把log4j.properties拷贝到src目录下
```

# 第二步：编写SpringMVC的配置文件

```xml
//webApplicationContext.xml,放在src目录下
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
	<bean class="org.springframework.web.servlet.view.InternalResourceViewResolver" 
		p:prefix="/WEB-INF/view/" p:suffix=".jsp" />
</beans>
```

# 第三步：在web.xml中引入SpringMVC

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

# 第四步：编写Controller、Service、Model

```java
//UserController
@Controller
@RequestMapping("/user")
public class UserController {
	@Autowired
	private UserService userService;
	
	@RequestMapping("/loginView") 
	public String loginView() {
		System.out.println("loginView");
		return "user/login";
	}

	@RequestMapping("/login")
	public ModelAndView login(User user) {
		userService.print();
		ModelAndView mav = new ModelAndView();
		mav.setViewName("user/home");
		mav.addObject("user", user);
		return mav;
	}
}

//UserService，目前没处理任何业务逻辑，只为测试IOC容器是否创建它
@Service
public class UserService {
	public void print() {
		System.out.println("userService="+this);
	}
}

//User.java
@Component //这个注解，目前不用也可以
public class User {
	private String username;
	private String password;
	//省略getter/setter	
}
```

# 第五步：编写jsp

```jsp
//所有JSP都放在WEB-INF/view/user下面
//login.jsp
<base href="<%=basePath%>">
<body>
	<form action="user/login" method="post">
		账号：<input type="text" name="username" /> <br>
		密码：<input type="password" name="password" /> <br>
		<input type="submit" value="提交" />
	</form>
</body>

//home.jsp
<body>
	欢迎${user.username}
</body>

```

# 第六步：测试

假设项目名称为mySpring，则访问路径：`http://localhost:8080/mySpring/user/loginView`，此时会跳转到登录页面。输入用户名密码后点击提交，会跳转至home.jsp，页面上会显示你的账号。

