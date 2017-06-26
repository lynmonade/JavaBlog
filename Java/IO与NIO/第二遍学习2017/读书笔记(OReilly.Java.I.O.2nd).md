# Chapter1 

## 1.2 Numeric Data(byte和int的区别)

回头看

## 1.4 Readers and Writers

**Stream的定义**：关键词：move bytes

> A stream is an ordered sequence of bytes of indeterminate 
> length. Input streams move bytes of data into a Java program from some generally 
> external source. Output streams move bytes of data from Java to some generally 
> external target. (In special cases, streams can also move bytes from one part of 
> a Java program to another.)

## 1.5 Buffers and Channels的简单介绍

需要到专门章节认真看

## 1.7 Console类

回头看，然后看JDK API

# Chapter2

## 2.1 单个byte写入输出流 

`System.out.write('\t');`表示打印一个tab间隙。

```java
public class Client {
	public static void main(String[] args) {
	    for (int i = 32; i < 127; i++) {
	      System.out.write(i);
	      // break line after every eight characters.
	      if (i % 8 == 7) {
	    	  System.out.write('\n');
	      }
	      else {
	    	  System.out.write('\t');
	      }
	    }
	    System.out.write('\n');
	   }
}
```

## 2.2 byte数组写入输出流

作者建议，在网络IO下建议用128 byte的缓存。在file IO下建议用1024 byte的缓存。

```java
//先填充构造一个byte数组，然后再write这个byte数组
//程序的结果与2.1是一样的，但他更快，因为他一次性写入多个byte，
//如果目的地是file的话，性能提升的效果更佳明显
public class Client {
	public static void main(String[] args) {
		byte[] b = new byte[(127 - 31) * 2];
		int index = 0;
		for (int i = 32; i < 127; i++) {
			b[index++] = (byte) i;
			// Break line after every eight characters.
			if (i % 8 == 7) {
				b[index++] = (byte) '\n';
			} else {
				b[index++] = (byte) '\t';
			}
		}
		b[index++] = (byte) '\n';
		try {
			System.out.write(b);
		} catch (IOException ex) {
			System.err.println(ex);
		}
	}
}
```

## 2.3 close操作 

并不是每一个stream都需要close，但一般设计网络、文件的stream都需要close。下面给出close的正确姿势：

```java
//要在finally中执行close
//catch异常
OutputStream out = null;
try {
  out = new FileOutputStream("numbers.dat");
  // Write to the stream...
}
catch (IOException ex) {
  System.err.println(ex);
}
finally {
  if (out != null) {
    try {
      out.close( );
    }
    catch (IOException ex) {
      System.err.println(ex);
    }
  }
}

//如果你抛出异常，则catch都省了
OutputStream out == null;
try {
  out = new FileOutputStream("numbers.dat");
  // Write to the stream...
}
finally {
  if (out != null) out.close( );
}
```

## flush操作

一般来说，当buffer满了，或者stream正常close时，stream都会自动flush一次。但当程序以外挂掉，buffer中的数据很可能并不会写入到目的地。因此建议做法是：客户端的byte[]的大小与缓冲大小一致，每次write后都执行一次flush。

对于那几个打印流来说，当执行了`println()`或者显式写入了`\n`后，都将会自动flush一次。

# Chapter3

## 3.1 read()

`read(int a)`方法一次只读取一个byte。非常没有效率。

## 3.2 read()的重载

read()方法有两个重载方法，他可以传入一个byte[]数组作为参数。InputStream提供的默认实现是：使用for循环，重复的调用`read(int a)`方法，这么做是很没效率的，所以InputStream的子类一般都会覆盖此方法，比如通过调用native方法，实现一次性read多个byte，以减少I/O次数。	

```java
//使用offset实现read。这个例子出现在3.3
try {
  int a = System.in.available( );
  byte[] b = new byte[a];
  int offset = 0;
  while (offset < b.length) {
    
    int bytesRead = System.in.read(b, offset, a);
    if (bytesRead == -1) break; // end of stream
    offset += bytesRead; //移动offset
}
catch (IOException ex) {
  System.err.println("Couldn't read from System.in!");
}
```

## 3.3 available方法

InputStream类默认提供的实现是：available()方法的返回值是0。子类一般都会重写该方法，而不是仅返回0。

个人感觉这个方法没啥大用。因为在复杂的I/O环境下，byte的个数是很难确定的，available()方法返回的值很可能是不准的。在API上也说到，这只是一个预估值，并不准确。另外API上还提到了这句话：

> Note that while some implementations of InputStream will return 
> the total number of bytes in the stream, many will not. It is never correct to 
> use the return value of this method to allocate a buffer intended to hold all 
> data in this stream. 
>
> 大意是：永远不要使用available()方法的返回值来初始一个用来承载所有I/O数据的数组。

因此下面的做法在实际项目中很可能会出问题：

```java
int a = System.in.available( );
byte[] b = new byte[a];
```

## 3.4 skip byte

## 3.6 marking and resetting

目前只有BufferedInputStream和ByteArrayInputStream支持mark操作。作者这里吐槽到：mark的相关方法居然定义在InputStream抽象类中，这样并不好。更好的做法是，声明一个接口，把mark相关方法放到接口中，那些支持mark操作的stream只需实现该接口即可。

## 3.8 一个stream copy的例子

```java
//把in的东西写入到out
public class StreamCopier {
  public static void main(String[] args) {
    try {
      copy(System.in, System.out);
    }
    catch (IOException ex) {
      System.err.println(ex);
    }
  }
  public static void copy(InputStream in, OutputStream out)
   throws IOException {
    byte[] buffer = new byte[1024];
    while (true) {
      int bytesRead = in.read(buffer);
      if (bytesRead == -1) break;
      out.write(buffer, 0, bytesRead);
    }
  }
}
```

