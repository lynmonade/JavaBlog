# 第1章 JavaScript简介

JS是一张专为网页交互而设计的脚本语言，由夏磊三个不同的部分组成：

* ECMAScript，由ECMA-262定义，提供核心语言功能。
* 文档对象模型（DOM），提供访问和操作网页内容的方法和接口。
* 浏览器对象模型（BOM），提供与浏览器交互的方法和接口。

ECMAScript定义了语法、类型、语句、关键字、保留字、操作符、对象。ECMAScript与web浏览器没有依赖关系。ECMA-262定义的只是这门语言的基础，而在此基础之上可以构建更完善的脚本语言。我们常见的web浏览器只是ECMAScript实现可能的宿主环境之一。宿主环境不仅提供基本的ECMAScript实现，同时也会提供该语言的扩展，以便语言与环境之间对接交互。而这些扩展， 如DOM，则利用ECMAScript的核心类型和语法提供更多更具体的功能，以便实现针对环境的操作。其他宿主环境包括Node（一种服务端JavaScript平台）和Adobe Flash。

简单来说，ECMAScript就是对实现该标准规定的各个方面内容的语言的描述。JS则是基于浏览器宿主实现了ECMAScript，并提供了许多与浏览器宿主相关的对象，比如window，document等。Adobe ActionScript同样也实现了ECMAScript。

DOM是文档对象模型（Document Object Model），其主要工作是：

* 映射文档的结构
* DOM视图
* DOM事件
* DOM样式
* DOM遍历和范围

BOM是浏览器对象模型（Browser Object Model）。开发人员使用BOM可以控制浏览器显示的页面以外的部分。BOM作为JS实现的一部分，但却并没有相关的标准，这也导致BOM在不同浏览器下可能会有不同的效果。不过这一点在H5下已经得到了统一解决。BOM提供了如下功能：

* 弹出新浏览器窗口的功能
* 移动、缩放、关闭浏览器窗口的功能
* 提供浏览器详细信息的navigator对象
* 提供浏览器所加载页面的详细信息的location对象
* 提供用户显示器分辨率详细信息的screen对象
* 对cookies的支持
* 像XMLHttpRequest和IE的ActiveXobject这样的自定义对象

# 第2章 在HTML中使用JS

向HTML页面中插入JS的主要方法，就是使用`<script>`元素。这个元素有6个属性，但常用的只有src这个属性，src用于指定外部引用JS的地址，这个地址甚至可以是跨域的地址。当引入多个JS文件时，浏览器会按他们出现的先后顺序解析他们。

一般我们把`<script>...</script>`放置在</body>之前，就像下面这样：

```html
<body>
...HTML的内容
<script src=example1.js></script>
<script src=example2.js></script>
</body>
```

建议尽量把JS代码放到外部文件中，然后在HTML中引用外部js文件。这样做的好处是：

1. 可维护性：HTML代码和JS代码分离，便于维护。
2. 可缓存：如果有两个页面都是用同一个外部JS文件，那么浏览器只需下载这个外部JS文件一次。
3. 适应未来：在XHTML中无需再使用各种hack写法。

# 基本概念

## 语法

* JS严格区分大小写
* 变量命名方式和规则与Java一致
* 注释的方式与java一致
* 建议严格使用分号进行断句
* 建议if风格与java一致，避免goto错误

## 关键字和保留字

详见书中3.2章节，大多数和java一致

## 变量

变量是松散类型的，可以用来保存任何类型的数据。但不建议这么做。

```javascript
var message = "hi";
message = 100; //有效，但不推荐
```

**全局变量**

使用var操作符定义的变量将成为定义该变量的作用域中的局部变量。

```javascript
function test() {
    message = "hi"; //局部变量
}
test();
alert(message); //错误
```

**全局变量**

在定义变量时，如果胜率var操作符，则会创建一个全局变量。在下面的例子中，只要调用过一次test()函数，这个变量就有了定义，就可以在函数外部的任何地方被访问到。

```javascript
function test() {
    message = "hi"; //全局变量
}
test();
alert(message); //hi
```

## 数据类型

ECMAScript中有5种简单数据类型（也称为基本数据类型）：

* Undefined
* Null
* Boolean
* Number
* String

