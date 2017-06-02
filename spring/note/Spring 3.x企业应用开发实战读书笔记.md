# 第15章：SpringMVC

## web.xml的配置

<servlet>默认加载的是`WEB-INF/<servlet-name>-servlet.xmld`的文件。如果想改变配置文件的路径，则可以在web.xml中，通过serlvet的初始化参数实现，具体有以下两种办法：

* 使用namespace参数：如果namespace为myConfig，则会去加载`WEB-INF/myConfig.xml`文件。
* 使用contextConfigLocation参数 ：它不仅可以加载指定的配置文件，还能加载多个springMVC的配置文件，比如：classpath:myConfig1.xml,classpath:myConfig2.xml。**推荐使用contextConfigLocation进行配置。**


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

另外，不建议使用<context-param>或者<listener>标签进行配置。

## SpringMVC的环境搭建

例子详见`practice\（1）SpringMVC环境搭建与实例.md`文件。需要注意以下几点：

* jar包要引入完整
* webApplicationContext.xml文件顶部的引入信息不要写错
* 记得加上自动扫描，否则IOC容器不会帮你初始化
* `p:prefix="/WEB-INF/view/" p:suffix=".jsp" /`语句中，注意view后面有一个`/`
* 请使用上一小节中推荐的SpringMVC引入方式。注意，url-pattern的正确写法是`<url-patten>/</url-pattern>`。千万别写成`/*`，这样是无法映射到jsp的
* 类和方法都加上@RequestMaping，其值必须`/`开头
* 注意映射到逻辑视图名的写法

## 注释式地路由映射

注解映射的规则具体由**请求URL、请求方法、请求头、请求参数**四个方面你的信息所组成的。其中，请求URL对应@RequestMapping的value值，请求方法就是GET/POST，请求头就是HTTP中请求的头部信息，请求参数即GET或POST提交过来的参数，参数会映射到方法的形参中。

### 映射请求URL

这种方式，既可以加value，也可以不加value，两者是等价的。此外还有其他风格的URL匹配，包括ant风格，星号模糊匹配等，用到再说吧。ant风格的映射需要用到@PathVariabe注解。

```java
@Controller
@RequestMapping("/user")
public class UserController {
	@Autowired
	private UserService userService;
	
	@RequestMapping(value="/loginView") 
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
```

### 映射请求方法（GET/POST）

```java
@RequestMapping(value="/login", method=RequestMethod.POST)
public ModelAndView login(User user) {
	userService.print();
	ModelAndView mav = new ModelAndView();
	mav.setViewName("user/home");
	mav.addObject("user", user);
	return mav;
}
```

###  映射请求头

```
@RequestMapping(value="/login", headers="Accept-Encoding=gzip, deflate")
public ModelAndView login() {
	//...
}
```

### 映射请求参数

#### 精确绑定参数名@ReuqestParam

该注解用于修饰形参，实现参数与形参根据名称的精确匹配。它有三个配置项可选：

1. value：前端的参数名称
2. required：参数是否必需
3. defaultValue：默认参数值，此时自动设置为required=false

```java
//login.jsp
<form action="user/login" method="POST">
	账号：<input type="text" name="myName" /> <br>
	密码：<input type="password" name="password" /> <br>
	<input type="submit" value="提交" />
</form>

//Controller
@RequestMapping(value="/login", method=RequestMethod.POST)
public ModelAndView login(@RequestParam(value="myName", required=false, defaultValue="abc") String  username) { //前端的myName匹配后端形参username
	userService.print();
	ModelAndView mav = new ModelAndView();
	mav.setViewName("user/home");
	mav.addObject("username", username);
	return mav;
}

//home.jsp
<body>
欢迎${username}
</body>
```

如果仅需要参数是否存在的校验mapping，也可以在@RequestMapping中配置：

```java
/*
params="username" 必须包含username参数
params="!username" 不能包含username参数
params="username!=admin" 必须包含username参数，但参数值不能是admin
params={"username=admin","password"} 必须包含username和password两个参数，且username的值必须为admin

上述表达式规则对于@RequestMapping的headers配置项同样适用
*/

@RequestMapping(value="/login", method=RequestMethod.POST,params="username") {
	//...
}
```

#### 绑定cookie@CookieValue

该注解可以实现在后端controller方法中很方便的获取到某个cookie的值。同样也是有三个配置项可选：

1. value：cookie的名称
2. required：是否必需
3. defaultValue：默认值，自动设置为required=false

```java
public ModelAndView login(@CookieValue(value="JSESSIONID", required=false) String sessionId) {
	//...
}
```

