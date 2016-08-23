#gitignore模板
[github上的模板，各种编程语言都有](https://github.com/github/gitignore/)

#下载project
当你在github、oschina上发现优秀的project，想下载下来研究时，可以使用clone命令：

假设要把project下载到`D:\workspace\`目录下。首先进到workspace文件夹，然后右键，选择git clone。或者直接在git bash下输入下列命令。完成后，就会在得到目录:`D:workspace\JavaBlog\`

```java
git clone http://git.oschina.net/iSingular/JavaBlog

--指定新的文件夹名字RenameProject
git clone http://git.oschina.net/iSingular/JavaBlog RenameProject
```

#忽略
```
--忽略test文件夹以及其中的文件
/test
```