以及一种复杂数据类型：

* Object：Object本质上是由一组无需的key-value对组成的。就像map一样。

### typeof操作符

鉴于ECMAScript是松散类型的，因此需要有一种手段来检测给定变量的数据类型，typeof就是负责提供这方面信息的操作符。对一个值使用typeof操作符可能返回下列某个字符串：

* "undefined"，如果这个值未定义
* "boolean"，如果这个值是布尔值
* "string"，如果这个值是字符串
* "number"，如果这个值是数值
* "object"，如果这个值是对象或者null
* "function"，如果这个值是函数

```javascript
function myFunction() {
}
var message = "hello";
var obj = null;
alert(typeof(message)); //"string"
alert(typeof(true)); //"boolean"
alert(typeof(param)); //"undefined"
alert(typeof(99)); //"number"
alert(typeof(null)); //"object"
alert(typeof(obj)); //"object"
alert(typeof(myFunction)); //"function"
```

### Undefined类型

Undefined类型只有一个值，即undefined。在使用var声明变量但未对其初始化时，这个变量的值就是undefined。

```javascript
var message;
alert(message==undefined); //true
```

**一般来说，我们无需显式地使用undefined指来初始化变量，因为JS默认会对未初始化的变量赋上undefined。undefined这个值一般只用于比较，无需用于初始化。**

**未声明的变量**

对未声明的变量调用alert()函数会报错。**对于未声明的变量只能执行一项操作，即使用typeof检测其数据类型，此时会返回"undefined"。**

```javascript
var message;
alert(message); //undefined
alert(typeof(message));//undefined

//下面这个变量未定义
//var age; 
alert(age); //报错
alert(typeof(age)); //undefined
```

### Null类型

Null类型也是只有一个值的数据类型，这个值是null。null指表示一个空对象指针。这也正是使用typeof操作符检测null值时会返回"object"的原因。

**如果定义的变量准备在将来用于保存对象，那么最好将该变量初始化为null而不是其他值。这样一来，只要直接检查null值就可以知道相应的变量是否已经保存了一个对象的引用：**

```javascript
if(car!=null) {
	//对car对象执行某些操作
}
```

实际上，undefined值是派生自null值。因此ECMA-262规定对它们的相等性测试要返回true：

```
alert(null==undefined); //true
```

### Boolean类型

Boolean类型只有两个字面值：true和false。注意区分大小写，全为小写的才是Boolean类型的值。

虽然Boolean类型的字面值只有两个，但ECMAScript中所有类型的值都有与这个Boolean值等价的值。要将一个值转换为其对应的Boolean值，可以调用转型函数Boolean()。

下表列出了各种数据类型调用Boolean()函数转为Boolean类型时的结果：

| 数据类型      | 转换为true的值      | 转换为false的值 |
| --------- | -------------- | ---------- |
| Boolean   | true           | false      |
| String    | 任何非空字符串        | 空字符串''     |
| Number    | 任何非零数字值（包括无穷大） | 0和NaN      |
| Object    | 任何对象           | null       |
| Undefined | 不适用            | undefined  |

**上面的规则非常重要，因为他们会应用于if语句中：if语句会自动对上述数据类型调用Boolean()函数，转为对应的Boolean类型进行if判断。**

```javascript
var message = "hello";
var num = 32;
var zero = 0;
var obj = null;
if(message) {
    alert("message is true");
}
if(num) {
    alert("num is true");
}
if(zero==false) {
    alert("zero is false");
}
if(!obj) {
    alert("obj is false");
}
```

### Number类型

ECMAScript中的数字都是双精度浮点类型，类似于Java中的double。在大多数浏览器中，JS数字的范围是[5e-324, 1.7976931348623157e+308]。我们可以用下面的方式获取最大值和最小值：

```javascript
Number.MIN_VALUE;
Number.MAX_VALUE;
```

如果数字超过上述范围，则这个数字将被自动转换成特殊的Infinity值。如果这个值是正数，则会转化为Infinity，如果是负数，则会转化为-Infinity。下面两个属性分别表示数字的正无穷和负无穷。

```javascript
Number.POSITIVE_INFINITY;
Number.NEGATIVE_INFINITY;
```

