#最基础的路由
当前端需要调用后端的action，必须依靠路由，才能找到对应的action方法。路由路径由三部分组成：projectPath/controllerKey/methodKey。

**projectPath：**表示项目的路径，比如`http://localhost:8080/myproject`

**controllerKey：**这个key值会映射到对应的controller类，一般像下面这样配置：

```java
public void configRoute(Routes me) {
	me.add("/controllerKey", FirstController.class);
}
```

**methodKey：**这个key值会映射到controller中同名的method，一般像下面这样配置：

```java
public class FirstController extends Controller{
    //映射URL：projectPath+controllerKey
    //没有指明methodKey就映射index方法
	public void index() {
		System.out.println("invoke FirstController index");
	}
	
	//映射URL：projectPath/controllerKey/method
	//methodKey默认与方法同名
	public void method() {
		System.out.println("invoke FirstController Method");
	}
}
```



