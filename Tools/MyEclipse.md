# MyEclipse

## 安装MyEclipse后你应该做这些设置

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

## 如何对JDK源码设置断点debug

Sun对rt.jar中的类进行编译时去除了调试信息，因此在eclipse中调试JDK源码时，我们无法看到JDK局部变量的值。因此我们需要自己编译相应的源码使之拥有调试信息。下面就来讲解一下如何自己编译JDK源码：

![myJDK]()

**第一步：**在任意目录下创建一个文件夹，名为myJDK。比如D:\myJDK\，然后在myJDK下创建一个文件夹名为jdk_src，用于存放oracle提供的jdk源码；接着再在myJDK下创建一个文件夹名为jdk_debug，用于输出编译结果。

**第二步：**在%JDK_HOME%下找到src.zip压缩包，这就是oracle提供的jdk源码。把src.zip解压到jdk_src目录下。编译时，我们只需要留下java、javax、org三个文件夹就够了，所以其他的文件夹删掉即可。

**第三步：**把整个%JDK_HOME%\jre\lib文件夹复制到D:\myJDK\目录下。这样可以减少在命令行中输入文件名。

**第四步：**打开cmd控制台，进入cd到D:\myJDK目录，执行下面这条语句，这时会在myJDK目录下创建一个filelist.txt文件，里面列出了所有的jdk_src下所有的.java文件的完整路径。

```java
dir /B /S /X jdk_src\*.java > filelist.txt
```

**第五步：**在D:\myJDK目录下，执行下面的命令，稍等片刻，这将编译你所指定的文件，并把编译结果输出到jdk_debug目录下，并产生log.txt日志文件。日志里一般会记录着警告，但不会有错误，如果有错误信息，那很可能是前几步没做对。

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