**NaN**

NaN，表示非数值，它是一个特殊的数值，这个数值用于表示一个本来要返回数值的操作数未返回数值的情况（这样就不会抛出错误了）。例如，在Java中，任何数除以0都会导致错误，从而停止代码执行。而在JS中，任何数值除以0会返回NaN，因此不会影响其他代码的执行。NaN的三个特点：

* 任何涉及NaN的操作都会返回NaN
* NaN与任何值都不想等，包括NaN本身
* ECMAScript提供isNaN()函数，这个函数接受一个参数，该参数可以是任何类型，而函数会帮我们确定这个参数是否"不是数值"。

```javascript
alert(NaN==NaN); //false
alert(isNaN(NaN)); //true
alert(isNaN(10)); //false
alert(isNaN("blue")); //true
alert(isNaN(true)); //false
```

**数值转换**

下列三个函数可以把非数值转换为数值，第一个函数可以用于任何数据类型，而另两个函数则专门用于把字符串转换成数值。

```javascript
Number();
parseInt();
parseFloat();
```

Number()函数的转换规则如下：

* 如果是Boolean值，true转换为1，false转换为0
* 如果是数字值，只是简单的传入和返回
* 如果是null值，返回0
* 如果是undefined，返回NaN
* 如果是字符串，则遵循下列规则：
  * 如果字符串中只包含数字（包括前面带的正号、负号），则将其转换为十进制数值
  * 如果字符串中包含有效的浮点格式，则转换为对应的浮点数
  * 如果字符串中包含有效的十六进制格式，则转换为相等大小的十进制整数值
  * 如果字符串是空的（不包含任何字符），则转换为0
  * 如果字符串中包含除了上述格式之外的字符，则将其转换为NaN
* 如果是对象，则调用对象的valueOf()方法，然后依照前面的规则转换返回的值。如果转换的结果是NaN，则调用对象的toString()方法，然后再次依照前面的规则转换返回的字符串值。

```javascript
alert(Number(true)); //1
alert(Number(false)); //0
alert(Number(32)); //32
alert(Number(0099)); //99，忽略前导的00
alert(Number(null)); //0
var para; alert(Number(para)); //NaN
var s1 = "123"; alert(Number(s1)); //123
var s2 = "3.43"; alert(Number(s2)); //3.43
var s3 = ""; alert(Number(s3)); //0
var s4 = "str123"; alert(Number(s4)); //NaN
```

**Number()函数在做字符串转化时比较麻烦，因此在处理整数的时候更常用的是parseInt()函数。**parserInt()的转换规则如下：

* 该函数会忽略字符串前面的空格，直到找到第一个非空格字符
* 如果第一个字符不是数字字符或负号，parseInt()就会返回NaN
* 如果第一个字符是数字字符，parserInt()会继续解析第二个字符，直到解析完所有后续字符或者遇到了一个非数字字符。

```javascript
// 建议显式地指定第二个参数，说明转化为什么进制的整数
alert(parseInt("1234blue", 10)); //1234
alert(parseInt("blue1234", 10)); //NaN
alert(parseInt("0xA", 16)); //10（十六进制）
alert(parseInt(22.5, 10)); //22
alert(parseInt(070, 8)); //46(8进制)
alert(parseInt("80",10)); //80
```

parseFloat()方法与parseInt()类似，但parseFloat()会忽略前导0，并且他也没有第二个参数，只能解析成十进制的值。

```
alert(parseFloat("1234blue")); //1234
alert(parseFloat("blue1234")); //NaN
alert(parseFloat("22.5")); //22.5
alert(parseFloat("0xA")); //0,因为只能识别十进制数
alert(parseFloat("22.33.5")); //22.33
alert(parseFloat("0908.5")); //908.5
alert(parseFloat("3.125e7")); //31250000
```

### 字符串

ECMAScript中的字符串可以用单引号、也可以用双引号。这里的字符串与Java中的字符串类似，字符串一旦创建，它们的值就不能改变。我们可以通过length属性获取字符串中的字符个数：

```javascript
alert("hello".length); //5
alert("中国".length); //2
```

**字符串转换的两个函数**

```javascript
toString();
String();
```

