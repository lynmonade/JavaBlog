# SpringMVC Case

## Case 1:标准Form+基础数据映射

```java
//showForm.jsp
<form action="user/handleForm" method="POST">
    报表名称：<input type="text" name="reportName"/> <br/>
    单位名称：<input type="text" name="deptName"/> <br/>
    用户名称：<input type="text" name="userName"/> <br/>
    <input type="submit" value="提交" />
</form>

//POJO
public class Report {
	private String reportName;
	private String deptName;
	private String userName;
    //getter/setter
}

//Controller.java
@RequestMapping("/showForm")
public String showForm() {
	return "register/showForm";
}
	
@RequestMapping("/handleForm")
public String handleForm(String reportName, String deptName, String userName) {
	System.out.println("handleForm");
	return "register/success2";
}

//success.jsp
<body>
	${report.reportName } ${report.deptName } ${report.userName }  
</body>

/*
结果：
1. 前端参数可以正确传至方法形参
2. 方法形参不会转存至视图
3. 视图无法展示数据
*/
```

## Case 2：在Case1基础上给参数加上@ModelAttribute
```java
@RequestMapping("/handleForm")
	public String handleForm(@ModelAttribute("reportName") String reportName, @ModelAttribute("deptName") String deptName, @ModelAttribute("userName") String userName) {
		System.out.println("handleForm");
		return "register/success2";
	}
/*
结果：
1. 前端参数无法传至方法形参
2. 方法形参不会转存至视图
3. 视图无法展示数据

所以，千万不要使用@ModelAttribute修饰基础数据类型。
*/
```

## Case 3：标准Form+POJO对象
```java
//只需在case1的基础上把形参改为如下形式：
@RequestMapping("/handleForm")
public String handleForm(Report report) {
	System.out.println("handleForm");
	return "register/success2";
}

/*
结果：
1. 前端参数可以正确传至方法形参
2. 方法形参自动转存至视图
3. 视图可以正常显示数据

也就是说，POJO对象作为形参时，会自动放入request域中。
*/
```

## Case 4：在Case3的基础上给POJO加上@ModelAttribute
```java
@RequestMapping("/handleForm")
public String handleForm(@ModelAttribute("report") Report report) {
	System.out.println("handleForm");
	return "register/success2";
}

/*
结果：
1. 前端参数可以正确传至方法形参
2. 方法形参自动转存至视图
3. 视图可以正常显示数据

也就是说，@ModelAttribute修饰的POJO对象，也会自动放入request域中。
*/
```

## Case 5 只使用ModelMap作为形参
```java
@RequestMapping("/handleForm")
public String handleForm(ModelMap modelMap) {
	System.out.println("handleForm");
	Report report1 = (Report)modelMap.get("report"); //null
	return "register/success2";
}

/*
结果：
1. 前端参数无法传至方法形参
2. 方法形参无法转存至视图
3. 视图可以无法显示数据

也就是说，只使用ModelMap时，SpringMVC无法帮我们封装参数至后台，因此ModelMap里面什么都没有。
*/
```

## Case 6 使用ModelMap + POJO对象作为形参
```java
@RequestMapping("/handleForm")
public String handleForm(ModelMap modelMap, Report report) {
	System.out.println("handleForm");
	Report report1 = (Report)modelMap.get("report");
	if(report1==report) {
		System.out.println("same report object"); //会执行
	}
	return "register/success2";
}
/*
结果：
1. 前端参数可以传至方法形参，同时也被封装在ModelMap中
2. 方法形参可以转存至视图（感觉是POJO的功劳）
3. 视图可以可以显示数据
*/
```

## Case 7 使用ModelMap + 基本类型参数作为形参
```java
@RequestMapping("/handleForm")
public String handleForm(ModelMap modelMap, String reportName) {
	System.out.println("handleForm");
	return "register/success2";
}
/*
结果：
1. 前端参数可以传至方法形参(reportName有值)，但参数值并未封装在ModelMap中
2. 方法形参无法转存至视图
3. 视图可以无法显示数据
*/
```



# el表达式的搜索顺序
el表达式的搜索顺序是，page, request, session, context