# Chapter4

## 4.1 Reading Files

在使用file类时，如果是操纵项目子目录中的文件，则最好使用相对路径，而不是绝对路径，因为绝对路径是与平台绑定的。

```java
//这句可以获得项目所在根目录
//D:\workspace\eclipse4x\iobook1
System.getProperty("user.dir");
```



在创建FileInputStream对象时，最好以File作为形参，而不是以String作为形参。这样可以具有更强地跨平台性。

另外，最好不要硬编码路径，而应该像下面这样：

```
//当然，这还不是最好的做法，因为不支持windows平台
File[] roots = File.listRoots( )
File dir = new File(roots[0], "etc");
File child = new File(dir, "hosts");
FileInputStream fis = new FileInputStream(child);
```

## 4.2 Writing Files 

FileOutputStream真的支持追加模式的写入，只要在构造函数中把append设置为true即可。

```java
FileOutputStream fos = new FileOutputStream("resource/dest.txt", true);
```

## 4.3 例子

```java
import java.io.*;
import com.elharo.io.*;
public class FileDumper {
  public static final int ASC = 0;
  public static final int DEC = 1;
  public static final int HEX = 2;
  public static void main(String[] args) {
    if (args.length < 1) {
      System.err.println("Usage: java FileDumper [-ahd] file1 file2...");
      return;
    }
    int firstArg = 0;
    int mode = ASC;
    if (args[0].startsWith("-")) {
      firstArg = 1;
      if (args[0].equals("-h")) mode = HEX;
      else if (args[0].equals("-d")) mode = DEC;
    }
    for (int i = firstArg; i < args.length; i++) {
      try {
        if (mode == ASC) dumpAscii(args[i]);
        else if (mode == HEX) dumpHex(args[i]);
        else if (mode == DEC) dumpDecimal(args[i]);
      }
      catch (IOException ex) {
        System.err.println("Error reading from " + args[i] + ": "
         + ex.getMessage( ));
      }
      if (i < args.length-1) {  // more files to dump
        System.out.println("\r\n--------------------------------------\r\n");
      }
    }
  }
  public static void dumpAscii(String filename) throws IOException {
    FileInputStream fin = null;
    try {
      fin = new FileInputStream(filename);
      StreamCopier.copy(fin, System.out);
    }
    finally {
      if (fin != null) fin.close( );
    }
  }
  public static void dumpDecimal(String filename) throws IOException {
    FileInputStream fin = null;
    byte[] buffer = new byte[16];
    boolean end = false;
    try {
      fin = new FileInputStream(filename);
      while (!end) {
        int bytesRead = 0;
        while (bytesRead < buffer.length) {
          int r = fin.read(buffer, bytesRead, buffer.length - bytesRead);
          if (r == -1) {
            end = true;
            break;
          }
          bytesRead += r;
        }
        for (int i = 0; i < bytesRead; i++) {
          int dec = buffer[i];
          if (dec < 0) dec = 256 + dec;
          if (dec < 10) System.out.print("00" + dec + " ");
          else if (dec < 100) System.out.print("0" + dec + " ");
          else System.out.print(dec + " ");
        }
        System.out.println( );
      }
    }
    finally {
      if (fin != null) fin.close( );
    }
  }
  public static void dumpHex(String filename) throws IOException {
    FileInputStream fin = null;
    byte[] buffer = new byte[24];
    boolean end = false;
    try {
      fin = new FileInputStream(filename);
      while (!end) {
        int bytesRead = 0;
        while (bytesRead < buffer.length) {
          int r = fin.read(buffer, bytesRead, buffer.length - bytesRead);
          if (r == -1) {
            end = true;
            break;
          }
          bytesRead += r;
        }
        for (int i = 0; i < bytesRead; i++) {
          int hex = buffer[i];
          if (hex < 0) hex = 256 + hex;
          if (hex >= 16) System.out.print(Integer.toHexString(hex) + " ");
          else System.out.print("0" + Integer.toHexString(hex) + " ");
        }
        System.out.println( );
      }
    }
    finally {
      if (fin != null) fin.close( );
    }
  }
}
```

# Chapter5 网络

先学网络再看

# Chapter6 

## 6.1 Filter stream classes

```java
//又一种写法
public class StringExtractor {
  public static void main(String[] args) {
    if (args.length < 1) {
      System.out.println("Usage: java StringExtractor inFile");
      return;
    }
    try {
      InputStream in = new FileInputStream(args[0]);
      OutputStream out;
      if (args.length >= 2) {
        out = new FileOutputStream(args[1]);
      }
      else out = System.out;
      // Here's where the output stream is chained
      // to the ASCII output stream.
      PrintableOutputStream pout = new PrintableOutputStream(out);
      for (int c = in.read(); c != -1; c = in.read( )) {
          pout.write(c);
      }
      out.close( );
    }
    catch (FileNotFoundException e) {
      System.out.println("Usage: java StringExtractor inFile outFile");
    }
    catch (IOException ex) {
      System.err.println(ex);
    }
  }
}
```

## 6.2 粗略介绍FilterStream的子类

没啥东东。

## 6.3 Buffered Streams

文件buffer大小建议设置为：512byte < buffer < 8192byte。如果涉及到网络编程，最好把buffer设置的小一点，比如256byte。当然，最主要还是得看运行环境决定。

## 6.4 pushback

没啥用

## 6.5 ProgressMonitor

没啥用

## 6.6 Multitarget output stream





