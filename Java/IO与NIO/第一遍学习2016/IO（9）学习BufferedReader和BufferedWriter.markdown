# IO（9）学习BufferedReader和BufferedWriter
## BufferedReader
BufferedReader是Reader的子类，它内部维护了一个Reader，并为这个Reader在进行Read操作时提供缓存功能。此外，它也能支持mark/reset操作。它还提供readLine()方法，让我们可以读取一整行字符，具体是使用`System.getProperties("line.separator")`来判断换行符，因为不同操作系统的换行符不一样。

BufferedReader经常用来封装InputStreamReader和FileReader，以实现更高效地字符读取操作。

## BufferedReader的缓存机制
BufferedReader的缓存机制与BufferedInputStream非常类似。BufferedReader在内部维护了一个char[]数组作为缓冲区，如果缓冲区的可用大小足以容纳客户端传进来的char[]数组，那么BufferedInputStream会先把char读取到缓冲区，再执行数组拷贝，把缓冲区的数据拷贝到客户端的char[]数组。如果缓冲区的可用大小无法容纳客户端传进来的char[]，那么BufferedInputStream会直接把读到的char数据保存到客户端传进来的char[]数组中，而不再利用缓冲区。

## BufferedWriter
BufferedWriter是Writer的子类，它内部维护了一个Writer，并未这个Writer在进行write操作时提供缓存功能。此外，他还提供了newLine()方法，根据不同的操作系统，像目的地写入一个换行符。

BufferedWriter经常用来封装OutputStreamWriter和FileWriter，以实现更高效地写入字符操作。

## BufferedWriter的缓存机制
BufferedWr了iter的缓存机制与BufferedOutputStream非常类似。BufferedWriter内部维护了一个char[]数组作为缓冲区，如果缓冲区的可用大小足以容纳客户端传入的char[]数组，那么BufferedWriter会先把客户端的数组拷贝到缓冲区，在对缓冲区执行write操作。如果缓冲区的可用大小无法容纳客户端传入的char[]数组，那么BufferedWriter会直接把客户端传入的数组直接write到目的地，而不使用缓冲区。

```java
public class BufferedWriter extends Writer {

	//内部持有一个Writer
    private Writer out; 

	//缓冲区
    private char cb[];
    private int nChars, nextChar; //记录缓冲区中index的位置

	//缓冲区默认大小
    private static int defaultCharBufferSize = 8192;

    //换行符
    private String lineSeparator;

    //构造函数
    public BufferedWriter(Writer out) {
        this(out, defaultCharBufferSize);
    }

    //构造函数
    public BufferedWriter(Writer out, int sz) {
        super(out);
        if (sz <= 0)
            throw new IllegalArgumentException("Buffer size <= 0");
        this.out = out;
        cb = new char[sz];
        nChars = sz;
        nextChar = 0;

        lineSeparator = java.security.AccessController.doPrivileged(
            new sun.security.action.GetPropertyAction("line.separator"));
    }

    /** Checks to make sure that the stream has not been closed */
    private void ensureOpen() throws IOException {
        if (out == null)
            throw new IOException("Stream closed");
    }

    //只有当缓冲区里有数据时，才执行flash操作(缓冲区的数据写入到目的地的)
    void flushBuffer() throws IOException {
        synchronized (lock) {
            ensureOpen();
            if (nextChar == 0)
                return;
            out.write(cb, 0, nextChar);
            nextChar = 0;
        }
    }

    //写入一个char，直接往缓冲区里写即可
    public void write(int c) throws IOException {
        synchronized (lock) {
            ensureOpen();
            if (nextChar >= nChars)
                flushBuffer();
            cb[nextChar++] = (char) c;
        }
    }

    /**
     * Our own little min method, to avoid loading java.lang.Math if we've run
     * out of file descriptors and we're trying to print a stack trace.
     */
    private int min(int a, int b) {
        if (a < b) return a;
        return b;
    }

	//写入一个char[]数组
    public void write(char cbuf[], int off, int len) throws IOException {
        synchronized (lock) {
            ensureOpen();
			//非法参数检查
            if ((off < 0) || (off > cbuf.length) || (len < 0) ||
                ((off + len) > cbuf.length) || ((off + len) < 0)) {
                throw new IndexOutOfBoundsException();
            } else if (len == 0) {
                return;
            }
			
			//如果缓冲区不足以容纳cbuf[]
            if (len >= nChars) {
                /* If the request length exceeds the size of the output buffer,
                   flush the buffer and then write the data directly.  In this
                   way buffered streams will cascade harmlessly. */
                flushBuffer(); //flash缓冲区如果缓冲区满了
                out.write(cbuf, off, len); //把客户端传入的cbuf[]数组直接写入到目的地
                return;
            }

            int b = off, t = off + len;
            while (b < t) { //如果缓冲区可以容纳cbuf[]
                int d = min(nChars - nextChar, t - b);
                System.arraycopy(cbuf, b, cb, nextChar, d); //把cbuf[]的数据拷贝到缓冲区
                b += d;
                nextChar += d;
                if (nextChar >= nChars) //flash缓冲区如果缓冲区满了
                    flushBuffer(); 
            }
        }
    }

	//接收String作为参数
    public void write(String s, int off, int len) throws IOException {
        synchronized (lock) {
            ensureOpen();

            int b = off, t = off + len;
            while (b < t) {
                int d = min(nChars - nextChar, t - b);
                s.getChars(b, b + d, cb, nextChar); //把s转为char[]，并保存到缓冲区中
                b += d;
                nextChar += d;
                if (nextChar >= nChars) //flash缓冲区如果缓冲区满了
                    flushBuffer(); 
            }
        }
    }

	//写入一个换行符
    public void newLine() throws IOException {
        write(lineSeparator);
    }

    public void flush() throws IOException {
        synchronized (lock) {
            flushBuffer();
            out.flush();
        }
    }

    public void close() throws IOException {
        synchronized (lock) {
            if (out == null) {
                return;
            }
            try {
                flushBuffer();
            } finally {
                out.close();
                out = null;
                cb = null;
            }
        }
    }
}
```



