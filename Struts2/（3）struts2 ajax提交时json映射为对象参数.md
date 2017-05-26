# ajax提交时json映射为对象参数

ajax提交的json参数时，可以利用struts2的json插件，把json字符串映射为对象参数，这样你可以直接在action中使用对象而不是普通参数。

无论后端映射的是普通数据类型，还是对象类型，整个前后端交互流程都大致如下：

（1）用户在表单中填写数据

（2）通过第三方函数从表单中提取数据，并格式化json字符串。***注意，提交普通数据和对象数据的json字符串个是不一样的，这两天就被坑在这了！如果你前端形成的json字符串格式不正确，在struts2是没法帮你映射的，也不会有错误信息！***

```json
//普通数据类型
{"username":"admin","password":"111111111"}

//对象类型
{"user":{"username":"admin","password":"111111111"}}
```

（3）引入jar包：`struts2-json-plugin-2.2.1.jar`。用户提交数据时，struts2的json拦截器获取到json字符串，如果格式符合要求，则进行参数映射，这样你就可以在action中直接使用成员变量了。

## 注意事项

无论是映射普通数据类型、还是对象类型，都需要注意一下几点：

（1）只需引入jquery包，无需引入其他js包。

（2）需自定义一个`serializeObject()`函数，用于将form表单的参数转化为json对象。**注意，每个输入标签都必须带有name属性，**这样serializeObject()才能知道如何转化，因为json的每一项值都是用name属性值作为key的。如果不带name属性，则函数调用结果是返回一个空对象。

（3）无论是映射普通数据类型、还是对象类型，标签的name属性都不要带前缀，只需要像在处理普通类型一样即可：

```html
账号：<input type="text" name="username"/> <br>
密码：<input type="password" name="password" /><br>
```

（4）。ajax的data属性接收的是json字符串，而不是json对象。因此需要使用`JSON.stringify()`函数把`serializeObject()`j函数得到的json对象转化为json字符串

（5）**ajax函数中必须要加下列两条属性，否则struts2的json拦截器无法识别。**

```json
dataType:"json",
contentType:"application/json",
```

（6）后端的POJO类和Action类像往常一样编写即可。

（7）在struts.xml中让package不再继承于`struts-default`，而是继承于`json-default`，`json-default`是继承于`struts-default`的包，因此具备父包的全部特性，此外具备json拦截器的特性。最后再定义一个新的全局拦截器栈，包含json拦截器和defaultStack拦截器，并引用这个全局拦截器，使得拦截器对所有action都生效。

```xml
<package name="cc" extends="json-default">
	<interceptors>
		<interceptor-stack name="globalInterceptor">
			<interceptor-ref name="json"/>
			<interceptor-ref name="defaultStack"/>
		</interceptor-stack>
	</interceptors>
    <default-interceptor-ref name="globalInterceptor"/>
	<action name="login" class="com.LoginAction">
		<result name="success">/welcome.jsp</result>
	</action>
</package>
```

## 映射普通类型的参数

**login.jsp**

```html
<body>
	<form>
		账号：<input type="text" name="username"/> <br>
		密码：<input type="password" name="password" /><br>
		<input type="button" value="提交" id="btn"/>
	</form>
	<script type="text/javascript" src="jquery-1.6.2.min.js"></script>
	<script type="text/javascript">
    //自己创建一个用于解析form的函数
	$.fn.serializeObject = function(){
	    var o = {};
	    var a = this.serializeArray();
	    $.each(a, function() {
	        if (o[this.name] !== undefined) {
	            if (!o[this.name].push) {
	                o[this.name] = [o[this.name]];
	            }
	            o[this.name].push(this.value || '');
	        } else {
	            o[this.name] = this.value || '';
	        }
	    });
	    return o;
	}
	
	$("#btn").click(function() {
		var jsonString = JSON.stringify($("form").serializeObject()); //stringify()可以把json对象转为String字符串
		console.log(jsonString);
		$.ajax({
            type:"POST",
            data:jsonString, 
            url:"login.action",
            dataType:"json",
            contentType:"application/json",
            success:function() {
            }
        });
	});
	</script>
</body>
```

**LoginAction.java**

```java
public class LoginAction extends ActionSupport{
	private String username;
	private int password;
	//省略getter/setter
	
	@Override
	public String execute() throws Exception {
		System.out.println(getUsername());
		System.out.println(getPassword());
	}
}
```

**struts.xml**

```xml
<struts>
	<!-- 指定全局国际化资源文件 -->
	<constant name="struts.custom.i18n.resources" value="mess_zh_CN" />
	<!-- 指定国际化编码所使用的字符集 -->
	<constant name="struts.i18n.encoding" value="UTF-8" />

<package name="cc" extends="json-default">
	<interceptors>
		<interceptor-stack name="globalInterceptor">
			<interceptor-ref name="json"/>
			<interceptor-ref name="defaultStack"/>
		</interceptor-stack>
	</interceptors>
    <default-interceptor-ref name="globalInterceptor"/>
	<action name="login" class="com.LoginAction">
		<result name="success">/welcome.jsp</result>
	</action>
</package>
</struts>
```

## 映射对象类型的参数

**index.jsp**

```html
<body>
	<form>
		账号：<input type="text" name="username"/> <br>
		密码：<input type="password" name="password" /><br>
		<input type="button" value="提交" id="btn"/>
	</form>
	<script type="text/javascript" src="jquery-1.6.2.min.js"></script>
	<script type="text/javascript">
	
	//自己创建一个用于解析form的函数
	$.fn.serializeObject = function(){
	    var o = {};
	    var a = this.serializeArray();
	    $.each(a, function() {
	        if (o[this.name] !== undefined) {
	            if (!o[this.name].push) {
	                o[this.name] = [o[this.name]];
	            }
	            o[this.name].push(this.value || '');
	        } else {
	            o[this.name] = this.value || '';
	        }
	    });
	    return o;
	}
	
	//用于把json字符串拼接成对象形式
	function jsonStringWrapper(key, json) {
		var keyWrapper ='\"' + key + '\":';
		return "{" + keyWrapper + json + "}";
	}
	
	$("#btn").click(function() {
		var json = JSON.stringify($("form").serializeObject());
		var jsonString = jsonStringWrapper("user", json);
		console.log(jsonString);
		$.ajax({
            type:"POST",
            data:jsonString, 
            url:"login.action",
            dataType:"json",
            contentType:"application/json",
            success:function() {
            }
        });
	});
	</script>
</body>
```

**User.java和LoginAction.java**

```java
public class User {
	private String username;
	private int password;
}

public class LoginAction extends ActionSupport{
	private User user = new User();
	//省略getter/setter
	
	public String execute() throws Exception {
		System.out.println(user.getUsername());
		System.out.println(user.getPassword());
		return SUCCESS;
	}
}
```

**struts.xml**

```xml
<struts>
	<!-- 指定全局国际化资源文件 -->
	<constant name="struts.custom.i18n.resources" value="mess_zh_CN" />
	<!-- 指定国际化编码所使用的字符集 -->
	<constant name="struts.i18n.encoding" value="UTF-8" />
	
	
<package name="cc" extends="json-default">
	<interceptors>
		<interceptor-stack name="globalInterceptor">
			<interceptor-ref name="json"/>
			<interceptor-ref name="defaultStack"/>
		</interceptor-stack>
	</interceptors>
    <default-interceptor-ref name="globalInterceptor"/>
	<action name="login" class="com.LoginAction">
		<result name="success">/welcome.jsp</result>
	</action>
</package>
	
</struts>
```







