# IO（6）学习FileDescriptor
## FileDescriptor的定义

> Instances of the file descriptor class serve as an opaque handle to the underlying machine-specific structure representing an open file, an open socket, or another source or sink of bytes. The main practical use for a file descriptor is to create a FileInputStream or FileOutputStream to contain it. 

> Applications should not create their own file descriptors. 

FileDescriptor表示一个“开放的文件”、“开发的socket”。FileDescriptor的主要用于是创建一个FileInputScream或者从一个FileOutputStream中获取对应的FileDescriptor。

最后一句最重要：应用程序不应该创建他们的file descriptors。

```java
//FileOutputStream源代码
public
class FileOutputStream extends OutputStream {
    //通过FileDescriptor构造FileOutputStream
    public FileOutputStream(FileDescriptor fdObj) {
            SecurityManager security = System.getSecurityManager();
        if (fdObj == null) {
            throw new NullPointerException();
        }
        if (security != null) {
            security.checkWrite(fdObj);
        }
        this.fd = fdObj;
        this.path = null;
        this.append = false;
    
        fd.incrementAndGetUseCount();
    }   
    
    //获取FileOutputStream对应的FileDescriptor
    public final FileDescriptor getFD()  throws IOException {
        if (fd != null) return fd;
        throw new IOException();
     }
}
```

## FileDescriptor源码分析和应用
虽然我们在程序中一般不会直接用到FileDescriptor。但还是有必要了解FileDescriptor的应用场景。在JDK中一般不会单独使用FileDescriptor，而是要与FileInputStream/FileOutputStream结合使用。先来看看FileDescriptor的源代码：

```java
public final class FileDescriptor {

	/*
	0表示标准输入
	1表示标准输出
	2表示标准错误输出
	*/
    private int fd;

    private long handle;

    private AtomicInteger useCount;
	
	//标准输入的描述符（一般是键盘）
	public static final FileDescriptor in = standardStream(0);

    //标准输出的描述符（一般是屏幕/控制台）
    public static final FileDescriptor out = standardStream(1);

    //标准错误输出的描述符（一般是屏幕/控制台）
    public static final FileDescriptor err = standardStream(2);
	
	//工厂方法
	private static FileDescriptor standardStream(int fd) {
        FileDescriptor desc = new FileDescriptor();
        desc.handle = set(fd);
        return desc;
    }
}
```

一般我们不会直接new创建一个FileDescriptor，而是通过直接访问成员变量的形式创建3种类型的描述符：

```java
FileDescriptor in = FileDescriptor.in;
FileDescriptor out = FileDescriptor.out;
FileDescriptor err = FileDescriptor.err;
```

然后通过他们来创建FileInputStream、FileOutputStream对象：

```java
FileOutputStream fosOut = new FileOutputStream(out);
fosOut.write((byte)65); //在控制台打印A
FileOutputStream fosErr = new FileOutputStream(err);
fosErr.write((byte)66); //在控制台打印B
```

从上面的例子可以看出，当使用FileDescriptor来创建FileInputStream/FileOutputStream时，输入源可以不再是文件，而是键盘，而输出目的地可以不再是文件，而是屏幕。对于计算机来说，标准输入一般就是键盘，而标准输出则是屏幕。

**因此，FileDescriptor最主要的应用场景就是和FileInputStream/FileOutputStream结合使用，实现把键盘作为数据源接收数据，以及把屏幕作为输出目的地，向目的地写入数据。**

### hello world
```java
System.out.println("hello world");
```

我们经常会使用上面的语句在控制台打印信息。它背后的原理到底是什么呢？对比一下前面的FileDescriptor，我们发现两者都可以像屏幕/控制台写入数据，不妨来研究一下System类的源代码：

```java
//System.java
public final class System {
	public final static InputStream in = null; //输入流
	public final static PrintStream out = null; //输出流
	public final static PrintStream err = null; //错误信息的输出流
	
	private static void initializeSystemClass() {

        props = new Properties();
        initProperties(props);  // initialized by the VM

        sun.misc.VM.saveAndRemoveProperties(props);


        lineSeparator = props.getProperty("line.separator");
        sun.misc.Version.init();

        FileInputStream fdIn = new FileInputStream(FileDescriptor.in);
        FileOutputStream fdOut = new FileOutputStream(FileDescriptor.out); //line1
        FileOutputStream fdErr = new FileOutputStream(FileDescriptor.err);
        setIn0(new BufferedInputStream(fdIn));
        setOut0(new PrintStream(new BufferedOutputStream(fdOut, 128), true)); //line2
        setErr0(new PrintStream(new BufferedOutputStream(fdErr, 128), true));

        loadLibrary("zip");

        Terminator.setup();

        sun.misc.VM.initializeOSEnvironment();
		
        Thread current = Thread.currentThread();
        current.getThreadGroup().add(current);

        setJavaLangAccess();
        sun.misc.VM.booted();
    }
}
```
在System类中，in成员变量是一个InputStream，out和err成员变量都是PrintStream。line1通过`FileDescriptor.out`创建了一个目的地为屏幕的FileOutputStream，而line2则对FileOutputStream进一步封装，形成支持多种数据类型的PrintStream。

所以System.out获得的是一个可以向屏幕写入内容的PrintStream对象，而println()方法就是PrintStream类提供的输出方法，底层实质还是调用write方法。我们也可以使用write、print、println、printf、format、append方法向屏幕写入内容。

因此从本质上来说，`System.out.println()`在底层使用`FileDescriptor.out`，创建了一个可以向屏幕写入内容的PrintStream，并利用PrintStream丰富的方法，实现各种数据类型的输出打印。
