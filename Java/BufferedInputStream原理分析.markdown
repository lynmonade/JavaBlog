# BufferedInputStream原理分析

BufferedInputStream内部有一个缓存byte数组：buf。BufferedInputStream之所以效率较高，是因为在适当条件下，它可以从缓存数组中读取数据，而无需再次去IO磁盘。

BufferedInputStream在IO时，也是调用`public synchronized int read(byte b[], int off, int len)`方法：

```java
public synchronized int read(byte b[], int off, int len)
    throws IOException
{
    getBufIfOpen(); // Check for closed stream
    if ((off | len | (off + len) | (b.length - (off + len))) < 0) {
        throw new IndexOutOfBoundsException();
    } else if (len == 0) {
        return 0;
    }

    int n = 0;
    for (;;) {
        int nread = read1(b, off + n, len - n); //内部实际转调read1()方法
        if (nread <= 0)
            return (n == 0) ? nread : n;
        n += nread;
        if (n >= len)
            return n;
        // if not closed but no bytes available, return
        InputStream input = in;
        if (input != null && input.available() <= 0)
            return n;
    }
}
```

上面的`read`方法实际上会转调`read1()`方法：

```java
private int read1(byte[] b, int off, int len) throws IOException {
    int avail = count - pos;
    if (avail <= 0) { //buffer不符合要求，则只能从磁盘读取byte
        /* If the requested length is at least as large as the buffer, and
           if there is no mark/reset activity, do not bother to copy the
           bytes into the local buffer.  In this way buffered streams will
           cascade harmlessly. */
        if (len >= getBufIfOpen().length && markpos < 0) {
            return getInIfOpen().read(b, off, len); //从磁盘读取byte
        }
        fill(); //从磁盘读取byte，同时也把byte写入到buf缓存数组中，供下一次使用
        avail = count - pos;
        if (avail <= 0) return -1;
    }
    int cnt = (avail < len) ? avail : len;
    System.arraycopy(getBufIfOpen(), pos, b, off, cnt); //如果buffer符合要求，则直接把buf缓存中的字节数组copy到byte[] b中，而无需从磁盘读byte，以提高效率
    pos += cnt;
    return cnt;
}

private void fill() throws IOException {
    byte[] buffer = getBufIfOpen(); //获取buf缓存数组
    if (markpos < 0)
        pos = 0;            /* no mark: throw away the buffer */
    else if (pos >= buffer.length)  /* no room left in buffer */
        if (markpos > 0) {  /* can throw away early part of the buffer */
            int sz = pos - markpos;
            System.arraycopy(buffer, markpos, buffer, 0, sz);
            pos = sz;
            markpos = 0;
        } else if (buffer.length >= marklimit) {
            markpos = -1;   /* buffer got too big, invalidate mark */
            pos = 0;        /* drop buffer contents */
        } else if (buffer.length >= MAX_BUFFER_SIZE) {
            throw new OutOfMemoryError("Required array size too large");
        } else {            /* grow buffer */
            int nsz = (pos <= MAX_BUFFER_SIZE - pos) ?
                    pos * 2 : MAX_BUFFER_SIZE;
            if (nsz > marklimit)
                nsz = marklimit;
            byte nbuf[] = new byte[nsz];
            System.arraycopy(buffer, 0, nbuf, 0, pos);
            if (!bufUpdater.compareAndSet(this, buffer, nbuf)) {
                // Can't replace buf if there was an async close.
                // Note: This would need to be changed if fill()
                // is ever made accessible to multiple threads.
                // But for now, the only way CAS can fail is via close.
                // assert buf == null;
                throw new IOException("Stream closed");
            }
            buffer = nbuf;
        }
    count = pos;
    int n = getInIfOpen().read(buffer, pos, buffer.length - pos); //从磁盘中读byte，并把byte保存到buf缓存数组中，这样下次就能使用buf数组啦。
    if (n > 0)
        count = n + pos;
}
```

# 小结
大致思路如下：BufferedInputStream内部有一个byte[]数组作为缓存，当第一次执行read()时，会把read到的byte写入到byte[]缓存数组中。下一次再次执行IO时，如果byte[]缓存数组满足要求，则直接从byte[]缓存数组中读取数据，无需再IO磁盘去执行read了。

其实，这个思路与InputStream中，通过执行`read(byte b[], int off, int len)`的思路是一样的，我们需要传入一个`byte[] b`数组作为缓存，让read方法把byte写入到byte b[]中。而BufferedInputStream则直接把byte[]数组作为成员变量，让其一直存在，下一次再次使用BufferedInputStream进行read操作时，就有可能复用成员变量中缓存的数据。

