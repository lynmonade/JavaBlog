#gitignore模板
[github上的模板，各种编程语言都有](https://github.com/github/gitignore/)

#下载project
当你在github、oschina上发现优秀的project，想下载下来研究时，可以使用clone命令：

假设要把project下载到`D:\workspace\`目录下。首先进到workspace文件夹，然后右键，选择git clone。或者直接在git bash下输入下列命令。完成后，就会在得到目录:`D:workspace\JavaBlog\`

```java
git clone https://github.com/lynmonade/JavaBlog.git

--指定新的文件夹名字RenameProject
git clone https://github.com/lynmonade/JavaBlog.git RenameProject
```

#忽略文件
忽略文件其实分为两步，并不是直接修改.gitignore就可以的。

## 第一步：删除已被跟踪的文件
如果你希望忽略的文件/文件夹已经被git所跟踪了（之前曾经被commit到仓库），这时你必须先让git不再跟踪此该文件（git delete）。如果你用的是乌龟，则右键该文件-->TortoiseGit-->Delete and add to ignore list。这个操作直接把文件脱离git的跟踪，但你的本地依然保留着该文件。然后你再检查一下.gitignore文件，按照第二步的做法，确保忽略了该文件。

当一个文件被git delete后，他处于unversion状态，此时你commit的话，你还是能勾选到该文件，因为git会询问你是否让git跟踪此文件。如果你希望在commit时，不再能勾选该文件，那就需要在.gitignore文件中明确指明忽略该文件.**这就是.gitignore文件的作用:让git在commit时不再探测.gitignore文件中所配置的unversion状态的文件。**

## 第二步：配置.gitignore文件

```java
# 注释

# 忽略.class文件
*.class

# 忽略WebRoot/WEB-INF/classes文件夹以及其中的文件
WebRoot/WEB-INF/classes

# 忽略特定文件
src/rebel.xml
```
