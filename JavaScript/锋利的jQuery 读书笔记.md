# 第1章 认识jQuery

在jq中，$是jQuery的一个简写形式，例如下面两条语句是等价的。

```javascript
$("#foo);
jQuery("$foo");
```

# 第2章 jQuery选择器

## 常用的CSS选择器

（1）标签选择器：以文档元素作为选择符

```css
td {
font-size:14px;
width:120px;
}
```

（2）ID选择器：以文档元素的唯一表示服ID作为选择符

```
#myButton {
font-size:12px;
width:100px;
}
```

（3）类选择器：以文档元素的class属性作为选择符

```javascript
div.myNote {
	font-size:13px;
}

.myNote {
	background-color:blue;
}
```

## 常用的jQuery选择器

jq中的选择器格式基本上是参考了CSS的选择器风格。

* id选择器：`$('#buttonId')`
* 类选择器：`$('.buttonClass')`
* 标签选择器：`$('button')`

```javascript
<html>
    <head>
        <title>我的标题</title>
    </head>
<body>
    <button id="buttonId" class="buttonClass">我的按钮</button> <br><br>
    <button class="buttonClass">你的按钮</button>
    <script src="jquery-1.6.1.min.js"></script>
    <script src="js1.js"></script>
</body>
</html>

//id选择器
//修改css：页面打开时，按钮背景就是蓝色
$('#buttonId').css("background", "blue");

//绑定事件：点击按钮时，按钮背景变为黄色
$('#buttonId').click(function() {
    $('#buttonId').css("background", "yellow");
});

//类选择器
$('.buttonClass').click(function() {
    $('.buttonClass').css('font-size',"20px");
});

//标签选择器
$('button').click(function() {
    $('button').css('background', 'green');
});
```

# 第3章 DOM操作

## html() 获取标签夹着的所有内容（包括子标签）

```javascript
<p title="选择你喜欢的水果。"><strong>你最喜欢的水果是？</strong></p>

//获取
var p_html = $("p").html();
alert(p_html); //<strong>你最喜欢的水果是？</strong>
//设置
$("p").html("<strong>我爱中国</strong>");
```

## text() 仅获取标签夹着的文本内容

```javascript
<p title="选择你喜欢的水果。"><strong>你最喜欢的水果是？</strong></p>

//获取
var p_text = $("p").text();
alert(p_text); //你最喜欢的水果是？
//设置
$("p").text("我爱中国");
```

## val() 获取用户输入的值

该方法不仅可以获取输入框中用户输入的值，还可以获取value属性的值。

```
<input type="text" value="请输入用户名" />

//获取
var inputVal = $("input").val();
alert(inputVal);
//设置
$("input").val("请输入密码");
```

## attr() 获取标签的属性值

```javascript
<p id="p1"></p>

//设置
 var p1Color = $("#p1").attr("class", "p1Class");

//获取
var p1Title = $("#p1").attr("class");
alert(p1Title); //p1Class

//删除
$("#p1").removeAttr("class");
```

## 设置CSS

```javascript
<p><strong>我爱我的祖国</strong></p>

//设置
$("p").css("backgroundColor", "yellow");
//获取
var bgColor = $("p").css("backgroundColor");
//同时设置多个属性
$("p").css({"backgroundColor":"yellow", "fontSize":"20px"});
```

注意，对于含有`-`号的css属性有两种写法：

```javascript
//推荐此写法：转为驼峰命名法，并带引号
$("p").css("backgroundColor", "yellow");

$("p").css("background-color", "yellow");

$("p").css(backgroundColor, "yellow");
```

# 第4章 jQuery中的事件

## ready()函数

该函数与JS中的window.onload的效果非常类似，主要区别在于：

（1）window.onload是在网页中所有的元素、资源文件完全加载到浏览器后才执行。而ready()是在DOM准备就绪后就立刻执行（此时可能一些大的图片还没有下载完毕）

