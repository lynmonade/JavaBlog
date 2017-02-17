#《Think In Java》
## 字符串拼接
在进行字符串拼接时，如果只是简单的拼接，则编译器在底层会自动优化为StringBuider的append()拼接形式。因此下面的拼接方式的效率是没有问题的。

```java
String s1 = "aa";
String s2 = s1 + "bb" + "cc";
```

如果在for循环中进行拼接时，则建议for外面显式地创建StringBuider()，并在for内部显式调用append()方法进行拼接。

```java
/*
 * 错误做法：编译器会在for循环中创建N个StringBuilder对象，这样效率比较差
 * */
public String wrongWay(String[] fields) {
	String result= "";
	for(int i=0; i<fields.length; i++) {
		result += fields[i];
	}
	return result;
}
	
/*
 * 正确做法：只创建一个StringBuilder，效率更好
 * */
public String rightWay(String[] fields) {
	StringBuilder result = new StringBuilder();
	for(int i=0; i<fields.length; i++) {
		result.append(fields[i]);
	}
	return result.toString();
}
```

此外，千万不要妄想走捷径，写出下面这样错误的代码：

```java
/*
	 * 错误做法：a + ":" + b其实又会另外创建一个StringBuider对象。
	 * 因为编译器底层都是把String拼接自动优化为StringBuider对象。
	 */
	public String wrong() {
		StringBuilder sb = new StringBuilder();
		String a = "a";
		String b = "b";
		return sb.append(a + ":" + b).toString();
	}
```

## toString()无意识递归
对集合调用toString()方法时，其实都会转调集合内部每一个元素的toString()方法。如果要打印每一个元素的内存地址，千万不要使用this，而应该使用super.toString()。

```java
public class InfiniteString {
	public String toString() {
	    //return "InfiniteString address:" + this; //错误
		return "InfiniteString address:" + super.toString(); //正确
	}
	
	public static void main(String[] args) {
		List<InfiniteString> v = new ArrayList<InfiniteString>();
		for(int i=0; i<10; i++) {
			v.add(new InfiniteString());
		}
		System.out.println(v);
	}
}
```

`"InfiniteString address:" + this`其实发生了自动类型转换，当编译器看到"InfiniteString address"后面跟着一个+号，并且+号后面不是一个String，则编译器就试着讲this转为String。怎么转呢？就是调用自身的toString()方法，于是就发生了递归调用(一直在调用自己！)。正确做法是使用super.toString()。

## 想Objc一样使用占位符输出
```java
public static void main(String[] args) {
	int x =5;
	double y = 5.332542;
	System.out.println("x=" + x + ", y=" + y); //old way
	System.out.format("x=%d, y=%f+", x,y); //new way
	System.out.printf("x=%d, y=%f", x,y); //or new way
}
```

此外，还有很多棋其他类型的占位符。自己看书吧！

