# 泛型

## 通配符?

> Sometimes we would like lists to behave more like arrays, in that we want to accept not only a list with elements of a given type, but also a list with elements of any subtype of a given type. For this purpose, we use *wildcards*.

```java
//对于数组
Integer[] is a subtype of Number[]
//对于集合来说
List<Integer> is a subtype of Collection<Integer>
List<Integer> is not a subtype of Collection<Number>
```

因此为了获得与数组相似的subtype特性，就引入了通配符：`List<Integer> is a subtype of Collection<? extends Number>`。引入通配符的好处是：不使用通配符，我们只能往Collection<Integer>里放入Integer类型。使用通配符后，我们可以往Collection<? extends Number>放入任何Number的子类。（但从集合取出element时，只能是Number类型）。

**使用通配符后，我们把固定类型变为了范围类型。通配符经常与extends、super一起使用。`List<?>等价于List<? extends Object>`**



### 通配符可以放在哪

(1)放在等号赋值语句的左边

```java
List<?> list = new ArrayList<Integer>();
```

(1)放在方法声明的形参尖括号中。这与(1)中的赋值语句是一样的道理。

```java
public void add(List<?> list) {}
public void add2(List<? extends Number> list){}
```

(2)放在方法声明的类型参数T的进一步说明的第二层中

```java
public <T extends List<? super Number>> void add3(List<?> list) {}
```

(3)放在类、接口声明的第二层中

```java
public class MyComparable2<T extends List<? extends Number>> 
  implements Comparable<List<? extends Number>> {} //ok，通配符在第二层
```

### 通配符不能放在哪

(1)不能与new一起使用创建对象

```java
List<?> list = new ArrayList<?>(); //compile-time error,等号左边的?是没问题的，问题出在等号右边的?，因为new创建对象时，已经是最后一步，参数类型必须明确，不能再推迟了

List<?> list = new ArrayList<Integer>(); //ok，因为他等价于下面
List<? extends Object> list = new ArrayList<Integer>(); //ArrayList<Integer> is a subtype of List<? extends Object>
```

(2)声明类、接口时，不能作为第一层占位符

```java
public class MyComparable2<?> implements Comparable<?> {} //compile-time error 两个?都有问题，这两个地方都是第一层占位符，不能出现任何?
public class MyComparable2<? extends Number> implements Comparable<?> {} //compile-time error
public class MyComparable2<?> implements Comparable<? extends Number> {} //compile-time error
```

## 类型参数T

**类型参数关心的问题是边界bound：**

```java
public class MyUtils<T> {
	private T t;
  
	//不好，因为该方法的参数已经写死了只能是List<? extends Number>的子类，因此寻找max值是也只能从List<? extends Number>的子类中寻找
	public Number max1(List<? extends Number> list){
		return null;
	}
	
  	//更好更通用，因为可以根据客户端传入的具体类型，在运行时动态地确定T的数据类型，比如T也可以是Comparable接口，这时在客户端，任何List<? extends Comparable>的子类都可以作为方法参数，都可以使用该max方法。
	public T max2(List<? extends T> list) {
      	//...
		return t;
	}
}

public class Client {
	public static void main(String[] args) {
		List<Integer> list1 = Arrays.asList(1,2,3);
		List<String> list2 = Arrays.asList("one", "two", "three");
		
      	MyUtils<Integer> my1 = new MyUtils<Integer>();
		my1.max1(list1); //ok
		my1.max1(list2); //compile-time error
      
      	MyUtils<String> my2 = new MyUtils<String>();
		my2.max2(list2); //ok
	}
}
```

未使用类型参数时，bound在类、接口、方法声明时就已经写死了。使用类型参数后，方法声明不必再写死边界。**边界的具体化**将推迟到客户端，由客户端的代码在运行时确定。

**类型参数在编写通用的工具类、声明能力接口时经常会用到。比如Collections工具类、ArrayList<E>工具类，Comparable<E>能力接口、Iterable<E>能力接口。**

## 类、接口的声明

## 方法的进一步说明

如果在类、接口的声明中没有涉及类型参数，而你又在方法声明中使用了类型参数，**则必须在方法声明中添加类型参数的进一步说明**：

```
public class MyUtils {
	//<T extends Comparable<? super T>>就是进一步说明
	public <T extends Comparable<? super T>> void max2(List<? extends T> list) {
	}
}
```

# Reference

《Java Generics and Collections》