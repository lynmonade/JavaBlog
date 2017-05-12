# 研磨struts2读书笔记

## 第2章：struts2的Helloworld

### helloWorld入门：基于struts2.1.8.1

**web.xml**

```xml
  <filter>
  	<filter-name>struts2</filter-name>
  	<filter-class>org.apache.struts2.dispatcher.ng.filter.StrutsPrepareAndExecuteFilter</filter-class>
  </filter>
  <filter-mapping>
  	<filter-name>struts2</filter-name>
  	<url-pattern>/*</url-pattern>
  </filter-mapping>
```

**struts.xml**

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE struts PUBLIC
    "-//Apache Software Foundation//DTD Struts Configuration 2.0//EN"
    "http://struts.apache.org/dtds/struts-2.0.dtd">
<!-- struts2配置文件根元素 -->
<struts>
	<!-- 指定全局国际化资源文件 -->
	<constant name="struts.custom.i18n.resources" value="mess_zh_CN" />
	<!-- 指定国际化编码所使用的字符集 -->
	<constant name="struts.i18n.encoding" value="UTF-8" />
	
	<!-- 所有Action定义都应该放在 package下 -->
	<package name="cc" extends="struts-default">
		<action name="login" class="com.LoginAction">
			<!-- 定义三个逻辑视图和物理视图之间的映射 -->
			<result name="input">/login.jsp</result>
			<result name="error">/error.jsp</result>
			<result name="success">/welcome.jsp</result>
		</action>
	</package>
	
	<include file="struts-part1.xml" />
</struts>
```

**login.jsp和welcome.jsp**

```jsp
// WebRoot/view/login.jsp
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
	<form action="../hello/helloWorldAction.action" method="post">
		<input type="hidden" name="submitFlag" value="login" />
		账号：<input type="text" name="account" /> <br>
		密码：<input type="password" name="password" /> <br>
		<input type="submit" value="提交" />
	</form>
</body>
</html>


// WebRoot/view/welcome.jsp
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
<%@ taglib prefix="s" uri="/struts-tags" %>
欢迎账号为：<s:property value="account" />的朋友来访
</body>
</html>
```

**HelloWorldAction.java**

```java
public class HelloWorldAction extends ActionSupport{
	private String account;
	private String password;
	private String submitFlag;
	
	@Override
	public String execute() throws Exception {
		System.out.println("用户输入的参数为：account="+getAccount()+
				",password="+getPassword()+",submitFlag="+getSubmitFlag());
		return "toWelcome";
	}
  
  	//省略getter/setter
}
```

### 开发技巧：使用DTD获得XML的帮助

在断网情况下，同样可以使用DTD获得XML的帮助。

**第一步：**在WebRoot下创建一个名为DTD的文件夹，然后把struts2-core-2.1.8.jar中的struts-2.0.dtd文件拷贝到DTD文件夹下。

**第二步：**eclipse-->windows-->preferences-->XML Catalog-->User Specified Entries-->点击Add按钮。Location中选择刚才拷贝的文件，Key type选择Public ID。Key的值为`-//Apache Software Foundation//DTD Struts Configuration 2.0//EN`。

### 开发技巧：获得Action的全类名

一种办法是在Package Explorer视图中右击Action类，接着选择Copy Qualified Name，然后就可以在struts.xml文件中CTRL+V了。

另一种办法就是用eclipse插件。

### 开发技巧：获得JSP在Web工程中的绝对路径

右击JSP文件，选择properties即可。

## 第3章：struts2的架构和运行流程

多读几遍

## 第4章：Action

书中说到，FilterDispatcher充当的是控制器的角色，而Action充当的是模型的角色，在实际项目中，业务逻辑会交由逻辑层处理，action负责调用业务逻辑层。

### 创建Action

创建Action有三种方式：

1. Action为POJO类，不继承任何类、不实现任何接口，此时必须包含一个空参构造函数，以及一个execute()方法：`public String execute() throws Exception`
2. 实现Action接口：必须覆盖`execute()`方法
3. 集成ActionSupport抽象类：推荐。

### 例子：简单的数据验证

仔HelloWorld的基础上增加数据验证的功能：

（1）仔action中增加validate()方法：

```java
public void validate() {
	if(account==null || account.trim().length()==0) {
		this.addFieldError("account", "账号不能为空");
	}
	if(password==null || password.trim().length()==0) {
		this.addFieldError("password", "密码不能为空");
	}
	if(password==null || password.trim().length()<=6) {
		this.addFieldError("password", "密码长度要大于6位");
	}
}
```

（2）修改struts.xml：struts默认，当验证失败时，会返回逻辑视图名input，然后跳转回物理视图login.jsp。

```xml
<result name="input">/view/login.jsp</result>
```

（3）修改login.jsp：如果验证失败，则在页面上显示验证信息。

```html
<body>
<%@ taglib prefix="s" uri="/struts-tags"%>
<s:if test="hasFieldErrors()" >
<s:iterator value="fieldErrors">
	<font color=red><s:property value="value[0]"/></font><br>
</s:iterator>
</s:if>

	<form action="../hello/helloWorldAction.action" method="post">
		<input type="hidden" name="submitFlag" value="login" />
		账号：<input type="text" name="account" /> <br>
		密码：<input type="password" name="password" /> <br>
		<input type="submit" value="提交" />
	</form>
</body>
```

（4）为了国际化，我们还可以把错误信息写在配置文件里，然后读取即可。首先需要在Action所在目录下创建一个同名的properties文件HelloWorldAction.properties。然后修改validate()方法。

```properties
//HelloWorldAction.properties
k1=写在配置文件中，账号不能为空
k2=写在配置文件中，密码不能为空
```

```java
//HelloWorldAction
public void validate() {
		if(account==null || account.trim().length()==0) {
			this.addFieldError("account", this.getText("k1"));
		}
		if(password==null || password.trim().length()==0) {
			this.addFieldError("password", this.getText("k2"));
		}
		if(password==null || password.trim().length()<=6) {
			this.addFieldError("password", "密码长度要大于6位");
		}
	}
```

### 理解execute方法

在实际开发中，execute方法内部通常需要实现如下工作：

1. 收集用户传递过来的数据
2. 把收集到的数据组织成逻辑层需要的类型和格式
3. 调用逻辑层接口，来执行业务逻辑处理
4. 准备下一个页面所需要展示的数据，存放在响应的地方
5. 转向下一个页面

### Action的数据（获取前端参数）

#### 三种数据映射方式

页面的数据和Action的3种数据对应方式：

* 属性驱动（基本数据类型的属性对应）：实际项目中不建议用。
* 属性驱动（直接使用域对象）：推荐使用
* 模型驱动：Action需要实现额外的接口，不建议使用



**（1）属性驱动（基本数据类型的属性对应）**

前面HelloWorld的例子就是**属性驱动（基本数据类型的属性对应）**，特点如下：

* 成员变量为基本数据类型或字符串类型
* 表单中直接使用成员变量的名称
* Action中的成员变量为private类型，并提供对应的getter/setter


**（2）属性驱动（直接使用域对象）**

域对象可以看做是多个基本数据类型的包装类，需要对项目进行如下改造：

* 创建一个独立的POJO类，它用来封装这个action所用到的传入参数字段。
* Action不再持有简单数据类型，而是持有域对象（这个域对象开发者来初始化，struts在用到它时会自动初始化）
* Action不再包含简单数据类型的getter/setter，而是持有域对象的getter/setter
* Action中使用域对象的getter/setter间接访问数据类型
* 前端界面中需要用`域对象名称.普通变量名称`的格式来实现参数映射。

```java
//POJO类
public class HelloWorldModel {
	private String account;
	private String password;
	private String submitFlag;
	
	//getter/setter
}

//Action类
public class HelloWorldAction extends ActionSupport{
	private HelloWorldModel hwm; //持有的是域对象
	
	public HelloWorldModel getHwm() {
		return hwm;
	}
	public void setHwm(HelloWorldModel hwm) {
		this.hwm = hwm;
	}
	
	//execute方法
}
```

前端页面使用`域对象名称.普通变量名称`的方式来实现参数映射：

```jsp
//login.jsp
<input type="hidden" name="hwm.submitFlag" value="login" />
账号：<input type="text" name="hwm.account" /> <br>
密码：<input type="password" name="hwm.password" /> <br>

//welcome.jsp
<%@ taglib prefix="s" uri="/struts-tags" %>
欢迎账号为<s:property value="hwm.account" />的朋友来访
```

**（3）模型驱动**

模型驱动和域对象非常类型，都需要一个单独的域对象来封装基本数据。区别在于，模型驱动必须实现ModelDriven接口，必须覆盖`Object getModel()`方法，因此使用模型驱动后，这个Action对应一个POJO类，因为`getModel()`方法只能返回一个对象。具体要求如下：

* Action持有一个POJO对象作为成员变量，该POJO对象必须在声明后立刻初始化
* Action必须实现ModelDriven接口，并覆盖`Object getModel()`方法，这个方法用户获得该Action唯一对应的一个Model
* 前端页面直接使用普通变量的名称实现参数映射。

```java
//Action
public class HelloWorldAction extends ActionSupport implements ModelDriven{
	private HelloWorldModel hwm = new HelloWorldModel(); //必须立刻初始化
	
	//必须覆盖该方法，返回model
	@Override
	public Object getModel() {
		return hwm;
	}
}
```

前端页面，直接使用普通变量名称：

```java
//login.jsp
<input type="hidden" name="submitFlag" value="login" />
账号：<input type="text" name="account" /> <br>
密码：<input type="password" name="password" /> <br>

//welcome.jsp
欢迎账号为<s:property value="account" />的朋友来访
```

**小结：三种映射方式可以同时使用，但不推荐这么做，建议只使用属性驱动（直接使用域对象）。**属性驱动（基本数据类型的属性对应）与模型驱动同时使用时，由于两种方式都没有前缀，如果出现冲突，则struts2优先选用模型驱动。其他还需要深入研究的问题包括：

1. 传入值的类型不一致，需要转换
2. 需要传入一组数目不确定的字符串
3. 需要传入一组数目不确定的域对象

#### 传入int类型

如果我们把上例中的account改为int/Interger类型，struts依然可以帮我们把前端的参数转为int/Integer类型

* 如果用户输入的参数不是数字，则struts会报错，并且struts会自动往FieldError中写入信息。
* 如果用户不传入参数，当account是int类型，则struts会报错。当account是Integer类型，则struts不会报错，account的值为null。
* 即使某一个参数传入后类型转换失败，也不会影响其他参数的转换。

这里还提到了**attribute和property**的区别。两者都可以翻译为属性。attribute是用来描述对象固有的一些属性，一般是创建过后不变的一些值，比如人这个对象，有手这attribute。property用来表示创建后可变的一些值。比如人这个对象，有头发颜色这个property，创建对象实例后，这个人可能去染发了，编程其他颜色，因此头发颜色是可变的。

个人建议：attribute和property都设设置为private，attribute不提供setter，只提供getter。而property提供getter和setter。

#### 传入一组数目不定的String

