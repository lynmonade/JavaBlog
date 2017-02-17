# IO（3）学习OutputStream

## flush
```java
public void flush() throws IOException
```

flash方法用于把目前存在于缓存中的byte强制写到目的地中。该方法只负责通知底层进行写入操作，但具体是否写入成功，flush并不关心。OutputStream中的flush是个空方法，原因和简单因为OutputStream本身并不带有缓存。

## write(int b)
```java
public abstract void write(int b) throws IOException
```

该方法会把一个byte写入到目的地。注意，方法参数是int，一个int的长度是4个byte。所以，在执行写入操作时，只会写入int的低8位(eight low-order bits)，而忽略掉剩下的24bit(24 high-order bits)。该方法在OutputStream是一个抽象方法，子类必须提供实现。

## write(byte[] b)
```java
public void write(byte[] b) throws IOException
```

该方法会把b数组中的byte都写入到目的地。其内部会转调`write(b, 0, b.length)`。

## write(byte b[], int off, int len)
```java
public void write(byte b[], int off, int len) throws IOException 
```

该方法会尝试把b[]数组中，"至多"len个byte写入到目的地。其内部会循环调用`write(int b)`。b用于存储"源数据"。off表示从b中的第off个位置开始write数据。length表示至多写入多少个byte。

## close()
```java
public void close() throws IOException
```

该方法用于关闭输出流，并释放相关资源。一个已经被关闭的输出流无法再执行流操作，也无法重新打开流。OutputStream中的close()是空方法。