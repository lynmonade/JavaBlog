##web.xml配置
```xml
<servlet>
    <!--用于路由映射-->
    <servlet-name>MyServlet</servlet-name>
    <servlet-class>com.lyn.MyServlet</servlet-class>
    
    <!--servlet初始化参数-->
    <init-param>
        <param-name>debug</param-name>
        <param-value>0</param-value>
    </init-param>
    <init-param>
        <param-name>listings</param-name>
        <param-value>false</param-value>
    </init-param>
    
    <!--servlet加载时机:0表示项目启动时就创建servlet-->
    <load-on-startup>0</load-on-startup>
</servlet>

<!--用于路由映射-->
<servlet-mapping>
    <servlet-name>MyServlet</servlet-name>
    <url-pattern>/print</url-pattern>
</servlet-mapping>
```


##servlet常用方法
```Java
//获取ServletConfig对象
this.getServletConfig();

//获得ServletContext对象
this.getServletContext();

//获取servlet初始化参数
this.getServletConfig().getInitParameter("debug");

//获取servlet名称
/*
因为GenericServlet也实现了ServletConfig接口中的getServletName方法，这样可以简化操作。
*/
this.getServletConfig().getServletName(); //或者
this.getServletName();
```