这时，我们可以用一个List或者一个数组来持有这些数目不定的String。

```java
//Model
public class HelloWorldModel {
	private String account;
	private String password;
	private String submitFlag;
	private List<String> habits;
	//或者
	//private String[] habits;
	
	//getter/setter
}

//前端页面
<input type="checkbox" name="hwm.habits" value="sports" /> 运动
<input type="checkbox" name="hwm.habits" value="reading" /> 读书
<input type="checkbox" name="hwm.habits" value="sleep" /> 睡觉
```

#### 传入一组数目不定的域对象

此时要用一个List来持有数目不定的域对象，**并且在声明List时必须立即初始化这个List。**

```java
//Model
public class UserModel {
	private String account;
	private String password;
	//getter/setter
}

//Action
public class HelloWorldAction extends ActionSupport{
	private List<UserModel> users = new ArrayList<UserModel>();
	//getter/setter
}

//前端页面
账号1：<input type="text" name="users[0].account" /> <br>
密码1：<input type="password" name="users[0].password" /> <br>
账号2：<input type="text" name="users[1].account" /> <br>
密码2：<input type="password" name="users[1].password" /> <br>
```

###  Action在struts.xml中的配置

* 一个<struts>元素中可以包含多个<package>元素
* 一个<package>元素中可以包含多个<action>元素

但为了开发和维护的方便，建议一个<struts>元素中只包含一个<package>元素，然后通过分模块配置的方式引入多个xml文件即可。

#### <package>元素

<package>元素有如下属性：

* name：包的名称，必须配置。不影响URL映射。
* extends：要继承的包，可选。一般会继承于默认包`struts-default`
* namespace：包的命名空间。可选。会影响URL映射。前面一般会有一个`/`，比如`namespace="/home"`。如果你想定义两个名称相同的action，则必须把两个action放到不同的namespace下。可以把namespace形象成java中的包，起到模块化和隔离作用。如果不配置namespace，则表示默认namespace，此时不会影响URL映射。
* abstract：定义保卫抽象的，也就是不能包含Action的定义，可选。

```xml
<package name="aa"  namespace="/bb" extends="struts-default"  abstract="false">
<package name="aa"  extends="struts-default"> //缩减版
```

**小实验**

name和namespace的值似乎都会影响URL的映射路径，下面测试一下：

```java
//例子1：仅包含name，使用form绝对路径映射
<package name="aa" extends="struts-default"  abstract="false">
<form action="/struts21/aa/helloWorldAction.action" method="post">
http://localhost:8080/struts21/aa/helloWorldAction.action

<form action="/struts21/helloWorldAction.action" method="post">
http://localhost:8080/struts21/helloWorldAction.action

//例子2：包含name和namespace，使用form绝对路径映射
<package name="aa" namespace="/bb" extends="struts-default" abstract="false">
<form action="/struts21/bb/helloWorldAction.action" method="post">
http://localhost:8080/struts21/bb/helloWorldAction.action

//例子3：仅包含name，使用form相对路径映射，login.jsp在WebRoot/view目录下
<package name="aa" extends="struts-default" abstract="false">
<form action="../aa/helloWorldAction.action" method="post">
http://localhost:8080/struts21/aa/helloWorldAction.action

//例子4：包含name和namespace，使用form相对路径映射，login.jsp在WebRoot/view目录下
<package name="aa" namespace="/bb" extends="struts-default" abstract="false">
<form action="../bb/helloWorldAction.action" method="post">
```

**经验证，如果仅包含name属性，则在URL中写不写name的值都可以映射到后端的action。如果包含name和namespace属性，则在URL中只能有namespace的值，不能有name的值。所以，package元素的name属性是不会影响URL映射的。**

#### <action>元素

* <action>元素是<package>元素的子元素，因此必须配置在<package>里面
* <action>元素中通常要配置name、class、method属性，其中name是必须的。
* <action>元素中还可以包含<param>, <result>, <interceptor-ref>, <exception-mapping>。

#### 分模块配置

```xml
<struts>
	<include file="struts-home.xml"></include>
	<include file="struts-report.xml"></include>
	<include file="struts-4A.xml"></include>
</struts>
```

#### 使用通配符

struts2还支持class属性和method属性使用来自name属性的通配符。此外，<result>元素在配置页面路径时，也可以使用通配符。另外，如果精确匹配和模糊匹配同时都能匹配上，struts2优先选择精确匹配的action。通配符个人感觉并没什么用。

```java
//struts.xml
<action name="*-*" class="com.{1}Action" method="{2}Function">
</action>

//action
public class TestAction extends ActionSupport{
	public void doFunction() {
		System.out.println("doFunction");
	}
}

//前端页面
<form action="../bb/Test-do.action" method="post">
```

#### class属性的默认值

如果不给action元素配置class属性，则class属性的值为`com.opensymphony.xwork2.ActionSupport`。这有什么用呢？对于安全性较高的web项目，往往把JSP放到WEB-INF文件夹下，这样可以防止外界直接通过URL来访问JSP页面，这是的jsp就一定要是Servlet或Action的后继页面，才可以被访问到。

因此如果我们有一个JSP页面在WEB-INF下，但在它之前不需要Action访问逻辑层，就相当于需要直接访问这个JSP页面。此时就可以让这个JSP作为ActionSupport的后继页面。ActionSupport类的execute方法返回字符串"success"，而<result>元素的name属性如果不写的话，默认就是success。

```xml
<action name="home">
	<result>/WEB-INF/view/homepage.jsp</result>
</action>

//访问jsp：
http://localhost:8080/struts21/home.action
```

### Action的声明周期

tomcat在启动时并不会创建action的实例。每次调用一次action时，都会创建一个新的action。

### 调用非execute方法

我们不会把逻辑都写到execute方法中，因为这样的话，一个action类就只能负责一个业务逻辑。实际开发中，我们会让一个action负责一个小模块，action中包含多个方法，分别处理不同的事。方法的定义需遵循：

* 必须为public方法
* 不需要传入参数
* 返回一个字符串，就是指示的下一个页面的result
* 可以抛出Exception，也可以不抛出。

我们可以通过两种方式实现调用非execute方法：

（1）首先在action类中定义好方法，然后给struts.xml中的<action>元素配置method属性。

（2）在action类中定义好方法，然后通过URL的方式来映射方法，比如：`http://localhost:8080/struts21/bb/helloWorldAction!create.action`

### 关于.action

在前面的配置可以看到，在URL中我们都会把路径写完整，比如`XX/YY/ZZ/CC.action`，此时是包含`.action`这个后缀的。而在struts.xml文件中配置<action>元素的name属性时，是不带`.action`后缀的。

## 第5章 result的基础

* result是Action执行完后返回的一个字符串，它指示了Action执行完成后，下一个页面在哪里。
* ResultType指的是具体执行result的类，由它来决定采用哪一种视图技术，将执行结果展现给用户。

### result预定义常量

* SUCCESS：表示action执行成功，显示结果视图给用户，值为字符串`success`
* NONE：表示Action执行成功，不需要显示视图给用户，值为字符串`none`
* ERROR：表示action执行失败，显示错误页面给用户，值为字符串`error`
* INPUT：表示执行action需要更多的输入信息，回到input对应的页面，值为字符串`input`
* LOGIN：表示因用户没有登录而没有正确执行，将返回该登录视图，值为字符串`login`

也可以自己定义字符串，只要在struts.xml中的<result>元素的name属性里配置就行。

### 预定义的result-type

struts2提供了许多预定义的result-type，我们可以在struts-default.xml文件中找到，其中dispatcher是默认的值。

```xml
<result-types>
	<result-type name="chain" class="com.opensymphony.xwork2.ActionChainResult"/>
	<result-type name="dispatcher" class="org.apache.struts2.dispatcher.ServletDispatcherResult" default="true"/>
	<result-type name="freemarker" class="org.apache.struts2.views.freemarker.FreemarkerResult"/>
	<result-type name="httpheader" class="org.apache.struts2.dispatcher.HttpHeaderResult"/>
	<result-type name="redirect" class="org.apache.struts2.dispatcher.ServletRedirectResult"/>
	<result-type name="redirectAction" class="org.apache.struts2.dispatcher.ServletActionRedirectResult"/>
	<result-type name="stream" class="org.apache.struts2.dispatcher.StreamResult"/>
	<result-type name="velocity" class="org.apache.struts2.dispatcher.VelocityResult"/>
	<result-type name="xslt" class="org.apache.struts2.views.xslt.XSLTResult"/>
	<result-type name="plainText" class="org.apache.struts2.dispatcher.PlainTextResult" />
</result-types>
```

（1）dispatcher：它相当于Servlet中的RequestDispatcher请求转发技术。

（2）redirect：它相当于Servlet中的sendRedirect重定向技术。

（3）chain：它是一种特殊的试图结果，用来将actino执行完之后链接到另一个action中继续执行。新的action使用上一个action的上下文（ActionContext），数据也会被传递。chain类似于请求转发，用户只发出一次请求，struts负责把请求在多个action中传递。注意，使用chain之后，将不能在<result>的页面路径URL中拼接参数。

```java
//Action1
public class HelloWorldAction extends ActionSupport{
	private UserModel um;
	@Override
	public String execute() throws Exception {
		System.out.println(um); 
		return "toSecond";
	}
	//省略getter/setter
}

//Action2
public class SecondAction extends ActionSupport{
	public String execute() {
		System.out.println("in second action");
		return "toWelcome";
	}
}

//struts.xml
<package name="aa" namespace="/bb" extends="struts-default" abstract="false">
	<action name="helloWorldAction" class="com.HelloWorldAction">
		<result name="toSecond" type="chain">
			<param name="actionName">secondAction</param>
            <!--还有一个namespace参数，可选，如果不设置，则默认为当前命名空间-->
            <!--<param name="namespace">otherspace</param>-->
		</result>
	</action>
	<action name="secondAction" class="com.SecondAction">
		<result name="toWelcome">/view/welcome.jsp</result>
	</action>
</package>
```

（4）Freemarker：用到再看吧

### <result>元素的配置

* name属性：用来和action的execute方法返回的字符串相对应。其值可以是任意字符串。它不是必须设置的，如果不设置，默认值为`success`
* type属性：表明具体跳转到哪种视图技术。它不是必须设置的。如果设置了，它必须是某一个<result-type>元素的name属性。如果没设置，则默认是dispatcher。

<result>元素既可以使用简略配置，也可以使用完整配置，效果都是一样的。

```xml
<!-- 简略配置 -->
<result name="toWelcome">/view/welcome.jsp</result>

<!-- 完整配置 -->
<!--location页面的物理路径-->
<!-- parse决定了location是否可以通过使用OGNL来引用参数，默认为true -->
<result name="toWelcome" type="dispatcher">
	<param name="location">/view/welcome.jsp</param>
	<param name="parse">true</param>
</result>
```

**下面还将介绍三个关于<result>元素的奇巧淫技：**

**（1）页面路径参数化：**struts允许参数化<result>元素的页面路径，这样我们就可以不写死路径，而是通过action把路径传过来。此时，我们可以在Action中增加一个成员变量表示参数，然后在<result>元素中通过EL表达式引用这个参数值。

