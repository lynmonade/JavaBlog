# struts2 Action控制器

在struts2中，Action类就是POJO类，Action类中的每一个非getter/setter方法都可以看做是一个业务方法。如果我们希望在方法中获取前端传过来的参数，必须满足如下条件：

1. 在Action类中定义成员变量，成员变量用于存储传入的参数
2. 在Action类中为成员变量定义getter/setter方法，因为struts2底层都是通过getter/setter来访问前端参数的。

严格来说，即使我们不定义成员变量，仅定义getter/setter方法，也同样可以获取前端参数，因为struts2依赖的是getter/setter，而不是成员变量。但为了保证类结构的规范性，建议还是同时定义成员变量和getter/setter方法。

此外，我们还可以在Action中定义成员变量来表示输出值。然后在JSP中使用如下语句来输出该值。这个输出值可以是普通的字符串，也可以是用户自定义的类、数组、集合对象、Map对象等。

```xml
<s:property value="outputValue" />
```

