# 安装MyEclipse后你应该做这些设置：
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