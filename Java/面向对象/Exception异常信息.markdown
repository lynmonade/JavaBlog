# Exception异常信息

异常定义了程序中遇到的**非致命的错误**，而不是编译时的语法错误。比如程序打开一个不存在的文件、网络连接中断、操作数组越界、装在一个不存在的类等。

首先我们需要关注的是`Throwable`类，他是所有异常的父类。`Throwable`下有两个子类：Error类和Exception类。Error表示很严重的错误，一般开发人员不需要关心他，也不需要抛出或捕获它。我们只需要抛出、捕获Exception类及其子类。

Exception有一个子类叫做RuntimeException，他属于**不受检查的异常**，而Exception的其他子类在编译时被强制检查的异常称为**受检查的异常**。

## RuntimeException

RunTimeException属于编程错误，会被Java虚拟机自动抛出，异常会直达至main方法，，因此**开发人员无需显式地抛出、捕获RuntimeException**，Java虚拟机都帮你完成了。而Exception的其他异常子类，开发人员必须显式地抛出、捕获。

但在实际开发中，我们还是经常显式地抛出RuntimeException，这么做的目的在于提供更加精确的异常信息，便于方法使用者进行错误排查，比如JFinal的源码就是这么做的：

```java
private void createJFinalConfig(String configClass) {
	if (configClass == null)
      //显式地抛出RuntimeException
		throw new RuntimeException("Please set configClass parameter of JFinalFilter in web.xml");
	
	try {
		Object temp = Class.forName(configClass).newInstance();
		if (temp instanceof JFinalConfig)
			jfinalConfig = (JFinalConfig)temp;
		else
			throw new RuntimeException("Can not create instance of class: " + configClass + ". Please check the config in web.xml");
	} catch (InstantiationException e) { //catch受检查异常，抛出不受检查异常
		throw new RuntimeException("Can not create instance of class: " + configClass, e);
	} catch (IllegalAccessException e) {
		throw new RuntimeException("Can not create instance of class: " + configClass, e);
	} catch (ClassNotFoundException e) {
		throw new RuntimeException("Class not found: " + configClass + ". Please config it in web.xml", e);
	}
}
```

我们可以对比一下显式抛出RuntimeException和不显式抛出RuntimeException的异常报错信息，我们自己抛出的RuntimeException异常会包含更多的提示信息，便于异常排查。

```java
//显式抛出
严重: Exception starting filter jfinal
java.lang.RuntimeException: Please set configClass parameter of JFinalFilter in web.xml

//不显式抛出
严重: Exception starting filter jfinal
java.lang.NullPointerException
```

此外，JFinal中还是用了一种技巧：**catch受检查的异常，并抛出部受检查的异常RuntimeException**。

## try..catch的作用

使用try..catch后，如果try中发生异常，异常之后的语句不会继续执行，并转而执行catch，catch执行完毕后，继续正常执行catch{}后面的语句。

如果不是用try..catch包裹住语句，当程序执行到**非致命错误的语句时**，程序就会停止执行。所以我们需要用try..catch包裹住这类可能发生非致命错误的语句，这样就可以让程序继续执行下去，而不是终止。此外我们还可以在catch{}中进行尽可能的补救，比如设置一些默认值，或者把错误写入日志等。

```java
public class TestException {
	public static void main(String[] args) {
		try {
			int result = new Test().devide(3, 0);
			System.out.println("result="+result);
		}
		catch (Exception e) {
			System.out.println(e.getMessage());
		}
		System.out.println("end of main"); //有了try..catch，程序不会终止，catch{}之后这句肯定会执行
	}
}
class Test {
	public int devide(int x, int y) {
		return x/y;
	}
}
```

## 异常说明：throws关键字

在上面的例子中，如果Test和TestException类是由不同的编写的。比如我们可以假设Test类是服务端程序员编写的工具类，而客户端程序员编写TestException类来调用工具类的方法，那么客户端程序员如何才能知道应该catch哪些**潜在的异常**呢？答案就是：让服务端程序员在编写`devide()`方法时使用throws关键字抛出**潜在的异常**，这样客户端程序员就可以在阅读工具类API时，catch对应的异常。