#### 绑定请求头@RequestHeader

该注解可以实现在后端controller方法中很方便的获取到请求头中某个header的值。同样也是有三个配置项可选：

1. value：header的名称
2. required：是否必需
3. defaultValue：默认值，自动设置为required=false

```java
//无论是检验mapping，还是获取值，都推荐此做法
@RequestMapping(value="/login", method=RequestMethod.POST)
	public ModelAndView login(@RequestHeader(value="Accept-Encoding", required=false) String encoding) {
	//...
}

//如果仅需要校验mapping，则也可以在@RequestMapping中配置，但不推荐此做法，因为完全可以用上面的方法替代
@RequestMapping(value="/login", method=RequestMethod.POST, headers="Accept-Encoding=gzip, deflate")
public ModelAndView login() {
	//...
}
```

#### 绑定ServletAPI

直接以参数的形式注入后直接使用，非常方便！不必像struts2那样还得实现一个接口。当然，你还可以类比，引用HttpSession、HttpServletResponse等ServletAPI。

```java
public ModelAndView login(HttpServletRequest request) {
	//...
}
```

#### 绑定POJO对象

和struts2有点不一样。SpringMVC的要求是：前端的name名是username，password，而Struts2的要求是：前端的name名是user.username，user.password。当然，如果传入多个符合对象时，一般都采用json了，所以这也不是什么大问题。

```java
//前端login.jsp
<form action="user/login" method="POST">
	账号：<input type="text" name="username" /> <br>
	密码：<input type="password" name="password" /> <br>
	<input type="submit" value="提交" />
</form>

//model
public class User {
	private String username;
	private String password;
	//省略getter/setter
}
  
//controller
@RequestMapping(value="/login", method=RequestMethod.POST)
public ModelAndView login(User user) {
	userService.print();
	ModelAndView mav = new ModelAndView();
	mav.setViewName("user/home");
	mav.addObject("user", user);
	return mav;
}

//前端结果显示：home.jsp
<body>
欢迎${user.username}
</body>
```

#### 绑定IO对象

```java
@RequestMapping(value="/login", method=RequestMethod.POST)
public ModelAndView login(OutputStream os) {
	//...
}
```

#### 绑定的奥秘

我们知道，任何一次请求本质上都是一个Handler，由于Handler是我们定义的POJO Controller，因此需要用适配器模式，让一个HandlerAdaptor包裹住Handler，使得SpringMVC可以用统一的方式调度Handler。如果我们使用注解的方式，则SpringMVC默认让你使用AnnotationMethodHandlerAdapter类，它是Handler接口的实现类。AnnotationMethodHandlerAdapter类包含了一个重要的组件：**HttpMessageConverter接口**，它由两个任务：

1. 把前端传入的数据绑定到你的handler方法形参中
2. 把输出的结果转化为前端要求的格式

AnnotationMethodHandlerAdapter类默认为你装配了几个HttpMessageConverter的实现类，包括：StringHttpMessageConverter、ByteArrayHttpMessageConvertor、SourceHttpMessageConverter、XmlAwareFormHttpMessageConverter。它们让你能够实现String、xml、二进制数据、form表单数据的绑定。如果你需要实现其他的自动绑定，比如json自动绑定，则需要显式的配置json相关的converter，具体配置如下：

```
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
	
	<!-- 使用你指定的converter。注意顶部关于引入mvc、util的声明信息，如果写漏了项目启动会报错 -->
	<bean class="org.springframework.web.servlet.mvc.annotation.AnnotationMethodHandlerAdapter" 
		p:messageConverters-ref="messageConverters" />
	<util:list id="messageConverters" >
		<bean class="org.springframework.http.converter.BufferedImageHttpMessageConverter" />
		<bean class="org.springframework.http.converter.ByteArrayHttpMessageConverter" />
		<bean class="org.springframework.http.converter.StringHttpMessageConverter" />
		<bean class="org.springframework.http.converter.xml.XmlAwareFormHttpMessageConverter" />
	</util:list>
</beans>
```

HttpMessageConverter的最佳实现就是用来实现json的自动映射绑定和json数据的输出。我们只需要借助下面这两个东西的帮助，SpringMVC就能自动帮我们选择MappingJacksonHttpMessageConverter，帮我们实现json绑定与输出。

* @RequestBody/@ResponseBody：@RequestBody用于修饰方法形参，@ResponseBody用于修饰方法本身
* HttpEntity<T>/ResponseEntity<T>：前者修饰方法形参，后者一般作为方法返回值

