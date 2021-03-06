# IO（5）学习PrintStream
## PrintStream
PrintStream叫做打印流，但实际上，PrintStream的本质作用还是“向目的地输出byte数据”。那它和其他的输出流有什么区别呢：

1. PrintStream提供了多个重载和封装的方法，实现对多种数据类型的输出。
2. PrintStream提供了格式化输出方法，就像objc中的NSLog占位符输出的方式。

PrintStream实际上是对传统的OutputStream的输出进行了增强，这样的“增强”也就被称之为**"Print打印"**。

PrintStream是FilterOutputStream的子类。它内部持一个OutputStream成员变量。PrintStream具体的输出目的地由OutputStream来决定。

如果PrintStream发生IOException，它并不会报错或抛出异常，而是通过内部的标志位boolean trouble来表示是否发生异常，我们可以通过checkError()方法来确定是否发生异常。

PrintStream可以设置为AutoFlush的形式，即当一个byte[]数组被写入(调用write方法)、或者println方法被调用、或者一个换行符的byte字节被写入时，就会自动调用flush()方法。

PrintStream中有多个关于写入数据的操作：

```java
public void write(int b);
public void write(byte buf[], int off, int len);
private void write(char buf[]);
private void write(String s);
public void print(boolean b);
public void print(char c);
public void print(int i);
public void print(long l);
public void print(float f);
public void print(double d);
public void print(char s[]);
public void print(String s);
public void print(Object obj);
public void println();
public void println(boolean x);
public void println(char x);
public void println(int x);
public void println(long x);
public void println(float x);
public void println(char x[]);
public void println(String x);
public void println(Object x);
public PrintStream printf(String format, Object ... args);
public PrintStream printf(Locale l, String format, Object ... args);
public PrintStream format(String format, Object ... args);
public PrintStream format(Locale l, String format, Object ... args);
public PrintStream append(CharSequence csq);
public PrintStream append(CharSequence csq, int start, int end);
public PrintStream append(char c)
```

### write方法
write是从OutputStream中继承下来的方法，是最本质的写入方法。

write方法系列是最基础的方法，print方法、println方法、printf方法、append方法在底层，都会直接或间接地调用write方法。

从本质上来说，write、print、println、printf、append、format方法本质上都是往输出流目的地写入byte数据，这个目的地往往都是文件，所以PrintStream包含了多个以FileOutputStream为参数的构造函数。


### print方法
print方法在参数类型上提供了更多的选择，本质上弥补了write方法在参数类型尚不足的问题。查看源码可知，print方法是JDK帮我们多做的一层数据类型转换的封装。

```java
public void print(int i) {
    write(String.valueOf(i));
}
public void print(char s[]) {
    write(s);
}
public void print(String s) {
    if (s == null) {
        s = "null";
    }
    write(s);
}
```

### println方法
println则是对print方法的封装，让我们在执行完print之后，自动加入换行操作。

```java
public void println() {
    newLine();
}
public void println(int x) {
    synchronized (this) {
        print(x); //先调用print方法
        newLine(); //再调用ln方法实现换行
    }
}
```

### append方法
append方法来自Appendable接口，append接受的参数是char或CharSequence，在内部转调write或print方法。**注意，对一个已经有内容的文件，如果调用append方法，其效果是把源文件内容删除，然后在把append的内容写进文件中，并不是像字面意义所描述的把内容追加到源文件的内容尾部。**

```java
public PrintStream append(CharSequence csq) {
    if (csq == null)
        print("null");
    else
        print(csq.toString());
    return this;
}
public PrintStream append(CharSequence csq, int start, int end) {
    CharSequence cs = (csq == null ? "null" : csq);
    write(cs.subSequence(start, end).toString());
    return this;
}
public PrintStream append(char c) {
    print(c);
    return this;
}
```

### format方法
format方法会根据指定的编码格式对字符串进行编码，接着内部再调用append方法把编码后的byte写入到目的地。

### PrintWriter
PrintWriter和PrintStream非常似。PrintWriter是对Writer的增强，它可以向目的地输出char数据。此外，他还提供了许多重载方法，让我们很方便的把各种数据类型的数据写入目的地。PrintWriter内部维护了一个Writer成员变量，其相关写入方法的调用，最终都会转化为Writer的write操作。

PrintWriter有多个关于"向目的地写入数据"的方法，其底层本质上都会转调write方法。此外，PrintWriter还有多个构造函数，分别以OutputStream、或者Writer、或者File作为参数。

PrintWriter不会向外抛出异常，而是通过checkError()方法检查是否存在异常，这与PrintStream是一样的。

当开启AutoFlush后，在调用println方法、或者printf方法、或者format方法时，会自动调用flush方法。而在调用write方法、或写入换行符时，并不会自动flush。这点通过看源码就非常清晰了：

```java
public void println(char x) {
    synchronized (lock) {
        print(x);
        println(); //本质上就是调用自动flush
    }
}
public void println() {
    newLine();
}

private void newLine() {
    try {
        synchronized (lock) {
            ensureOpen();
            out.write(lineSeparator);
            if (autoFlush) //自动flush
                out.flush();
        }
    }
    catch (InterruptedIOException x) {
        Thread.currentThread().interrupt();
    }
    catch (IOException x) {
        trouble = true;
    }
}

```
