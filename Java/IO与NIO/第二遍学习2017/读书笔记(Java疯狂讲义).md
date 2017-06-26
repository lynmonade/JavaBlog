# File常用例子

## 获取当前路径

```java
File file1 = new File(""); //AbsolutePath=D:\workspace\eclipse4x\io3 在java项目中任意位置执行这一句
File file2 = new File("/"); //AbsolutePath=D:\ 获取项目所在根路径，windows的根路径是盘符
```

## 获取上一级路径

```java
File file1 = new File(""); 
//别用getAbsolutePath()，因为file1有可能是相对路径
String parent = file1.getAbsoluteFile().getParent(); // D:\workspace\eclipse4x
```

## 遍历子文件

```java
File file = new File("");
String[] subFileNames = file.list();
```

## 过滤子文件

使用FilenameFilter接口，结合Command设计模式即可实现。本质上我们是在遍历的过程中，传入一个过滤策略。

```java
public class Client {
	public static void main(String[] args) {
		File home = new File("D:/developer/JavaBlog/MarkdowmImages");
		String[] result = home.list(new FilenameFilter() {
			@Override
			public boolean accept(File dir, String name) {
				if(name.endsWith(".png")) {
					return true;
				}
				else {
					return false;
				}
				
			}
		});
		for(String subFileName : result) {
			System.out.println(subFileName);
		}
	}
}
```

## 遍历子孙文件

```java
public class Client {
	//客户端调用
	public static void main(String[] args) {
		Client client= new Client();
		File home = new File("");
		List<File> result = new ArrayList<>();
		 client.getFiles(home.getAbsolutePath(), result, true);
		for(File subFile : result) {
			System.out.println(subFile);
		}
	}
	
	/**
	 * @Title: getFiles
	 * @Description: 通过递归调用实现遍历子孙文件
	 * @param path 基础路径
	 * @param result 遍历结果集，必须传入一个List<File>，否则递归结果没法保存
	 * @param includeDirectory 结果集是否包含文件夹
	 * @return List<File> 遍历结果集
	 */
	public List<File> getFiles(String path, List<File> result, boolean includeDirectory) {
		if(result==null) {
			result = new ArrayList<>();
		}
		File home = new File(path);
		if(!home.exists()) {
			return  null;
		}
		File[] subFiles = home.listFiles();
		for(File file : subFiles) {
			
			if(file.isDirectory()) {
				if(includeDirectory) {
					result.add(file);
				}
				this.getFiles(file.getAbsolutePath(), result, includeDirectory); //递归遍历
			}
			else {
				result.add(file);
			}
		}
		return result;
	}
}
```

## 过滤子孙文件

```java
public class Client {
	//客户端测试
	public static void main(String[] args) {
		Client client= new Client();
		File home = new File("D:/developer/myBlog/");
		List<File> result = new ArrayList<>();
		client.getFilesWithFilter(home.getAbsolutePath(), result, new MyFilter());
		for(File subFile : result) {
			System.out.println(subFile);
		}
	}
	
	/**
	 * 
	 * @Title: getFilesWithFilter
	 * @Description 该方法保持了过滤器的风格，使用者只需传入过滤器，方法内部会自行对子孙文件夹进行迭代 
	 * @param path 基础路径
	 * @param result 遍历结果集
	 * @param filter 过滤器封装 过滤条件
	 * @return 返回结果集（其实也可以不返回，因为客户端以传入该参数，肯定会持有引用）
	 */
	public List<File> getFilesWithFilter(String path, List<File> result, FilenameFilter filter) {
		if(result==null) {
			result = new ArrayList<>();
		}
		
		File home = new File(path);
		if(!home.exists()) {
			return  null;
		}
		File[] subFiles = home.listFiles();
		for(File subFile : subFiles) {
			if(subFile.isDirectory()) {
				getFilesWithFilter(subFile.getAbsolutePath(), result, filter);
			}
			else {
				if(filter.accept(subFile.getAbsoluteFile().getParentFile(), subFile.getName())) {
					result.add(subFile);
				}
			}
		}
		return result;
	}
}

//过滤器
public class MyFilter implements FilenameFilter{

	@Override
	public boolean accept(File dir, String name) {
		String path = dir.getAbsolutePath()+File.separator+name;
		File subFile = new File(path);
		if(subFile.isDirectory()) {
			subFile.list(this);
		}
		if(name.endsWith(".png")) { //只需要.png文件
			return true;
		}
		return false;
	}
}
```

