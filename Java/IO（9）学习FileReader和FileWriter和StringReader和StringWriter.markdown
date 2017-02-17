# IO（9）学习FileReader和FileWriter和StringReader和StringWriter
## FileReader和FileWriter
这个两个非常非常简单！FileReader是InputStreamReader的子类，它使用InputStreamReader默认的编码格式（.java文件的编码格式）以及InputStreamReader默认大小的缓冲区，对文件进行字符流读取操作。

FileWriter是OutputStreamWriter的子类，它使用OutputStreamWriter默认的编码格式（.java文件的编码格式）以及OutputStreamWriter默认大小的缓冲区，把字符流写入到文件中。

源码非常简单：

```java
public class FileReader extends InputStreamReader {
    public FileReader(String fileName) throws FileNotFoundException {
        super(new FileInputStream(fileName));
    }

    public FileReader(File file) throws FileNotFoundException {
        super(new FileInputStream(file));
    }

    public FileReader(FileDescriptor fd) {
        super(new FileInputStream(fd));
    }
}

public abstract class Writer implements Appendable, Closeable, Flushable {
    private char[] writeBuffer;

    private final int writeBufferSize = 1024;

    protected Object lock;

    protected Writer() {
        this.lock = this;
    }

    protected Writer(Object lock) {
        if (lock == null) {
            throw new NullPointerException();
        }
        this.lock = lock;
    }

    public void write(int c) throws IOException {
        synchronized (lock) {
            if (writeBuffer == null){
                writeBuffer = new char[writeBufferSize];
            }
            writeBuffer[0] = (char) c;
            write(writeBuffer, 0, 1);
        }
    }

    public void write(char cbuf[]) throws IOException {
        write(cbuf, 0, cbuf.length);
    }

    abstract public void write(char cbuf[], int off, int len) throws IOException;

    public void write(String str) throws IOException {
        write(str, 0, str.length());
    }

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

    public Writer append(CharSequence csq) throws IOException {
        if (csq == null)
            write("null");
        else
            write(csq.toString());
        return this;
    }

    public Writer append(CharSequence csq, int start, int end) throws IOException {
        CharSequence cs = (csq == null ? "null" : csq);
        write(cs.subSequence(start, end).toString());
        return this;
    }

    public Writer append(char c) throws IOException {
        write(c);
        return this;
    }

    abstract public void flush() throws IOException;

    abstract public void close() throws IOException;

}
```

## StringReader
StringReader本身并不涉及外部设备的IO，它只是允许大家使用IO操作的方式，把一个字符串解析成字符数组，它本身也支持mark/reset操作。

## StringReader源码分析
```java
public class StringReader extends Reader {

	//内部维护一个需要解析的字符串
    private String str;
    private int length;
    private int next = 0;
    private int mark = 0;

	//构造函数，传入一个需要解析的字符串
    public StringReader(String s) {
        this.str = s;
        this.length = s.length();
    }

    private void ensureOpen() throws IOException {
        if (str == null)
            throw new IOException("Stream closed");
    }

    //读取一个字符，则直接用charAt方法
    public int read() throws IOException {
        synchronized (lock) {
            ensureOpen();
            if (next >= length)
                return -1;
            return str.charAt(next++);
        }
    }

    //通过getChars方法把字符串解析char数组，再把char数组保存到cbuf[]中
    public int read(char cbuf[], int off, int len) throws IOException {
        synchronized (lock) {
            ensureOpen();
            if ((off < 0) || (off > cbuf.length) || (len < 0) ||
                ((off + len) > cbuf.length) || ((off + len) < 0)) {
                throw new IndexOutOfBoundsException();
            } else if (len == 0) {
                return 0;
            }
            if (next >= length)
                return -1;
            int n = Math.min(length - next, len);
            str.getChars(next, next + n, cbuf, off); //把字符串解析为char数组，再保存到cbuf[]中
            next += n;
            return n;
        }
    }

    public long skip(long ns) throws IOException {
        synchronized (lock) {
            ensureOpen();
            if (next >= length)
                return 0;
            // Bound skip by beginning and end of the source
            long n = Math.min(length - next, ns);
            n = Math.max(-next, n);
            next += n;
            return n;
        }
    }

    public boolean ready() throws IOException {
        synchronized (lock) {
        ensureOpen();
        return true;
        }
    }

    public boolean markSupported() {
        return true;
    }

    public void mark(int readAheadLimit) throws IOException {
        if (readAheadLimit < 0){
            throw new IllegalArgumentException("Read-ahead limit < 0");
        }
        synchronized (lock) {
            ensureOpen();
            mark = next;
        }
    }

    public void reset() throws IOException {
        synchronized (lock) {
            ensureOpen();
            next = mark;
        }
    }

    public void close() {
        str = null;
    }
}
```

## StringWriter
StringWriter可以让我们把字符、字符数组、字符串写入到写入到StringWriter内部维护的一个StringBuffer中。StringWriter本身也不涉及I/O操作，它只是提供类似I/O的方式，然我们把字符/字符串转化为StringBuffer，因此，调用它的close()并没有任何效果，即使close()后依然可以调用它的write方法。

## StringWriter源码分析
StringWriter的close()方法和flush()方法都是空方法。StringWriter有两个与写入相关的方法：write和append方法，wite方法内部调用StringBuffer的append方法，实现往StringBuffer中追加内容。而append方法则转调write方法。

```java
public class StringWriter extends Writer {
	
	//内部持有一个StringBuffer，这个StringBuffer就是输出目的地
    private StringBuffer buf;

    public StringWriter() {
        buf = new StringBuffer();
        lock = buf;
    }

    //构造函数，设置StringBuffer的初始容量
    public StringWriter(int initialSize) {
        if (initialSize < 0) {
            throw new IllegalArgumentException("Negative buffer size");
        }
        buf = new StringBuffer(initialSize);
        lock = buf;
    }

    //转调StringBuffer.append()
    public void write(int c) {
        buf.append((char) c);
    }

    //转调StringBuffer.append()
    public void write(char cbuf[], int off, int len) {
        if ((off < 0) || (off > cbuf.length) || (len < 0) ||
            ((off + len) > cbuf.length) || ((off + len) < 0)) {
            throw new IndexOutOfBoundsException();
        } else if (len == 0) {
            return;
        }
        buf.append(cbuf, off, len);
    }

    //转调StringBuffer.append()
    public void write(String str) {
        buf.append(str);
    }

    //转调StringBuffer.append()
    public void write(String str, int off, int len)  {
        buf.append(str.substring(off, off + len));
    }

    //转调write方法
    public StringWriter append(CharSequence csq) {
        if (csq == null)
            write("null");
        else
            write(csq.toString());
        return this;
    }

    //转调write方法
    public StringWriter append(CharSequence csq, int start, int end) {
        CharSequence cs = (csq == null ? "null" : csq);
        write(cs.subSequence(start, end).toString());
        return this;
    }

    //转调write方法
    public StringWriter append(char c) {
        write(c);
        return this;
    }

    public String toString() {
        return buf.toString();
    }

    public StringBuffer getBuffer() {
        return buf;
    }

	//空方法
    public void flush() {
    }

	//空方法
    public void close() throws IOException {
    }
}
```


