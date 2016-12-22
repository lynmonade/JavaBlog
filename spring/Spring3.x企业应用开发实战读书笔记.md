# 第三章
* IOC：控制反转，这个概念比较难理解。其实IOC等价于DI(依赖注入)。最初大家都直接在方法里new一个对象，然后使用它，这样造成了依赖和耦合。使用DI，可以把创建对象的工作交给容器(xml配置文件)，你可以在容器中配置类与类之间的关系，这样，在类代码中，你只需要用接口引用调用抽象方法就行了。说白了，就是把**对象创建和对象持有关系**搬到xml配置文件中去实现。
* 依赖注入有三种方式：
	* 构造方法注入
	* setter方法注入
	* 接口注入（很少用）
* Spring中包含了一套资源访问类和方法（Resource接口），比java自带的强大很多。
* applicationContext
* beanFactory
* java反射机制在spring中的应用

# 第四章

要使应用程序中的spring容器成功启动，需具备三个条件：

* spring框架的类包都已经放到应用程序的类路径下。
* 应用程序为spring提供完备的bean配置信息。
* bean的类都已经放到应用程序的类路径下。

bean配置信息是bean的元数据信息，它由以下4个方面组成：

* bean的实现类
* bean的属性信息：如数据源的连接数，用户名，密码
* bean的依赖关系，spring根据依赖关系配置完成bean之间的装配
* bean的行为配置，如生命周期范围及生命周期各过程的回调函数。


## bean属性
id属性必须全局唯一。推荐用id命名。

name属性不需要全局唯一，可以多个bean name相同，获取bean时，返回最后定义的bean。所以name很容易造成歧义，尽量少用。

为了减少java成员变量大小写所带来的问题，对于特殊名称，推荐使用全小写，比如：iphone，xcode。

在使用构造函数注入时，可联合使用index和type属性，精确指定所用的构造函数。

使用构造函数注入时，会出现循环依赖的问题，导致bean初始化失败，这时可以把其中一个bean改为属性注入即可解决。

工厂方法注入，说实话，用的很少，只在一些第三方类库或者旧系统中出现。

## 一些其他的东西：
* 引用其他bean：ref
* 内部bean
* null bean
* 集合形式的bean
* 级联属性配置
* 简化形式的配置格式
* P命名空间
* bean的作用域
* 

@Autowired(required=false) 表示即使找不到这个bean，也不要报spring的错误

# 15章 springMVC
## 1.1 @RequestMapping映射
@RequestMapping可以根据下列4个方面的信息，实现更加精确的请求映射：



上面的4个选项可以组合，共同来确定请求URL映射到哪个方法上。






## 1.2 方法形参签名
这一小节主要介绍如何获取前台传过来的参数。

### 1.2.1 @RequestParam
这个注解用于方法形参上，主要有两个作用：

* 映射不同名的参数：当前台传过来的参数名称与后台方法形参不一致时，可以使用这个注解进行映射匹配。
* 设置参数是否必要：通过required设置该参数是否必要，默认为true。如果为true，当获取不到该值，则抛出异常。

```java
public ModelAndView display(String username, @RequestParam(value="pwd", required=true) String password) {
    //...
}
```

或者还可以用最直接的方式，不使用@RequestParam，只要能确保前台传入的参数与方法形参名一致即可：

```java
@RequestMapping(value="/straight")
public void straight(String username, String password) {
	System.out.println("username="+username + ", password="+password);
}
```

### 1.2.2 @CookieValue
用于把cookie值绑定到方法的行参上，确保方法体内能访问cookie值：

* 和RequestParam一样，通过value对cookie名称与形参名称进行映射。
* 和RequestParam一样，通过required设置该参数是否必要，默认为true。如果为true，当获取不到该值，则抛出异常。

```java
public void myCookie(@CookieValue(value="JSESSIONID", required=false) String myCookie) {
		//...
	}
```

### 1.2.3 @RequestHeader
用于把header信息绑定到方法的形参上，确保方法体内能访问到header值：

* 和RequestParam一样，通过value对header名称与形参名称进行映射。
* 和RequestParam一样，通过required设置该参数是否必要，默认为true。如果为true，当获取不到该值，则抛出异常

```java
public void getInfo(@RequestHeader("Accept-Language") String acceptLanguage) {
	//...
}
```

### 1.2.4 使用命令对象/表单对象绑定请求参数值
所谓命令对象/表单对象就是不需要实现任何接口，仅是一个拥有若干属性的POJO。比如下面的Employee就是命令对象，SpringMVC会按请求参数名与命令对象属性名匹配的方式，自动为该对象填充属性值，并支持级联属性。

