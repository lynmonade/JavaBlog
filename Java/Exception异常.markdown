# Exception异常

先执行try，如果有异常则立刻停止执行try之后的语句，转为执行catch。无论是否有异常，都会执行finally。

每个try都必须执行跟着一个catch或者finally。

catch从上到下捕获异常，最精确的异常应该放在最上面。另外，一个catch代码块也可以捕获多种类型的异常，多种类型异常用|隔开，表示"或"。

```java
public static void main(String[] args) {
	int i= 1;
	int j = 1;
	try {
		System.out.println("Try block entered i="+i+",j="+j );
		System.out.println(i/j);
		System.out.println("Ending try block");
	}
	catch (ArithmeticException | ArrayStoreException e) { //精确异常放上面。这个catch可以捕获两种异常
		System.out.println("Arithmetic Exception caught");
	}
	catch (Exception e) { //放下面
	}
	System.out.println("after try block");
}
```

无论是否捕获异常，finally均会执行。比如我们可以把关闭文件，关闭流的语句放在finally中。finally代码块中的返回值，会覆盖try代码块中的返回值。

```
try {
    ...
    ...
    return xx; //line 1
}
finally {
    ... //line 2;
}
... //line 3

//当执行完line1后，依然会执行line2之后才return返回值，但line3不会执行。、、
```




```
try {
    ...
    ...
    ...; //line 1 非return语句
}
finally {
    ... //line 2;
}
... //line 3
//line1, line2, line3会按顺序执行
```

也就是说，如果try或者finally中有return语句，则try-catch-finally之后的语句将不会被执行，如果try或finally中没有return语句，则try-catch-finally之后的语句会执行。此外，finally中的return结果将会覆盖try中的return结果。


RuntimeException和Error不需要捕获，因为这是不可挽回的错误，这种错误一般都是很严重的，需要修改代码才行，比如数组越界，除数为0等问题。

普通的Exception则可以捕获，并且开发人员可以尝试在catch中修复他们。
