# 安装MyEclipse后你应该做这些设置

安装好MyEclipse后，最好设置一下MyEclipse的全局编码格式，包括项目/文件的编码格式、文件的打开方式、JRE、tomcat内存方法如下：

```java
//设置项目的编码格式为UTF-8
windows--preferences--General--Workspace--Text file encoding

//设置HTML、JSP等文件默认的编码方式为UTF-8
windows--preferences--General--Content Types--Text

//置HTML、JSP等文件默认的编码方式为UTF-8
windows--preferences--Myeclipse--File and Editors

//设置文件的打开编辑器
window--preferences--General--Editors--Files Associations

//设置JRE目录
windows--preferences--Java--Installed JREs

//设置tomcat最大内存
-Xms512m -Xmx1024m -XX:MaxNewSize=256m -XX:MaxPermSize=256m
```

# 如何对JDK源码设置断点debug

Sun对rt.jar中的类进行编译时去除了调试信息，因此在eclipse中调试JDK源码时，我们无法看到JDK局部变量的值。因此我们需要自己编译相应的源码使之拥有调试信息。下面就来讲解一下如何自己编译JDK源码：

**第一步：**在任意目录下创建一个文件夹，名为myJDK。比如D:\myJDK\，然后在myJDK下创建一个文件夹名为jdk_src，用于存放oracle提供的jdk源码；接着再在myJDK下创建一个文件夹名为jdk_debug，用于输出编译结果。

**第二步：**在%JDK_HOME%下找到src.zip压缩包，这就是oracle提供的jdk源码。把src.zip解压到myJDK文件夹下。编译时，我们只需要留下java、javax、org三个文件夹就够了，其他的包从myJDK文件夹下删掉即可。

**第三步：**把%JDK_HOME%\jre\lib文件夹复制到D:\myJDK\目录下。这样可以减少在命令行中输入文件名。

**第四步：**打开cmd控制台，进入cd到D:\myJDK目录，执行下面这条语句，这将创建一个java文件列表，里面列出了所有的jdk_src下所有的.java文件的完整路径。

```java
dir /B /S /X jdk_src\*.java > filelist.txt
```

**第五步：**在D:\myJDK目录下，执行下面的命令，稍等片刻，这将编译你所指定的文件，并把便以结果输出到jdk_debug目录下，并产生log.txt日志文件。日志里一般会记录着警告，但不会有错误，如果有错误信息，那很可能是前几步没做对。

```java
javac -J-Xms16m -J-Xmx1024m -sourcepath D:\myJDK\jdk_src -cp D:\myJDK\lib\rt.jar -d D:\myJDK\jdk_debug -g @filelist.txt >> log.txt 2>&1
```

**第六步：**cd到jdk_debug目录下，执行下面的命令，这回在jdk_debug目录下创建一个rt_debug.jar文件。

```java
jar cf0 rt_debug.jar *
```

**第七步：**把rt_debug.jar文件拷贝到%JDK_HOME%\jre\lib\endorsed目录下，如果没有endorsed目录，就自己创建一个。

**第八步：**打开eclipse，进入Window--Preferences--Java--Installed JREs，eclipse默认使用的是JRE，JRE是不具备断点调试功能的，需要换成JDK，因此点击Add按钮--Next(Stanard VM)--Directory定位到%JDK_HOME%，记得点击Finish。最后记得勾选刚才我们新添加的JDK。

**第九步：**新建一个Java Project，设置JRE时，记得选择我们新建的JDK，而不是使用默认设置。这样，你就可以在该项目中尽情的设置断点了！

![jdk_debug](http://wx1.sinaimg.cn/mw690/0065Y1avgy1fdre6lp1urj30f60hpmxo.jpg)

# Reference

* [如何在eclipse中debug调试进入JDK源码及显示调试过程中的局部变量的值](http://blog.csdn.net/ftp_2014/article/details/51087603)