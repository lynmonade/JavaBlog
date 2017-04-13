JFinal和shiro

## JFinal的render路径配置
我们把jsp文件放在WEB-INF/view文件夹下。

```
//第一种方式：使用绝对路径，在controller中直接：
render("/WEB-INF/view/login.jsp");

//第二种方式：使用相对路径，则需要先设置baseViewPath：
public void configConstant(Constants me) {		
    me.setBaseViewPath("/WEB-INF/view");
}	
//然后在controller中：
render("login.jsp");

//绝对路径的优先级比baseViewPath的优先级更高，当我们设置了BaseViewPath，同时又使用绝对路径定位view时，baseViewPath将失效，并以绝对路径为准。
```

form表单提交与ajax提交的区别