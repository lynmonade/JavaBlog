# Maven实用教程
## 安装与配置Maven
首先到官网[下载Maven](http://maven.apache.org/download.cgi)。下载下来是一个一个压缩包，解压出来就可以直接用了。接着在环境变量中配置Maven，是的我们可以在cmd窗口中使用Maven的命令：

```
1.创建MAVEN_HOME
变量=MAVEN_HOME
值=D:\developer\software\maven\apache-maven-3.3.9

2.配置path：在path的值后面添加
%MAVEN_HOME%\bin;
```

## Maven的基本知识
### 修改jar包保存的位置
Maven可以帮助我们从互联网上的Maven中央库中下载项目所依赖的jar包。你只需要编写pom.xml文件，Maven便会根据pom.xml文件下载必要的jar包。Maven下载的jar包默认保存在C:\Users\用户名\.m2\目录中。如果想要修改jar包保存的位置，可以修改`%MAVEN_HOME%\conf\settinng.xml`的文件。该文件是Maven的全局配置文件：

```xml
//修改jar包的保存位置：
<localRepository>D:\workspace_maven\maven_jar</localRepository>
```

此外，我们还可以把setting.xml文件拷贝到`在C:\Users\用户名\.m2\`目录下，这样setting.xml文件就会变为该计算机用户的配置文件，只对该用户有效果。而`%MAVEN_HOME%\conf\settinng.xml`则是全局的配置文件。

## 在eclipse中部署maven项目
eclipse4x自带了maven插件，因此无需额外安装maven插件，只需要配置一下maven插件，让其指向你本地的maven即可。

**第一步：配置maven**

Window--Preferences-Maven--Installations-->Add:选择你安装的maven。

**第二步：克隆并导入maven项目**

在github中clone整个maven项目到你的eclipse工作空间下，接着打开eclipse-->File-->Import-->Maven-->Existing Maven Projects-->选中你想导入的maven项目-->finish，稍等片刻直至右下角的导入完成。

**第三步：把maven项目转为java web项目**





## 如何用Maven部署github上的项目
按照上面的步骤，你就可以把Maven配置完成了。接着你可以在cmd中，使用`mvn version`查看Maven版本。

一般大神上传到github上的开源项目只包含一个src目录和一个pom.xml文件，你只需要按照下面的步骤就可以成功部署项目了：

1. 使用git clone把项目克隆到本地。
2. 在cmd中cd到项目目录。
3. 然后在cmd中敲`mvn eclipse:eclipse`，该命令可以把项目转为eclipse项目，然后自动根据pom.xml中的配置信息，自动下载jar包。
4. 在MyEclipse中，File--Import--Existing Projects into Workspace，导入该项目到MyEclipse工作空间中。
5. 如果是JavaWeb项目，只需要在MyEclipse中，项目--右键--Properties--MyEclipse--Project Facets，勾选Dynamic Web Module即可把项目转为JavaWeb项目。
6. 最后，还要手动设置，把Maven下载的Jar包发布到中间件中：项目--右键---Properties--MyEclipse--Deployment Assembly--点击Add按钮--选择Java Build Path Entries--选择所有jar包。


