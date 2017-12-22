# 环境变量配置

```java
//JAVA_HOME
C:\Program Files\Java\jdk1.8.0_101

//CLASSPATH
%Java_Home%\bin;%Java_Home%\lib\dt.jar;%Java_Home%\lib\tools.jar

//PATH
%JAVA_HOME%\bin;

有些人喜欢在环境变量的首部添加.;
其实根本没必要加，效果都是一样的。
//PATH
.;D:\software\app\Roger\product\11.1.0\db_1\bin;%JAVA_HOME%\bin;
```

# Java命令行工具

##  javac 编译.java文件

需要注意几点：

* 必须先配置三大环境变量
* 建议显式地指定使用utf-8，不然可能会报错：“错误: 编码GBK的不可映射字符”
* 注意cmd所在当前目录，因为必要时必须加载包路径
* 必须用完整的文件名，包括.java
* 编译成功后将在.java文件所在目录生成一个同名的.class文件

```
//在windows的cmd下将采用GBK编码
javac Hello.java

//指定编码格式，同时带有包路径：推荐
javac -encoding utf-8 com/lync/CompileClassLoader.java
```

## java 运行.class文件

需注意几点：

* 不需要带.class后缀
* 注意cmd所在当前目录，因为必要时必须加载包路径
* 向main函数传参时，用空格隔开

```java
//传递了三个参数{com.lync.DesHello, aaa, bbb}
java com/lync/CompileClassLoader com.lync.DesHello aaa bbb
```