数值、布尔值、对象、字符串都具有toString()方法，但null和undefined没有这个方法。多数情况下，调用toString()方法不必传递参数，此时表示已十进制格式返回数值的字符串表示形式。此外，也可以通过传递参数，表示可以输出以二进制、八进制、十六进制的数值。

```javascript
var num = 10;
alert(num.toString()); //10
alert(num.toString(2)); //1010
alert(num.toString(8)); //12
alert(num.toString(10)); //10
alert(num.toString(16)); //a
```

在不知道要转换的值是不是null或undefined的情况下，还可以使用转型函数String()，这个函数能将任何类型的值转换为字符串。String()函数的具体规则是：

* 如果值有toString()方法，则调用该方法（无参数）并返回相应的结果
* 如果值是null，则返回"null"
* 如果值是undefined，则返回"undefined"

```javascript
alert(String("53")); //53
var obj = null; alert(String(obj)); //null
var p1; alert(String(p1)); //undefined
```

### Object类型

即对象类型，可以用下面的方式创建自定义对象。Object类型可以与Java中的Object基类非常类似，继承了Object类型的对象都会具有Object类型的相关方法：

```javascript
var o = new Object();
```

Object类型包含的属性和方法详见3.4.7章节。

## 操作符

多数与Java类似，用到再看吧。

* 与：&&
* 或：||
* 非：!

全等比较===，它只在两个操作数未经转换就相等的情况下返回true。

```javascript
alert("55"==55); //true,因为转换后相等
alert("55"===55); //false,因为不同的数据类型不相等
```

## 语句

多数与Java一致。用到再看吧。

## 函数

当使用return终止函数执行时，实际上是返回一个undefined的值。推荐做法：要么让函数始终都返回一个值，要么永远都不要返回值，这样方便调试代码。

JS函数中的参数是通过arguments对象进行传递的，arguments对象与数组类似，可以通过[]访问第N个参数，也可以通过length属性确定传递进来多少个参数。所以，在JS中函数定义中的参数列表并不是必须的，它只是提供了一种便利。即使该函数在定义时不接收任何参数，我们还是可以通过arguments对象在函数中获取传入的参数。并且可以利用arguments.length来间接实现函数重载。

```javascript
function myFunction() {
    alert(arguments.length);
    if(arguments.length>0) {
        for(var i=0; i<arguments.length; i++) {
            alert(arguments[i]);
        }
    }
  	return; //实际上返回的是undefined
}

myFunction("a", "b"); 
myFunction(true, 50, "c");
```

# 第4章

基本类型和引用类型在传值方面的规则与Java完全一致。对于基本类型，按值传递，形参和实参都是独立的个体，一方的修改不影响另一方。对于对象类型，形参和实参指向内存中同一个对象。

## 检测类型

typeof常用于检测基本类型。对于对象类型，我们并不像知道某个值是对象，而是想知道它是什么类型的对象，此时应该使用instanceof操作符。如果变量是给定引用类型的实例（根据原型链来判断），那么instanceof操作符就会返回true。

根据规定，所有引用类型的值都是Object的实例。因此在检测一个引用类型值和Object构造函数时，instanceof操作符始终返回true。如果使用instanceof检测基本类型时，始终返回false，因为基本类型不是对象。

```javascript
alert(person instanceof Object); //变量person是Object类型吗
alert(colors instanceof Array); //变量colors是Array吗
alert(pattern instanceof RegExp); //变量pattern是RegExp吗
```

## 执行环境及作用域

### 执行环境

执行环境（execution context）是JS中最重要的一个概念，它定义了变量或函数有权访问的其他数据。每个执行环境都有一个与之关联的变量对象（variable object），环境中定义的所有变量和函数都保存在这个对象中。虽然我们编写的代码无法访问这个对象，但解析器在处理数据时会在后台使用它。

全局执行环境是最外围的一个执行环境。在web浏览器中，全局执行环境是window对象。因此所有全局变量和函数都是作为window对象的属性和方法创建的。某个执行环境中的所有代码执行完毕后，该环境被销毁。例如浏览器关闭时，全局执行环境被销毁。JS中常用的两个执行环境就是**全局执行环境和函数环境。**

### 作用域