```java
public class HelloWorldAction extends ActionSupport{
	private String path;
	@Override
	public String execute() throws Exception {
		path = "view";
		return "toWelcome";
	}
	public String getPath() {
		return path;
	}
	public void setPath(String path) {
		this.path = path;
	}
}	

//struts.xml
<action name="helloWorldAction" class="com.HelloWorldAction">
	<result name="toWelcome">/${path}/welcome.jsp</result>
	<result name="input">/view/login.jsp</result>
</action>
```

**（2）页面路径传递参数**：如果我们使用redirect重定向，那么只能通过在URL后面拼接参数来实现参数传递，然后通过传统的`request.getParameter()`的方式在页面上获取参数值。

```java
//model
public class UserModel {
	private String account;
	private String password;
	//省略getter/setter
}

//Action
public class HelloWorldAction extends ActionSupport{
	private UserModel um;
	@Override
	public String execute() throws Exception {
		System.out.println(um); 
		return "other";
	}
	//省略getter/setter
}

//struts.xml
<action name="helloWorldAction" class="com.HelloWorldAction">
	<result name="other" type="redirect">/view/other.jsp?account=${um.account}</result>
</action>

//other.jsp
<body>
	欢迎朋友<%=request.getParameter("account")%>来访 <br>
	again, 欢迎朋友${param['account']}来访
</body>
```

**（3）从action跳转至servlet：**action的后继也可以是一个servlet，只需要把servlet的映射路径配置到<result>中即可。

```xml
//web.xml
<servlet>
    <description></description>
    <servlet-name>MyServlet</servlet-name>
    <servlet-class>com.MyServlet</servlet-class>
</servlet>
<servlet-mapping>
    <servlet-name>MyServlet</servlet-name>
    <url-pattern>/MyServlet</url-pattern>
</servlet-mapping>
      
//struts.xml
<action name="helloWorldAction" class="com.HelloWorldAction">
	<result name="other">/MyServlet</result>
</action>
```

### 全局result和result匹配顺序

全局result可以由多个action共用，定义方式如下：

```xml
<package name="aa" namespace="/bb" extends="struts-default" abstract="false">
	<global-results>
		<result name="login">/login.jsp</result>
	</global-results>
</package>	
```

再有了全局result后，需要明白在action运行之后execute方法返回值的匹配顺序：

1. 首先，先找自己的<action>元素内的<result>元素是否有匹配的，如果有就执行这个result。如果没有，执行下一步查找。
2. 其次，再找 自己的<action>所在的包的全局result，看是否有匹配的，如果有就执行这个全局result，否则执行下一步查找。
3. 递归的寻找自己的包的父包、祖父包中的全局result，看是否有匹配的，如果有就执行这个全局result，否则抛出异常。

一个简单的应用例子：

```xml
<struts>
	<package name="struts-abstract" extends="struts-default">
	 	<global-results>
			<result name="login">/login.jsp</result>
		</global-results>
	</package>
	<include file="struts-homepage.xml"></include>
	<include file="struts-4A.xml"></include>
</struts>
```

### 异常Exception映射

在实际开发中，我们不需要在execute()方法中try--catch捕获异常，而是把异常交由struts2框架来捕获，我们只需要在struts.xml中配置需要捕获哪种异常，并配置异常出现后，需要跳转至哪个result。

```java
//action
public class HelloWorldAction extends ActionSupport{
	@Override
	public String execute() throws Exception {
		int a = 5/0; //ArithmeticException异常
		return "toWelcome";
	}
}

//struts.xml
<action name="helloWorldAction" class="com.HelloWorldAction">
	<exception-mapping result="math-exception" exception="java.lang.ArithmeticException" />
	<result name="math-exception">/view/error.jsp</result>
	<result name="toWelcome">/view/welcome.jsp</result>
</action>

//error.jsp
<body>
<%@ taglib prefix="s" uri="/struts-tags"%>
对比起，出错了，错误信息为：<br>
<s:property value="exception" /><br>
错误的堆栈信息为：<br>
<s:property value="exceptionStack"/>
</body>
```

**全局异常映射**

我们也可以像<result>一样定义全局异常映射，这样，多个action都可以使用这个异常映射。注意，必须先定义<global-results>，然后才能定义<global-exception-mappings>。

```xml
<package name="aa" namespace="/bb" extends="struts-default" abstract="false">
	<global-results>
		<result name="math-exception">/view/error.jsp</result>
	</global-results>
	<global-exception-mappings>
		<exception-mapping result="math-exception" exception="java.lang.ArithmeticException" />
	</global-exception-mappings>
</package>
```

具体的异常映射匹配顺序如下：

1. 首先，找到自己的<action>元素内的<exception-mapping>元素是否有匹配的，如果有就执行这个exception映射，如果没有，执行下一步。
2. 其次，找到自己的包里面的全局异常映射，看看是否有匹配的，如果有就执行这个全局异常映射，否则执行下一步。
3. 再次，递归的寻找自己的包的父包、祖父包中的全局异常映射是否有匹配的，如果有就执行这个异常映射，否则爆出异常交由struts2处理。

### PreResultListener

在实际开发中，常常需要在action执行完毕后，而result还没有开始执行的时候，做一些功能处理，比如异常处理，此时就需要用PreResultListener。他本质上就是一个监听器，监听的事件就是actino执行完毕，马上要开始result的处理。

我们只需要编写好监听器类，然后把监听器注册到struts2中，struts2就会在事件发生时调用我们的监听器。监听器类要实现PreResultListener接口，该接口中只有一个方法需要覆盖：`beforeResult(ActionInvocation actionInvocation, String result)`

```java
//我们创建的监听器
public class MyPreResult implements PreResultListener{
	@Override
	public void beforeResult(ActionInvocation actionInvocation, String result) {
		System.out.println("现在处理result执行前的功能，result="+result);
	}
}

//action，在其中注册监听器
public class HelloWorldAction extends ActionSupport{
	private UserModel um;
	@Override
	public String execute() throws Exception {
		System.out.println(um); 
		//注册我们的监听器
		PreResultListener pr = new MyPreResult();
		ActionContext.getContext().getActionInvocation().addPreResultListener(pr);
		
		return "toWelcome";
	}
}
```

### 自定义Result（没啥用）

用到再学吧。

## 第6章 拦截器

拦截器式一种可以让用户**在Action执行之前和Result执行之后**进行一些功能处理的机制。具体的执行顺序如下：

```

```

拦截器有如下优点：

1. 简化actino的实现、功能更加单一、通用代码模块化、提高重用性
2. 实现AOP

### 拦截器的原理

拦截器非常类似于filter，但它比filter更加强大，比如拦截器与servlet的API无关，拦截器可以访问值栈。struts2提供了许多预定义的拦截器，比如统计action执行时间的拦截器，比如把前端参数填充到action属性的拦截器。预定义的拦截器都在struts-default.xml文件中。其外，开发者也可以创建自定义的拦截器。在struts.xml文件中，我们的<package>元素通常都会去继承`struts-default`，而其中定义了如下语句，因此我们<package>中的<action>自动会被struts2预定义拦截器所拦截。

```xml
<default-interceptor-ref name="defaultStack"/>
```

### 拦截器的标签介绍

我们可以打开struts-default.xml文件来学习拦截器相关的标签，学习如何在xml文件中定义拦截器。

```xml
<package name="struts-default" abstract="true">
	<interceptors>
		<interceptor name="alias" class="com.opensymphony.xwork2.interceptor.AliasInterceptor"/>
		<interceptor name="autowiring" class="com.opensymphony.xwork2.spring.interceptor.ActionAutowiringInterceptor"/>
		<interceptor name="chain" class="com.opensymphony.xwork2.interceptor.ChainingInterceptor"/>

		<!-- Basic stack -->
		<interceptor-stack name="basicStack">
			<interceptor-ref name="exception"/>
			<interceptor-ref name="servletConfig"/>
			<interceptor-ref name="prepare"/>
			<interceptor-ref name="checkbox"/>
			<interceptor-ref name="multiselect"/>
			<interceptor-ref name="actionMappingParams"/>
			<interceptor-ref name="params">
				<param name="excludeParams">dojo\..*,^struts\..*</param>
			</interceptor-ref>
			<interceptor-ref name="conversionError"/>
		</interceptor-stack>
   </interceptors>
   <default-interceptor-ref name="defaultStack"/>
</package>
```

**（1）<interceptors>：该标签必须放置在package标签下，可以把它看做是拦截器的容器标签，如果你想定义拦截器，则必须先定义一个<interceptors>标签，然后把拦截器相关的标签作为其子标签。**

**（2）<interceptor>：该标签用于定义一个拦截器，name属性是拦截器的名字，name作为拦截器的唯一标志。而class属性对应拦截器的类。注意，该标签只是定义了拦截器，此时还没有任何一个action来引用它。**

**（3）<interceptor-stack>：该标签用于定义一个拦截器栈。拦截器栈用来封装多个拦截器。因为在实际开发中，action在引用拦截器的时候都不会仅仅引用一个拦截器，而是引用一组拦截器，此时为了引用方便，就把多个拦截器组成一个拦截器栈，action在引用的时候，只需要引用这个拦截器栈就可以了，而不是引用每一个拦截器。**

**（4）<interceptor-ref>：该标签用于在拦截器栈中引用已经定义好的拦截器。它含有一个name属性，name用来表示所引用的拦截器。注意，name的值既可以是一个拦截器，也可以是一个拦截器栈。**

**（5）<param>：我们还可以在<interceptor-ref>中添加<param>，以表示该拦截器的初始化参数，这很类似于servlet、filter中的初始化参数。我们可以在拦截器类中获取到初始化参数。**

**（6）<default-interceptor-ref>：该标签设置了默认的拦截器，所有的actino都会被默认拦截器所拦截。默认拦截器实际上是一个拦截器栈，名为defaultStack。所有的action都会被defaultStack中的拦截器所拦截。**

### 在struts.xml中引用拦截器

非常简单，只需要在<action>元素中添加子元素<interceptor-ref>即可。name属性既可以是一个拦截器，也可以是一个拦截器栈。

```xml
<action name="helloWorldAction" class="com.HelloWorldAction">
	<result name="toWelcome">/view/welcome.jsp</result>
	<interceptor-ref name="myInterceptor" />
	<interceptor-ref name="defaultStack" />
</action>
```

### 拦截器的匹配顺序 

action会按照如下顺序找到它引用的拦截器：

1. 首先，要找到它自己有没有声明拦截器的引用，即<action>元素有没有<interceptor>子元素，如果有，则使用这些拦截器，否则继续寻找。
2. 其次，找到这个<action>所在的包有没有声明默认的拦截器引用，即<package>元素的<default-interceptor=ref>子元素，如果有，则使用这些拦截器，否则继续寻找。
3. 最后，递归寻找这个包的父包，看看有没有声明默认的拦截器引用，直到找到有拦截器引用为止。