**Reference：[如何在eclipse中debug调试进入JDK源码及显示调试过程中的局部变量的值](http://blog.csdn.net/ftp_2014/article/details/51087603)**

## MyEclipse2015集成JRebel
JRebel简直就是JavaWeb开发的神器！有了它，你修改.java文件就再也不需要重启tomcat了！

环境：MyEclipse2015+JRebel6.4.3。（下面的方法同样适用于eclipse集成JRebel）

**第一步：下载所需文件**
[下载JRbel6.4.3](http://download.csdn.net/detail/u014229956/9883054)，里面包含JRebel6.4.3、破解JRebel所需的文件、以及myEclipse2015的JRebel插件。

**第二步：安装JRebel插件**

```java
1. 解压下载的文件得到两个文件：jrebel-6.4.3-crack.rar、update-site.zip

2. 打开myEclipse-->Help-->Install from site-->点击Add按钮:
    A. Name随意写，Location栏选择Archive按钮，选中刚才解压的update-site.zip文件。
    B. 在列表栏中勾选JRebel for MyEclipse(2015 and later)的两个子选项（前两个）：
        JRebel(required)
        JRebel for Java EE
    C. 左下方取消勾选Contact all update sites during install to find required software
    D. 无脑下一步到底。最后会提示重启MyEclipse，那就重启吧！
    E. 重启MyEclipse后，在Help下面如果能勘界JRebel相关选项，则表明安装成功。
```

**第三步：破解JRebel**

```java
1. 关闭MyEclipse，然后解压jrebel-6.4.3-crack.rar文件。

2. 将jrebel-6.4.3-crack\jrebel\jrebel.jar拷贝覆盖到MyEclipse 2015\plugins\org.zeroturnaround.eclipse.embedder_6.4.3.RELEASE\jrebel\目录下

3. 将jrebel-6.4.3-crack\jrebel6\jrebel.jar和jrebel-6.4.3-crack\jrebel6\jrebel.lic两个文件拷贝覆盖到MyEclipse 2015\plugins\org.zeroturnaround.eclipse.embedder_6.4.3.RELEASE\jr6\jrebel目录下

4. 重启MyEclipse，这时应该会在Window-->Preferences下面看到JRebel的选项。

5. 点击JRebel Configuration，在弹出的界面中选择Activate/Update License。

6. 在弹出的界面中选择"I salready have a license"，然后选择jrebel-6.4.3-crack\jrebel.lic文件。至此，破解完成。
```

**第四步：让JRebel作用于tomcat和你的web项目**

```java
1. 这里假设你已经为MyEclipse配置了一个tomcat。在MyEclipse主界面下方，找到Server窗口，右键选择你的tomcat，点击open打开tomcat配置窗口。

2. 在Publishing栏中，选中"Automaically publish when resouces change"

3. 在JRebel Intergration栏中，选中"Enble JRebel agent"

4. 右键你想要为其配置JRebel的web项目，选择JRebel-->Add JRebel Nature。这时会在自动在src目录下添加一个rebel.xml文件。

5. clean你的项目，使得它重新编译，确保tomcat可以正确加载JRebel的配置。

6. 把你的项目部署到刚才的tomcat下并启动tomcat，当你在控制台下看见如下信息则表示JRebel生效了。至此，你可以任意修改项目源代码而无需重启tomcat了！

2017-06-28 16:27:59 JRebel:  
2017-06-28 16:27:59 JRebel:  #############################################################
2017-06-28 16:27:59 JRebel:  
2017-06-28 16:27:59 JRebel:  JRebel Agent 6.4.3 (201604210950)
2017-06-28 16:27:59 JRebel:  (c) Copyright ZeroTurnaround AS, Estonia, Tartu.
2017-06-28 16:27:59 JRebel:  
2017-06-28 16:27:59 JRebel:  Over the last 1 days JRebel prevented
2017-06-28 16:27:59 JRebel:  at least 3 redeploys/restarts saving you about 0.1 hours.
2017-06-28 16:28:00 JRebel:  
2017-06-28 16:28:00 JRebel:  Licensed to VIMACER (ZeroTurnaround)
2017-06-28 16:28:00 JRebel:   with the following restrictions: 
2017-06-28 16:28:00 JRebel:   ### Hello World Cracked ### :)
2017-06-28 16:28:00 JRebel:  
2017-06-28 16:28:00 JRebel:  License type: enterprise
2017-06-28 16:28:00 JRebel:  Valid from: July 14, 2014
2017-06-28 16:28:00 JRebel:  Valid until: August 18, 2888
2017-06-28 16:28:00 JRebel:  
2017-06-28 16:28:00 JRebel:  
2017-06-28 16:28:00 JRebel:  #############################################################
2017-06-28 16:28:00 JRebel:  
```

**如果你用的是eclipse，则还需要做如下配置：**

* 在eclipse的tomcat配置界面-->Overview-->Server Options：勾选Serve modules wihout publishing，Modules auto reload by default
* Eclipse-->Help-->JRebel Configuration-->Advanced-->JRebel agent:选择JRebel 6 Agent 6.4.3
* 在你把项目add到tomcat后，进入eclipse的tomcat配置界面-->Modules:确保你的项目的Auto Reload = Enabled

**Reference**

* [Myeclipse2015 Jrebel插件的安装、配置、使用（新建.java文件、给类添加新方法、新属性、修改代码等，不用重启tomcat即可更新）](http://blog.csdn.net/qq844622079/article/details/51058471)
* [MyEclipse安装JRebel插件实现热部署](http://blog.csdn.net/u013539342/article/details/51010540)
* [菜鸟教程之工具使用（四）——借助JRebel使Tomcat支持热部署](http://blog.csdn.net/liushuijinger/article/details/39898415)


## Eclipse快捷键

* 快速打开资源：CTRL+SHIFT+R
* 查看类的继承关系：CTRL+T
* Debug
  * step into: F5
  * step over: F6
  * step return(step out): F7
  * resume: F8
  * terminate(拔电源): CTRL+F2 

## Eclipse插件

安装方法通常是：把插件解压出来，然后把features文件夹和plugins文件夹下的东西拷贝到eclipse安装目录的features文件夹和plugins文件夹下。

* propedit：有了它，你的eclipse在打开包含中文properties文件时，再也不会出现`/u`字样了。
