# IO（0）IO类介绍

![InputStream 相关类层次结构](http://wx2.sinaimg.cn/mw690/0065Y1avgy1fcr65wt9oqj30v60740sy.jpg)

![ OutputStream 相关类层次结构](http://wx4.sinaimg.cn/mw690/0065Y1avgy1fcr660d0anj30uo0513ym.jpg)

## InputStream/OutputStream
InputStream/OutputStream类作为基类，描述了一个input stream/output stream应该提供什么什么样的接口功能，比如read()相关方法，write()相关方法，flush()，close()，mark/reset，available()相关方法等。一般我们很少会直接使用InputStream/OutputStream类，而是使用它的子类。

## FileInputStream/FileOutputStream
FileInputStream/FileOutputStream以文件作为数据源/目的地，把文件中的数据以byte的形式读到程序中（把数据以byte的形式写到文件中）***该类经常会用到！*

注意，FileOutputStream的构造函数有一个参数`boolean append`，它表示“追加模式”，默认为false，即“写到输出的流内容”不是以追加的方式添加到文件中。

```java
FileOutputStream(File file, boolean append);
FileOutputStream(String path, boolean append);
```

## ByteArrayInputStream/ByteArrayOutputStream
ByteArrayInputStream/ByteArrayOutputStream是InputStream/OutputStream的子类，并不是很常用。

对于ByteArrayInputStream来说，该类内部封装byte[]缓存数组。该类以内存中的数据作为数据源，把内存中的byte读到byte[]缓存数据中。严格来说，这个类和IO并没什么关系，只是方面我们用InputSream的方式来操作byte。ByteArrayOutputStream也类似。

## FilterInputStream/FilterOutputStream
用于对其他InputStream/OutputStream进行封装，以提供功能更为强大的read/write功能。一般我们不直接用它，而是用它的子类。

## ObjectInputStream/ObjectOutputStream
与序列化有关，比较少用。

## PipedInputStream/PipedOutputStream
与多线程有关，比较少用。

## BufferedInputStream/BufferedOutputStream
BufferedInputStream是FilterInputStream的子类，它内部持有一个InputStream的引用，在底层调用read时，本质上是调用InputStream的read方法，并在此基础上添加缓存功能。***该类经常会用到！***

BufferedOutputStream在内部同样维护了一个OutputStream和一个buf[]，在"适当条件"下，数据先被写入到buf中，当buf无法容纳更多数据时，则把buf中的内容flash到目的地。

## SocketInputStream/SocketOutputStream
对于SocketInputStream来说，它是FileInputStream的子类，他用于从网络接口中读取byte数据。无论是从网络还是文件，其实都是从一个URI地址中读取byte数据，所以本质上来说是一样的。SocketOutputStream类似。

## DataInputStream/DataOutputStream
读取/写入Java的基本数据类型，比如int，float，byte，char这些，比较少用。

## InflaterInputStream/ZipInputStream/ZipInputStream
InflaterInputStream和ZipInputStream用于压缩，ZipInputStream用于解压缩。比较少用。

## PrintStream
PrintStream的作用也是向目的地输出数据，其特别的地方是：对传统的OutputStream的输出功能进行增强：

1. 支持多种数据类型的输出
2. 支持格式化输出（类似于objc的NSLog）

也正是因为这些丰富的输出方式，才会把Write上升为Print。



![Writer 相关类层次结构](http://wx1.sinaimg.cn/mw690/0065Y1avgy1fcr660p6aqj30qa05b3yj.jpg)

![Reader 类层次结构](http://wx1.sinaimg.cn/mw690/0065Y1avgy1fcr660z3yej30qb05aq2z.jpg)


# 小结
基本上，日常上会用到的类包括：

* FileInputStream+BufferedInputStream
* SocketInputStream+BufferedInputStream

其他的，用到再研究吧。

