java中的char是用来表示unicode基本平面上的字符的。在unicode中，有17个平面。第一个平面是基本平面，第2-17个平面是辅助平面。基本平面包含了我们各国语言的常用字符。而辅助平面则包含了特殊字符。

java用UTF-16来表示字符。UTF-16采用双字节来表示unicode基本平面中的字符，也就是说，一个char就能容纳基本平面中的字符。而对于unicode辅助平面中的字符，unicode采用4字节来表示，所以，必须要用两个char才能容纳辅助平面的字符。

例如，字母A在unicode码表的值，十进制表示是65，十六进制表示是41。41就是字符A的code point值。UTF-16使用一个char来表示：U+0041。下面两个例子都表示字符A。

```java
char c1 = 'A';
char c2 = '\u0041';
System.out.println(c1); //A
System.out.println(c2); //A
```


如果想要表示辅助平面的字符，则必须要用char[]。比如数学字符Z的code point=U+1D56B。UTF-16使用两个char来表示：U+D835，U+DD6B。

```java
char[] c1 = {'\uD835','\uDD6B'};
System.out.println(c1);
```

## 关于\u
\uXXXX是字符的表示形式，\u是转义符，XXXX是16进制数字的字符串表示形式。