还有一个很好用的类叫做Formatter，它可以看做翻译器，将你的格式化字符串与数据翻译成需要的结果。当你创建一个Formatter对象时，需要向其构造函数传递一些信息，告诉它最终的结果将向哪里输出。
![格式化占位符](http://wx3.sinaimg.cn/mw690/0065Y1avgy1fc9xk0x5o0j310x09b76w.jpg)

此外，String类也提供了format()方法，让你通过占位符的方式，格式化形成一个新的String。其底层其实也是通过Formatter实现的。format()只是一个包装方法。

第327页有一个小例子，可以把二进制数据转为十六进制的格式，并查看其内容。就像notepad++提供的功能一样。

## 正则表达式

## Scanner

## StringTokenizer




# 《Java7入门经典》
## String类的方法分类：
### 字符串操作
#### 字符串拼接
+表示字符串拼接，产生新的字符串。

```
System.out.println(5+5+" = result"); //10 = result
System.out.println("result = "+5+5); //result = 55

System.out.println(1+(2+"a")); //12a
```

+号运算符都是从左到右进行运算的。第一行语句中，`5+5`是整数加法运算，接着才是整数与字符串拼接运算。而第二行语句中，`"result = "+5`是字符串与整数的拼接运算，接着下一个+号还是字符串和整数的拼接运算。

其实，当非String类型与String类型进行拼接时，编译器都会先调用非String类型的toString()方法把其转为String后再进行拼接。如果是基本数据类型，则调用其包装类的toString()方法。

java中8个基本类型的包装类：

```java
byte    Byte
short   Short
int     Integer
long    Long
float   Float
double  Double
boolean Boolean
char    Character
```

#### 类型转换： static String valueOf(arg)
该方法接收基本数据类型或者Object类型的参数，并返回其对应String类型。底层其实都是调用包装类的toString()方法。

#### 字符串比较：==， equals(String)

==用于比较两个对象的内存地址是否相等。equals()用于比较两个字符串的字面值是否相等。

#### 字符串驻留：intern()

#### 检查字符串头和尾
从头、或者从尾部，检查字符串的起始和结尾部分是否存在"另一个字符串"。

```java
String str = "java";
boolean b1 = str.startWith("ja"); //true
boolean b2 = str.endWith("va"); //true
```

#### 字符串排序：int compareTo(String)
返回整数，表示哪个字符串大。排序规则按照unicode码表进行排序。

#### 查找字符：int charAt(char)

#### 查找字符串第一次/最后一次出现的位置：int indexOf(String), int lastIndexOf(String)

indexOf其实应该叫做firstIndexOf更合适，因为他专门用于查找第一次出现的位置。关于参数，其实不仅可以传String，还可以传int类型，他表示一个char，因为每个char在unicode码表都有一个对应的整数值。

#### 提取子字符串 String subString(int, int)

## StringBuilder/StringBuffer
StringBuffer默认容量是16bit，每次自动扩容16bit。

```java
StringBuffer sb = new StringBuffer("aa");
System.out.println(sb.length()); //2
System.out.println(sb.capacity()); //18=2+16
```


# 《编写高质量代码-改善Java程序的151个建议》
## 创建String
推荐使用`String str1 = "中国";`的方式创建不可变字符串。而不要使用new的方式。


```java
String str1 = "中国";
```

先检查字符串池中有没有该字面量，如果有，则不创建新对象，而是让str1指向该字面量。如果没有则创建新的对象，并把该字面量值放入到字符串池中。

```java
String str1 = new String("中国");
```

使用`new String("中国")`创建的字符串时，并不会去检查字符串池，而是直接创建一个新对象，创建完毕后，也不会把对象放入字符串池中。

```java
String str2 = str1.intern();
```
intern()方法会检查str1对象在字符串对象池中是否有字面量相同的对象，如果池中有这样的对象，则返回池中的对象。如果池中没有这样的对象，则在字符串池中创建一个新的对象，新对象的字面量与str1的字面量相同，最后返回池中的新对象。

```java
String s1 = "a"+"b";
```
通过反汇编命令可知：编译器也是把在字符串池中创建String，而不涉及任何StringBuider、或者new String的操作。

```java
String s1 = "a"; //line1
String s2 = s1+"b"; //line2
```
通过[反汇编命令:javap -c MyClass](http://www.365mini.com/page/javap-disassemble-class-file-code.htm)可知，line1是直接在常量池中创建一个String。line2涉及到+号拼接，加号前面应用了一个String变量，而后面是一个String字面值，则编译器实际上会转化为如下三步：

```java
StringBuilder sb = new StringBuider(s1);
sb.append("b");
s2 = sb.toString();
```


## replaceAll(arg0, arg1)
replaceAll的第一个参数是正则表达式。

## subString(0);
String str2 = str1.subString(0)不会创建新对象，而是返回str1本身。

## String, StringBuilder, StringBuffer应用场景
* String用于常量声明，少量的变量运算。
* StringBuffer线程安全，用于多线程环境中，如xml解析，HTTP参数解析和封装
* StringBuilder用于单线程环境中，用于单线程环境中，如SQL语句拼接，JSON封装。

## 字符串拼接
字符串拼接有三种方式：

* +号：最慢
* concat方法：一般
* append方法：最快

+号拼接在底层虽然也会被编译器优化为StringBuilder的形式，但如果放在一个很大的for循环中，还是会创建N个StringBuilder，性能很差。

concat方法直接操作String内部的char字符数组，并返回一个新的String。但如果放在一个很大的for循环中，还是会创建N个String，性能一般。

append()方法直接操作StringBuilder内部的char字符数组，即使放在for循环中，也不会涉及创建新对象，性能最好。

## 正则表达式

## 乱码
* 使用记事本，IDE创建.java文件时，文件格式是操作系统的默认格式。(Windows是GBK)
* 使用javac命令生成的.class文件是UTF-8编码。这在任何操作系统上都一样。UTF是unicode的存储和传输格式。

## 中文排序
中文排序不能依赖于string.compareTo()方法，而应该使用Collator类进行排序：

```
```






