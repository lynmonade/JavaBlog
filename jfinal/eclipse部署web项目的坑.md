#eclipse部署web项目的坑
1. 首先我们在eclipse要创建的是Dynamic Web Project，在Default output folder处，最好改为WebRoot\WEB-INF\classes，这样，编译后的class文件就会放在该目录下。
2. 自己在WebRoot\WEB-INF\目录下新建一个lib目录，然后把外部需要引用的jar都拷贝进去，最后在properties-->Java Build Path那里把这些外部jar都添加进来。
3. 检查Web Project Settings下的Context root的名称，必须与项目名保持一致。对于复制过来的项目，经常会出现项目名称与Context root名称不一致的情况，如果不一致，就会导致项目部署到tomcat时，项目名称与工程名称不一致，你就无法在浏览器URL中引用项目名称了。
4. 检查Properties-->Project Facets，确保勾选了Java，JavaScript，Dynamic Web Module。
5. 打开Properties-->Deployment Assembly，把lib下的jar包都添加进来，这样在部署到tomcat时，才会把jar包一起部署过去。
6. 最后，你就可以创建一个基于tomcat6的server，把项目部署进去了。

**如果你部署的是jfinal的项目，请遵照下面的步骤：**

**第一步：在项目中引入JFinal必要的jar包**

**第二步：添加log4j.properties文件到src目录下**

**第三步：创建一个JFinalConfig的子类和一个Controller的子类**

```java
public class ProjectConfig extends JFinalConfig{
	@Override
	public void configConstant(Constants me) {
		me.setDevMode(true);
		me.setViewType(ViewType.JSP);	
	}
	@Override
	public void configRoute(Routes me) {
		me.add("/hello", MyController.class);
	}
    @Override
	public void configRoute(Routes me) {
		me.add("/hello", MyController.class);
	}
	@Override
	public void configPlugin(Plugins me) {}
	@Override
	public void configInterceptor(Interceptors me) {}
	@Override
	public void configHandler(Handlers me) {}
}

public class FirstController extends Controller{
    //http://localhost:8080/myjfinal/hello/index
    //或者 http://localhost:8080/myjfinal/hello
	public void index() {
		System.out.println("invoke FirstController index");
	}
  
    //http://localhost:8080/myjfinal/hello/method
	public void method() {
		System.out.println("invoke FirstController Method");
	}
}

/*格式：
http://localhost:8080/项目名称/controller别名/method原名（别名）
*/
```

**第四步：修改web.xml文件，让JFinal拦截所有请求**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns="http://java.sun.com/xml/ns/javaee" xmlns:web="http://java.sun.com/xml/ns/javaee/web-app_2_5.xsd"
	xsi:schemaLocation="http://java.sun.com/xml/ns/javaee http://java.sun.com/xml/ns/javaee/web-app_2_5.xsd"
	id="WebApp_ID" version="2.5">
	
	<display-name>jfinal framework</display-name>
	<filter>
		<filter-name>jfinal</filter-name>
		<filter-class>com.jfinal.core.JFinalFilter</filter-class>
		<init-param>
			<param-name>configClass</param-name>
			<param-value>com.project.config.ProjectConfig</param-value>
		</init-param>
	</filter>
	
	<filter-mapping>
		<filter-name>jfinal</filter-name>
		<url-pattern>/*</url-pattern>
	</filter-mapping>
</web-app>
```

部署到tomcat并开启tomcat，假设项目名称是myjfinal，则使用如下两个地址访问action：

```java
http://localhost:8080/myjfinal/hello/index
http://localhost:8080/myjfinal/hello/method
```





