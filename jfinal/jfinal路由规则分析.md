#最基础的路由
当前端需要调用后端的action，必须依靠路由，才能找到对应的action方法。路由路径由三部分组成：projectPath+controllerKey+methodKey。

* projectPath:表示项目的路径，比如http://localhost:8080/myproject
* controllerKey：这个key值会映射到对应的controller类。
* methodKey：这个key值会映射到controller中同名的method。