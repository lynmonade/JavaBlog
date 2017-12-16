# 面向对象（20）static与final

简单来说，static是为了确保**只有一份**，final是为了确保**不能被再次赋值**。

## static关键字

static关键字可以用来修饰：

* 成员变量
* 方法
* 静态代码块

### static修饰成员变量

当static修饰成员变量时，无论创建多少个对象，静态成员变量在内存中只有一份，这可以达到多个对象共享同一份成员变量的目的。一个常见的例子是：所有的中国人的国籍属性都是中国，可以把成员变量“国籍”设置为static，这样所有的中国人对象就可以共享**同一个国籍对象**。

```java
public class Chinese {
	static Nationality nationality = new Nationality("中国");
}
```

**此外，static不能修饰局部变量，这点需要特别的注意。**

### static修饰方法

static也可以修饰方法，这时方法就变成了静态方法，最常见的例子就是工具类。一般使用`类名.静态方法名()`的方式调用静态方法。

**在静态方法中：无法访问非静态成员变量，无法调用非静态方法，也无法使用this、super关键字，但可以访问静态成员变量。而在非静态方法中，可以调用静态方法，也可以访问静态成员变量。**

这是因为静态方法、静态成员变量在类创建时就跟着创建了。而非静态成员变量、非静态方法是在对象创建时才创建，静态方法/静态成员变量的创建早于非静态成员变量/非静态方法的创建，因此非静态可以访问到静态，而静态无法访问到非静态。

静态方法+静态成员变量的组合使用可以实现**单例模式**。

子类无法覆盖父类的static方法，虽然你可以为子类编写一个与父类同名的static方法，但这并不会发生覆盖效果，而是发生了隐藏。其实一个对象有两种类型：表面类型（Appearent Type）和实际类型（Actual Type），表面类型是声明时的类型，而实际类型是运行时对象产生的类型。例如下面的例子中，变量f的表面类型时Father，而实际类型是Son，而static方法是在编译期就已经与类绑定，所以调用的是表面类型的静态方法。严格来说，不推荐使用对象来调用静态方法，虽然语法上没有问题，但这会带来代码的坏味道，最好还是严格使用类名来调用静态方法。

```java
public class Father {
	public static void staticMethod() {
		System.out.println("Father method");
	}
}

public class Son extends Father{
	public static void staticMethod() {
		System.out.println("Son method");
	}
	public static void main(String[] args) {
		Father f = new Son();
		f.staticMethod(); //Father method
	}
}
```



### 静态代码块

一个类中可以使用不包含在人恶化方法体中的静态代码块，当类被载入时，静态代码块被执行，且只被执行一次，静态块静态用来进行类属性的初始化。

```java
public class StaticBlock {
	static String country;
	static {
		country = "China";
		System.out.println("StaticBlock is loading");
		System.out.println("country="+country);
	}
	
	public static void main(String[] args) {
      	System.out.println("invoke main");
		StaticBlock sb1 = new StaticBlock();
		StaticBlock sb2 = new StaticBlock();
		StaticBlock sb3 = new StaticBlock();
	}
}

//打印结果，即使创建了多个对象，静态代码块也只执行了一次
//此外，注意执行顺序，静态代码块在类创建时就被执行了
StaticBlock is loading
country=China
invoke main
```

## final

final关键字通常表示**这是无法改变的**。不想做出改变一般处于两种理由：设计或效率（现在编译器很牛逼了，不考虑）。final关键字可以用在三个地方：

* 类：表示类不能被继承。
* 方法：表示方法不能被子类重写。
* 成员变量和局部变量：表示变量为常量，即只能赋值一次。具体的赋值，可以是在编译期就确定，也可以在运行期才确定。 

### 修饰类

final修饰类表示这个类不能被继承，这个类内部的成员变量可以是用final或不用final修饰均可。final类内部的方法隐式指定为final方法，因此无法覆盖他们。你可以给final类中的方法添加final关键字，但这并不会给方法添加任何额外的意义。

### 修饰方法

《Think In Java》中提到，final修饰方法主要有两个原因：1. 防止子类覆盖父类的方法，保持父类方法的行为。2. 提升方法调用效率。早期Java会利用final修饰方法可以提升调用效率，但Java5以后基本无需考虑效率问题，而是更多的往**防止方法被子类重写**的角度考虑。

所有的private方法都是隐式地指定为是final的。我们可以为private方法添加final修饰词，但这并不会给方法添加任何额外的意义。

从语法层面来说，在子类中我们可以覆盖（override）父类同名的private方法，编译器并不会报错 。但这其实并不是覆盖，private方法严格来说并不能覆盖，private方法只能在类的内部自己使用，其他类均不能访问private方法。**因此如果你在子类中尝试覆盖覆盖了private方法时，实际发生的是：在子类定义了一个与父类private方法同名的方法，方法间并不存在任何覆盖关系**

**修饰方法形参**

final修饰方法形参，就表明我们在方法内部无法修改这个参数的值。这一特性主要用来像匿名内部类传递数据。

```java
public void method2(final int a, final Object o) {
	a = 20; //error, 不能再重新赋值
    o = new Object(); //error, 不能再重新赋值
}
```

### 修饰局部变量和成员变量

```java
public class FinalField {
	final int a = 1; // 声明后立即赋值
	final int b; // 在构造函数中赋值
	public FinalField(int b) {
		this.b = b;
	}
	public void method() {
		final double d = 0.5d; // ok
		// d = 0.3d; //error，不能再赋值
	}
}
```

final修饰成员变量时，必须在声明成员变量的同时、或者再该类的构造函数中显示地赋值。而final在修饰局部变量时，建议立即初始化，并且在此之后不能再给局部变量重新赋值。

**修饰对象类型**

final修饰对象类型或者数组类型的变量时，表示该引用无法指向其他变量，但对象本身的值是可以改变的。

***public static final**

我们可以在接口中使用`public static final`来修饰变量，这样他就变成了全局常量，我们便可以用`接口名.常量名`来访问常量。注意，这样定义的常量只能在声明时立刻赋值，不能在构造函数中赋值。