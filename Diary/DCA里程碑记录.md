# V0.1 

搭建了struts2的环境，并解决了URL映射的问题。（错误在于package的namespace属性没有以`/`开头）。

# V0.2

实现了如下功能：

1. 加入了miniui，并使用miniui开发了登录、主页页面。
2. 实现前端输入校验，并把校验结果写入到预留好的标签中。
3. **使用ajax进行登录数据提交，登录数据转换为json格式，并用struts2把前端的json数据映射为后端的对象类型参数。**
4. 前端表单数据转为json的方式，目前是自己编写函数，期望日后能找到第三方库。
5. 实现后端校验，并把校验结果写入到json中返回给ajax的success()回调函数，在回调函数把校验结果写入到预留好的标签中。
6. 登录成功后，通过window.location重定向到首页。
7. 登录过程融入了JJWT，当用户名/密码验证成功后，在userLogin()中创建token，并把token写入cookie返回给浏览器。
8. 通过创建全局的token拦截器，在用户请求到来之前，先对token进行解析校验。**我们不需要自己来校验token是否过期，是否符合要求，JJWT会在解析时自行判断。**一般来说我们会给token解析语句套一个try---catch，如进到catch则表明不能信任该token，JJWT无法解析不被信任的token，此时会跳转至登录页让用户重新登录。如果一直在try中，则表明解析成功，token可以被信任，则继续action请求的逻辑。
9. 注销操作的思路是使用ajax调用action，在action中销毁存储token的cookie。因为JWT规范只规定了token的创建和解析，并不负责管理token的存储和销毁。当点击注销按钮，后台会把cookie的maxAge设置为0并把cookie返回给客户端。客户端收到maxAge=0的cookie后就会立刻销毁该cookie，这样在success()回调函数中重定向到注册页的请求中就不会带有token的cookie。
10. 如果希望浏览器关闭后token依然存活，则可以在创建token的cookie时，同时设置maxAge。
11. 实现了回车按键响应登录按钮。

**未实现**

* 开启httpOnly
* 前端密码MD5加密
* ajax函数系统全面地学习、总结