# 流的分类

（1）输入流和输出流：

* 输入流：只能从中读取数据
* 输出流：只能从中写入数据

（2）字节流和字符流：用法几乎一样，区别在于操作的数据单元不同

* 字节流操作的数据单元是8位的字节（8bit）
* 字符流操作的数据单元是16位的字符

（3）节点流和处理流

* 节点流：可以从/向一个特定的IO设备读/写数据的流，一般都会直连数据源。
* 处理流：也叫做过滤流，用于对一个已存在的流进行连接或封装。这里用到了装饰模式

**使用处理流主要有两方面的优势：1. 有效地提高I/O性能。2. 提供更便捷地操作，一次性处理大批量的I/O内容。因此我们通常都会先创建一个节点流，然后使用处理流包裹住节点流，再对处理流执行IO操作。**

# 输入/输出流的体系（各个I/O类的用途）

## 操作文件

FileInputStream/FileOutputStream用于读/写二进制文件，FileReader和FileWriter用于读取文本文件。他们一般都会结合buffered处理流一起使用。

## 缓冲

涉及4个类：BufferedInputStream、BufferedOutputStream、BufferedReader、BufferedWriter。主要用来封装其他的节点流以提供缓冲功能。

## 格式化输出

涉及两个类：PrintStream和PrintWriter。两者都是处理流，所以肯定会包裹着一个输出目的地。通过观察他们的构造函数可以看出，我们可以目的地设置为一个节点流、文件、屏幕。`System.out`就是返回一个PrintStream对象，该对象把输出目的地设置为屏幕，因此当调用`System.out.println()`时便可以在屏幕上打印相关信息。

## 操作字节/字符数组

涉及到4个类：ByteArrayInputStream、ByteArrayOutputStream、CharArrayReader、CharArrayWriter。他们提供了以I/O的方式进行数组读写的相关方法。使用I/O来操纵字节、字符数组主要有如下优势：

* 这四个类自带Buffer，可以提供缓冲功能
* ByteArrayInputStream具备动态扩展能力，可以动态扩展byte数组，这对于使用传统方式来操纵数组来说是非常困难的。

## 操作字符串

涉及2个类：StringReader、StringWriter。他们都是节点流，只不过流的连接点都是字符串，而不是文件。

**StringReader的作用是读取其内部封装的String，并保存到一个字符数组中。**其内部持有成员变量String。StringReader只有一个构造函数，调用时必须传入一个字符串。

**StringWriter的作用是把字符数组写入到期内部封装的StringBuffer中，接着通过getBuffer()获得StringBuffer，进而可以使用StringBuffer来构建字符串。**

