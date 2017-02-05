#String API历险记

## 创建String：构造函数
* 根据byte[]创建：一定要显式地制定编码格式！
* 根据char[]创建
* 根据int[] codePoints创建：用得少
* 根据String创建：基本没啥用
* 根据StringBuffer创建
* 根据StringBuilder创建
* 使用字面值创建

## 查询方法
```java
//返回字符串长度
int length()

//参数：字符/字符串（语义上）
//返回值：参数在这个String中的index位置。
//参数可以是String，也可以使char的int表示形式。
int indexOf(...)
int lastIndexOf(...)

//根据指定的编码格式，获取背后的byte[]
byte[] getBytes()
byte[] getBytes(Charset charset)
byte[] getBytes(String charsetName)


//返回特定index位置的字符。范围是0到length()-1。
char charAt(int index)

//返回一个char[]数组
char[] toCharArray()

//返回一个子charSequence
CharSequence subSequence(int beginIndex, int endIndex) 
```

## 判断方法
```java
//根据length==0来判断是否为空
boolean isEmpty()

//比较大小，顺序按照unicode码表的顺序。
//如果要比较中文，则需使用Collator类
int compareTo(String anotherString)
int compareToIgnoreCase(String str)

//是否包含特定字符串
boolean contains(CharSequence s)

//是否以字符串结尾
boolean endsWith(string suffix)

//是否以字符串开头
boolean startsWith(String prefix) 
boolean startsWith(String prefix, int toffset) 

//判断字符串字面值是否相等
boolean equals(Object anObject)
boolean equalsIgnoreCase(String anotherString)

//根据正则表达式判断String是否包含某个字符串
boolean match(String regex)

//其实和equals方法作用一样，都是比较String的内容
//line2内部转调line1，并且line1是线程安全的，这点和equals方法不一样。
boolean contentEquals(CharSequence cs) //line1
boolean contentEquals(StringBuffer sb) //line2

//看不懂的match
boolean regionMatches(int toffset, String other, int ooffset, int len)
boolean regionMatches(boolean ignoreCase, int toffset, String other, int ooffset, int len) 
```

## 修改方法
```java
//替换字符串中的特定字符串，并返回一个新的字符串
//replace可以替换字符、字符串，replace会替换所有匹配的内容
//replaceAll接收的参数是正则表达式
//replaceFirst接收的参数是正则表达式，替换的是第一个匹配的内容
String replace(char oldChar, char newChar)
String replace(CharSequence target, CharSequence replacement)
String replaceAll(String regex, String replacement)
String replaceFirst(String regex, String replacement) 

//截取一个子字符串
String substring(int beginIndex) 
String substring(int beginIndex, int endIndex)

//分词
String[] split(String regex)
String[] split(String regex, int limit) 

//根据值，生成对应的字符串
valueOf(...)

//大小写转换
String toLowerCase()
String toLowerCase(Locale locale) 
String toUpperCase()
String toUpperCase(Locale locale) 

//删除空格
String trim()

//转为字符串
String toString() 

//作用：拼接字符串，并返回一个new String
//该方法始终返回一个新创建的字符串，但并没有利用字符串池。
String concat(String str)
```

## 格式化构建String
```java
//根据String中的占位符、传入的参数来创建一个新的String
static String format(Locale l, String format, Object... args)
sataic String format(String format, Object...args)
```

## copy方法
```java
//从字符串池中取出一个字面量一样的对象并返回，或者创建一个字面量一样的对象并放入池中并返回。
String intern()

//根据char[]，创建一个新的String
//内部其实都是转调的String的构造函数
static String copyValueOf(char[] data)
staitc String copyValueOf(char[] data, int offset, int count)

//把String中的一部分字符拷贝到一个新的char[]中。
void getChars(int srcBegin, int srcEnd, char[] dst, int dstBegin)
```

## codePoint相关
```java
int codePointAt(int index)

int codePointBefore(int index)

int codePointCount(int beginIndex, intendIndex)

int offsetByCodePoints(int index, int codePointOffset)
```