（2）window.onload只能绑定一个函数，而ready()可以绑定多个函数。

```javascript
//绑在window上与绑在document上是一样的，推荐绑在document上
$(window).ready(function() {
    alert("i m ready!");
});

$(document).ready(function() {
    alert("i m ready!");
});
```

## load()函数

load()函数的效果等价于window.onload。该函数的执行时机也与window.onload完全相同。唯一的好处就是可以注册多个函数事件。

```javascript
//只能绑在window上，不能绑在document上
$(window).load(function() {
    alert("i m loaded!");
});
```

## ready()函数的简写

```javascript
//下面三者等价
$(document).ready(function() {
    alert("ready to work");
});

//$(document)可以简写为$()。因为当$()不带参数时，默认参数就是document
$().ready(function() {
    alert("ready to work");
});

$(function() {
    alert("ready to work");
});
```

## 事件绑定

**方法1：使用bind()函数**

```javascript
$("p").bind("click", function() {
    alert("bind click");
});
```

**方法2：直接使用事件函数**

```javascript
$("p").click(function() {
    alert("bind click");
});
```

**一个事件绑定多个函数**

```javascript
$("p").click(function() {
    alert("bind 1");
});
$("p").click(function() {
    alert("bind 2");
});
```



## 阻止事件冒泡、阻止默认行为

jq并没有提供这方面的封装，因此我们直接使用DOM规范提供的方式就可以了。

```javascript
event.stopPropagation(); //阻止事件传播
event.preventDefault(); //阻止默认行为
```

## unbind()移除绑定

```javascript
//移除绑定所有事件
$("p").unbind();

//移除绑定所有的click事件
$("p").unbind("click");

//移除某一个绑定的事件
$("p").click(fun1 = function() {
    alert("bind 1");
});
$("p").click(fun2 = function() {
    alert("bind 2");
});
$("p").unbind("click", fun1);
```

## 第6章 jQuery与Ajax的应用

## 传统的ajax

```javascript
<body>
    <input type="button" value="ajax提交" onclick="submitAjax();" /> <br>
    <p id="resultText"></p>
    <script src="js1.js"></script>
</body>

function submitAjax() {
    var xmlHttpReq = null;
    if(window.ActiveXObject) { //IE5,IE6是以ActiveXObject的方式引入XMLHttpRequest对象的
        xmlHttpReq = new ActiveXObject("Microsoft.XMLHTTP");    
    }
    else if(window.XMLHttpRequest) { //除IE5,IE6以外的浏览器，XML
        xmlHttpReq = new XMLHttpRequest();
    }
    xmlHttpReq.open("GET","example.txt", true); //true表示异步
    xmlHttpReq.onreadystatechange = requestCallBack; //设置回调函数
    xmlHttpReq.send(null); //send()函数：get方式可以使用不指定参数或者null为参数。
    function requestCallBack() {
        if(xmlHttpReq.readyState==4) {
            if(xmlHttpReq.status==200) {
                //将xmlHttpReq.responseText的值赋予id为resultText的元素
                document.getElementById("resultText").innerHTML = xmlHttpReq.responseText;
            }
        }
    }
}

//必须部署在tomcat里运行，否则会报跨域以及协议不支持的错误。
```

## jQuery中的ajax

jQuery对ajax操作进行了多次封装，形成了下列方法，其中第一层和第二层的方法最常用。

* 第一层的方法：`$.ajax()`
* 第二层的方法：`load()`和`$.get()`和`$.post()`
* 第三层方法：`$.getScript()`和`$.getJSON()`

### load()

load()方法通常用来从服务器上获取静态的数据文件。可设置的参数包括：

* url：请求url地址
* data：发送至服务端的key-value参数
* callback：回调函数

**1.基本用法**

```javascript
//不指定参数，则默认用get方式
//返回的结果内容自动插入到标签中作为文本内容
$("input").click(function() {
    $("#resultText").load("example.txt");
});
```

**2.采用post**

