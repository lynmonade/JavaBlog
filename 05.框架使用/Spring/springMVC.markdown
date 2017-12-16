#SpringMVC

## 1. URL映射
1. 根据“请求url地址”：aaa/bbb
2. 根据“请求方法类型”：get、post
3. 根据“传入的参数”：userid、username
4. 根据“请求头信息”：header、cookie


## 1.1 根据请求url地址

`@RequestMapping(value="/getinfo")`。我们可以在class和method位置设置请求URL地址，具体来说有以下两种映射方式，推荐在class和method处都设置mappinng地址：

```java
//1.在class和method都定义映射路径，此时最终路径是：
http://localhost:8080/webprojectname/classrouter/methodrouter

@Controller
@RequestMapping(value="/user")
public class UserController {

	@RequestMapping("/mymethod")
	public void myMethod() {
		System.out.println("myMethod");
	}
}
//访问地址：
http://localhost:8080/springmvc/user/mymethod

//2. 仅在method定义映射路径，则此是相对于webprojectname目录:
http://localhost:8080/webprojectname/methodrouter

@Controller
public class ObjectController {
	
	@RequestMapping("/print")
	public void print() {
		System.out.println("objectController print");
	}
}
```

**Ant风格的地址**

另外，URL地址也支持Ant风格的地址，这样的风格比较贴近Restful。

1. ?    匹配任何单字符
2. \*   匹配0或者任意数量的字符
3. \*\* 匹配0或者更多的目录

```java
@Controller
@RequestMapping("/companyid/{companyid}")
public class CompanyController {
	
	@RequestMapping("/userid/{userid}")
	public void employee(@PathVariable String companyid, @PathVariable String userid) {
		System.out.println(companyid); //blit
		System.out.println(userid); //lyn
	}
}

//访问地址:http://localhost:8080/springself/companyid/blit/userid/lyn
```

### 1.2 根据请求方法类型
* `@RequestMapping(method=RequestMethod.GET)`:仅匹配get类型。
* `@RequestMapping(method=RequestMethod.POST)`:仅匹配post类型。

## 1.3 根据传入的参数
params表示使用参数进行映射。它支持简单的表达式，比如：`params="userid"`表示url参数必须含有userid，`params!="userid"`表示url参数不能含有userid。

```java
@Controller
@RequestMapping("/my")
public class MyController {
	
	@RequestMapping(value="/myfunc", method=RequestMethod.GET, params="userid", headers="text/*")
	public void myFunc(String userid) {
		System.out.println(userid);
	}
}
```

### 1.4 请求头信息
`@RequestMapping(headers="content-type=text/*")`:只对特定的header进行匹配。

### 2. 获取参数
1. 使用基础数据类型直接映射（@RequestParam）
2. 使用POJO对象/命令对象/表单对象绑定请求参数值（推荐）
3. 使用Servlet API作为入参

### 3. 输出参数至视图
1. 使用ModelAndView
2. 使用@ModelAttribute + POJO对象
3. 使用ModelMap/Map + POJO对象
4. 使用@SessionAttribute + POJO对象

###3.1 输出参数至视图小结：例子详见SpringMVC Case.md
1. 推荐使用POJO作为形参，它会自动放入request域中，前台可以访问到。
2. 推荐使用@ModelAttribute修饰的POJO对象作为形参，它会自动放入request域中，前台可以访问到。
2. 推荐使用ModelAndView，逻辑表达很清晰。
3. 不建议使用ModelMap。
4. 不建议使用基本类型参数。
