# IO（6）学习File


## File简介
File类用于表示一个文件或者文件夹。它内置的静态成员变量可以方便开发者获取与平台相关的路径分隔符。File可以使用“绝对路径”或“相对路径”来表示一个文件或文件夹。对于UNIX来说，使用`/`来表示绝对路径，而对于Windows来说，使用盘符`D:`表示绝对路径。而直接以文件夹名称或者文件名称开头的则表示相对路径。此外，File还可以实现对File的access permisssion控制，即文件的访问权限控制，比如对于File的所有者File可写，而对于其他用户File可读。 

## 容易混淆的概念
* abstract pathname：抽象的路径，也就是构造File对象时传进去的String路径值，他可以是绝对路径，也可以是相对路径
* parent：也就是除了最后一个目录以外的父路径
* name：File自身的名称，不带父路径，即”文件名.文件后缀“
* prefix：name的前缀，一般是.前面的部分，也就是文件名
* suffix：name的后缀，一般是.后面的部分，也就是文件后缀
* dictionary：文件夹
* absolute pathname：绝对路径
* relative pathname：相对路径

### 正斜杠与反斜杠
* 正斜杠是位于大于号右边的按键`/`
* 反斜杠是位于回车键上方的按键`\`

在Windows中访问文件目录时，可以使用正斜杠，也可以使用反斜杠，甚至可以正反斜杠混用：

```
d:/developer
d:\developer
d:/developer\maven
```

在Java中访问Windows的文件目录，可以使用一个正斜杠`\`，或者两个反斜杠`\\`作为分隔符。这是因为Java中`\`表示转义字符，因此必须使用`\\`表示"单个反斜杠字符"。

```java
File file = new File("d:/developer");
File file = new File("d:\\developer");
File file = new File("d:\\developer/maven");
```


##API分析
### 静态成员变量
```java
//pathSeparator是路径分隔符，Winndows的路径分隔符是;，即多个路径之间用;进行分隔。UNIX的路径分隔符是:
static String pathSeparator
static char pathSeparatorChar
//separator是一个路径之中中的分隔符，Windows的分隔符是\，即parentFolder\childFolder。UNIX的分隔符是/
static String separator
static char separatorChar
```

### 构造函数
```java
File(File parent, String child) 
File(String pathname) 
File(String parent, String child) 
File(URI uri)
```


### 创建File
```java
//当且仅当其父路径存在，且该文件不存在，才能成功创建文件
boolean createNewFile()

//在默认路下下创建一个临时文件、默认路径由System.getProperty("java.io.tmpdir");决定
//prefix是文件名，至少三个字符。suffix是扩展名，比如jpg，如果为null，则默认为.tmp
//前缀和后缀的最大长度取决于底层的操作系统，该方法会自动对过长的前缀、后缀进行裁剪处理
static File createTempFile(String prefix, String suffix)

////在特定路径下下创建一个临时文件，特定路径由最后一个参数决定。
static File createTempFile(String prefix, String suffix, File directory)

//创建文件夹，前提是必要的父目录必须存在
boolean mkdir()

//创建文件夹，如果父目录不存在，则自动创建父目录，即使创建失败，之前创建的部分父目录也会存在
boolean mkdirs()
```


### 修改File
```
//删除file，如果file表示文件夹，则只有文件夹为空时才能删除
boolean delete()

//对file进行标记，当JVM正常关闭时删除被标记的file，删除的顺序与当初被标记的顺序相反
//如果是文件夹，则只有当文件夹为空时才能被删除。如果被标记的file已经提前执行了delete()操作，则无影响
//只有当JVM正常关闭时，才会对标记的file删除
void deleteOnExit()

//从字面上看是文件重命名。但其实质作用在不同操作系统中是不一样的。
//在Windows下的测试结果是，剪切+重命名的操作，即会把File剪切到dest目录，然后重命名为dest对应的名称
//此外Windows下只能对文件执行renameTo方法，不能对文件夹执行renameTo方法。
boolean renameTo(File dest)
```


### 路径时相关
```java
//获取当初构造File时传入的路径，可能是绝对路径，也可能是相对路径
//File的构造函数需要接受一个abstractPath作为路径
String getPath()