当代码在某一环境中执行时，会创建变量对象的一个作用域链。作用域链由以下作用：

1. 确定当前执行环境可以访问到的变量
2. 确保当前执行环境可以按顺序访问到变量
3. 确保当前执行环境访问变量的顺序

作用链的前端是当前执行的代码所在环境的变量对象，如果这个环境是函数，则将函数的活动对象（activation object）作为变量对象。活动对象的下一个变量对象来自包含（外部）环境，而再下一个变量对象则来自下一个包含环境。这样，一致延续到全局执行环境。全局执行环境的变量对象始终都会作用域链中的最后一个对象。表示服解析是沿着作用域链一级一级地搜索标识符的过程。搜索过程始终从作用域链的前端开始，然后逐级地向后回溯。

```javascript
var color = "blue";
function changeColor() {
    var anotherColor  = "red";

    function swapColors() {
        var tempColor = anotherColor;
        anotherColor = color;
        color = tempColor;
        //这里可以访问color、anotherColor和tempColor
    }
    //这里可以访问color和anotherColor，但不能访问tempColor
    swapColors();
}
//这里只能访问color
changeColor();
```

在上面的例子中包含三个执行环境。

（1）全局执行环境，包含一个全局变量color和一个全局函数changeColor()。全局环境的作用链点顶端就是全局环境的变量对象。由于其外围已经不包含其他环境，因此全局执行环境中只能访问color和changeColor()。

（2）changeColor()函数执行环境。包含一个局部变量anotherColor，一个函数swapColors()，以及arguments[]对象。此时，changeColor环境的作用域链顶端是changeColor变量对象，而外围包含是全局执行环境，因此该环境可以访问anotherColor局部变量、swapColors()、color全局变量。

（3）swapColors()函数执行环境。包含一个局部变量tempColor、以及arguments[]对象。此时，changeColor环境的作用域链顶端是swapColors变量对象，其外围是changeColor环境，而再外一层是全局执行环境。因此swapColor环境可以访问tempColor局部变量、anotherColor局部变量、color全局变量。

### 延长作用链

可以使用try-catch和with实现延长作用链。

### 没有块级作用域

js并没有花括号作用域这种说法，这导致在if花括号或者for循环中定义的变量，并不会在花括号结束后销毁。此时变量会被挂靠在最近的执行环境上。

**声明变量**

使用var声明的变量会自动被添加到最接近的环境中。在函数内部，最接近的环境就是函数的局部环境。在with语句中，最接近的环境是函数环境。如果初始化变量时没有使用var声明，该变量会自动被添加到全局环境上。

**查询标识符**

查询标识符是从作用域链的前端开始，向外扩展一步一步的查询外围环境中名称匹配的标识符。一旦查询命中，则查询终止，并使用命中的标识符。

## 垃圾回收

两种方式：

1. 标记清除（推荐，现在的浏览器基本都使用这个方式）
2. 引用计数（会造成循环引用，不推荐使用）

关于内存管理，需注意两点：

1. 局部变量无需显式地设置为null，因为当局部变量离开函数环境后，会被自动销毁。
2. 全局变量使用完毕后，开发人员最好显式地设置为null，这样可以让该变量更快地得到销毁。


# 第5章 引用类型

## Object类型

JS中，**引用类型**一词等价于Java中的类，我们可以使用new关键字创建引用类型的实例对象。下面列出了JS创建对象的集中方式：

```javascript
//创建对象
var person1 = new Object(); //第一种方式：使用new关键字
person1.name = "lyn"; //属性赋值，使用.语法
person1.age = 20; //属性赋值

var person2 = { //第二种方式：对象字面量表示法，推荐。
    name : "lyn",
    age : 20
};

//在函数参数中使用对象字面量表示法
function displayInfo(args) {
    var output = "";
    if(typeof args.name == "string") {
        output += "name="+args.name + "\n";
    }
    if(typeof args.age == "number") {
        output += "age=" + args.age + "\n";
    }
    alert(output);
}

displayInfo({
    name:"roger",
    age:15
});
displayInfo({
    name:"burg"
});
```

## 数组类型

JS中的数组有如下特性：

* 它是有序列表
* 每一个项可以保存不同的数据类型
* 数组长度可以自增

