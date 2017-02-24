# IO（1）API分析 InputStream和OutputStream
## InputStream
### available()
```java
public int available() throws IOException;
```
该方法用于**预估**这个InputStream将会包含多少个byte，并把预估值返回。

注意，不建议使用这个预估值来初始化一个byte[]数组,用于存储这个Stream的byte，因为这只是**预估值**！

如果Stream已经close了，则该方法会抛出IOException。对于InputStream的实例对象来说，该方法永远返回0，一般我们都会在InputStream的子类中重写该方法。

这个方法不会造成阻塞。

当reaches the end of the input steam，则该方法返回0。冲下面的例子可以看出，每read()一次， available()的byte个数就会减1，最后一次read()后，available()会判断出，没有更多的byte可读了，所以返回0。


```java
public static void fileAnalyze2() throws Exception {
	FileInputStream fis = new FileInputStream("D:/workspace/eclipse4x/io2/bin/resources/utf8_en_short.txt");
	for(int i=0; i<26; i++) {
		System.out.println("char="+(char)fis.read());
		System.out.println("available="+fis.available());
	}
}
//打印结果
char=a
available=25
char=b
available=24
char=c
available=23
char=d
available=22
char=e
available=21
char=f
available=20
char=g
available=19
char=h
available=18
char=i
available=17
char=j
available=16
char=k
available=15
char=l
available=14
char=m
available=13
char=n
available=12
char=o
available=11
char=p
available=10
char=q
available=9
char=r
available=8
char=s
available=7
char=t
available=6
char=u
available=5
char=v
available=4
char=w
available=3
char=x
available=2
char=y
available=1
char=z
available=0
```

### read()
```java
public abstract int read() throws IOException;
```

读取input stream中的下一个byte，并返回这个byte。由于一个byte占8个bit，而一个int占等于4个byte，所以返回一个int值是完全足以容纳byte的，并且这个返回值肯定在0~255之间（8个bit，2的八次幂）。

当读到文件的末尾时，该方法返回-1。

改方法会造成阻塞，直到下一个byte available，或者读到文件末尾，或者抛出异常。


### read(byte[] b,int off,int len)
```java
public int read(byte[] b,int off,int len) throws IOException;
```

该方法会把**至多**len个byte从input stream中读取出来，并保存到b数组中。

**至多**的概念：假设input stream包含26个byte，而len=26，则会读取26个byte存储到b数组中。如果len=30，则len>input stream byte，则实际上读到的还是26个byte。所以len必须大于/等于input stream byte，不然无法完整读取input stream。此外，len必须大于/等于b.length，不然有可能会b数组太小，无法容纳读到的byte。一般来说，b.length = len。

这个方法会造成阻塞，直到预期想要读的byte都已经读取完毕，或者到达文件末尾，或者抛出异常。

该方法底层实际上会循环调用read()方法，如果第一次调用read()时就抛出异常，则整个方法抛出异常。如果在菲第一次调用read()时抛出异常，则整个方法抛出异常，并且不再继续读取，b数组中保存着抛出异常前已经读到的byte，方法返回值是已经读到的b.length。

参数：b数组用于存储读到的byte，数组长度应该至少等于length。off表示读取到的第一个byte保存在数组b的第off个位置，一般设置off=0，即让byte从b数组头部开始填充。len表示**至多**要从input stream中读取len个byte。如果len=0，则该方法返回0。

返回值：返回实际读到的byte个数，如果已经到达文件末尾，则返回-1。

### read(byte[] b)
```java
public int read(byte[] b) throws IOException
```
该方法会把**至多**b.length个byte从input stream中读取出来，并保存到b数组中。其等价于调用` read(b, 0, b.length)`。

### markSupported()
```java
public boolean markSupported();
```

判断这个input stream是否支持mark和reset操作。InputStream不支持mark和reset，所以该方法返回false。我们可以让InputStream的子类支持mark和reset。

### mark(int readlimit)
```java
public void mark(int readlimit)
```

该方法用于在input stream中的某个mark标记一下，接下来在调用reset()方法时，在回到当初mark的位置，重新读取byte。

readlimit参数在官方文档上解释为：从最后一次调用mark()，到调用reset()方法之间，如果读到的byte个数（假设等于count），大于readlimit，则mark和reset无效，并且会抛出异常。但实际测试的结果是，只要count值小于/等于input stream内部的缓存数组length，即缓存数组能容纳这么多个count，则mark/reset操作依然有效，不会受到readlimit限制。只有当内部缓存数组无法容纳count个byte时，mark/reset操作才会失败。因此readlimit严格来说，并没什么用。参考：[BufferedInputStream类mark(int readlimit)中readlimit的确切含义](http://blog.csdn.net/hui12343211/article/details/14166327)

### reset()
```java
public void reset() throws IOException
```

reset方法会把指针定位到最后一次mark的地方，然后从mark的下一个byte开始，接着读取byte。比如字符串"abcdefgh"，在读取c之后，mark了一次，接着读取f之后执行reset，则最终读取结果是"abcdefdefgh"。

### close()
```java
public void close() throws IOException
```

该方法会关闭input stream并释放相关资源。InputStream的close()方法啥也没做，是一个空方法。

### skip(long n)
```java
public long skip(long n) throws IOException;
```

该方法用于在读取byte的过程中跳过n个byte，n就是传入的参数，方法返回值是实际跳过的byte个数。如果传入的参数n比实际剩余的byte要多，则只会跳过实际剩余的byte个数。

该方法的底层实际上也维护了一个byte[]数组，被skip掉的byte实际上被保存到了这个数组中。

```java
String content = "abcdefghijk";  
InputStream is = new ByteArrayInputStream(content.getBytes());  
		  
System.out.print((char)is.read()); //a
System.out.println((char)is.read()); //b
System.out.println("skip="+is.skip(3)); 
byte[] b = new byte[is.available()];
is.read(b);
		
for(int i=0;i<b.length;i++) {
	System.out.print((char)b[i]); //fghijk
}
```

## OutputStream
# IO（3）学习OutputStream

### flush
```java
public void flush() throws IOException
```

flash方法用于把目前存在于缓存中的byte强制写到目的地中。该方法只负责通知底层进行写入操作，但具体是否写入成功，flush并不关心。OutputStream中的flush是个空方法，原因和简单因为OutputStream本身并不带有缓存。

### write(int b)
```java
public abstract void write(int b) throws IOException
```

该方法会把一个byte写入到目的地。注意，方法参数是int，一个int的长度是4个byte。所以，在执行写入操作时，只会写入int的低8位(eight low-order bits)，而忽略掉剩下的24bit(24 high-order bits)。该方法在OutputStream是一个抽象方法，子类必须提供实现。

### write(byte[] b)
```java
public void write(byte[] b) throws IOException
```

该方法会把b数组中的byte都写入到目的地。其内部会转调`write(b, 0, b.length)`。

### write(byte b[], int off, int len)
```java
public void write(byte b[], int off, int len) throws IOException 
```

该方法会尝试把b[]数组中，"至多"len个byte写入到目的地。其内部会循环调用`write(int b)`。b用于存储"源数据"。off表示从b中的第off个位置开始write数据。length表示至多写入多少个byte。

### close()
```java
public void close() throws IOException
```

该方法用于关闭输出流，并释放相关资源。一个已经被关闭的输出流无法再执行流操作，也无法重新打开流。OutputStream中的close()是空方法。
