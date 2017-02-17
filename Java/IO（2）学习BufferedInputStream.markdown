# IO（2）学习BufferedInputStream
BufferedInputStream是FilterInputStream的子类，它继承了FilterInputStream的工作模式，在内部维护了一个InputStream作为成员变量。

## 缓存机制
BufferedInputStream内部维护了一个byte buf[]数组，默认大小为8M，作为缓存数组。在**“适当条件”**下，程序首先会从input stream中获取byte数据，并填充到buf[]中。客户端只需拷贝buf[]中的数据即可，而无需直接面对外部数据。由于buf[]存在于内存中，拷贝buf[]的数据非常快。如果直接从外部设备中获取数据，速度会慢一些。

![缓存执行流程](http://wx3.sinaimg.cn/mw690/0065Y1avgy1fcr9wp1552j30le0g8wfh.jpg)

## 缓存效率分析
使用BufferedInputStream对文件拷问，并查看拷贝所用时间：

```java
public static void bufferedCopy() throws Exception {
    InputStream is = new FileInputStream("d:/3G.mkv"); 
    BufferedInputStream bufferedIs = new BufferedInputStream(is);

    OutputStream os = new FileOutputStream("E:/3G.mkv"); //复制的目的地
    BufferedOutputStream bufferedOs = new BufferedOutputStream(os);
    byte[] b = new byte[1024*8];

    long start = System.currentTimeMillis();
    while(bufferedIs.read(b)!=-1) {
        bufferedOs.write(b);
    }
    long end = System.currentTimeMillis();
    System.out.println("复制用时: " + (end-start));
    bufferedIs.close();
    bufferedOs.close();
}

/*
客户端byte[]数组大小   拷贝耗时（毫秒）

15MB的文件
1024                36ms         --用到buf[] 
1024*10             24ms         --没用buf[]

333MB的文件
1024                716ms        --用到buf[]
1024*10             643ms        --没用buf[]
1024*1024           622ms        --没用buf[]

3GB的文件
1024                122867ms     --用到buf[]
1024*10             82054ms      --没用buf[]
1024*1024           118454ms     --没用buf[]
1024*8              151398ms     --用到buf[]
*/
```

对于小文件来说，buf[]对于效率的提升并不是非常明显。但对于2GB以上的大文件来说，缓存则非常奇怪，也许是数组拷贝也是一项耗时的操作，从结果表明：选择合适大小的byte[] b，直接从input stream中读取数据才是最快的。

## 源码分析
```java
public class BufferedInputStream extends FilterInputStream {

	//默认buf[]大小
    private static int DEFAULT_BUFFER_SIZE = 8192; 

    private static int MAX_BUFFER_SIZE = Integer.MAX_VALUE - 8;

	//BufferedInputStream内部维护的一个缓存数组，也就是缓冲区
    protected volatile byte buf[]; 

    private static final
        AtomicReferenceFieldUpdater<BufferedInputStream, byte[]> bufUpdater =
        AtomicReferenceFieldUpdater.newUpdater
        (BufferedInputStream.class,  byte[].class, "buf");

    //当前缓冲区的有效字节数。也就是缓冲区中有多少个byte还没被copy到客户端
    protected int count; 

    //当前缓冲区的有效字节的起始位置
    protected int pos; 

    //mark的位置
    protected int markpos = -1; 

	//mark后还能读多少个字节
    protected int marklimit; 
	
	/*
	  read入口方法
	*/
	public synchronized int read(byte b[], int off, int len) throws IOException
	{
		getBufIfOpen(); // Check for closed stream
		//非法参数检查
		if ((off | len | (off + len) | (b.length - (off + len))) < 0) {
			throw new IndexOutOfBoundsException();
		} else if (len == 0) {
			return 0;
		}

		int n = 0;
		for (;;) {
			int nread = read1(b, off + n, len - n); //执行具体read操作
			if (nread <= 0) //这次read正好到达文件末尾，所以返回0
				return (n == 0) ? nread : n;
			n += nread; 
			
			//因为length可能比n大，所以实际read到字节应该是n
			if (n >= len)
				return n; 
			// if not closed but no bytes available, return
			InputStream input = in;
			if (input != null && input.available() <= 0)
				return n;
		}
	}

	/*
	b是客户端传入的byte数组，用来保存read到的byte
	off是byte保存的起始位置
	len表示这一次要从input stream中读取多少个byte
	*/
	private int read1(byte[] b, int off, int len) throws IOException {
		int avail = count - pos; //avial表示目前buf[]中剩余的有效byte个数(还没被copy到b里的byte)
		if (avail <= 0) { //如果已经没有有效byte了
			/* If the requested length is at least as large as the buffer, and
			   if there is no mark/reset activity, do not bother to copy the
			   bytes into the local buffer.  In this way buffered streams will
			   cascade harmlessly. 
			   如果b数组比buf数组大，则根本不需要往buf中填充数据。因为如果先往buf中填充数据，
			   再执行数组拷贝操作，效率非常低。还不如一次性从input stream中读取byte，并直接
			   保存到b中，也就是不用buf。
			*/   
			if (len >= getBufIfOpen().length && markpos < 0) { 
				return getInIfOpen().read(b, off, len);
			}
			fill(); //如果b没有buf大，则先从input stream中获取数据，并填充(fill)到buf中。
			avail = count - pos; //填充完毕后，判断有多少个有效byte
			if (avail <= 0) return -1; //如果小于0，则表示已经到达文件末尾。
		}
		int cnt = (avail < len) ? avail : len; 
		System.arraycopy(getBufIfOpen(), pos, b, off, cnt); //把buf中的数据拷贝到b中。
		pos += cnt;
		return cnt;
	}
}
```
