#freemarker手册 2.3.19
##第一部分 模板开发指南
###第一章 模板开发入门
模板 + 数据模型 = 输入

freemarker有五种数据类型：

* 标量：存储单一值，也就是叶节点。包括字符串、数字、日期/时间、布尔值。
* 哈希表：根节点root和子节点
* 序列：存储有序变量的容器。通过数字索引。[i]

##第三章 模板
一个ftl模板由如下部分组成：

* Text文本：文本按照原样输出。例如HTML标签和文本
* Interpolation:插值： ${...}
* FTL tags标签：比如<#list>, <#if>这些标签。FTL标签在底层会调用directves指令。 **重点学习**
* 注释：<#-- ... -->

##指令
###if指令

```freemarker
<body>
	<#--if with string-->
	<#if user=="lyn"><p>administrator</p></#if>
	
	<#--if else with number-->
	<#if number==0>
		<p>administrator's lucky number</p>
	<#else>
		<p>tourist's lucky number</p>
	</#if>
	
	<#--if else with boolean-->
	<#if istrue>
		the value is true
	<#else>
		the value is false
	</#if>
</body>
```

###list指令
```Java
//java端
List<String> list1 = new ArrayList<String>();
list1.add("list1_value1");
list1.add("list1_value2");
list1.add("list1_value3");
list1.add("list1_value4");
setAttr("list1", list1);

//html
<table>
	<tr>
		<#list list1 as str>
			<td>${str}<td>
		</#list>
	</tr>
</table>
```

###include命令
```freemarker
<body>
    ...
    ...
    <#include "/page/footer.html">
</body>

//footer.html
<#if user=="lyn"> 
	<p>administrtor's footer</p>
<#else>
	<p>normal footer</p> 
</#if>
```

###更多指令
更多指令请参考**第四部分 参考文档-->第二章 指令参考文档**。

##内建函数
更多内建函数请参考**第四部分 参考文档-->第一章 内建函数参考文档**。

##自定义宏
参考**第一部分 模板开发指南-->第四章 其它**。

##空值处理
###指定默认值
不论在哪里引用变量，都可以指定一个默认值来避免变量丢失的情况：

```freemarker
<body>
<#--如果usename不存在，则取值Anonymous-->
<h3>welcome back: ${username!"Anonymous"}</h3>

<#--person或age不存在，则取值18。加上()可以对person和age的存在性都做判断-->
<h3>age is: ${peson.age!18}</h3>

<#--不给出默认值，则默认值是空串、空list、空map-->
<h3>address is: ${(person.address)!}</h3>
</body>
```

###if判断不存在的值
使用if判断值是否存在：

```freemarker
<#--判断person.job是否存在。同样的，()是为了对person和job都做存在性判断-->
<#if (person.job)??> 
    <h5>has a job</h5>
<#else>
    <h5>no job</h5>
</#if>
```