![](http://wx1.sinaimg.cn/mw690/0065Y1avgy1fgu2vem7gfj30hd0a8gr8.jpg)

## 访问管道

涉及4个类：PipeInputStream、PipeOutputStream、PipedReader、PipedWriter。

## 	转换流

涉及2个类：InputStreamReader、InputStreamWriter。**用于把字节流转换为字符流。（注意，I/O体系中并没有提供把字符流转为字节流的转换流，因为没这个必要）**

## 序列化

涉及2个类：ObjectInputStream、ObjectOutputStream。

## 推回输入流

涉及2个类：PushbackInputStream、PushbackReader

## 特殊流

DataInputStream、DataOutputStream

# 流的关闭问题

## 如何关闭含有处理流的节点流

如果节点流被处理流包裹着，那么怎样才算是正确的关闭方式呢？下面提供几种方式：

- 如果你使用JDK7+，可以使用`try-with-resources`语法
- 只需关闭最外层的处理流即可
- 从外到内关闭

## 如何关闭多个节点流

# 流的推荐写法

# 各平台的换行符

```
unix换行：\n(0x0A)
MAC回车：\r(0x0D)
WIN回车换行：\r\n(0x0D,0x0A)
```

还有个更简单的办法：把流封装成BufferedWriter，然后利用它的`newLine()`方法。

参考：[\r,\n与\r\n有什么区别?](http://blog.csdn.net/amqvje/article/details/38370681)

# 常见案例

## 文件复制

文件复制时推荐使用文件流+缓冲流的形式。我们需要根据文件大小来设置合适的缓存大小。另外在客户端的byte[]数组也建议设置为与缓冲数组大小一致，这样可以减少缓冲区与客户端之间的数组数据拷贝次数。

* 如果文件实在太小（比缓冲区默认大小8kb还小），则使用file.length()，获取文件大小，然后使用文件大小作为缓冲区大小
* 如果文件小于2GB，则建议使用缓冲区的默认大小8kb
* 如果文件大于2GB，则建议把缓冲区设置为32kb

```java
public class Client {
	public static void main(String[] args) throws IOException {
		long start = System.currentTimeMillis();
		Client client = new Client();
		//client.fileCopy("resource/index.css", "E:/FileDest/index.css"); //560b的小文件
		//client.fileCopy("resource/Westworld.mp4", "E:/FileDest/Westworld.mp4"); //500M的中等文件
		//client.fileCopy("resource/movie.mkv", "E:/FileDest/movie.mkv"); //3.69GB的大文件
		long end = System.currentTimeMillis();
		System.out.println("耗时="+(end-start)/1000+"秒");
	}
	
	//文件拷贝
	public void fileCopy(String src, String dest) throws IOException {
		FileInputStream fis = null;
		BufferedInputStream bis = null;
		FileOutputStream fos = null;
		BufferedOutputStream bos = null;
		File srcFile = new File(src);
		File destFile = new File(dest);
		if(!srcFile.exists()) {
			throw new FileNotFoundException("源文件路径不合法");
		}
		if(!destFile.exists()) {
			destFile.createNewFile(); //严格来说，还得确保父路径也存在才行
		}
		try {
			fis = new FileInputStream(srcFile);
			fos = new FileOutputStream(destFile);
			int kb = 1024;
			long gb = (long)(1024*1024*1024);
			
			//根据文件大小选择合适的bufferSize
			long fileLength = srcFile.length();
			int bufferSize = 0;
			if(fileLength < 8*kb) { //如果文件实在太小，那就直接就用文件size作为缓冲大小吧，不然如果缓冲太大，会把多余的空byte也拷贝过去
				bufferSize = (int)fileLength;
			}
			else if (fileLength<gb*2) { //文件大小<2GB
				bufferSize = 8*kb;
			}
			else { //大于2GB
				bufferSize = 32*kb;
			}
			
			bis = new BufferedInputStream(fis, bufferSize);
			bos = new BufferedOutputStream(fos, bufferSize);
			byte[] b = new byte[bufferSize];
			int readSize = 0;
			while((readSize = bis.read(b))!=-1) {
				bos.write(b);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if(bis!=null) {
					bis.close();
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
			try {
				if(bos!=null) {
					bos.close();
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
}
```

## 文件剪切

只需在拷贝完毕后，删除源文件即可。

```java
public class Client {
	public static void main(String[] args) throws IOException {
		long start = System.currentTimeMillis();
		Client client = new Client();
		//client.fileCut("resource/movie.mkv", "E:/FileDest/movie.mkv"); //3.69GB的大文件
		long end = System.currentTimeMillis();
		System.out.println("耗时="+(end-start)/1000+"秒");
		System.out.println(Integer.MAX_VALUE);
	}
	
	//文件剪切
	public void fileCut(String src, String dest) throws IOException {
		fileCopy(src, dest);
		File srcFile = new File(src);
		srcFile.delete();
	}
	
	//文件复制
	public void fileCopy(String src, String dest) throws IOException {
		FileInputStream fis = null;
		BufferedInputStream bis = null;
		FileOutputStream fos = null;
		BufferedOutputStream bos = null;
		File srcFile = new File(src);
		File destFile = new File(dest);
		if(!srcFile.exists()) {
			throw new FileNotFoundException("源文件路径不合法");
		}
		if(!destFile.exists()) {
			destFile.createNewFile(); //严格来说，还得确保父路径也存在才行
		}
		try {
			fis = new FileInputStream(srcFile);
			fos = new FileOutputStream(destFile);
			int kb = 1024;
			long gb = (long)(1024*1024*1024);
			
			//根据文件大小选择合适的bufferSize
			long fileLength = srcFile.length();
			int bufferSize = 0;
			if(fileLength < 8*kb) { //如果文件实在太小，那就直接就用文件size作为缓冲大小吧，不然如果缓冲太大，会把多余的空byte也拷贝过去
				bufferSize = (int)fileLength;
			}
			else if (fileLength<gb*2) { //文件大小<2GB
				bufferSize = 8*kb;
			}
			else { //大于2GB
				bufferSize = 32*kb;
			}
			
			bis = new BufferedInputStream(fis, bufferSize);
			bos = new BufferedOutputStream(fos, bufferSize);
			byte[] b = new byte[bufferSize];
			int readSize = 0;
			while((readSize = bis.read(b))!=-1) {
				bos.write(b);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if(bis!=null) {
					bis.close();
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
			try {
				if(bos!=null) {
					bos.close();
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
}
```

## 文件删除

```java
//文件删除，只是放进回收站
public boolean fileDelete(String src) throws FileNotFoundException {
	File file = new File(src);
	if(!file.exists()) {
		throw new FileNotFoundException();
	}
	return file.delete();
}
```

# 冷门案例

## 字节流转为字符流

这样的做法可以让我们利用字符流的方法，更加的便捷地读取字符。

```java
public class Client2 {
	public static void main(String[] args) {
		Client2 client2 = new Client2();
		
		client2.toReader("resource/text.txt");
	}
	
	/*
	 * 从源文件中读出二进制数据，接着使用BufferedReader、OutputStreamWriter进行包裹
	 * 最后用OutputStreamWriter写入到目标文件
	 * */
	public void toReader(String src) {
		File destFile = new File("resource/dest.txt");
		if(!destFile.exists()) {
			try {
				destFile.createNewFile();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		try(FileInputStream fis = new FileInputStream(new File(src));
			InputStreamReader isr = new InputStreamReader(fis, "UTF-8");
			BufferedReader br = new BufferedReader(isr); //通过BufferedReader的包裹，可以实现按行来读取
			OutputStreamWriter osw = new OutputStreamWriter(new FileOutputStream(destFile), "UTF-8");) {
			String buffer = null;
			boolean writeLine = false; //换行
			while((buffer = br.readLine())!=null) {
				if(writeLine==true) {
					osw.write("\r\n");
					writeLine = false;
				}
				osw.write(buffer);
				writeLine = true;
			}
		} catch (Exception e) {
			e.printStackTrace(); 
		} 
	}
}
```

## 推回流

用到再看。

## 重定向标准输入/输出

Java的标准输入/输出分别通过System.in和System.out来代表，在默认情况下它们分别代表键盘和显示器。我们可以通过下列三个函数重定向标准输入的源、标准输出的目的地。

```java
static void setIn(InputStream in) //设置标准输入流
static void setOut(PrintStream out) //设置标准输出流
static void setErr(PrintStream err) //设置标准错误输出流
```

```java
public void redirectIO() {
	File srcFile = new File("resource/text.txt");
	try(
	FileInputStream fis = new FileInputStream(srcFile);
	FileOutputStream fos = new FileOutputStream(new File("resource/dest.txt"));
	PrintStream ps = new PrintStream(fos);
	) {
		System.setIn(fis);
		System.setOut(ps);
		byte[] bytes = new byte[1024];
		while(System.in.read(bytes)>0) {
			String content = new String(bytes, "UTF-8");
			System.out.print(content);
		}
	} catch (Exception e) {
		e.printStackTrace();
	}
}
```

# RandomAccessFile

周末学习

# 序列化

对象的序列化是指将一个Java对象写入IO流中，需要用到ObjectOutputStream。对象的反序列化则是指从IO流中回复该Java对象，需要用到ObjectInputStream。

如果需要让某个对象支持序列化机制，则必须实现Serializable接口、或者实现Externalizable接口。Serializable接口是一个标记接口，实现该接口无需实现任何方法，它只是表明该类的实例是可序列化的。

所有可能在网络上传输的对象的类都应该是可序列化的，比如HttpSession、ServletContext。

```java
public class Person implements Serializable{
	private String name;
	private int age;
	public Person(String name, int age) {
		super();
		this.name = name;
		this.age = age;
	}
	//省略getter/setter/toString
}

public void testSer() {
	File destFile = new File("resource/person1.obj");
	if(!destFile.exists()) {
		try {
			destFile.createNewFile();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	try(FileOutputStream fos = new FileOutputStream(destFile);
		ObjectOutputStream oos = new ObjectOutputStream(fos);
		FileInputStream fis = new FileInputStream(destFile);
		ObjectInputStream ois = new ObjectInputStream(fis);
			) {
		Person person1 = new Person("中国", 10);
		oos.writeObject(person1);
		Person person11 = (Person)ois.readObject();
		System.out.println(person11);
		
	} catch (Exception e) {
		e.printStackTrace();
	}
}
```

## 序列化注意事项

- 执行反序列化时，项目中必须存在对象所属类的.class文件。，否则会报ClassNotFoundException异常
- 执行反序列化时，并不是通过函数来重新初始化对象的。
- 如果使用序列化机制向文件中写入了多个对象，使用反序列化恢复对象时必须按照实际写入的顺序读取。
- 当一个可序列化类由多个父类时（包括直接、间接的父类），必须满足如下任意一个条件：
  - 父类具有无参数构造器，此时弗雷中定义的成员变量值并不会序列化到二进制流中
  - 父类也可以序列化
- 当该类持有一个对象类型的成员变量时，如果希望该类可以序列化，则其成员变量也必须支持序列化

## 对象成员变量的序列化问题

当该类持有一个对象类型的成员变量时，如果希望该类可以序列化，则其成员变量也必须支持序列化。此时，成员变量也会顺带着被序列化。

```
public class Company implements Serializable{
	private String name;
	private Person person;
	
	public Company(String name, Person person) {
		super();
		this.name = name;
		this.person = person;
	}
	//省略getter/setter/toString
}

public void testSer() {
	File destFile = new File("resource/person1.obj");
	if(!destFile.exists()) {
		try {
			destFile.createNewFile();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	try(FileOutputStream fos = new FileOutputStream(destFile);
		ObjectOutputStream oos = new ObjectOutputStream(fos);
		FileInputStream fis = new FileInputStream(destFile);
		ObjectInputStream ois = new ObjectInputStream(fis);
			) {
		Person person1 = new Person("angle", 10);
		Company company1 = new Company("apple", person1);
		
		oos.writeObject(company1);
		Company company11 = (Company)ois.readObject();
		System.out.println(company11);
		
	} catch (Exception e) {
		e.printStackTrace();
	}
}
```

## 对同一个对象多次序列化

这会涉及到序列化的相关算法：

* 所有保存到磁盘中的对象都有一个序列化编号
* 当程序视图序列化一个对象时，程序将先检查该对象是否已被序列化过，左右该对象从未（在本次JVM中）被序列化过，系统才会将该对象转换成字节并输出。
* 如果某个对象已经序列化过，程序将只是直接输出一个序列化编号，而不是再次重新序列化该对象。

在下面的例子中，两个Company对象持有同一个Person对象，此外，我们还显式地对Person对象进行序列化。但最终最有第一次对Person序列化是有效的，后面两次只是返回一个编号而已。**（注意，如果第一次序列化成功后，尝试改变Person的成员变量值，然后再对Person做序列化，JVM依然认为Person已经序列化，这是个坑！）**

```java
public void testSer() {
	File destFile = new File("resource/person1.obj");
	if(!destFile.exists()) {
		try {
			destFile.createNewFile();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	try(FileOutputStream fos = new FileOutputStream(destFile);
		ObjectOutputStream oos = new ObjectOutputStream(fos);
		FileInputStream fis = new FileInputStream(destFile);
		ObjectInputStream ois = new ObjectInputStream(fis);
			) {
		Person person1 = new Person("angle", 10);
		Company company1 = new Company("Apple", person1);
		Company company2 = new Company("Google", person1);
		oos.writeObject(company1);
		oos.writeObject(company2);
		oos.writeObject(person1);
		oos.writeObject(company1);
		Company company11 = (Company)ois.readObject();
		Company company22 = (Company)ois.readObject();
		Person person11 = (Person)ois.readObject();
		Company company33 = (Company)ois.readObject();
		
		System.out.println(company11==company33); //true
		System.out.println(company11.getPerson()==person11); //true
		System.out.println(company22.getPerson()==person11); //true
		
	} catch (Exception e) {
		e.printStackTrace();
	}
}
```

## 不可序列化的成员变量

* 被transient修饰的成员变量，反序列化时，该成员变量任然存在，只是他的值是该变量类型的默认值。
* 被static修饰的成员变量，反序列化时，该成员变量仍然存在，如果在同一JVM上反序列化，则其值就是当初序列化时的值。如果不是同一JVM上反序列化，则他的值是该变量类型的默认值。

# 自定义序列化方式

自定义序列化有两种方式：

* 重写writeObject()和readObject()方法
* 实现Externalizable接口











# Reference

* 《Java疯狂讲义》
* 《Java编程思想》
* 《Java程序设计语言》
* [Java SE7新特性之try-with-resources语句](http://blog.csdn.net/jackiehff/article/details/17765909)
* [Java的IO操作中关闭流的注意点](http://blog.csdn.net/woshixuye/article/details/23546081)