注意，这三个位置的定义是覆盖关系，也就是说，如果<action>中生命了拦截器引用，那么就以它为准，其他的定义就无效了。即<action>中的拦截器引用声明 会覆盖<package>里面的默认拦截器声明，以此类推。正因为如此，如果<action>引用自定义的拦截器，最好在后面显式的引用默认拦截器栈，这样自定义拦截器、默认拦截器栈都会被调用。

```xml
<action name="helloWorldAction" class="com.HelloWorldAction">
	<result name="toWelcome">/view/welcome.jsp</result>
	<interceptor-ref name="myInterceptor" />
	<interceptor-ref name="defaultStack" /> <!--显式引用-->
</action>
```

### 自定义拦截器

自定义拦截器必须实现Interceptor接口。

```java
//action
public class MyInterceptor implements Interceptor{
	private String db;
	
	@Override
	public void destroy() {
		System.out.println("MyInterceptor destroy");
	}

	@Override
	public void init() {
		System.out.println("MyInterceptor init");
		System.out.println("db="+db);
	}

	@Override
	public String intercept(ActionInvocation invocation) throws Exception {
		System.out.println("action执行之前");
		String result = invocation.invoke();
		System.out.println("action执行之后");
		return result;
	}
	
	public String getDb() {
		return db;
	}

	public void setDb(String db) {
		this.db = db;
	}
}
```

```xml
//struts.xml
<package name="aa" namespace="/bb" extends="struts-default" abstract="false">
	<!-- 定义一个拦截器 -->
	<interceptors>
		<interceptor name="myInterceptor" class="com.MyInterceptor" >
				<param name="db">oracle</param>
			</interceptor>
	</interceptors>

	<action name="helloWorldAction" class="com.HelloWorldAction">
		<result name="toWelcome">/view/welcome.jsp</result>
		<interceptor-ref name="myInterceptor" > <!-- 引用拦截器 -->
			<param name="db">mysql</param>
		</interceptor-ref> 
		<interceptor-ref name="defaultStack" />
	</action>
</package>
```

```jsp
//welcome.jsp
<body>
<%@ taglib prefix="s" uri="/struts-tags" %>
欢迎账号为<s:property value="um.account" />的朋友来访
<%
System.out.println("result页面中的JSP脚本");
%>
</body>
```

Interceptor接口包含3个方法，`init()`、`destroy()`、`intercept(ActionInvocation invocation)`，只要我们在struts.xml中定义并引用了这个Interceptor，tomcat在启动时就自动创建这个拦截器，并调用`init()方法`。而当tomcat正常关闭时，就会自动调用`destroy()`方法销毁拦截器。

`intercept(ActionInvocation invocation)`方法是拦截器的核心方法，他的作用与filter的`doFilter()`方法类似：

* 在`invocation.invoke()`语句之前的语句，会爱actino运行之前执行。
* 在`invocation.invoke()`语句之后的语句，会在result运行渲染之后执行。
* `invocation.invoke()`语句用于执行下一个拦截器，就像doFilter一样执行下一个filter，如果是最后一个拦截器，则执行action。`invocation.invoke()`还有一个String返回值，它表示action执行完毕后期望跳转到的result页面。

**注意，`intercept(ActionInvocation invocation)`方法本身也会返回一个字符串，如果方法体中没有执行`invocation.invoke()`方法（比如数据验证失败），则会跳到`intercept(ActionInvocation invocation)`返回值对应的result页面中。如果方法体中执行了`invocation.invoke()`方法，则`intercept(ActionInvocation invocation)`返回值没有任何意义。**

接下来，我们只需在struts.xml中配置定义这个拦截器，然后在<action>元素中引用这个拦截器即可。

此外，我们还可以在**定义拦截器时(<interceptor标签中>)或者在引用拦截器时(<interceptor-ref标签中>)**，通过<param>标签来创建拦截器初始化参数。tomcat会在启动时便把参数加载到拦截器中，我们可以直接在init方法中通过属性来获取该参数。注意，如果定义了同名初始化参数，则<interceptor-ref>中的参数会覆盖<interceptor>中的参数。

最后我们来观察一下tomcat输出，这也证实了几点：

* tomcat启动时就创建拦截器，并加载初始化参数
* 拦截器作用于action执行之前
* 拦截器作用于result渲染完毕之后

```java
//tomcat启动时
MyInterceptor init
db=mysql

//执行action
action执行之前
account=admin,password=111111111; //action的execute()执行时
result页面中的JSP脚本  //先渲染result
action执行之后  //后执行拦截器的后继部分
```

## 值栈和OGNL

这一章涉及到很多概念，首先我们必须了解这些概念的含义，并清楚他们的用途。

### 容易混淆的概念

#### ActionContext和valueStack

struts2本质上是由**控制流和数据流组成的**。控制流是指ActionProxy、ActionInvocation、Action、Interceptor、Result等这些控制组件。而数据流指的就是ActionContext和valueStack。数据流可以理解为**数据和流**。其中ActionContext表示数据，即数据的存储。而valueStack表示流，即数据在各个控制组件上的传输流动。

根据HTTP协议，J2EE的servlet要求我们使用类似于`request.getParameter("username")`的方式获取前端参数，此时参数是String类型的，也就是说，从请求到响应的过程中，数据只能以String的表现形式存在：

