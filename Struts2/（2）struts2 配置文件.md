# struts2配置文件

## 最重要的配置文件struts.xml

struts.xml文件最重要的作用就是配置Action与请求之间的映射关系，此外，我们还可以在其中配置Bean、常量、导入其他配置文件等。**个人建议：在eclipse工程中，把struts2相关的配置文件放到src目录下，当部署到tomcat后，配置文件会自动发布到`WEB-INF/classes`目录下。**

## 常量配置

struts2的常量均由默认值，默认值定义在struts2-core-2.2.1.jar文件中，`org\apache\struts2`中的default.properties配置文件里。struts2按照如下搜索顺序加载struts2常量：

1. struts-default.xml：该文件保存在struts2-core-2.2.1.jar文件中
2. struts-plugin.xml：该文件保存在struts2-Xxx-2.2.1.jar等Struts2插件jar文件中
3. struts.xml：**推荐在此文件中配置常量**
4. struts.properties
5. web.xml：通过在filter中嵌套<init-param>实现

```xml
<constant name="struts.i18n.encoding" value="UTF-8" />
```

## 包含其他配置文件

为了提高struts.xml配置文件的可读性，也为了团队高效开发，我们可以将一个struts.xml配置文件分解成多个配置文件，然后在struts.xml文件中包含其他配置文件：

```xml
<struts>
	<include file="struts-part1.xml" />
</struts>
```



