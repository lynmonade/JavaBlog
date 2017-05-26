# 登录验证（struts2+ajax+json错误信息返回）

**需求场景**

用户输入账号密码进行登录。这里不使用表单的action提交，而是通过button的click方法拦截提交，并对提交参数进行前端JS验证。如果验证失败，则在标签中插入失败信息进行提示。如果验证成功，则通过jquery的ajax函数进行异步提交。

提交的数据在前端会先封装成json字符串，在后端通过struts2的json拦截器，把json字符串映射为Action中的User对象。

在Action中我们需要定义一个字段用于存储后端验证失败的错误信息。无论验证成功还是失败，在前端都会跳转到ajax的success函数中进行回调处理。

**后端是否验证成功的判断标志位是后端是否把错误信息写入到json作为返回数据**：如果后端验证成功，则后端无需返回任何数据和信息，也不用去映射任何result，只需在success回调函数中直接把window.location指向登录后的首页。

如果验证失败，则需要把错误信息写入到Action的message成员变量中，并通过reusult映射struts.xml中映射对应的result。struts2的json拦截器会自动把json数据放入到success回调函数中的data参数中。在success回调函数中只需判断data是否为空。如果data不为空，则表明包含错误信息，此时只需data.error获取错误信息，再用jquery.text()把错误信息写入到标签中即可。

**login.jsp**

```jsp
<body>
	<div id="loginWindow" class="mini-window" title="用户登录"
		style="width:360px;height:165px;" showModal="true"
		showCloseButton="false">

		<div id="loginForm" style="padding:15px;padding-top:10px;">
			<table>
				<tr>
					<td><label for="username$text">帐号：</label></td>
					<td><input name="username" errorMode="none"
						onvalidation="onUserNameValidation" class="mini-textbox" />
					</td>
					<td id="username_error" class="errorText"></td>
				</tr>
				<tr>
					<td><label for="pwd$text">密码：</label></td>
					<td><input name="password" errorMode="none"
						onvalidation="onPwdValidation" class="mini-password" /></td>
					<td id="pwd_error" class="errorText"></td>
				</tr>
				<tr>
					<td></td>
					<td style="padding-top:5px;"><a onclick="onLoginClick"
						class="mini-button" style="width:50px;">登录</a> <a
						onclick="onRegisterClick" class="mini-button" style="width:50px;">注册</a>
					</td>
				</tr>
			</table>
		</div>

	</div>

	<script type="text/javascript">
	mini.parse();
	
	var isAdmin = false;
	
    var loginWindow = mini.get("loginWindow");
    loginWindow.show();
    
	//用于把json字符串拼接成对象形式
	function jsonStringWrapper(key, json) {
		var keyWrapper ='\"' + key + '\":';
		return "{" + keyWrapper + json + "}";
	}

    function onLoginClick(e) {
        var form = new mini.Form("#loginWindow");
        form.validate();
        if (form.isValid() == false) return;

        var data = form.getData();
        var json = mini.encode(data);
        console.log(json);
        var jsonString = jsonStringWrapper("voUser", json);
        console.log(jsonString);
        $.ajax({
            type:"POST",
            data:jsonString,
            url:"rbac/userLogin",
            dataType:"json",
            contentType:"application/json",
            success:function(data,textStatus) {
            	console.log(data);
            	console.log(textStatus);
            	if(data!=null) { //验证失败
            		$("#username_error").text(data.error);
            	}
            	else { //登录成功
                	loginWindow.hide();
                    mini.loading("登录成功，马上转到系统...", "登录成功");
                    setTimeout(function () {
                        window.location = "rbac/indexView";
                    }, 1500);
            	}
            	
            }
        });

             
    }
    
    /////////////////////////////////////
    function isEmail(s) {
        if (s.search(/^\w+((-\w+)|(\.\w+))*\@[A-Za-z0-9]+((\.|-)[A-Za-z0-9]+)*\.[A-Za-z0-9]+$/) != -1)
            return true;
        else
            return false;
    }
    function onUserNameValidation(e) {
        if (e.isValid) {
        	if(e.value=='admin') {
        		isAdmin = true;
        		e.isValid = true;
        	}
        	else if (isEmail(e.value) == false) {
                e.errorText = "必须输入邮件地址";
                e.isValid = false;
            }
        	else {
        		e.errorText = "系统异常，请联系管理员";
        		e.isValid = false;
        	}
        }
        updateError(e);
    }
    function onPwdValidation(e) {
        if (e.isValid) {
        	if(isAdmin==true) {
        		if(e.value.length>0) {
        			e.isValid = true;
        		}
        	}
        	else if (e.value.length < 2) {
                e.errorText = "密码不能少于3个字符";
                e.isValid = false;
            }
        	else {
        		e.errorText = "系统异常，请联系管理员";
        		e.isValid = false;
        	}
        }
        updateError(e);
    }
    
    function updateError(e) {
        var id = "#"+e.sender.name + "_error";
        var el = $(id);
        if(el) {
        	el.text(e.errorText); 
        }
    }
    </script>

</body>
```

**UserAction.java**

```java
public class UserAction extends ActionSupport{
	private VOUser voUser = new VOUser();
	private Map message = new HashMap();
	//省略getter/setter
	public String userLogin() {
		if(voUser.getUsername().equals("admin") && voUser.getPassword().equals("1")) {
			System.out.println("userLogin:登录成功");
			return null;
		}
		else {
			message.put("error", "账号或密码错误");
			return ERROR;
		}
	}
}
```

**struts.xml**

```xml
<package name="rbac" namespace="/rbac" extends="json-default">
	<!--全局拦截器 -->
	<interceptors>
		<interceptor-stack name="globalInterceptor">
			<interceptor-ref name="json"></interceptor-ref>
			<interceptor-ref name="defaultStack"></interceptor-ref>
		</interceptor-stack>
	</interceptors>
	<default-interceptor-ref name="globalInterceptor" />
	<action name="userLogin" class="com.lyn.rbac.user.action.UserAction"
		method="userLogin">
		<result name="error" type="json" >
		<!-- 因为UserLogin有多个成员变量，所以需设置root，表明只把这个成员变量作为json数据返回 -->
			<param name="root">message</param>
		</result>
	</action>
</package>
```

