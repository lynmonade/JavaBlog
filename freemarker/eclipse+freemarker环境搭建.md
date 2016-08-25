#eclipse安装freemarker插件
第一步，下载freemarker插件：[下载地址](https://sourceforge.net/projects/freemarker-ide/files/)。由于该插件的freemarker jar包版本很旧，所以需要手动更新jar包版本。先解压出来：

1. 用新版freemarker jar包替换里面的freemarker-2.3.6.jar包。（我用的是freemarker-2.3.20.jar）
2. 修改\META-INF\MANIFEST.MF文件，修改引用的freemarker jar包名称。
3. 把hudson.freemarker_ide_0.9.14文件夹放到eclipse\plugins\文件夹下。
4. 重启eclipse即可。可以在Preferences -> General –> Editors –> File Associations下修改ftl文件对应的编辑器。

#一个最简单的freemarker例子：基于JFinal
在eclipse中新建一个dynamic web project，名为jfreemarker。接着引入freemarker-2.3.20.jar、jfinal-2.2-bin-with-src.jar、log4j-1.2.16.jar三个jar包。

修改web.xml文件：

```java
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://java.sun.com/xml/ns/javaee" xmlns:web="http://java.sun.com/xml/ns/javaee/web-app_2_5.xsd" xsi:schemaLocation="http://java.sun.com/xml/ns/javaee http://java.sun.com/xml/ns/javaee/web-app_2_5.xsd" id="WebApp_ID" version="2.5">
  <filter>
    <filter-name>jfinal</filter-name>
    <filter-class>com.jfinal.core.JFinalFilter</filter-class>
    <init-param>
      <param-name>configClass</param-name>
      <param-value>com.blit.ProjectConfig</param-value>
    </init-param>
  </filter>
  <filter-mapping>
    <filter-name>jfinal</filter-name>
    <url-pattern>/*</url-pattern>
  </filter-mapping>
</web-app>
```

新建ProjectConfig类，用于配置JFinal的基本信息：

```java
package com.blit;

import com.jfinal.config.Constants;
import com.jfinal.config.Handlers;
import com.jfinal.config.Interceptors;
import com.jfinal.config.JFinalConfig;
import com.jfinal.config.Plugins;
import com.jfinal.config.Routes;
import com.jfinal.render.ViewType;

public class ProjectConfig extends JFinalConfig {

	@Override
	public void configConstant(Constants me) {
		me.setDevMode(true);
		me.setViewType(ViewType.FREE_MARKER);

	}

	@Override
	public void configRoute(Routes me) {
		me.add("/test", IndexController.class);
	}

	@Override
	public void configPlugin(Plugins me) {
		// TODO Auto-generated method stub

	}

	@Override
	public void configInterceptor(Interceptors me) {
		// TODO Auto-generated method stub

	}

	@Override
	public void configHandler(Handlers me) {
		// TODO Auto-generated method stub

	}
}

```

新建IndexController类，用于编写业务逻辑。

```java
package com.blit;

import com.jfinal.core.Controller;

public class IndexController extends Controller {
	
	public void index() {
		setAttr("key", "lyn"); //request.setAttrite(key value);
		render("/page/root.ftl"); //请求转发至freemaker模板
	}
}

```

在WebRoot新建一个page文件夹，并在里面创建文件root.ftl，这个就是freemaker模板文件。

```html
<html>
<head>
<body>
	<span>the value is ${key}</span>
</body>
</head>
</html>
```

最后，启动tomcat，并访问地址：http://localhost:8080/jfreemarker/test。界面上就会西那是the value is lyn。