### 创建数组

下面列出了几种创建数组的方式。数组创建后，如果没有立刻赋值，则对应位置会自动初始化为undefined。

```javascript
//创建数组
var colors1 = new Array(); //创建空数组
var colors2 = new Array(20); //创建长度为20的数组
var colors3 = Array(3); //创建长度为3的数组
var colors4 = new Array("red", "blue", "green"); //创建后立即填充数据
var colors5 = ["red", "blue", "green"]; //创建后立即填充数据

//访问数组元素,赋值元素
var color = colors[1];
colors[2] = "orange";
```

**JS的数组还有很多有用的方法，用到再看。具体详见书中5.2章节。**

## Date类型

5.3章节，用到再看。

## RegExp类型

5.4章节，用到再看。

## Function类型

JS中的函数没有重载，如果两个函数的名称相同，则后面声明的函数会覆盖前面声明的函数。

定义函数有两种方式下面两种方式：

* 函数声明
* 函数表达式

```javascript
//函数声明
function sum(n1, n2) {
    return n1+n2;
}

//函数表达式
var sum = function(n1, n2) {
    return n1+n2;
}
```

两者的主要区别在于：**函数声明**具备**函数声明提升**的特性：即函数声明可以放在函数调用的后面。但函数表达式却不具备提升的特性。

```javascript
//正确
alert(sum(1,2));
function sum(n1, n2) {
    return n1+n2;
}

//错误
alert(sum(1,2));
var sum = function(n1, n2) {
    return n1+n2;
}
```

由于JS中的函数都是用指针来操纵的，因此也可以把函数指针作为参数进行传递。需注意的是，作为参数传递时，只需传递函数指针名称，如`sum`，而作为函数调用时，需加上括号和实参`sum(1,2)`。

```javascript
//正确
function sumA(n1, n2) {
    return n1+n2;
}
function funA(method) {
    return method(1,2); //函数调用
}
alert(funA(sumA));//3,函数指针作为参数传递

//正确
var sumB = function(n1, n2) {
    return n1+n2;
}
function funB(method) {
    return method(4,5); //函数调用
}
alert(funB(sumB)); //9,函数指针作为参数传递
```

函数中还可以使用this关键字，其作用与java中的this一样，我们可以把this看作是JS执行环境对象。

## 内置对象

内置对象是指有ECMAScript实现提供的、不依赖于宿主环境的对象，这些对象在ECMAScript程序执行之前就已经存在了，因此开发人员不必显示第实例化内置对象。常用的内置对象包括Object、Array、String、Math、Global。在浏览器中，都是以window对象作为Global对象。

**所有的全局函数、全局变量、以及那些可以直接使用的方法，如isNaN()、isFinite()、parseInt()、parseFloat()，他们都会挂载到global对象上。在浏览器上就会挂载到windows对象上，成为window对性的属性和方法**。

**两个重要方法**

```javascript
//会对空格、中文进行UTF-8编码，但不会对冒号、斜杠进行编码，常用于编码整个URL
encodeURI()

//对非字母、非数字进行UTF-8编码，因此常用于编码URL的参数部分。更加常用
encodeURIComponent()

//例子
var url = "http://localhost:8080/project/loginServlet";
//http://localhost:8080/project/loginServlet
console.log(encodeURI(url));

var baseURL = 'http://localhost:8080/project/loginServlet?username=';
var param = "中国";
//http://localhost:8080/project/loginServlet?username=%E4%B8%AD%E5%9B%BD
console.log(baseURL+encodeURIComponent(param));
```

# 第8章 BOM

## window.open()打开窗口

该函数可以在新窗口或新页签中打开一个特定的URL。该方法接收4个参数：

1. 要加载的URL，通常只需要设置这个参数
2. 窗口目标，如果包含iframe，则可以指定在哪个iframe中加载URL
3. 特性字符串，用于设置新窗口的属性，比如窗口大小、位置等
4. 表示新页面是否取代浏览器历史记录中当前加载页面的布尔值，没啥用

## window.close()关闭窗口

该函数没有参数，用于关闭当前窗口或页签。

## setTimeOut()超时调用

