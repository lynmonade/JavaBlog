# 字符串处理
常见问题：

* 字符串替换字符（正则表达式）
* 字符串替换特殊字符：英文空格，中文空格，英文tab，中午tab，换行符，双引号
* 字符串截取：区间问题
* 字符串为空判断
* 字符串开头、结尾判断

解决办法：

* 学习正则表达式
* 学习apache.common.lang.String相关类
* 找一个前端的StringUtil来学习，因为在前端也需要用JS处理字符串。
* 写一个自己的StringKit
* 学习Jfinal提供的StrKit
* 学习Jeesite提供的StrKit

# 前端编码-乱码-模板

常见问题：

* 对前端参数进行UTF-8编码
* 在前端、后端用过滤器、编码等办法处理敏感字符
* 自行构建json字符串
* js变量作用域
* 引入js、css时总是要重复写
* 如何像LP一样引入全局变量`g_path`，作用域basePath
* 实现用相对路径引入资源文件，实现码最少的字引入资源

解决办法：

* 总结前段时间研究的火狐官网文档、JS书，记录JSON相关的js方法。
* 多研读火狐官网文档
* 看下载的前端书，包括JS、ajax、HTTP
* 学习欧工的LP框架源码
* 构建自己的前端js工具类，避免冗余代码
* 学习一个模板引擎

# 后端Java

常见问题：

* try...catch代码漫天飞，代码非常难看
* 实现JavaBean映射，在代码中不要出现JSONObject等
* 使用AOP、filter、hibernate-validator进行参数校验，避免在Controller层写一堆验证代码
* Controller代码太肮脏了，因尽量保持干净，清爽
* 应该定义统一的controller返回对象ResultBean和ResultPageBean。
* 定义统一的Logger使用方法，坚决杜绝`System.out.println`
* 如何区分三层结构，controller-service-dao
* 如何构建VO，减少手工set的代码
* 如果使用过滤器、拦截器
* 用maven构建一些脚手架式的空项目，比如jfinal，springMVC+mybatis，方便日常练习。
* 熟悉maven的基本操作，如何下载并构建github上的maven项目，如何把自己写的maven项目打包上github（gitignore要怎么写），如何打包maven项目（把依赖的jar包打包进去）
* 如何实现热部署，提高开发效率，不用每次都重启tomcat！
* 在控制台打印已填充参数的sql语句


解决办法：

* 用AOP尽量消除try...catch代码，异常处理代码全部放到AOP里处理。参考《程序员你为什么那么累-我的编码习惯》专栏。
* 自定义一些常见异常，并和前端约定自定义异常的标志位，实现进攻型异常编码方式，让错误能最快的暴露出来。
* 看jfinal-club源码，jeesite源码

# SQL

常见问题：

* 依然在手工写sql，没有一款趁手的sql代码生成工具
* 对join的语法还不清晰，也不知道如何优化join
* 不知道怎么建索引，不知道如何让索引命中
* 如何在java端实现join操作，以符合阿里规范
* 如何用Java工具类进行mysql/oracle、jfinal/mybatis分页
* 存在冗余字段时，如何连带更新冗余字段
* 如何抽象可复用的sql语句
* 如何对不同的数据库实现batch操作，jfinal、mybatis
* 判断table有多少条记录，count
* 判断table是否为空，count
* group by还不习惯用
* 树型sql的构建
* 左树，右grid的表结构设计，sql构建
* 

解决办法：

* 基于mysql/oracle、jfinal/mybatis构建自己的代码生成工具，网上又蛮多可以直接用的，多研究一些，提高效率，一劳永逸！
* 关于sql的书：《SQL Cookbook中文版》，《SQL基础教程》，《深入浅出SQL（中文版）》，《SQL语言艺术》
* 关于数据库的书：《涂抹oracle》
* 抽象出构建可复用的sql语句，这对构建代码生成工具也是有帮助的。
* 多读jfinal-club、jeesite源码
* 构建自己的Java-join工具类
* 构建自己的分页工具类，jfinal、mybatis好像有现成的

# 工具类

常见问题：

* 获取当前时间：String格式，TimeStamp格式。
* 生成UUID
* 带缓存式的IO文件：每次读10000行，每次写入10000行。
* 遍历文件夹下所有以.e结尾的文件
* 创建目录
* 创建文件
* 如何使用apche.Codec工具类，代替urlEncode
* 定时器，cron4j，quartz，与jfinal、spring结合使用
* encode工具类
* 反射工具类
* 