#### 绑定json和输出json

具体做法详见**（2）SpringMVC绑定JSON和输出JSON.md**

## 把输出数据绑定到视图上

具体来说有五种办法：

####  ModelAndView

也就是显式地创建ModelAndView对象，并把他看作一个map，我们只需调用addObject往里面添加要返回的数据即可。

```java
@RequestMapping("/login")
public ModelAndView login(User user) {
	userService.print();
	ModelAndView mav = new ModelAndView();
	mav.setViewName("user/home");
	mav.addObject("userKey", user);
	return mav;
}

//前端引用
${userKey.username}
```

#### @ModelAttribute

使用@ModelAttribute修饰形参，被修饰的形参会被SpringMVC自动加入到返回值中。

```java
//userkey就是用来在前端引用的，这个例子的效果与（1）中的完全一致
@RequestMapping(value="/login")
public String login(@ModelAttribute("userKey") User user) {
	return "user/home";
}

//前端引用
${userKey.username}
```

**@ModelAttribute还能修饰方法**。在下面的例子中，在访问该Controller中任何一个请求处理方法之前，SpringMVC都会先执行这个被@ModelAttribute修饰的方法，即getUser()，并将user对象以userkey作为键添加到隐含模型中。

调用getUser()时，会先创建一个user对象并放入隐含模型中。接着调用login时，发现以存在key为userKey的对象，则不再创建新的user对象，而是执行赋值操作，把前端传入的值附给隐含模型中的user对象。

```
@RequestMapping(value="/login")
public String login(@ModelAttribute("userKey") User user) {
	return "user/home";
}

@ModelAttribute("userKey")
public User getUser() {
	User user = new User();
	user.setPassword("999");
	return user;
}
```

#### Map

如果方法的形参中包括`org.springframework.ui.model`、或`org.springframework.ui.ModelMap`、或`java.util.Map`类型的参数时，SpringMVC会自动把隐含模型的赋值到这个参数中，我们便可以通过这个参数来隐含模型中的数据。

```jva
@RequestMapping(value="/loginView2") 
public String loginView2() {
	System.out.println("loginView2");
	return "user/login2";
}

@RequestMapping(value="/login")
public String login(ModelMap map) {
	User user = (User)map.get("userKey");
	user.setPassword("00000");
	return "user/home";
}
```

#### @SessionAttribute

没什么用

#### 返回json数据

具体详见**《绑定json和输出json》**章节

## 文件上传 

文件上传需要依赖CommonMultipartResolver，因此需要创建这个bean。此外，还要依赖如下两个jar包：

```java
commons-fileupload-1.3.2.jar
commons-io-2.5.jar
```

**（1）第一步：引入上述两个jar包**

**（2）第二步：引入CommonsMultipartResolver包**

```xml
<bean id="multipartResolver" class="org.springframework.web.multipart.commons.CommonsMultipartResolver" 
		p:defaultEncoding="UTF-8"
		p:maxUploadSize="5242880"  <!--允许上传的最大size -->
		p:uploadTempDir="upload/temp" /> <!-- 临时存储路径 -->
```

**（3）第三步：编写controller**

```
@Controller
@RequestMapping("/user")
public class UserController {
	@RequestMapping(value="/uploadView") 
	public String uploadView() {
		return "user/upload";
	}
	
	@RequestMapping(value="/upload")
	public String upload(@RequestParam("name") String name, @RequestParam("file") MultipartFile file) throws Exception {
		if(!file.isEmpty()) {
			System.out.println("你输入的文件名是："+name);
			System.out.println("文件真实名字是："+file.getOriginalFilename());
			file.transferTo(new File("d:/uploadDestination/"+file.getOriginalFilename()));
			return "redirect:success"; //重定向使用相对路径，相对于/user的路径
		}
		else {
			return "redirect:fail";
		}
	}
	
	@RequestMapping(value="/success") 
	public String uploadSuccess() {
		return "user/success";
	}
	
	@RequestMapping(value="/fail") 
	public String uploadFail() {
		return "user/fail";
	}

}
```

**（4）第四步：编写jsp**

```jsp
//upload.jsp
<body>
<form action="user/upload" method="post" enctype="multipart/form-data">
	你输入的文件名：<input type="text" name="name" /> <br>
	<input type="file" name="file" /> <br>
	<input type="submit" />  
</form>
</body>

//success.jsp和fail.jsp都是简单的打印语句，就不写了
//三个jsp都放在WEB-INF/view/user/下面
```