该函数表示在N毫秒之后把要执行的代码加入到JS的任务队列中。注意这里表达的是N毫秒后加入队列，而不是N毫秒后立即执行。因为JS是一个单线程的解释器，一定时间内只能执行一段代码。因此该函数只能确保一定时间后，指定代码会被加入到队列中，但必须等到队列前面的代码执行完毕后，才能轮到你的代码执行。

```javascript
var timeoutId = setTimeout(function() {
    alert("hello world");
}, 1000);
```

此外，我们还可以在指定的时间尚未过去之前调用clearTimeout()，实现完全取消超时调用。

```javascript
clearTimeOut(timeoutId);
```

## setInterval()间歇调用

该函数可以实现在指定的时间间隔重复执行代码。

```javascript
var count = 0;
var intervalId = setInterval(function() {
    alert("hello world");
    count++;
    if(count>3) {
        clearInterval(intervalId); //取消间歇调用
    }
}, 1000);

```

## 三个模态的系统对话框

浏览器可以通过下列三个函数弹出对话框。这三个函数打开的对话框都是同步和模态的，也就是说，显示这些对话框的时候代码会停止执行，而关闭这些对话框后代码又会恢复执行。

```javascript
alert("hello world");

if(confirm("are u sure??")) {
    alert("i m so glad u r sure.");
}
else {
    alert("i m sorry to hear u r not sure.");
}

var result = prompt("what is ur name?", "");
if(result!=null) {
    alert("welcome "+result);
}

```

## location对象

它提供了许多与当前窗口中加载的文档的URL有关的信息，还提供了一些导航功能。location对象既是window对象的属性，也是document对象的属性，因此window.location和document.location引用的是同一个对象。location对象常用的属性包括：hash、host、hostname、href、pathname、port、protocal、search。

**使用location改变浏览器的位置**

我们可以使用location对象改变浏览器当前页面的URL，即跳转到特定URL。具体有下面几种方式：

```javascript
//调用下列三个方法，浏览器的后退操作不受影响
//window.location和location.href本质上在内部会转调location.assign()
location.assign("www.baidu.com");
window.location = "www.baidu.com";
location.href = "www.baidu.com"; //最常用

//relace()会使得浏览器的后退按钮被禁用
location.replace("www.baidu.com");

//reload()表示重新加载当前页面，如果不带参数则表示尽可能从缓存中加载，如果参数为true则表示强制从后端重新加载。一般放在代码最后一行执行
loaction.reload(true);
```

## history对象

history对象是window对象的属性，它保存着用户上网的历史记录，虽然开发人员无法得知用户浏览过的URL，但可以借由用户访问过的页面列表，在不知道实际URL的情况下间接实现后退和前进。history主要用于创建自定义的“后退”和“前进”按钮。

```javascript
//后退一页
history.go(-1);
history.back();
//前进一页
history.go(1);
history.forward();
//前进两页
history.go(2);
//跳转到最近的baidu.com页面,类似于like
history.go("baidu.com");
```

# 第10章 DOM

文档元素是文档的最外层元素，在html文档中，<html>元素就是文档元素。HTML文档中共有12种节点类型，他们都继承自Node类型，可以把Node类型看做是所有节点类型的基类，因此这12种节点都共享着相同的属性和方法。

## document

document对象是HTMLDocument（继承自Document类型）的一个实例，可以把document理解为HTML页面本身，通过document对象我们可以获得页面的有关信息，并操作页面的外观。

**1. 获取文档信息**

```javascript
var html = document.documentElement; //取得对<html>的引用
var body = document.body; //取得对<body>的引用
var title = document.title; //取得对<title>的引用
document.title = "new title"; //设置标题
var url = document.URL; //取得完整的URL
var domain = document.domain; //取得域名
var referrer = document.referrer; //取得来源页面的URL
```

**2. 查找元素**

```
var element1 = document.getElementById("myId"); //根据id属性寻找第一个匹配的元素，不存在则返回null
var elements1 = document.getElementsByTagName("img"); //根据元素名称寻找所有标签名称匹配的元素
var elements2 = document.getElementsByName("myColor"); //根据name属性寻找所有匹配的元素
var elements3 = document.anchors; //寻找文档中所有带name属性的<a>元素
var elements4 = document.forms; //寻找所有的<form>元素
var elements5 = document.iamges; //寻找所有的<img>元素
var elements6 = document.links; //寻找所有带href属性的<a>元素
```

