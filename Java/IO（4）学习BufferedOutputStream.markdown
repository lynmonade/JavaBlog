# IO（4）学习BufferedOutputStream
BufferedOutputStream是FilterOutputStream的子类，它继承了FilterOutputStream的工作模式，在内部维护了一个OutputStream作为成员变量。

## 缓存机制
BufferedOutputStream内部维护了一个byte buf[]数组，默认大小为8M，作为缓存数组。在**“适当条件”**下，程序会先把客户端b数组的数据并填充到buf[]中，当buf[]装满、或者已容不下b数组的数据时，则执行flush操作，把buf中的数据写入到目的地，接着在把b中下一批数据写入到buf中，以此循环直到没有更多的数据需要写入。

![缓存执行流程](http://wx4.sinaimg.cn/mw690/0065Y1avgy1fcrg9ep535j30ly0cct9p.jpg)


## 源码分析
```java
public class BufferedOutputStream extends FilterOutputStream {
    
	//缓冲区数组
    protected byte buf[];

    //已经被写入到缓冲区中的byte个数
    protected int count;

	/*
	  write入口方法
	*/
	public synchronized void write(byte b[], int off, int len) throws IOException {
		//如果b比buf要大
		if (len >= buf.length) { 
			/* If the request length exceeds the size of the output buffer,
			   flush the output buffer and then write the data directly.
			   In this way buffered streams will cascade harmlessly. */
			flushBuffer(); //flush缓冲区（如果有数据的话）
			out.write(b, off, len); //把b中的数据直接写入到目的地，而不经过缓冲区，因为缓冲区装不下b
			return;
		}
		
		//如果缓冲区的剩余未用空间小于"至多"要写入的byte个数，则先flush缓冲区
		if (len > buf.length - count) { 
			flushBuffer(); //把缓冲区中的数据写入到目的地
		}
		System.arraycopy(b, off, buf, count, len); //执行数组拷贝，把b数组拷贝到缓冲区
		count += len;
	}
	
	 //把缓冲区中的数据写入到目的地
	 private void flushBuffer() throws IOException {
        if (count > 0) { //如果缓冲区有数据，才会把缓冲区的数据写入到目的地，否则啥也不做
            out.write(buf, 0, count);
            count = 0; //写入到目的地后，缓冲区的有效byte个数为0。
        }
    }
    
    //flash()方法内部会转调flushBuffer()，把当前buf中的内容写入到目的地。
    //此外，因为BufferedOutputStream可能会包含多层OutputStream，而每一层都有可能有buf，
    //调用flush()可以确保每一次的buf都被写入到目的地。
    public synchronized void flush() throws IOException {
        flushBuffer();
        out.flush();
    }
}
```

## 一个小小例子
```java
//把26个大写字母写入到文件中
public static void testWrite() throws Exception {
	FileOutputStream fos = new FileOutputStream("e:/out.txt");
	BufferedOutputStream bos = new BufferedOutputStream(fo);
	int len = 26;
	byte[] b = new byte[len];
	int index = 65;
	for(int i=0; i<len; i++) {
		b[i] = (byte)index;
		index++;
	}
	bos.write(b, 0, len);
	bos.close();
}
```
