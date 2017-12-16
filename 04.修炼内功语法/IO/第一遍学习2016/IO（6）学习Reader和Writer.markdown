# IO（7）学习Reader和Writer
## Reader
Reader是所有和输入字符流相关的类的基类。他提供了从数据源读取字符流的read方法。一般我们不直接使用Reader类，而是使用它的子类。它的子类必须实现`read(char[], int, int)`方法和`close()`方法。

Reader的read是按照字符char来读取数据，而InputStream则是按照byte来读取数据，这是最大的区别。

Reader的源码比较简单，就不分析了。

## Writer
Writer是所有和输入字符流相关的类的基类。他提供了像目的地写入字符流的writer方法。一般我们不直接使用Writer类，而是使用它的子类。它的子类必须实现`write(char[], int, int)`方法、`flush()`方法和`close()`方法。

### Writer源码分析
```java
public abstract class Writer implements Appendable, Closeable, Flushable {
	//缓冲区
	private char[] writeBuffer;

	//缓冲区默认大小
    private final int writeBufferSize = 1024;

    //内部维护的一个OutputStream对象
    protected Object lock;
	
	/*
	写入一个char，则直接把char先放入缓冲区，再把缓冲区数组写入到目的地
	*/
	public void write(int c) throws IOException {
        synchronized (lock) {
            if (writeBuffer == null){
                writeBuffer = new char[writeBufferSize];
            }
            writeBuffer[0] = (char) c; //把char放入缓冲区
            write(writeBuffer, 0, 1); //把缓冲区数组写入到目的地
        }
    }

    //间接调用
    public void write(char cbuf[]) throws IOException {
        write(cbuf, 0, cbuf.length);
    }

    //由子类提供实现
    abstract public void write(char cbuf[], int off, int len) throws IOException;

    //间接调用
    public void write(String str) throws IOException {
        write(str, 0, str.length());
    }

    /*
	  这个方法中，缓冲区实际上是cbuf[]
	  1.1 如果缓冲区可以容纳str，则把str转为char数组，再放入缓冲区中
	  1.2 如果缓冲区不能容纳str，则以str.len为长度，创建一个新的char[]作为缓冲区，再把str放进去
	  2. 最终再把缓冲区写入到目的地
	*/
    public void write(String str, int off, int len) throws IOException {
        synchronized (lock) {
            char cbuf[];
            if (len <= writeBufferSize) {
                if (writeBuffer == null) {
                    writeBuffer = new char[writeBufferSize];
                }
                cbuf = writeBuffer;
            } else {    // Don't permanently allocate very large buffers.
                cbuf = new char[len];
            }
            str.getChars(off, (off + len), cbuf, 0);
            write(cbuf, 0, len);
        }
    }

    //append本质上还是调用write
    public Writer append(CharSequence csq) throws IOException {
        if (csq == null)
            write("null");
        else
            write(csq.toString());
        return this;
    }

    //append本质上还是调用write
    public Writer append(CharSequence csq, int start, int end) throws IOException {
        CharSequence cs = (csq == null ? "null" : csq);
        write(cs.subSequence(start, end).toString());
        return this;
    }

    //append本质上还是调用write
    public Writer append(char c) throws IOException {
        write(c);
        return this;
    }

    //由子类提供实现
    abstract public void flush() throws IOException;

    //由子类提供实现
    abstract public void close() throws IOException;
}
```

## 小结
虽然Reader和Writer操纵的是字符char，但在底层，实质上还是使用字节流进行读取/写入数据。当获取到字节数组后，再根据编码格式把字节数组拼成字符。
