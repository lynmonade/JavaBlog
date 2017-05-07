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

### 例子：更强大logger拦截器



### 例子：登录检查拦截器