如果传递了参数，则自动采用post方式

```javascript
$("input").click(function() {
    $("#resultText").load("example.txt", {name:"rain", age:"12"});
});
```

**3.设置回调函数**

```javascript
$("input").click(function() {
    $("#resultText").load("example.txt", {name:"rain", age:"12"}, function(responseText, textStatus, XMLHttpRequest) {
        // responseText：请求返回的内容
        // textStatus：请求状态，包括success、error、notmodified、timeout4种
        //XMLHttpRequest：XMLHttpRequest对象
    });
});
```

### get和post

使用`$.get()`和`$.post()`方式进行异步请求。两者用法都是一样的。可设置的参数包括：

* url：请求url
* data：发送至服务端的参数
* callback：回调函数
* type：服务端返回内容的格式，包括xml、html、script、json、text、_default

**获取json数据**

```javascript
<body>
    <input type="button" value="ajax提交" onclick="submitAjax();" /> <br>
    <p id="p1"></p>
    <p id="p2"></p>
    <p id="p3"></p>
    <script src="jquery-1.6.1.min.js"></script>
    <script src="js1.js"></script>
</body>

//example.json
{
	"username":"lyn",
	"password":"abc123",
	"age":19
}

$("input").click(function() {
    $.post("example.json", {address:"kings road", country:"uk"}, function(data, textStatus) {
        var username = data.username;
        var password = data.password;
        var age = data.age;
        $("#p1").text(username);
        $("#p2").text(password);
        $("#p3").text(age);
    }, "json")
});
```

### $.ajax()

该函数只有一个参数，封装成对象的形式。ajax用到的具体参数都是以key/value的形式存在。所有的具体参数都是可选的。主要用到的参数如下：

* url：String类型，请求URL的地址
* type：String类型，GET、POST方式
* timeout：Number类型，设置请求超时时间（毫秒）。此设置将覆盖$.ajaxSetup()方法的全局设置
* data：Object或String类型。发送给服务端的参数
* dataType：String类型，预期服务器返回的数据类型，比如xml、json。不指定的话，jq将自动根据HTTP包MIME信息返回responseXML或responseText，并作为回调函数参数传递。
* beforeSend：Function类型，发送请求前可以修改XMLHttpRequest对象的函数。例如添加自定义HTTP头。在beforeSend中如果返回false则会取消本次Ajax请求。XMLHttpRequest对象是唯一的参数。
* complete：Function类型，请求完成后调用的回调函数（请求成功或失败均调用）。参数包括XMLHttpRequest对象和一个描述成功请求类型的字符串。
* success：Function类型，请求成功后调用的回调函数。1.由服务器返回，并根据dataType参数进行处理后的数据。2.描述状态的字符串。
* error：Function类型，请求失败时调用的函数，该函数有有三个参数。
* global：Boolean类型。默认为true。表示是否触发全局Ajax事件。

```javascript
//beforeSend
function(XMLHttpReuqest {
}
          
//complete
function(XMLHttpRequest, textStatus) {
}

//success
function(data, textStatus) {
}

//error,通常，textStatus和errorThrown只有其中一个包含信息
error(XMLHttpRequest, textStatus, errorThrown)
```

```javascript
<html>
    <head>
        <title>我的标题</title>
    </head>
<body>
    <input type="button" value="ajax提交" onclick="submitAjax();" /> <br>
    <p id="p1"></p>
    <p id="p2"></p>
    <p id="p3"></p>
    <script src="jquery-1.6.1.min.js"></script>
    <script src="js1.js"></script>
</body>
</html>

{
	"username":"lyn",
	"password":"abc123",
	"age":19
}

$("input").click(function() {
   $.ajax({
       type:"POST",
       url:"example.json",
       dataType:"json",
       success:function(data) {
           var username = data.username;
           var password = data.password;
           var age = data.age;
           $("#p1").text(username);
           $("#p2").text(password);
           $("#p3").text(age);
       }
   });
});
```





