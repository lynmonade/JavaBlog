# 字符串（3）String API分析
## int length()
> Returns the length of this string. The length is equal to the number of Unicode code units in the string.


String其实是char数组构成的，翻看String源码可知，`length()`返回的是char[]数组的长度。而根据API的介绍，`length()`的长度等于代码单元code units的个数。也就是说，char[]数组的长度也就是代码单元的个数。那如何确定代码单元的个数呢？或者说，如何确定该字符串底层包含多少个char呢？


在Java中，String在JVM中永远使用UTF-16编码，因此UTF-16的代码单元就是16bit，也就是2个byte，也就是1个char，所以，采用UTF-16的编码String的代码单元就是1个char。对于BMP平面的字符来说，UTF-16使用1个char进行编码，而对于SP平面的字符来说，UTF-16使用2个char进行编码。

```java
public final class String
    implements java.io.Serializable, Comparable<String>, CharSequence {
    /** The value is used for character storage. */
    private final char value[];

    public int length() {
        return value.length;
    }
}
```

## byte[] getBytes()
`getBytes()`方法有三个重载方法：

```java
byte[] getBytes(Charset charset)
byte[] getBytes(String charsetName)
byte[] getBytes()
```

由于Java中的String在JVM中采用UTF-16编码，因此`getBytes()`从本质上来说，就是把UTF-16编码的字节数组转换为XXX编码格式的字节数组。XXX由方法参数决定，对于前两个重载方法，我们可以显式地指定XXX编码格式，而对于无参数的重载方法，其会选用平台默认的编码格式（platform's default charset）。

`平台默认的编码格式 == .java文件的编码格式 == eclipse项目工程的编码格式`。Windows下默认为GBK，这也是为什么我们需要修改eclipse全局的项目工程编码格式为UTF-8。

![getBytes()](http://wx4.sinaimg.cn/mw690/0065Y1avly1fciwi6ekx7j309h0aygls.jpg)

### 关于BOM
```
//转为UTF-16时，java自动加上BOM
String str = "中国";
System.out.println(str.getBytes("UTF-16").length); //6=2+4,BOM占两个byte
```

## int indexOf()
`indexOf()`方法用于返回**子字符串在字符串中首次出现的位置**。传入的参数可以是子字符串的codePoint，也可以是子字符串本身。如果没找到这个子字符串，则返回-1。

```
int codePoint = "p".codePointAt(0);	 
int index = "apple".indexOf(codePoint)); //1

int index2 = "hello".indexOf("ll"); //2

```

## int compareTo()
`X.compareTo(Y)`方法用于比较两个字符串的大小。其比较方式是：

1. 从index=0开始，按顺序一一比较每个index上的字符大小。
2. 字符比较方式是charX-charY，依据字符的codePoint来做减法。
3. 如果所有char均相同，则返回0。如果charA大，则返回1，如果charB大，则返回-1。

```java
/*
index=0时，都是A，codePoint相等
index=1时，B的码点=66，D的码点=68，66-68=-2
index=2不做比较
*/
int result = "ABF".compareTo("ADE"); //-1
```

## boolean startsWith()
```
//两个重载方法
boolean b1 = "modify".startsWith("mo"); //true
boolean b2 = "modification".startsWith("di",2); //true，注意第二个参数index的位置
```

## boolean equals()/contentEquals()
和比较字符串相关的有三个方法：

```java
boolean equals(Object anObject) //字符串内容比较
boolean equalsIgnoreCase(String anotherString) //内部统一转为大写后，再比较内容
boolean contentEquals(StringBuffer sb) //内部转调line4
boolean contentEquals(CharSequence cs) //
 //line4，字符串内容比较，且线程安全。
```


```java
//equals()方法源码分析
//作用：字符串内容比较，线程不安全
public boolean equals(Object anObject) {
	if (this == anObject) { //如果和自身比较，则永远返回true
		return true;
	}
	if (anObject instanceof String) { //如果是字符串，则转为字符串
		String anotherString = (String)anObject;
		int n = value.length;
		//如果长度不同，则直接返回false，如果长度相同，再进行比较
		if (n == anotherString.value.length)  {
			//获取String底层的char[]，并逐个比较char
			char v1[] = value;
			char v2[] = anotherString.value;
			int i = 0;
			while (n-- != 0) {
				if (v1[i] != v2[i]) 
					return false;
				i++;
			}
			return true;
		}
	}
	return false;
}
```

```java
//equalsIgnoreCase源码分析
//作用：比较字符串内容
//特点：忽略大小写，线程不安全
public boolean equalsIgnoreCase(String anotherString) {
    return (this == anotherString) ? true
            : (anotherString != null)
            && (anotherString.value.length == value.length)
            && regionMatches(true, 0, anotherString, 0, value.length);
}
    
public boolean regionMatches(boolean ignoreCase, int toffset,
        String other, int ooffset, int len) {
    char ta[] = value;
    int to = toffset;
    char pa[] = other.value;
    int po = ooffset;
    // Note: toffset, ooffset, or len might be near -1>>>1.
    if ((ooffset < 0) || (toffset < 0)
            || (toffset > (long)value.length - len)
            || (ooffset > (long)other.value.length - len)) {
        return false;
    }
    while (len-- > 0) {
        char c1 = ta[to++];
        char c2 = pa[po++];
        if (c1 == c2) {
            continue;
        }
        if (ignoreCase) {
            // If characters don't match but case may be ignored,
            // try converting both characters to uppercase.
            // If the results match, then the comparison scan should
            // continue.
            char u1 = Character.toUpperCase(c1); //转为大写
            char u2 = Character.toUpperCase(c2);
            if (u1 == u2) {
                continue;
            }
            // Unfortunately, conversion to uppercase does not work properly
            // for the Georgian alphabet, which has strange rules about case
            // conversion.  So we need to make one last check before
            // exiting.
            if (Character.toLowerCase(u1) == Character.toLowerCase(u2)) {
                continue;
            }
        }
        return false;
    }
    return true;
}

//使用
String str1 = "hello中国";
String str2 = "HELLO中国";
String str3 = "HELLO中华";

boolean b1 = str1.equalsIgnoreCase(str2); //true
boolean b2 = str1.equalsIgnoreCase(str3);//false
```

```java
//contentEquals(StringBuffer sb)源码分析
//作用：字符串内容比较
//特点：线程安全，内部转调contentEquals((CharSequence)sb);
public boolean contentEquals(StringBuffer sb) {
    return contentEquals((CharSequence)sb);
}
```

```java
//contentEquals(CharSequence cs)源码分析
//作用：字符串内容比较
//特点：线程安全
public boolean contentEquals(CharSequence cs) {
    // Argument is a StringBuffer, StringBuilder
    if (cs instanceof AbstractStringBuilder) {
        if (cs instanceof StringBuffer) {
            synchronized(cs) {
               return nonSyncContentEquals((AbstractStringBuilder)cs);
            }
        } else {
            return nonSyncContentEquals((AbstractStringBuilder)cs);
        }
    }
    // Argument is a String
    if (cs instanceof String) {
        return equals(cs);
    }
    // Argument is a generic CharSequence
    char v1[] = value;
    int n = v1.length;
    if (n != cs.length()) {
        return false;
    }
    for (int i = 0; i < n; i++) {
        if (v1[i] != cs.charAt(i)) {
            return false;
        }
    }
    return true;
}
```

## 和正则表达式相关的几个方法
```java
boolean match(String regex)
String replaceAll(String regex, String replacement)
String replaceFirst(String regex, String replacement) 
String[] split(String regex)
String[] split(String regex, int limit) 
```









