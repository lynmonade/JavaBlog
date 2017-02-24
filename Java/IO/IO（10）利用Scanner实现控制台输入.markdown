# IO（10）利用Scanner实现控制台输入
Scanner类主要用于简化文本扫描，最常见的场景就是获取控制台输入的信息。

## 获取控制台输入
```java
public static void main(String[] args) throws Exception {
	Scanner in = new Scanner(System.in); //System.in表示输入源为控制台
	System.out.println("how old are u?");
	String input = in.nextLine(); //从控制台获取用户输入的信息
	System.out.println(input); //打印输入结果
}
```

## 构造函数与扫描方法
Scanner拥有多个构造函数，可以接受多种数据源，并对数据源的数据进行扫描。Scanner的方法也非常多，支持多种花样的扫描，甚至按照正则表达式进行扫描。比较常用的方法有：

```java
//判断输入源中是否还有内容需要输出
boolean hasNext()

//判断输入源是否还有下一行内容
boolean hasNextLine()

//返回下一个内容，默认以空格作为分隔符
String next()

//返回下一行内容
String nextLine()
```

## References
* [java.util.Scanner应用详解](http://lavasoft.blog.51cto.com/62575/182467/)