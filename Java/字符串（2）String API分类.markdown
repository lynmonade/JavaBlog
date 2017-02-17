# 字符串（二）String API分类
String API为我们提供了如下几大类方法：

* 创建String
* 查询方法
* 判断方法
* 修改方法
* 格式化构建String
* 字符数组拷贝
* CodePoint相关


## 创建String
```java
* 根据byte[]创建：一定要显式地制定编码格式！
* 根据char[]创建
* 根据int[] codePoints创建，少用
* 根据String创建，少用
* 根据StringBuffer创建，少用
* 根据StringBuilder创建，少用
* 使用字面值创建，推荐使用

//作用：
//特点：如果字符串池中字面值一样的字符串，则从字符串池中取出该对象并返回，如果没有，则创建一个字面量一样的对象并放入池中并返回。
String intern()

//作用：根据char[]，创建一个新的String
//特点：内部其实都是转调的String的构造函数
static String copyValueOf(char[] data)
staitc String copyValueOf(char[] data, int offset, int count)
```

## 查询方法
```java
//作用：返回底层char[]数组的长度，BMP平面的字符占一个char，SP平面的字符占2个char
int length()

//作用：返回字符在字符串中的index位置
//特点：参数可以是String，也可以是codePoint，另外还可以设置从哪个index开始判断
int indexOf(int ch)
int indexOf(int ch, int fromIndex) 
int indexOf(String str)
int indexOf(String str, int fromIndex)
lastIndexOf(int ch)
lastIndexOf(int ch, int fromIndex)
lastIndexOf(String str)
lastIndexOf(String str, int fromIndex)

//作用：把UTF-16byte[]数组转为XXX编码的字节数组
//特点：推荐显式地指定编码格式
byte[] getBytes()
byte[] getBytes(Charset charset)
byte[] getBytes(String charsetName)


//作用：返回特定index位置的字符。范围是0到length()-1。
char charAt(int index)

//作用：返回String底层的char[]数组
char[] toCharArray()

//作用：返回一个子charSequence，其截取结果与substring()完全一样
//特点：闭开区间
CharSequence subSequence(int beginIndex, int endIndex)
```

## 判断方法
```java
//作用：判断字符串是否为空串""
//特点：根据length==0来判断
boolean isEmpty()

//作用：比较字符串大小，
//特点：按顺序依据每个字符的code point比较。实质是做减法：A-B，结果>0则返回1，<0则返回-1，字符串相同则返回0。如果要比较中文，则需使用Collator类
int compareTo(String anotherString)
int compareToIgnoreCase(String str)

//作用：判断是否包含特定字符串
boolean contains(CharSequence s)

//作用：是否以字符串结尾
boolean endsWith(string suffix)

//作用：是否以字符串开头
boolean startsWith(String prefix) 
boolean startsWith(String prefix, int toffset) 

//作用：判断字符串字面值是否相等
boolean equals(Object anObject) //线程不安全
boolean equalsIgnoreCase(String anotherString) //线程不安全，忽略大小写
boolean contentEquals(StringBuffer sb) //line3，线程安全，内部转调line4
boolean contentEquals(CharSequence cs) //line4，线程安全

//作用：根据正则表达式判断String是否包含某个字符串
boolean match(String regex)

//看不懂的match
boolean regionMatches(int toffset, String other, int ooffset, int len)
boolean regionMatches(boolean ignoreCase, int toffset, String other, int ooffset, int len) 
```

## 修改方法
```java
//替换字符串中的特定字符串，并返回一个新的字符串
//replace可以替换字符、字符串，replace会替换所有匹配的内容
//replaceAll接收的参数是正则表达式，并把匹配正则表达式的内容都替换掉
//replaceFirst接收的参数是正则表达式，替换的是第一个匹配正则表达式的内容
String replace(char oldChar, char newChar)
String replace(CharSequence target, CharSequence replacement)
String replaceAll(String regex, String replacement)
String replaceFirst(String regex, String replacement) 

//作用：截取一个子字符串
//特点：闭开区间，左闭右开
/*特殊例子
String str = "hello";
String str2 = str.substring(str.length()); //str2="";
*/
String substring(int beginIndex) 
String substring(int beginIndex, int endIndex)

//作用:分词
//特点：参数是正则表达式
String[] split(String regex)
String[] split(String regex, int limit) 

//作用：根据值，生成对应的字符串
static String valueOf(boolean b) //返回"true" or "false"Float.toString 
static String valueOf(char c) //转调new String(char[]);
static String valueOf(int i) //转调Integer.toString
static String valueOf(long l) //转调Long.toString
static String valueOf(float f) //转调Float.toString
static String valueOf(double d) //转调Double.toString

//作用：大小写转换
String toLowerCase()
String toLowerCase(Locale locale) 
String toUpperCase()
String toUpperCase(Locale locale)

//作用：删除半角空格
String trim()

//作用：转为字符串
String toString() 

//作用：拼接字符串，并返回一个new String
//特点：该方法始终返回一个新创建的字符串，但并没有利用字符串池。
String concat(String str)
```

## 格式化构建String
```java
//作用：根据String中的占位符、传入的参数来创建一个新的String
static String format(Locale l, String format, Object... args)
sataic String format(String format, Object...args)
```

## 字符数组拷贝
```java
//把String中的一部分字符拷贝到一个新的char[]中。
void getChars(int srcBegin, int srcEnd, char[] dst, int dstBegin)
```

## CodePoint相关
```java
//返回index位置上的char的码点值(十六进制)
int codePointAt(int index)

int codePointBefore(int index)

int codePointCount(int beginIndex, intendIndex)

int offsetByCodePoints(int index, int codePointOffset)
```