## element类型：html元素及其子元素

element类型就是我们常用的HTML元素，我们平时操纵的都是HTML元素的子元素。这些子元素常用的属性包括：

* id：元素在文档中的唯一标识符
* title：附加说明信息
* dir：语言方向
* className：即class属性的值

**获取属性的两种方式**

获取元素的属性时，可以使用通过“属性访问”，也可以通过“函数调用”的方式获取。这两种方式的区别在于：

* 属性访问的方式只能获取HTML元素所规定的属性，不能获取自定义属性。而函数调用的方式可以获取自定义属性。
* 获取class属性的信息时，属性访问方式使用className属性来获取。而函数调用方式使用class关键字来获取。
* 获取style属性的信息时，属性访问方式获取到的是一个Object对象，而函数调用方式获取到的是CSS对应的字符串。
* 获取类似于onclick这样的事件处理信息时，属性获取方式获取到的是一个Function对象，而函数调用方式获取到的是字符串。

在开发中，属性获取方式比较常用。

```javascript
<div id="myId" class="myClass" title="myTitle" style="color:blue" onclick="myFunction();" myAttr="custom_attribute">你好中国</div>

function myFunction() {
    alert("call myFunction");
}

//属性访问的方式
var div = document.getElementById("myId");
var divId = div.id; //myId
var divClass = div.className; //myClass,这是是用clasName，而不是class
var divTitle = div.title; //myTitle
var divStyle = div.style;
var divOnclick = div.onclick;
alert(typeof(divStyle)); //Object 
alert(typeof(divOnclick)); //Function

//函数调用的方式
var attrDivId = div.getAttribute("id"); //myId
var attrDivClass = div.getAttribute("class"); //myClass，这是是用class，而不是className
var attrDivTitle = div.getAttribute("title"); //myTitle
var attrDivStyle = div.getAttribute("style"); //color:blue
var attrDivOnclick =  div.getAttribute("onclick"); //myFunction();
var adtrDivMyAttr = div.getAttribute("myAttr"); //custom_attribute
```

此外，我们还可以使用下面两个方法实现设置属性和删除属性。

```javascript
var div = document.getElementById("myId");
div.setAttribute("id", "newId");
div.setAttribute("class", "newClass");
div.removeAttribute("id");
```

## 第12章 DOM2和DOM3

DOM1主要定义的是HTML文档的底层结构。DOM2和DOM3则在这个结构的基础上引入了更多的 交互能力（定义了更多的属性和函数）。

* DOM2级核心：在DOM1级核心的基础上构建，为节点天界了更多方法和属性。
* DOM2级视图：为文档定义了基于样式信息的不同视图。
* DOM2级事件：说明了如何使用事件与DOM文档交互。
* DOM2级样式：定义了如何以编程方式来访问和改变CSS样式信息。
* DOM2级遍历和范围：引入了遍历DOM文档和选择其特定部分的新接口。
* DOM2级HTML：在DOM1级HTML基础上构建，添加了更多属性、方法和新接口。
* DOM3级：添加了“XPath模块”和“加载与保存模块”。



## 第13章 事件

**事件流**描述的是从页面中接收事件的顺序。浏览器一般提供了两种事件流：1. 事件冒泡。2.  事件捕获。

```javascript
<html>
<body>
    <div id="myId" onclick="myFunction();">你好中国</div>
    <script src="js1.js"></script>
</body>
</html>
```

**1.事件冒泡**

即事件开始时由最具体的元素接收，然后逐级向上传播到较为不具体的节点。在上例中事件会按照如下循序传播，推荐使用事件冒泡模型。

1. <div>
2. <body>
3. <html>
4. <document>

**2.事件捕获**

事件捕获的思想是不太具体的节点应该更早接收到事件，而最具体的节点应该最后接收到事件。在上例中会按如下顺序触发click事件：

1. <document>
2. <html>
3. <body>
4. <div>

**DOM事件流**

DOM2级事件规定的事件流包括三个阶段：

* 事件捕获阶段
* 处于目标阶段
* 事件冒泡阶段