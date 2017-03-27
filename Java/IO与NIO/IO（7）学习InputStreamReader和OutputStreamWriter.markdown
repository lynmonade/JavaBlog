# IO（8）学习InputStreamReader和OutputStreamWriter
## InputStreamReader
InputStreamReader是字节流转为字符流的一座桥梁，他继承自Reader类。InputStreamReader内部维护了一个StreamDecoder成员变量，在执行read()操作时，实际上执行了两个步骤：

1. StreamDecoder使用传入的InputStream，实现读取字节流。
2. StreamDecoder使用根据指定的编码格式，把字节流转为字符数组。

此外为了提高效率，推荐使用BufferedReader在外面包一层：

```java
BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
```

![字符解码相关类结构](http://wx4.sinaimg.cn/mw690/0065Y1avgy1fcr661dp03j309s05674a.jpg)

## OutputStreamWriter
OutputStreamWriter是字符流转为字节流的一座桥梁，他继承自Writer类。OutputStreamWriter内部维护了一个StreamEncoder成员变量，在执行write()操作时，实际上执行了两个步骤：

1. StreamEncoder使用根据指定的编码格式，把字符流转为字节数组。
2. StreamEncoder使用传入的OutputStream，向目的地写入字节流。

此外为了提高效率，推荐使用BufferedReader在外面包一层：

```java
BufferedWriter in = new BufferedWriter(new OutputStreamWriter(System.out));
```

![字符编码相关类结构](http://wx3.sinaimg.cn/mw690/0065Y1avgy1fcr661ntcrj309z0573yi.jpg)

## 使用例子
```java
public static void testInputStreamReader() throws Exception {
	FileInputStream fis = new FileInputStream("d:/file.txt");
	InputStreamReader isr = new InputStreamReader(fis);
	char[] cbuf = new char[10];
	int len = isr.read(cbuf);
	System.out.println("read len = " + len);
	System.out.println(new String(cbuf));
	fis.close();
	isr.close();
}
	
public static void testOutputStreamWriter() throws Exception {
	FileOutputStream fos = new FileOutputStream("d:/file.txt");
	OutputStreamWriter osw = new OutputStreamWriter(fos, "UTF-8");
	osw.write("再见");
	osw.close();
}
```