```java
//POJO命令对象
//一定要有getter/setter，不然SpringMVC无法填充属性值
public class Employee {
	private String emid; 
	private String emname;
	private Department dept;
    //getter/setter
}

public class Department {
	private String deptid;
	private Address address;
    //getter/setter
} 

public class Address {
	private String zoneid;
    //getter/setter	
}

//Controller
@Controller
@RequestMapping(value="/employee")
public class EmployeeController {

	@RequestMapping(value="/getinfo")
	public void getInfo(Employee employee) {
		//...
	}
}
//访问地址：http://localhost:8080/springself/employee/getinfo?emid=emid123&dept.deptid=deptid456&dept.address.zoneid=zoneid789
```

### 1.2.5 使用Servlet API作为入参
```java
@RequestMapping("/oldway")
public void oldWay(HttpServletRequest req, HttpSession session) {
	req.getParameter("username").toString();
	req.getParameter("password").toString();
	session.setAttribute("realname", "roger");
}
```

在org.springframework.web.context.request包中定义了若干个可代理Servlet原生API类的接口，比如WebRequest和NativeWebRequest。他们也可以作为方法入参，通过这些代理类可访问请求对象的任何信息。

### 1.2.6 使用io对象作为入参
SpringMVC还可以使用inputStream/Reader，OutputSream/Writer作为入参，让开发者自行输出结果。

```java
public void ioMethod(OutputStream out) {
    //...
}
```

### 1.2.7 @PathVariable形式形参
@PathVariabe可以把Ant风格的URL中的参数，映射到方法形参中。

```java
@Controller
@RequestMapping("/companyid/{companyid}")
public class CompanyController {
	
	@RequestMapping("/userid/{userid}")
	public void employee(@PathVariable String companyid, @PathVariable String userid) {
		//...
	}
}
```

### 1.2.8 @ModelAttribute
@ModelAttribute可以修饰方法本身，可以修饰方法形参。

修饰方法时表示：SpringMVC在调用目标方法前，先调用目标Controller中，所有在方法级上标注了@ModelAttribute的方法（方法按照定义从上到下依次调用）。

修饰方法形参表示：SpringMVC先从方法级的@ModelAttribute获取参数A，（根据@ModelAttribute属性名进行匹配），接着再获取前端传入的参数B，然后把参数A和参数B整合成一个统一的参数对象。最终SpringMVC会把整合好的对象转存到视图上下文中并暴露给视图对象。这样就能在视图中使用该数据模型了。（其实就是调用ServletRequest.setAttribute(name, value);）。

```java
//Model
public class Student {
	private String studentId;
	private String studentName;
	private String studentTele;
	//getter,setter
}

@Controller
@RequestMapping(value="/student)
public class StudentController {
    
    @ModelAttribute("user") 
	public User handle50() {
		User user = new User();
		user.setUsername("abc");
		return user;
	}
	
	@ModelAttribute("student")
	public Student handle51() {
		Student student = new Student();
		student.setStudentName("roger");
		return student;
	}
	
	@RequestMapping("/handle52")
	public String handle52(@ModelAttribute("student") Student student) {
		student.setStudentTele("133");
		return "student"
	}
	
//student.jsp
<body>
    ${student.studentId} ${student.studentName} ${student.studentTele} 
</body>

/*
访问地址：http://localhost:8080/springself/student/handle52?studentId=111
执行顺序：handle50, handle51, handle52
在student.jsp会显示：studentId=111, studentName=roger, studentTele=133
*/
}

```

**注**
Controller方法的入参只能使用一个SpringMVC注解，如果使用两个，SpringMVC会报错。

## 1.3 HttpMessageConverter
前面的例子都是往服务端提交表单文本数据。当我们需要往服务端提交特殊的数据（比如二进制数据，上传图片），或者服务端向前端输出特殊数据（比如二进制数据，下载文件），这是就需要使用HttpMessageConverter。

* 当前端提交了数据后，SpringMVC会根据请求头的Accept属性，使用匹配的HttpMessageConverter子类，对http请求体中的数据进行封装，转化成controller方法形参所要求的数据类型。这样我们就可以在controller方法中使用提交的数据。
* 当服务端返回数据时，SpringMVC会根据响应头的Accept属性，使用匹配的HttpMessageConverter子类，对http响应体中的数据进行封装，转化成controller方法返回值所要求的数据类型。这样我们就可以往响应中写入一些特殊的数据，比如二进制、xml、json数据。