注意，如果一个方法在声明时，使用throws抛出潜在异常后，客户端在调用该方法时，即使你完全确定不会报错，但也必须使用try..catch捕获异常，这是强制的。

```java
public class TestException {
	public static void main(String[] args) {
		try {
			int result = new Test().devide(3, 0);
			System.out.println("result="+result);
		}
		catch (Exception e) { //强制捕获该异常
			System.out.println(e.getMessage());
		}
	}
}
class Test {
	public int devide(int x, int y) throws Exception{
		return x/y;
	}
}
```

如果上一层在调用方法时，如果还是无法捕获/处理该异常 ，则可以继续把异常抛出，让更上一层的方法来处理。

还有一种**作弊**的方式，即在方法声明时抛出异常，但实际代码却不抛出异常，这实际上是一种**预先占坑**的方式，以后修改代码时，或者子类在继承方法时可以抛出预先声明的异常。

## 自定义异常

我们可以创建继承自Exception类的自定义异常类，然后在客户端代码中捕获它：

````java
//除数为负数的自定义异常
public class DevideByMinusException extends Exception{
	int devisor;
	public DevideByMinusException(String msg, int devisor) {
		super(msg);
		this.devisor = devisor;
	}
	public int devisor() {
		return devisor;
	}
}
//注意catch的顺序，父类catch要放在最后，以保证精确获取异常，可类比if..elseif..elseif..else
public class TestException {
	public static void main(String[] args) {
		try {
			int result = new Test().devide(3, -1);
			System.out.println("result="+result);
		} 
		catch (DevideByMinusException e) { //除数为负数，则进入这里
			System.out.println(e.getMessage());
		}
		catch (ArithmeticException e) { //除数为0，则进入这里
			System.out.println(e.getMessage());
		}
		catch (Exception e) {
			System.out.println(e.getMessage());
		}
	}
}
class Test {
	public int devide(int x, int y) throws ArithmeticException, DevideByMinusException {
		if(y<0) {
			throw new DevideByMinusException("被除数为负数", y);
		}
		return x/y;
	}
}
````

此外，我们也可以用|或的方式在一个catch中捕获多个异常：

```java
catch (ArithmeticException | ArrayStoreException e) { //这个catch可以捕获两种异常
	System.out.println(e.getMessage());
}
```

## finally关键字

try..catch后面可以跟一个finally代码块，**无论是否出现了异常，finally均会在try..catch执行完毕后执行。**前面说到，catch{}后面跟着的普通语句也一样会被无条件的执行，那这和finally代码块有什么区别呢？这主要是执行顺序方面的区别。

### 例子1：try..catch包含return，而finally不包含return

```java
public class TestException {
	public static void main(String[] args) {
		TestException te = new TestException();
		System.out.println(te.method(3, -1));
	}
	public int method(int x, int y) {
		Test t = new Test();
		try {
			return t.devide(x, y);
		} catch (ArithmeticException e) {
			System.out.println(e.getMessage());
			return 0;
		} catch (DevideByMinusException e) {
			System.out.println(e.getMessage());
			return -1;
		} finally {
			System.out.println("call finally");
		}
	}
}
class Test {
	public int devide(int x, int y) throws ArithmeticException, DevideByMinusException {
		if(y<0) {
			throw new DevideByMinusException("被除数为负数", y);
		}
		return x/y;
	}
}

//打印结果
被除数为负数
call finally
result=-1
```

发生异常后，会进入`catch (DevideByMinusException e){}`中，这个catch会执行`return -1`，然而finally中的语句会在try..catch执行return之前就执行。

### 例子2：try..catch包含return，而finally包含return

把例子1中的finally代码块改为：

```java
finally {
	System.out.println("call finally");
	return -999;
}
//执行结果
被除数为负数
call finally
result=-999
```

由于finally中也包含return语句，因此finally中的return会覆盖try..catch中的return。另外，如果在try..catch..finally中执行了return后，try..catch..finally后面的语句就不会执行了。

## 异常方法覆盖

当一个方法被覆盖时，覆盖它的方法也必须抛出相同的异常或者异常的子类，子类中不能抛出新的异常。



**上面讲到的异常相关知识，足够应付日常开发了，如果想要自己写框架，则需要再读《Think In Java》。**