![](http://wx2.sinaimg.cn/mw690/0065Y1avgy1ffcplqiyerj30w205pjul.jpg)

而ActionContext和valueStack则解决了后端数据表现形式的问题。在后端我们更希望用Java的POJO类来表示数据，并且POJO类在表示复杂数据时天生具有优势。

![](http://wx2.sinaimg.cn/mw690/0065Y1avgy1ffcqm5o7m8j30y60dyag6.jpg)

struts2的做法做出了如下改变：

* Action不再和servlet绑定，解耦合，便于测试。
* 由于action不再和servlet耦合，因此action也无需自己从请求对象中解析参数，而是直接从ActionContext对象中获取POJO对象。

valueStack本质上是OGNL表达式的升级版。两者的作用都是：

* 把页面参数封装为POJO对象。
* 把POJO对象解析为页面显示数据。
* 提供一定的表达式运算能力。

在servlet中，页面参数的表达方式是username、password。而在struts2中，页面参数的表达方式是user.username、user.password，这便是OGNL表达式，只有使用这样的表达方式，OGNL才能通过POJO的getter/setter实现POJO对象的创建，并注入对应的属性。

#### JSTL标签和struts2标签

JSTL标签和struts2标签的作用都是一样的：**分离JSP上的Java代码和HTML代码，HTML用来管理数据展现在哪儿，而Java代码用来获取数据。让前端人员也有能力使用Java代码来动态输出页面内容**。首先需要明白一个道理：JSTL标签、struts2标签能做到的事情，JSP脚本元素<%%>肯定也能做到。那为什么还需要引入标签呢。因为前端人员大多不会java，因此Java提供了标签机制，标签本质上来说就是Java代码块，web引擎在解析标签时，会自动解析为对应的java代码块。比如前端人员期望在页面上显示本机IP地址，此时java开发人员就可以提前封装好一个显示本机IP的标签，例如`<y:show value="myip" />`，前端人员只需要使用这个标签即可，避免了在前端编写一大堆JSP脚本。通常，标签都会提供例如循环控制、条件控制等一些常用标签。

注意，标签本质上只是在页面结构上作文章（XML元素），而表达式（EL、OGNL）则是在显示数据的值上座位上（XML属性的值）。

#### freemarker和velocity

这两者本质上来说也是标签，作用和JSTL标签、struts2标签一样。只是据说他们的渲染速度更快，标签更容易学习。

#### EL表达式和OGNL

前面说到，OGNL、valueStack都是为了实现字符串到POJO以及POJO到字符串的解析。而EL表达式也是完成类似的功能。EL表达式只能从page、request、session、application域中获取数据。而OGNL、valueStack则直接从ActionContext中获取数据。

#### 小结

* 存储POJO对象：ActionContext
* String到POJO的封装，以及POJO到String的解析：valueStack、OGNL、EL表达式
* 页面结构的控制：JSTL、struts2标签、 freemarker、velocity

### 书中关于值栈的解释

值栈可以分为狭义和广义的解释：狭义的值栈就是ValueStack，而广义的值栈则是ActionContext。可以理解为ActionContext包含ValueStack。ActionContext和ValueStack都是线程安全的，这也是值栈相较于servlet的一大优势。

ActionContext中存储了如下数据：

* request的parameters
* request的attribute
* session的attribute
* application的attribute
* ValueStack

当我们希望在action中获取servlet相关的数据时，比如请求数据、session数据、cookie数据时，我们不需要直接和servlet的API打交道，只需要通过ActionContext获得。

在页面上使用OGNL时，没有特殊标志的情况下，默认从ValueStack获取值。

### ValueStack的基本使用

ValueStack有一个特点，如果访问的值栈里有多个对象，且相同的属性在多个对象中同时出现，则值栈会按照从栈顶到栈底的顺序，寻找第一个匹配的对象。**ValueStack中存储的值的作用域是request作用域。因为ValueStack依赖于ActionContext，而struts2会为每一个请求创建一个独立的ActionContext，请求--响应结束收，ActionContext就会销毁。**

ValueStack的具体方法可参考API，这里主要说几个：

```java
//根据表达式在value stack中，按照默认的访问顺序去获取表达式对应的值
Object findValue(String expr); 

//根据表达式，按照默认的访问顺序，向value stack中设置值
void setValue(String expr, Object value);

//获取value stack中定测对象，不修改value stack对象
Object peek();

//获取value stack中的顶层对象，并把这个对象从value stack中移走
Object pop();

//把对象加入到value stack对象中，并设置成为顶层对象
void push(Object o);
```

**ValueStack的小例子：**在PreResultListener中通过`setValue(String expr, Object value)`方法，在渲染result之前，给account属性设置新的值：

```java
public class MyPreResult implements PreResultListener{
	@Override
	public void beforeResult(ActionInvocation actionInvocation, String result) {
		actionInvocation.getInvocationContext().getValueStack().setValue("um.account", "NewAccount");
	}
}
```

通常情况下，向value stack里压入值都是由struts2去完成，而访问value stack多是通过标签中的OGNL表达式，因此开发者直接使用ValueStack的机会并不是很多。

### OGNL的使用

OGNL是对象图导航语言，它2是一种功能强大的表达式语言。通过它简单一致的表达式语法，可以存取对象的数据，调用对象的方法，遍历整个对象的结构图，实现字段类型转化等功能 。比如下面的例子，两个表达式`um.account`都是相同的，前一个保存对象属性的值，后一个取得对象属性的值。

```html
<input type="text" name="um.account" />
<s:property value="um.account" />
```

#### 输出常量

常量需要用额外的单引号括起来，常量表示无需OGNL来解析这个字符串。

```
//输出value stack中um.account对应的属性值
<s:property value="um.account" />

//输出常量um.account
<s:property value="'um.account'" />
```

#### 访问value stack

在OGNL中，没有前缀代表了访问当前值栈。此时会按照从栈顶到栈底的顺序，寻找第一个匹配的对象。

```java
<s:property value="um.account" />
```

#### 访问ActionContext中的数据

在OGNL中，可以通过符号`#`来访问ActionContext中除了值栈之外的各种值，比如：

* \#parameters：当前请求中的参数，对应`request.getParameter(name)`
* \#request：请求作用域中的属性：对应`request.getAttribute(name)`
* \#session：会话作用域中的属性：对应`session.getAttribute(name)`
* \#application：应用程序作用域的属性。
* \#attr：按照页面page、请求request、会话session和应用application的顺序，返回第一个符合条件的属性。

```jsp
//login.jsp
<form action="../bb/helloWorldAction.action" method="post">
	账号1：<input type="text" name="account" /> <br>
	密码1：<input type="password" name="password" /> <br>
	<input type="submit" value="提交" />
</form>

//welcome.jsp
<body>
<%@ taglib prefix="s" uri="/struts-tags" %>
欢迎账号为<s:property value="account" />的朋友来访 <br>
请求参数中的账号：<s:property value="#parameters.account" /> <br>
<%request.setAttribute("account", "request_account"); %>
请求属性中的账号：<s:property value="#request.account" /> <br>
会话属性中的账号：<s:property value="#session.account" /> <br>
应用属性中的账号：<s:property value="#application.account" /> <br>
attr中的账号：<s:property value="#attr.account" /> 
</body>
```

```java
//Action
public class HelloWorldAction extends ActionSupport{
	private String account;
	private String password;
	
	@Override
	public String execute() throws Exception {
		System.out.println("account="+account+",password="+password); 
		//注册我们的监听器
		PreResultListener pr = new MyPreResult();
		ActionContext ac = ActionContext.getContext();
		ac.getSession().put("account", "session_account");
		ac.getApplication().put("account", "application_account");
		return "toWelcome";
	} 
	//省略getter/setter
}

//打印结果
欢迎账号为admin的朋友来访 
请求参数中的账号：admin 
请求属性中的账号：request_account 
会话属性中的账号：session_account 
应用属性中的账号：application_account 
attr中的账号：request_account
```

#### 访问静态方法和静态属性

```java
@类的全路径名@属性名称
@类的全路径名@方法名称(参数列表)
```

```java
//struts.xml：设置允许静态方法访问
<constant name="struts.ognl.allowStaticMethodAccess" value="true" />

//action
public class HelloWorldAction extends ActionSupport{
	//静态成员变量必须是public，并且没有getter/setter
	public static String staticVar = "staticVar";
	
	public static void staticMethod() {
		System.out.println("this is static method");
	}
}

//welcome.jsp
<s:property value="@com.HelloWorldAction@staticVar" /> <br>
<s:property value="@com.HelloWorldAction@staticMethod()" /> <br>
```

#### 访问域对象

其实就是把value值设置为`um.account`的格式，这样的做法前面已经学习过了。有几点需要注意：

1. 首先，struts2默认寻找um属性对应getter/setter，如果找到，则使用getter/setter来赋值，否则继续寻找。
2. 接着，strut2寻找public修饰的um属性，如果找到则直接赋值，否则将赋值失败。需注意，如果um属性设置为public，则必须在声明时同时初始化um：`public UserModel um = new UserMdoel();`。

良好的编程习惯是，把属性设置为private，并提供getter/setter。

```jsp
//login.jsp
<form action="../bb/helloWorldAction.action" method="post">
	账号1：<input type="text" name="um.account" /> <br>
	密码1：<input type="password" name="um.password" /> <br>
	<input type="submit" value="提交" />
</form>

//welcome.jsp
欢迎账号为<s:property value="um.account" />的朋友来访 <br>
```

```java
//action
public class HelloWorldAction extends ActionSupport{
	private UserModel um;
	
	@Override
	public String execute() throws Exception {
		System.out.println(um); 
		return "toWelcome";
	}
	//省略getter/setter
}
```

#### 访问List和数组

```jsp
//login.jsp
<form action="../bb/helloWorldAction.action" method="post">
	账号：<input type="text" name="umList[0].account" /> <br>
	密码：<input type="password" name="umList[0].password" /> <br>
	<input type="submit" value="提交" />
</form>

//welcome.jsp
<body>
<%@ taglib prefix="s" uri="/struts-tags" %>
用户0账号:<s:property value="umList[0].account"/> <br>
用户0密码:<s:property value="umList[0].password"/> <br>
用户1账号:<s:property value="umList[1].account"/> <br>
用户1密码:<s:property value="umList[1].password"/> <br>
list.size():<s:property value="umList.size" /> <br>
list.isEmpty():<s:property value="umList.isEmpty"/>
</body>
```

```java
public class HelloWorldAction extends ActionSupport{
	private List<UserModel> umList;
	//省略getter/setter
	@Override
	public String execute() throws Exception {
		System.out.println("第0个用户的账号："+umList.get(0).getAccount());
		System.out.println("第0个用户的密码："+umList.get(0).getPassword());
		//放入一个新的用户
		UserModel um = new UserModel();
		um.setAccount("lyn");
		um.setPassword("99999");
		umList.add(um);
		return "toWelcome";
	}
}
```

如果属性是数组，则唯一需要变化的是，数组必须在声明时就立刻像下面这样初始化：

```java
private UserModel[] umList = {new UserModel(), new UserModel()};

//此外，数组还提供了这样的表达式
array.length:<s:property value="umList.length" /> <br>
```

#### 访问map

```jsp
//login.jsp
<form action="../bb/helloWorldAction.action" method="post">
	账号：<input type="text" name="userMap['umtest'].account" /> <br>
	密码：<input type="password" name="userMap['umtest'].password" /> <br>
	<input type="submit" value="提交" />
</form>

//welcome.jsp
用户0账号:<s:property value="userMap['umtest'].account"/> <br>
用户0密码:<s:property value="userMap['umtest'].password"/> <br>
```

```java
//action
public class HelloWorldAction extends ActionSupport{
	private Map<String, UserModel> userMap;
	//省略getter/setter
	@Override
	public String execute() throws Exception {
		System.out.println("第0个用户的账号："+userMap.get("umtest").getAccount());
		System.out.println("第0个用户的密码："+userMap.get("umtest").getPassword());
		//放入一个新的用户
		UserModel um = new UserModel();
		um.setAccount("lyn");
		um.setPassword("99999");
		userMap.put("umtest", um);
		return "toWelcome";
	}
}
```

### ActionContext

```java
//常用方法
ActionContext ac = ActionContext.getContext();
ValueStack vs = ActionContext.getContext().getValueStack();
ActionContext ac = invocation.getInvocationContext();
```

struts2在每次执行action之前都会创建新的ActionContext，在同一个县城里ActionContext里面的属性是唯一的，这样Action就可以在多线程中使用。

使用ActionContext可以获得session、request中的数据，但其实返回的并不是HttpServletRequest、HttpSession对象，而是Map对象。Map对象对HttpSession进行了封装。正是因为有了ActionContext，Action才能与ServletAPI解耦合。

### SessionAware接口

一般来说，为了能让execute可以脱离web容器独立测试，我们不会在execute方法中使用ActionContext，因为ActionContext方法是与ServletAPI耦合的。那我们想要访问session域中的数据应该怎么办呢？答案：可以让Action实现SessionAware接口。此外，也有RequestAware、ApplicationAware、ParameterAware接口，用法类似。

```java
//ation
HelloWorldAction extends ActionSupport implements SessionAware{
	private Map<String, Object> session;
	@Override
	public String execute() throws Exception {
		session.put("mySession", "123abc"); //这里的赋值与HttpSession是联动的
		return "toWelcome";
	}
	
	//实现SessionAware接口后，必须覆盖这个方法
	//struts2会通过DI依赖注入的方式，为我们给sesion属性赋值
	//这样就不用麻烦ActionContext了
	@Override
	public void setSession(Map<String, Object> session) {
		this.session = session;
	}
}

//welcome.jsp
<s:property value="#session.mySession"/>
```

### ServletActionContext

ServletActionContext是ActionContext的子类，他主要用于获取原生的ServletAPI相关的对象，包括HttpServletRequest、HttpServletResponse、ServletContext、PageContext。

### Context的思考

在Action中，优先考虑使用接口+DI依赖注入的方式实现访问各种域，尽量不要再action中使用ActionContext，这有利于Action的独立测试。

如果实在无法满足要求，再考虑在Action的execute中使用ActionContext，注意，不要在Action的空构造函数中使用ActionContext，因为那时ActionContext可能还没初始化完毕。

最后再考虑使用ServletActionContext。

## 第8章struts2的TagLib

标签有几大好处：

* 分离JSP上的Java代码和HTML代码，HTML用来管理数据展现在哪儿，而Java代码用来获取数据
* 无需在JSP中引入相关包、类
* 前端人员不懂Java也能用标签完成工作。

### struts2标签分类

* 数据标签：用来从值栈上取值或向值栈赋值
* 控制标签：控制程序的运行流程，比如判断分支、循环
* UI标签：用来显示UI页面的内容，多会生成HTML
* 杂项标签：用于完成其他功能的标签，比如生成URL和输出国际化文本等。

### 数据标签

#### property

property用于输出值，标签包含如下属性：

* value：用来获取值的OGNL表达式，如果value属性值没有指定，那么将会被设定为top，即返回位于值栈最顶端的对象。
* default：如果按照value属性指定的OGNL求值后返回的是空值，但仍希望输出某些内容，那么就可以使用default属性来指定这些内容。
* escape：是否转义HTML，默认为true
* escapeJavaScript：是否转义js，默认为false

```jsp
用户账号:<s:property value="um.account" default="xxx"/> <br>
用户密码:<s:property value="um.password" default="YYY"/> <br>
```

#### set

用于定义一个变量，并赋值。属性如下：

* var：变量名。刻在OGNL表达式中使用这个名称来引用存放到值栈的这个对象。
* value：设置给变量的值，可以是常量，也可以是OGNL表达式。
* scope：变量的生存周期，可选application、session、request、page、action，默认为action。

**set应用：重命名**

```
<!-- 给#sessoin.user定义了一个新名称tempUser，后面就可以使用新名称了 -->
<s:set var="tempUser" value="#sessoin.user"/>
<!-- 引用新名称前，必须用# -->
<s:property value="#tempUser.account"/>
<s:property value="#tempUser.password"/>
```

**set应用：实现i++**

```jsp
<%@ taglib prefix="s" uri="/struts-tags" %>
<s:set var="i" value="1" />
i的值：<s:property value="#i"/> <br>
<s:set var="i" value="#i+1"/>
i++的值：<s:property value="#i"/> <br>
```

**set应用：scope属性**

它表示set所定的变量的生存周期。值为action表示这个变量的生存周期是当前ActionContext范围。

```jsp
//other.jsp
<s:set var="v1" scope="application" value="'application范围的值'"/> <br>
<s:set var="v2" scope="session" value="'session范围的值'"/> <br>
<s:set var="v3" scope="request" value="'request范围的值'"/> <br>
<s:set var="v4" scope="page" value="'page范围的值'"/> <br>
<s:set var="v5" scope="action" value="'action范围的值'"/> <br>

//other2.jsp
输出application的值：<s:property value="#application['v1']"/> <br>
输出session的值：<s:property value="#session['v2']"/> <br>
输出request的值：<s:property value="#request['v3']"/> <br>
<!-- page输出时用的是attr -->
输出attr的值：<s:property value="#attr['v4']"/> <br>
<!-- action输出值，没有前缀 -->
输出action的值：<s:property value="#v5"/> <br>
```

先通过URL访问other.jsp，再通过URL访问other2.jsp，

#### push

push表现用于把指定的对象放到值栈的栈顶。属性只有一个。push和set都具有重命名的作用，但set的作用域是ActionContext，即请求域。而push的作用域是自己标签内。

* value：用来指定放到值栈栈顶的对象。

```java
public class HelloWorldAction extends ActionSupport implements SessionAware{
	private UserModel um;
	private Map<String, Object> session;
	
	@Override
	public String execute() throws Exception {
		UserModel umtest = new UserModel();
		umtest.setAccount("abc");
		umtest.setPassword("123");
		session.put("umtest", umtest);
		return "toWelcome";
	}
	//省略getter/setter
}

//welcome.jsp
<s:push value="#session.umtest">
	<s:property value="account" />
	<s:property value="password" />
</s:push>
```

#### bean标签和param标签

bean标签用于创建JavaBean实例，并将其压入值栈中，可以添加param标签。param标签用于为其他标签添加参数化设置的功能。

bean的属性：

* name：指定了要创建的JavaBean的全类名，必须要设置
* var：引用这个JavaBean实例的名称

param的属性：

* name：参数名称
* value：参数的值

```jsp
<%@ taglib prefix="s" uri="/struts-tags" %>
<s:bean name="com.UserModel" var="user">
	<s:param name="account" value="abc" />
	<s:param name="password" value="123" />
</s:bean>
<!-- 引用时需要# -->
<s:property value="#user.account" />
<s:property value="#user.password" />
```

#### date

date标签用于格式化输出一个日期数据。属性包括：

* format：用于指定日期显示格式，如果不指定，将会去找国际化细腻中key为struts.date.format的指定值。
* name：被格式化的值，必须设置，它本身是一个OGNL表达式。
* nice：是否显示当前时间与指定时间的差。如果设置为true，则不再显示指定时间，只显示当前时间与指定时间的差。

```jsp
<%
	Calendar c = Calendar.getInstance();
	Date date = c.getTime();
	request.setAttribute("dd", date);
%>
<%@ taglib prefix="s" uri="/struts-tags" %>
日期为：<s:date name="#request.dd" format="yyyy-MM-dd" nice="true"/>
```

#### debug

debug标签可以帮助程序员进行调试，它在页面上生成一个链接，点击这个链接可以查看ActionContext和值栈中所有能访问的值。

```java
<s:debug />
```

## 第10章 数据校验

无论是哪一种验证器，都要考虑一下几个问题：

* 验证谁？
* 使用什么条件验证？
* 不满足条件显示什么结果？
* 不满足验证条件时，显示的结果出现在页面的什么位置？

struts2的校验器是基于xml文件的。struts2默认提供了许多校验器，你只需要在Action所在包下创建一个action名称-validation.xml文件，并在其中引用定义好的校验器即可。

**struts2验证的是用户提交的参数，一般为表单参数。**

**struts2验证器的验证条件：验证条件写在xml文件中。**

**不满足条件时，错误信息定义在xml文件中。**

**错误信息通过struts2标签来显示。**

**struts2的验证时机：**验证发生在execute方法运行之前，在struts2的params拦截器已经把请求的参数反射的设置到action的属性之后。因此验证器实际上验证的是值栈的值。

**struts2验证跳转：**如果用户输入的参数完全满足验证条件，则会继续执行execute方法。如果用户输入的参数不完全满足验证条件，就会跳转到这个action所配置的名为input的Result页面上。

### 验证器的两种类型

struts2中的验证器分为两种类型：

* 字段验证器：用来验证提交的表单内的单个字段。
* 动作验证期：用于整个动作，一般用于验证提交的表单内的多个字段的关系，当然也可以验证单个字段 。

**字段验证器的例子：**账号、姓名不能为空，年龄至少18岁。

```java
//model
public class MyUser {
	private String account;
	private String name;
	private int age;
	//省略getter/setter
}

//action
public class RegisterAction extends ActionSupport{
	
	private MyUser user = new MyUser();

	public String execute() throws Exception{
		System.out.println("传入的数据为："+user);
		return SUCCESS;
	}
	//省略getter/setter
}
```

```jsp
//register.jsp
<body>
<%@ taglib prefix="s" uri="/struts-tags"%>
用户注册
<hr>
<s:form action="/bb/registerAction.action" method="post">
	<s:textfield name="user.account" label="账号" />
	<s:textfield name="user.name" label="姓名" />
	<s:textfield name="user.age" label="年龄" />
	<s:submit value="注册"/>
</s:form>
</body>

//success.jsp
<body>
恭喜您注册成功！
</body>
```

```xml
//struts.xml
<action name="registerAction" class="com.RegisterAction">
	<result name="success">/view/success.jsp</result>
	<result name="input">/view/register.jsp</result>
</action>

//RegisterAction-validation.xml 放在RegisterAction.java所在包下
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE validators PUBLIC
        "-//OpenSymphony Group//XWork Validator 1.0.2//EN"
        "http://www.opensymphony.com/xwork/xwork-validator-1.0.2.dtd">
<validators>
	<field name="user.account"> <!-- 账号不能为空 -->
		<field-validator type="requiredstring">
			<message>请输入账号</message>
		</field-validator>
	</field>
	<field name="user.name"> <!-- 姓名不能为空 -->
		<field-validator type="requiredstring">
			<message>请输入姓名</message>
		</field-validator>
	</field>
	<field name="user.age"> <!-- 年龄至少18岁 -->
		<field-validator type="int">
			<param name="min">18</param>
			<message>年龄必须在18岁以上</message>
		</field-validator>
	</field>	
</validators>
```

**动作验证器的例子：**在上面例子的基础上，要求输入的账号也为数字，并要求输入的age值要大于账号的值。

```xml
<!--RegisterAction-validation.xml-->
<validators>
	<validator type="expression">
		<param name="expression"><![CDATA[user.age>=user.account]]></param>
		<message>年龄必须在${user.account}之上，您输入的是${user.age}</message>
	</validator>
</validators>

<!-- 在页面上打印动作验证器的错误信息时，必须显式地使用<s:actionerror/>标签 -->
<s:actionerror/>
```

### 校验器的运行原理

在struts-default.xml中可以找到三个与校验器有关拦截器。defaultStack默认引用了这三个校验器，因此所有的action都可以使用它们。

```xml
<interceptors>
	<interceptor name="conversionError" class="org.apache.struts2.interceptor.StrutsConversionErrorInterceptor"/>
	<interceptor name="params" class="com.opensymphony.xwork2.interceptor.ParametersInterceptor"/>
	<interceptor name="validation" class="org.apache.struts2.interceptor.validation.AnnotationValidationInterceptor"/>
</interceptors>
<interceptor-stack name="defaultStack">
	<interceptor-ref name="params">
		<param name="excludeParams">dojo\..*,^struts\..*</param>
    </interceptor-ref>
	<interceptor-ref name="conversionError"/>
	<interceptor-ref name="validation">
		<param name="excludeMethods">input,back,cancel,browse</param>
	</interceptor-ref>
</interceptor-stack>
```

这三个拦截器都在Action的execute方法执行前运行，分别实现：

* params拦截器将请求的参数反射地设置入Action的属性。当然这时候有可能出错，比如，将”18a“这个字符串放入一个int属性的时候，肯定会出错。
* conversionError拦截器在params拦截器出错的请求下，把出现的错误放在值栈中。
* validation拦截器验证Action的属性是否符合条件。

其中最关键的是validation拦截器，它会根据验证文件的配置进行验证，验证的是值栈中的相应内容。显示错误可以使用`<s:fielderror />`标签，它可以集中的显示错误信息。

对于上例中的年龄字段，如果我们填写一个非数字，比如“12a”，则此时会显示两个错误。具体原因是：首先首先params拦截器获取到前端的参数"12a"，"12a"无法转换为数字，因此就不能给值栈中的user.age设置值。接着conversionError发挥作用，它发现"12a"无法转换后，便把转换错误的信息保存到值栈中。最后validation拦截器仍然会对user.age进行验证，由于params拦截器无法给user.age赋值，因此user.age保持int的默认值，即零，此时验证失败，并把验证失败的信息写入值栈。

```
Invalid field value for field "user.age"
年龄必须在18岁以上
```

![](http://wx1.sinaimg.cn/mw690/0065Y1avgy1ffecg1khcrj30jh0hwn12.jpg)

### 内建验证器

struts2在xwork-core-2.1.6.jar文件中的`/com/opensymphony/xwork2/validator/validators/default.xml`中生命了许多內建的验证器。具体用法详见《研磨struts2》的第10.4章节。

### 自定义验证器

实现自定义验证时需要考虑三个问题：

* 如何编写自定义验证器的代码
* 如何注册自定义验证器
* 程序中如何引用自定义验证器

**自定义验证器的例子：**实现一个不接受中文字符的验证器，验证逻辑是通过比较字符串的字节数和字符数。就可以知道字符串中是否有中文字符了。如果字节数大于字符数，那么肯定包含了中文字符。

```java
//第一步：创建自定义验证器类，必须继承FieldValidatorSupport类
public class ChineseValidator extends FieldValidatorSupport {

	/*
	 * 表示是否包含字符串，有三种模式：
	 * 1. none 没有中文字符
	 * 2. some 含有部分中文字符，默认值
	 * 3. all 全是中文字符
	 */
	private String mode = "some";

	public String getMode() {
		return mode;
	}

	public void setMode(String mode) {
		this.mode = mode;
	}

	@Override
	public void validate(Object object) throws ValidationException { 
		//获取字段名称
		final String fieldName = this.getFieldName();
		//获取字段值
		final String fieldValue = (String)this.getFieldValue(fieldName, object);
		//字节数
		final int bytes = fieldValue.getBytes().length;
		//字符数
		final int chars = fieldValue.length();
		
		if(mode.equals("none")) {
			if(chars!=bytes) {
				this.addFieldError(fieldName, object);
			}
		} else if(mode.equals("some")) {
			if(chars==bytes || chars*3==bytes) {
				this.addFieldError(fieldName, object);
			}
		} else if(mode.equals("all")) {
			if(chars*3!=bytes) {
				this.addFieldError(fieldName, object);
			}
		}
	}
}
```

```xml
<!--
第二步：注册你的验证器，注意，自定义的验证器会覆盖內建验证器，所以最好的办法是：
	1. 在src目录下，创建一个名为validators.xml的文件，
	2.然后把xwork-core-2.1.6.jar/com/opensymphony/xwork2/validator/validators/default.xml文件中的内容完整的拷贝进去
	3：最后在<validators>元素中，添加子元素<validator>并注册你的自定义验证器
-->
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE validators PUBLIC
        "-//OpenSymphony Group//XWork Validator Config 1.0//EN"
        "http://www.opensymphony.com/xwork/xwork-validator-config-1.0.dtd">

<!-- START SNIPPET: validators-default -->
<validators>
    <validator name="required" class="com.opensymphony.xwork2.validator.validators.RequiredFieldValidator"/>
    <validator name="requiredstring" class="com.opensymphony.xwork2.validator.validators.RequiredStringValidator"/>
    <validator name="int" class="com.opensymphony.xwork2.validator.validators.IntRangeFieldValidator"/>
    <validator name="long" class="com.opensymphony.xwork2.validator.validators.LongRangeFieldValidator"/>
    <validator name="short" class="com.opensymphony.xwork2.validator.validators.ShortRangeFieldValidator"/>
    <validator name="double" class="com.opensymphony.xwork2.validator.validators.DoubleRangeFieldValidator"/>
    <validator name="date" class="com.opensymphony.xwork2.validator.validators.DateRangeFieldValidator"/>
    <validator name="expression" class="com.opensymphony.xwork2.validator.validators.ExpressionValidator"/>
    <validator name="fieldexpression" class="com.opensymphony.xwork2.validator.validators.FieldExpressionValidator"/>
    <validator name="email" class="com.opensymphony.xwork2.validator.validators.EmailValidator"/>
    <validator name="url" class="com.opensymphony.xwork2.validator.validators.URLValidator"/>
    <validator name="visitor" class="com.opensymphony.xwork2.validator.validators.VisitorFieldValidator"/>
    <validator name="conversion" class="com.opensymphony.xwork2.validator.validators.ConversionErrorFieldValidator"/>
    <validator name="stringlength" class="com.opensymphony.xwork2.validator.validators.StringLengthFieldValidator"/>
    <validator name="regex" class="com.opensymphony.xwork2.validator.validators.RegexFieldValidator"/>
    <validator name="conditionalvisitor" class="com.opensymphony.xwork2.validator.validators.ConditionalVisitorFieldValidator"/>
    <!-- 我的自定义验证器 -->
    <validator name="chinese" class="com.ChineseValidator" />
</validators>
<!--  END SNIPPET: validators-default -->
```

```xml
<!-- 第三步：在RegisterAction-validation.xml中引用我的自定义验证器 -->
<validators>
	<field name="user.account">
		<field-validator type="chinese">
			<param name="mode">none</param>
			<message>用户账号只能输入非中文字符</message>
		</field-validator>
	</field>
</validators>
```

### 引用验证器返回的错误信息

引用字段验证错误有梁总方式：

* 对于字段验证错误来说，在<s:form>使用xhtml风格的时候，<s:textfield>标签会将这个字段的错误信息显示在这个文本框的上边。
* 还可以用<s:fielderror/>标签来将字段验证的错误信息显示在指定位置，如果不指定其fieldName属性则会显示所有的错误，如果指定了fieldName属性则会显示指定字段的错误。

对于动作验证错误 ，可以使用<s:actionerror/>标签，它会把所有的动作验证错误显示在指定的位置。

### 验证器的查找顺序

如果有多个验证器匹配，则会按照从上到下的顺序调用验证器：

* 父类-validation.xml
* 父类-别名-validation.xml
* 接口-validation.xml
* 接口-别名-validation.xml
* Action类名-validation.xml
* Action类名-别名-validation.xml

这里说的别名是<action>元素的method属性值，注意，上面的验证规则，绝不是体改或覆盖的关系，而是仅仅指定了先后顺序。下面是一个小例子，此时，对于年龄的两个验证器都会执行，先执行BaseAction的年龄验证器，后执行RegisterAction的年龄验证器。

```java
//BaseAction.java
public class BaseAction extends ActionSupport{
}

//RegisterAction.java
public class RegisterAction extends BaseAction{
	
	private MyUser user = new MyUser();
	//省略getter/setter
	public String execute() throws Exception{
		System.out.println("传入的数据为："+user);
		return SUCCESS;
	}
}
```

```xml
<!-- BaseAction-validation.xml -->
<field name="user.age">
	<field-validator type="int">
		<param name="min">15</param>
		<message>BaseAction的验证：年龄必须在15岁以上</message>
	</field-validator>
</field>

<!-- RegisterAction-validation.xml -->
<field name="user.account">
	<field-validator type="requiredstring">
		<message>请输入账号</message>
	</field-validator>
</field>
<field name="user.age">
	<field-validator type="int">
		<param name="min">18</param>
		<message>RigesterAction的验证：年龄必须在18岁以上</message>
	</field-validator>
</field>
```

```jsp
<body>
<%@ taglib prefix="s" uri="/struts-tags"%>
用户注册
<s:fielderror />
<hr>
<s:actionerror/>
<br>
<s:form action="/bb/registerAction.action" method="post">
	<s:textfield name="user.account" label="账号" />
	<s:textfield name="user.name" label="姓名" />
	<s:textfield name="user.age" label="年龄" />
	<s:submit value="注册"/>
</s:form>
</body>
```

```java
//仅在年龄中输入13，验证结果：
BaseAction的验证：年龄必须在15岁以上
RigesterAction的验证：年龄必须在18岁以上
请输入账号
```

### 验证器短路

在上面的例子中，两个验证器都对年龄进行了验证，如果我们希望让验证通不过第一个条件的时候，后续对这个字段的验证就不用进行了，则只需为<field-validator>或<validator>元素设置短路属性`short-circuit=true`即可。注意，只有xwork-validator-1.0.2.dtd的DTD声明才支持短路属性，1.0版本的DTD不支持。

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE validators PUBLIC
        "-//OpenSymphony Group//XWork Validator 1.0.2//EN"
        "http://www.opensymphony.com/xwork/xwork-validator-1.0.2.dtd">
<validators>
	<field name="user.age">
		<field-validator type="int" short-circuit="true">
			<param name="min">15</param>
			<message>BaseAction的验证：年龄必须在15岁以上</message>
		</field-validator>
	</field>	
</validators>	
```

## 第11章 类型转换

struts2默认支持对“简单类型”，“枚举类型”，“复合类型”进行类型自动类型转换，并帮我们自动绑定到对应的属性上。

### 简单类型

* int/Integer
* short/Short
* long/Long
* float/Float
* double/Double
* boolean/Boolean
* byte/Byte
* char/Character
* BigInteger
* BigDecimal
* Date

### 枚举类型

```java
//ConverterAction.java
public class ConverterAction extends ActionSupport{
	private ColorEnum color;
	public String execute() throws Exception {
		System.out.println("color="+color);
		return SUCCESS;
	}
	public ColorEnum getColor() {
		return color;
	}
	public void setColor(ColorEnum color) {
		this.color = color;
	}
}
//枚举类型
enum ColorEnum {
	red, blue, green;
}
<!-- struts.xml -->
<action name="converterAction" class="com.ConverterAction" >
	<result name="success">/view/success.jsp</result>
</action>

//访问地址：http://localhost:8080/struts21/bb/converterAction.action?color=blue
```

### 复合类型

复合类型JavaBean、数组或List、Map。前面都已经讲过，主要差别在OGNL的表达式方面：

* JavaBean：user.account
* 数组或List：users[0].account
* Map：user['key']

### 自定义类型转换器

如果用户想在一个文本框内输入人长方形的宽和高（width:height），比如16:9，再有系统自动计算出长方形的面积，此时便需要自定义类型转换器，自行解析这个字符串了。自定义类型转换器需要继承StrutsTypeConverter抽象类，并实现convertFromString()、convertToString()方法。

**第一步：编写JavaBean和Action**

```java
//JavaBean
public class Rectangle {
	private int width;
	private int height;
	public int getWidth() {
		return width;
	}
	public void setWidth(int width) {
		this.width = width;
	}
	public int getHeight() {
		return height;
	}
	public void setHeight(int height) {
		this.height = height;
	}
}

//Action
public class ConverterAction extends ActionSupport{
	private Rectangle rectangle;

	public String execute() throws Exception {
		int value = rectangle.getWidth()*rectangle.getHeight();
		System.out.println("长方形面积为："+value);
		return SUCCESS;
	}

	public Rectangle getRectangle() {
		return rectangle;
	}

	public void setRectangle(Rectangle rectangle) {
		this.rectangle = rectangle;
	}
}

//struts.xml
<action name="converterAction" class="com.ConverterAction" >
	<result name="success">/view/success.jsp</result>
</action>
```

**第二步：编写自定义类型转换的类**

```java
public class RectangleConverter extends StrutsTypeConverter{

	//前端参数转为后端JavaBean
	//values：用户传入的参数
	//context：可以让我们获得值栈中的值
	//toClass：将要被转换成的对象类型
	@Override
	public Object convertFromString(Map context, String[] values, Class toClass) {
		String userInput = values[0];
		String[] arr = userInput.split(":");
		
		//在真正的格式转化之前，先把所有的用户属性可能的错误拦截住
		if(arr.length!=2) {
			throw new TypeConversionException("请输入正确的长方形格式，如16:9");
		}
		try {
			Rectangle rectangle = new Rectangle();
			int width = Integer.parseInt(arr[0]);
			int height = Integer.parseInt(arr[1]);
			rectangle.setWidth(width);
			rectangle.setHeight(height);
			return rectangle;
		} catch (RuntimeException e) {
			throw new TypeConversionException("请输入正确的长方形格式，如16:9", e);
		}
	}

	//后端JavaBean转为前端String
	//context：可以让我们获得值栈中的值
	//需要被转换的对象
	@Override
	public String convertToString(Map context, Object o) {
		Rectangle rectangle = (Rectangle)o;
		//最终写入到值栈中的值，页面上使用<s:property value="rectangle"/>来引用
		return "长方形：宽="+rectangle.getWidth()+",高="+rectangle.getHeight();
	}
}
```

**第三步：注册自定义转换类**

```properties
//在src目录下创建一个名为xwork-conversion.properties的文件，内容为
com.Rectangle=com.RectangleConverter
```

**第四步：编写页面，OGNL表达式直接使用rectangle**

```jsp
<!-- register.jsp -->
<body>
<%@ taglib prefix="s" uri="/struts-tags"%>
长方形
<br>
<s:form action="/bb/converterAction.action" method="post">
	<s:textfield name="rectangle" label="输入宽和高" />
	<s:submit value="提交"/>
</s:form>
</body>

<!-- success.jsp -->
<body>
<%@ taglib prefix="s" uri="/struts-tags"%>
<s:property value="rectangle"/>
</body>
```

上面定义的是项目全局的类型转换器，我们也可以让这个类型转换器只应用于类级别。具体做法如下：

```properties
//删除xwork-conversion.properties
//在Action所在包下创建properties文件，格式为Action名-conversion.properties
//比如ConverterAction-conversion.properties，内容为：
rectangle=com.RectangleConverter
```

## 第13章 文件上传下载

struts2在Common-FileUpload的基础上进行了封装，进一步的简化了文件上传的代码。

### 文件上传

#### 例子1：上传多个文件

```jsp
//filupload.jsp
<form Action="../bb/uploadAction.action" method="post" enctype="multipart/form-data">
	文件：<input type="file" name="myFile" /> <br>
	文件：<input type="file" name="myFile" /> <br>
	文件：<input type="file" name="myFile" /> <br>
	文件：<input type="file" name="myFile" /> <br>
	<input type="submit" value="提交" />
</form>

//success.jsp
<body>
<%@ taglib prefix="s" uri="/struts-tags"%>
成功上传文件：<s:property value="myFileFileName"/>
</body>
```

```java
//action
public class UploadAction extends ActionSupport{
	private File[] myFile;
	private String[] myFileFileName;
	//省略getter/setter
	public String execute() throws Exception {
		OutputStream output = null;
		InputStream input = null;
		try {
			for(int i=0; i<myFileFileName.length; i++) {
				//filetemp文件夹必须提前创建好
				output = new FileOutputStream("e:/filetemp/"+myFileFileName[i]);
				//建议1kb大小的缓冲区
				byte[] bs = new byte[1024];
				//将上传过来的文件输出到output中
				input = new FileInputStream(myFile[i]);
				int length = 0;
				while((length=input.read(bs)) >0) {
					output.write(bs, 0, length);
				}
			}
		} finally {
			input.close();
			output.close();
		}
		return SUCCESS;
	}
}

//struts.xml
<action name="uploadAction" class="com.UploadAction">
	<result>/view/success.jsp</result>
</action>
```

#### 例子2：获取文件的信息

struts2预定义了3个文件上传相关的属性，让我们可以直接获取文件的相关信息，

```java
//假设前端表单中定义的input标签为名为xyz。
<input type="file" name="xyz" />

//则在action中可以直接定义下面三个属性
private File myFile; //上传的文件本身
private String myFileFileName; //上传文件的文件名称
private String myFileContentType; //文件的类型

//如果上传多个文件，则改为数组类型
private File[] myFile;
private String[] myFileFileName;
private String[] myFileContentType;
```

#### 例子3：限制文件大小和类型

我们可以通过设置fileUpload拦截器的参数来进行这方便的限制。因为defaultStack已经默认引用了fileUpload拦截器，因此我们需要像下面这样配置拦截器。fileUpload有三个参数可配置：

* allowedTypes：指定允许上传的文件的类型，多种类型用逗号隔开。注意，这里配置的不是文件的扩展名，而是对应的contentType，如果不知道某种文件的contentType可以先上传一下试试，在后台打印出来。
* maximumSize：指定允许上传的文件的最大字节数。单位是字节byte。
* allowedExtensions：指定允许上传的文件的扩展名。多个扩展名有逗号隔开。

如果上传的文件不满足以上的参数条件，就会跳转到input页面，所以一般会在input页面上使用`<s:fielderror />`打印错误信息。

```xml
//struts.xml
<action name="uploadAction" class="com.UploadAction">
<interceptor-ref name="fileUpload">
	<!-- 只能上传word文件 -->
	<param name="allowedTypes">application/msword,application/vnd.openxmlformats-officedocument.wordprocessingml.document</param>
	<param name="maximumSize">200*1024</param><!-- 最大200kb -->
	<param name="allowedExtensions">doc,docx</param><!-- 指定允许上传的文件扩展名 -->
</interceptor-ref>
<interceptor-ref name="defaultStack" />
	<result name="success">/view/success.jsp</result>
	<result name="input">/view/fileupload.jsp</result>
</action>
```

```jsp
<!-- fileupload.jsp -->
<body>
<%@ taglib prefix="s" uri="/struts-tags"%>
<s:fielderror />
<form Action="../bb/uploadAction.action" method="post" enctype="multipart/form-data">
	文件：<input type="file" name="myFile" /> <br>
	文件：<input type="file" name="myFile" /> <br>
	文件：<input type="file" name="myFile" /> <br>
	文件：<input type="file" name="myFile" /> <br>
	<input type="submit" value="提交" />
</form>
</body>
```

#### 例子4：上传大文件

struts2默认支持的单个上传文件最大为2097152字节。这是在Struts2-core-2.1.8.1.jar文件中的`org\apache\Struts2`文件夹下的default.properties文件中定义的。我们可以在struts.xml文件中覆盖这个默认值。

```xml
<!--
struts.xml
单个上传文件最大为10MB=1024*1024*10 
-->
<constant name="struts.multipart.maxSize" value="10485760"></constant>
```

### 文件下载

使用struts2来实现文件下载，会用到它的stream类型的result。

* 文件下载的Action无需实现execute方法，只需要提供`public InputStream getInputStream()`方法即可。
* 在struts.xml中配合result类型为stream，然后设置相关参数。

result中可配置的参数如下，最常用的是 contentDisposition来制定默认的文件下载名，其他的使用默认即可。

* contentType：下载文件的类型
* contentLength：下载文件的长度，用于浏览器的进度条显示
* tentDisposition：指定文件下载的默认名字，如果不指定则使用Action名.action
* inputName：Action中用于返回InputStream的get方法的名字，默认为inputStream。因此用户的Action中定义了getInputStream方法。
* bufferSize：缓冲区大小，默认为1KB
* allowCaching：是否允许浏览器进行缓存。
* contentCharSet：HTTP响应头信息中的编码格式。

```java
//Action
public class DownloadAction extends ActionSupport{
	
	public InputStream getInputStream() throws Exception {
		File file = new File("e:/filetemp/myfile.doc");
		return new FileInputStream(file);
	}
}

//struts.xml
<action name="downloadAction" class="com.DownloadAction">
	<result type="stream">
		<param name="contentDisposition">attachment;filename="rename.doc"</param>
	</result>
</action>
          
//download.jsp
<body>
	<a href="../bb/downloadAction.action">文件下载</a>
</body>
```

#### 重命名的三种方式

**方法一：像上面一样通过在contentDisposition参数中写死**

```xml
<action name="downloadAction" class="com.DownloadAction">
	<result type="stream">
		<param name="contentDisposition">attachment;filename="rename.doc"</param>
	</result>
</action>
```

**方法二：在contentDisposition参数中通过OGNL表达式引用方法返回值**

```java
//在action中定义一个新方法，用于返回文件名
public String getDownloadFileName() {
	return "rename.doc";
}

//在struts.xml中引用这个方法，注意OGNL表达式的名称对应
<action name="downloadAction" class="com.DownloadAction">
	<result type="stream" >
		<param name="contentDisposition">attachment;filename=${downloadFileName}</param>
	</result>
</action>
```

**方法三：直接定义一个getContentDisposition()方法，无需contentDisposition参数**

```java
//action
public String getContentDisposition() {
	return "attachment;filename=\"rename.doc\""; //转义字符""
}

//struts.xml，无需contentDisposition属性
<action name="downloadAction" class="com.DownloadAction">
	<result type="stream" >
	</result>
</action>
```

#### 中文文件名

```java
public String getContentDisposition() throws UnsupportedEncodingException {
	String rename = new String("中文名".getBytes("UTF-8"), "ISO8859-1");
	return "attachment;filename=\""+rename+".doc\""; //转义字符"";
}
```

## 第15章 整合spring

Spring解决了Action依赖于逻辑层的问题，如果不使用spring，我们只能在Action中显式地new创建Service层。如果使用了spring，则action不再依赖于service层的具体实现类，只需只有service的接口即可，spring会为我们管理action与service具体实现类的关系，并在合适的时候注入实现类对象。

```java
public String execute() throws Exception {
	ServiceInterface service = new ServiceImpl(); //依赖于具体的服务层实现类，不好
	String id = service.getUserId();
	return SUCCESS;
}
```

下面就开始把spring正和岛struts2中，为struts2提供依赖注入的功能。这里以spring2.5.6为例：

**第一步：导入jar包**

* spring-beans.jar
* spring-context.jar
* spring-core.jar
* spring-test.jar
* spring-web.jar
* commons-logging-1.0.4.jar （在struts2中）
* struts2-spring-plugin-2.1.8.jar （在struts2中）

**第二步：编写Action、服务层接口、服务层实现类**

```java
//服务层接口
public interface SampleService {
	public String getNameById(String userId);
}

//服务层实现类
public class SampleServiceImpl implements SampleService{
	@Override
	public String getNameById(String userId) {
		String name = "hello,"+userId;
		return name;
	}
}

//action
public class SampleAction extends ActionSupport{
	private SampleService service;
	private String name;
	private String userId;
	
	//省略getter/setter
	public SampleService getService() {
		return service;
	}

	public void setService(SampleService service) {
		this.service = service;
	}
	
	public String execute() throws Exception {
		name = this.service.getNameById(userId);
		return SUCCESS;
	}
}

//success.jsp
<body>
<%@ taglib prefix="s" uri="/struts-tags" %>
欢迎你：<s:property value="name"/>
</body>
```

**第三步：编写spring配置文件applicationContext.xml,放在src目录下**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
		xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
		xsi:schemaLocation="
			http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans-2.5.xsd">

	<bean name="service" class="com.SampleServiceImpl" />
	<bean name="sampleAction" class="com.SampleAction" scope="prototype" autowire="byName" />
</beans>
```

**第四步：在web.xml中引入spring**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns="http://java.sun.com/xml/ns/javaee"
	xsi:schemaLocation="http://java.sun.com/xml/ns/javaee http://java.sun.com/xml/ns/javaee/web-app_2_5.xsd"
	id="WebApp_ID" version="2.5">
  
  <!-- 引入spring -->
	<context-param>
		<param-name>contextConfigLocation</param-name>
		<param-value>classpath*:applicationContext.xml</param-value>
	</context-param>
	<listener>
		<listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>
	</listener>

	<filter>
		<filter-name>struts2</filter-name>
		<filter-class>org.apache.struts2.dispatcher.FilterDispatcher</filter-class>
	</filter>
	<filter-mapping>
		<filter-name>struts2</filter-name>
		<url-pattern>/*</url-pattern>
	</filter-mapping>
</web-app>
```

**第五步：修改struts.xml文件，让struts2通过spring来获取Action、Service对象**

```xml
<constant name="struts.objectFactory" value="spring" />

<action name="sampleAction" class="sampleAction">
	<result name="success">/view/success.jsp</result>
</action>
```

## 第17章：防止重复提交

防止重复提交表单只需两步：

**第一步：配置 <s:token />标签**

```jsp
//login.jsp
<form action="../bb/helloWorldAction.action" method="post">
	<s:token />
	账号：<input type="text" name="um.account" /> <br>
	密码：<input type="password" name="um.password" /> <br>
	<input type="submit" value="提交" />
</form>
```

**第二步：配置tokenSession拦截器**

```xml
<!-- struts.xml -->
<action name="helloWorldAction" class="com.HelloWorldAction">
	<interceptor-ref name="tokenSession" />
	<interceptor-ref name="defaultStack" />
	<result name="toWelcome">/view/welcome.jsp</result>
	<result name="other">/view/other.jsp</result>
</action>
```







