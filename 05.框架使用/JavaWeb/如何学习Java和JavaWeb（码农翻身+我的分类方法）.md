# 如何学习Java和JavaWeb（码农翻身+我的分类方法）

## 我的分类方法

**Java**

1. 数理知识：基本数据类型、Math包、枚举
2. 面向对象：封装、继承、多态、接口、抽象类（主要学习《Think In Java》），内部类、异常、static/final关键字
3. 字符串：String、StringBuilder、正则表达式、编码与解码、乱码问题
4. 容器：List、Set、Map
5. I/O与NIO：IO、NIO背后的思想，操纵XML，JSON，Properties文件
6. XML与JSON：操作XML和JSON
7. 网络编程：socket编程
8. 并发编程：多线程
9. 语言特性：反射、泛型、注解

**JavaWeb**

1. **交互协议：**HTTP、HTTPS、RMI、WebService、Restful、SOA、RPC
2. **Base64编码、加密、解密协议**
3. **JWT、Cookie、Session机制**
4. **前端渲染：**HTML、CSS、JS、Freemarker、Velocity、Bootstrap、MiniUI
5. **URL映射规则**
6. **数据提交方式：**Get、Post、超链接、AJAX
7. **数据校验：**AOP、拦截器式的校验
8. **数据转换与绑定：**前端到后端的转换与绑定，后端到前端的转换与绑定
9. **ORM数据库**
10. Web安全



**JavaWeb更进一步**

1. shiro：实现人员管理、权限管理、登录认证管理、单点登录、第三方认证登录
2. tomcat：集群配置
3. Nginx：负载均衡
4. redis：缓存服务与session存储
5. 缓存：ECache
6. Netty、HttpClient：网络连接管理
7. Dubbo：PRC远程调用
8. ZooKeeper：服务注册与发现
9. Hadoop：大数据

## 码农翻身

**Java**

1. **基本语法：**包括基本数据类型、表示服、关键字、运算符、流程控制语句、循环语句
2. **基本的数据结构：**包括字符串、集合（List、Set、Map）
3. **面向对象：**封装、继承、多态、接口、抽象类
4. **突破内存：**IO、XML、JSON、网络编程
5. **让多任务并发执行：**多线程
6. **语言特性：**反射、泛型、注解、内部类
7. **GUI：**安卓
   1. 界面是如何描述的
   2. 数据如何获取：数据库编程、网络编程
   3. 界面和数据如何绑定
   4. 用户在GUI上的操作该如何处理
8. Web：JavaWeb
9. 做项目！

**JavaWeb**

1. 理解浏览器/服务器结构 (B/S)
2. **Web页面是怎么组成的？（HTML+CSS+JS）**
3. 浏览器和服务器是怎么打交道的：HTTP协议，GET、POST、Cookie机制、Session机制、JWT机制
4. **URL和代码的映射：**理解url 和 代码之间的关联， 例如` www.xxx.com?action=login`这样的url 是怎么和后端的业务代码关联起来的？ 这样的规则是在哪里定义的？ 用代码、注解还是配置文件
5. **数据的验证、转换和绑定：**
   1. 如何优雅地校验前端传过来的数据（拦截器）
   2. 如何把`username=liuxin&password=123456`转换为对象类型，并把对应字段绑定到对应成员变量上，最大限度地利用Java丰富的数据类型（前端--->绑定--->后端）
   3. 数据处理完毕后，如何把对象转为JSON供前端使用（后端--->绑定--->前端）
6. **Web安全：**如何防止黑客利用SQL 注入，跨站脚本攻击， 跨站请求伪造等手段来攻击系统
7. **数据库访问：**ORM、MyBatis、连接池、事务、锁
8. **用什么技术来生成Web页面：**JSP、Velocity、Freemaker，以及5中的数据绑定后端对象转为JSON绑定至前端）
9. **如何把对象变成XML或者JSON字符串**：AJAX数据提交，以及5中的数据绑定（后端对象转为JSON绑定至前端）

**进阶：高并发，缓存，搜索，分布式**

