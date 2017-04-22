#实验
## 实验准备
实验环境：MyEclipse2015+tomcat6+JDK6+Chrome。

实验目的：观察session的创建、session的传递、session的销毁、session在tomcat内存中的存活状态。

提供两个sevlet，一个用于创建session，一个用于查看tomcat内存中所有存活的session(ActiveSession)

```Java
//MyTestServlet 创建session
public void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.setContentType("text/html;charset=UTF-8");
		PrintWriter out = response.getWriter();
		
		HttpSession session = request.getSession();
		Cookie[] cookies = request.getCookies();
		if(cookies!=null & cookies.length>0) {
			for(int i=0; i<cookies.length; i++) {
				if(cookies[i].getName().equals("JSESSIONID")) {
					String JSESSIONID = cookies[i].getValue();
					out.println("前端传入的JSESSIONID="+JSESSIONID + "</br>");
				}
			}
		}
		out.println("后端生成sessionID=" +session.getId() + "</br>");
		String isNew = session.isNew()==true?"新":"旧";
		out.println("这是" + isNew + "的ID </br>");
	}
	
//AllSessionServlet 查看tomcat内存中所有存活的session
//注意，这个方法中需要引用到tomcat的lib包，即在项目中需要引用%TOMCAT_HOME%/lib目录下的所有jar包
public void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException  {
		response.setContentType("text/html;charset=UTF-8");
		PrintWriter out = response.getWriter();
		try {
			int activeSessions = 0;
		    if (request instanceof RequestFacade) {
		      Field requestField = request.getClass().getDeclaredField("request");
		      requestField.setAccessible(true);
		      Request req = (Request) requestField.get(request);
		      Context context = req.getContext();
		      Manager manager = context.getManager();
		      activeSessions = manager.getActiveSessions();
		      out.println("tomcat里共有"+activeSessions+"个活动的session </br>" );
		      Session sessions[] = manager.findSessions();
		      if(sessions!=null & sessions.length>0) {
		    	  for(int i=0; i<sessions.length; i++) {
		    		  int index = i++;
		    		  out.println("第" + index + "个sessionID=" + sessions[i].getId() + "</br>");
		    	  }
		      }
		    }
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
```

## 实验开始
**获取session**表示访问地址：`http://localhost:8080/session/MyTestServlet`

**查看session个数**表示访问地址：`http://localhost:8080/session/AllSessionServlet`

### 第一步
打开chrome，按照下面步骤操作：

#### 1.1 查看session个数
```
tomcat里共有0个活动的session
```

#### 1.2 接着，在chrome中获取session
```
后端生成sessionID=4003C36DDAD53621BD45A45CD96835F7
这是新的ID
```
![2. 接着，在chrome中获取session](http://ww3.sinaimg.cn/mw690/0065Y1avgw1fb545ttqghj30oa07jab5.jpg)

在上图中，因为这是我们第一次访问该站点，因此请求头中不包含该站点的cookie，也不会含有JSESSIONID（JSESSIONID是保存在cookie中的）。当服务端发现我们请求头不含JSESSIONID，就认为这是一个新的会话，并开辟一个新的session，赋予一个新的SessionID（JSESSIONID），并把SESSIONID放入响应头中，返回给浏览器。

#### 1.3 查看session个数
```
tomcat里共有1个活动的session 
第1个sessionID=4003C36DDAD53621BD45A45CD96835F7
```

由于上以操作已经开启了一个新的会话，所以tomcat内存中存在一个活动的session。

#### 1.4 再次获取session
前端传入的JSESSIONID=4003C36DDAD53621BD45A45CD96835F7
后端生成sessionID=4003C36DDAD53621BD45A45CD96835F7
这是旧的ID 
![4. 再次获取session](http://ww3.sinaimg.cn/mw690/0065Y1avgw1fb54g6l1q3j30od07kaba.jpg)

由于之前已经获取过一次session，开辟了会话，因此响应头中的JSESSIONID将被浏览器缓存在内存中。当第二次尝试获取session时，浏览器发现自身内存中包含有该站点的JSEESIONID，因此就把JSEESIONID放入到请求头中，一并发送给服务端。

服务端从请求中获取到JSESSIONID后，与tomcat内存中存活的SESSION进行匹配，匹配成功后，`request.getSession();`将不创建新的SESSION，而是返回匹配的存活SESSION。另外，这一次服务端也不再把JSESSIONID放入响应头中，因为SESSION能匹配上，就表明此次请求是在同一个会话中，浏览器已经含有该JSESSIONID，所以服务端此时不再发送JSESSIONID。

### 第二步 
#### 2.1 关闭chrome进程，接着重新打开chrome，并查看session个数。
```
tomcat里共有1个活动的session 
第1个sessionID=4003C36DDAD53621BD45A45CD96835F7
```
这表明即使关闭浏览器，tomcat内存中的session依然存在。

**因此，系统一般会提供退出按钮，在点击退出时，同时删除服务端的SESSION，最大限度的节约服务端资源，不然的话，Session就只能等到既定的销毁时间才自动销毁。**

#### 2.2 在chrome中获取session
```
后端生成sessionID=6D0DB2024031109E97884F1CE6A74DFB
这是新的ID
```

![2. 在chrome中获取session](http://ww2.sinaimg.cn/mw690/0065Y1avgw1fb55hx18doj30ot07k75f.jpg)

在上图中我们发现，请求头中并不包含JSEESIONID，因此服务端接收到请求后，认为这是一个新的会话，所以在执行`request.getSeesion();`时创建一个新的session，并把新的JSESSIONID放入到响应头中返回给浏览器。

在第一步中也提到过，浏览器在第一次发出请求创建会话时，会接收到服务端创建的JSESSIONID，这个JSESSIONID只是保存在浏览器进程的内存中，并未保存到本地硬盘，因此当我们关闭浏览器后，内存中的JSESSIONID也就消失了，这也就解释了为什么这一次请求头中不包含JSESSIONID。

#### 2.3 查看session个数
```
tomcat里共有2个活动的session 
第1个sessionID=6D0DB2024031109E97884F1CE6A74DFB
第3个sessionID=4003C36DDAD53621BD45A45CD96835F7
```

#### 2.4 再次获取session
```
前端传入的JSESSIONID=6D0DB2024031109E97884F1CE6A74DFB
后端生成sessionID=6D0DB2024031109E97884F1CE6A74DFB
这是旧的ID 
```

### 第三步
#### 3.1 关闭tomcat
在%TOMCAT_HOME%/work/Catalina/localhost/PROJECT_NAME/目录下，会产生一个SESSIONS.ser文件。因为服务端生成的SESSION均保存在TOMCAT内存中，当关闭tomcat后，tomcat会自动把存活的session保存在文件SESSIONS.ser中（序列化），实现session持久化存储。

#### 3.2 开启tomcat
当开启tomcat时，tomcat会自动加载SESSIONS.ser，并反序列化其中的session，生成session对象。这样，session对象又成功载入到tomcat内存中。最后，tomcat删除SESSIONS.ser文件。

#### 3.3 查看tomcat个数
```
tomcat里共有2个活动的session 
第1个sessionID=6D0DB2024031109E97884F1CE6A74DFB
第3个sessionID=4003C36DDAD53621BD45A45CD96835F7
```

此处证明了：关闭tomcat后，tomcat内存中的session对象并未消失，而是被持久化存储到文件中。重新开启tomcat后，session对象又重新加载到tomcat内存中。