//获取File的绝对路径。
//如果File由空串构成，则返回user.dir目录
//如果File由绝对路径构成，则等价于调用getPath()，如果File由相对路径构成，则返回File的绝对路径
String getAbsolutePath()

//获取绝对路径构成的File，等价于new File(this.getAbsolutePath())
File getAbsoluteFile()

//获取一个权威的路径，权威路径肯定是一个绝对路径，并且不同的操作系统会对路径的字符进行一定的处理
//大多数情况下CanonicalPath和AbsolutePath是一样的
String getCanonicalPath()

//获取一个权威的路径，等价于new File(this.getCanonicalPath())
File getCanonicalFile()

//获取File路径中最后一个名称（最后一个有效/后面跟的名称）
String getName()

//获取File的父路径，也就是File路径中除了getName()之外的路径
String getParent()

//获取File的父路径，等价于new File(this.getParent())
File getParentFile()

//判断是不是绝对路径
//UNIX的绝对路径以/开头，而Windows的绝对路径以盘符开头
boolean isAbsolute()

//转为URI格式
URI toURI()

//重写了toString方法，底层调用了getPath()方法
String toString()
```


### 获取File基本信息
```java
//获取最后修改时间
long lastModified()

//获取File的大小（单位是byte）
long length()

//列出File目录中所有的subFile名称
//如果File是文件，则返回null，如果File是文件夹，则返回文件夹下所有subFile的名称
//返回值String[]是无序的。该方法也不会进行递归查询，而只会查询第一层。在Windows平台下尝试过，隐藏文件也同样被返回。
String[] list()

//列出File目录中所有的subFile，并用File来封装。底层本质上是调用了list()方法。
//如果File是绝对路径构造的，则subFile也是绝对路径构造的。如果File是相对路径构造的，则subFile也是相对路径构造的

//列出File目录中符合规则的subFile名称
//功能和list()基本一样，底层也是先调用list()方法，然后对数组元素逐个调用filter.accept()方法判断subFile是否符合要求
String[] list(FilenameFilter filter)

//列出File目录中符合规则的subFile名称
//功能和String[] list(FilenameFilter filter)一样，就是对其进行进一步封装而已
File[] listFiles(FilenameFilter filter)

//列出所有的盘符，比如Windows下就会列出从C:\、D:\、E:\、F:\
static File[] listRoots()
```


### File判断
```java
//对比File路径，底层实质上使用compareTo(File pathname)方法进行对比判断
boolean equals(Object obj)

//对比File的路径，UNIX大小写敏感，Windows大小写不明感
int compareTo(File pathname)

//判断File是否存在
boolean exists()

//判断是不是文件夹
boolean isDirectory()

//判断是不是文件
boolean isFile()

//判断File是不是隐藏的
//UNIX的隐藏文件用.开头，而Windows的隐藏文件通过标记设置
boolean isHidden()
```


### 访问控制(access permission)
```java
boolean canExecute() //可执行
boolean canRead() //可读
boolean canWrite() //可写
boolean setExecutable(boolean executable) 
boolean setExecutable(boolean executable, boolean ownerOnly)
boolean setReadable(boolean readable)
boolean setReadable(boolean readable, boolean ownerOnly)
boolean setWritable(boolean writable) 
boolean setReadable(boolean readable, boolean ownerOnly)

//设置为只读，但只读File是否可删除由底层操作系统决定
boolean setReadOnly()
```

### 获取空间信息
```java
//粗略地获取总空间（单位是byte）
long getTotalSpace()

//粗略地获取已用空间（单位是byte）
 long getUsableSpace()
 
//粗略地获取File剩余可用空间大小（单位是byte），可用空间大小只是粗略的估算，并不是精确值
long getFreeSpace()
```


