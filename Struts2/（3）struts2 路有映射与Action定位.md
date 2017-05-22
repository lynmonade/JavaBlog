## 先说结论

> 1. jsp要放在WEB-INF/view下面
> 2. jsp页面中一定要使用`<base href="<%=basePath%>">`，这样可以防止受到当前jsp所在路径的影响，即使jsp藏得很深都没关系！
> 3. 有了2的帮助，form的action属性就可以使用相对路径，相对于项目根目录。（也推荐使用相对路径）
> 4. 参与路径映射的包括两个地方，最终映射格式为`http://localhost:8080/projectname/packageNamespace/actionName`
>    1. **package的namespace属性：前面必须要加`/`，比如`/rbac`。今天就错在这了！**
>    2. action的name属性
> 5. URL中，action后面无需加.action
> 6. result映射页面时，必须以`/WEB-INF`开头
> 7. 无需在意`action!actionMethod`的语法，那玩意根本没用！

## 一个规范的例子

**项目结构**

* 项目包含一个UserAction类，路径是`com.lyn.rbac.user.UserAction`。UserAction包含两个action方法，`userRegister()`和`userLogin()`。
* 项目包含两个jsp页面：`WEB-INF/view/user/register.jsp`和`WEB-INF/view/index.jsp`。
* `userRegister()`用于跳转至`WEB-INF/view/user/register.jsp`。而`userLogin()`用于跳转至`WEB-INF/view/index.jsp`。
* 项目源码：

**路由跳转流程**

（1）因为jsp页面都藏在了WEB-INF下面，无法通过URL直接访问到他们，因此必须通过action进行跳转。首先访问`http://localhost:8080/dca/rbac/userRegister`访问`UserAction.userRegister()`方法，该方法使得流程跳转至`/WEB-INF/view/user/register.jsp`。

（2）在register.jsp中我们配置了`<base href="<%=basePath%>">`，因此form的action属性在使用相对路径时，都是基于项目根目录，即`http://localhost:8080/dca/`。而我们期望访问的action路径时`http://localhost:8080/dca/rbac/userRegister`，因此action属性的值是`rbac/userRegister`即可。

（3）在struts.xml中配置result映射路径时，推荐使用绝对路径，开头的/表示项目根目录，即WebRoot目录。

（4）另外再说一点，src目录下的配置文件（比如struts.xml文件），在部署时会发布到`WEB-INF/classes`目录下。

**UserAction类**

```java
public class UserAction extends ActionSupport{
	
	public String userRegister() {
		System.out.println("userRegister");
		return SUCCESS;
	}
	
	public String userLogin() {
		System.out.println("userLogin");
		return SUCCESS;
	}
}
```

**struts.xml**

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE struts PUBLIC
    "-//Apache Software Foundation//DTD Struts Configuration 2.0//EN"
    "http://struts.apache.org/dtds/struts-2.0.dtd">
<struts>
	<constant name="struts.custom.i18n.resources" value="mess_zh_CN" />
	<constant name="struts.i18n.encoding" value="UTF-8" />
  
	<!-- namespace的开头一定要加/ -->
    <!-- 注意result的路径写法 -->
	<package name="rbac" namespace="/rbac" extends="struts-default">
		<action name="userRegister" class="com.lyn.rbac.user.UserAction" method="userRegister">
			<result name="success">/WEB-INF/view/user/register.jsp</result>
		</action>
		<action name="userLogin" class="com.lyn.rbac.user.UserAction" method="userLogin">
			<result name="success">/WEB-INF/view/index.jsp</result>
		</action>
	</package>
</struts>
```

**register.jsp和index.jsp**

```jsp
// WEB-INF/view/user/register.jsp
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>My JSP 'register.jsp' starting page</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">

  </head>
  
  <body>
  this is register.jsp <br>
     <form action="rbac/userLogin" method="post">
     	<input type="submit" value="提交" />
     </form>
  </body>
</html>


//WEB-INF/view/index.jsp
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>My JSP 'index.jsp' starting page</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	
  </head>
  
  <body>
    this is index.jsp
  </body>
</html>

```

**web.xml**

```
<!-- struts2.2.1配置 -->
<filter>
	<filter-name>struts2</filter-name>
	<filter-class>org.apache.struts2.dispatcher.ng.filter.StrutsPrepareAndExecuteFilter</filter-class>
</filter>
<filter-mapping>
	<filter-name>struts2</filter-name>
	<url-pattern>/*</url-pattern>
</filter-mapping>
```









r