# chapter 1
显式地指定泛型类型：

```java
List<Integer> ints = Lists.<Integer>toList();
List<Object> objs = Lists.<Object>toList(1, "two");
```

隐式地指定泛型类型：

```java
List<Integer> ints = Lists.toList(1, 2, 3);
List<String> words = Lists.toList("hello", "world");
```

# chapter 2
## 2.1 Subtyping and the Substitution Principle 

Substitution Principle

```java
//Collection<Number>是LinkedList<Number>的父类
Collection<Number> col1 = new LinkedList<Number>(); //ok

//Collection<Number>不是LinkedList<Integer>的父类
List<Number> list1 = new LinkedList<Integer>(); //compile-time error

//List<Integer>是ArrayList<Integer>的父类
//listEx是list1的父类
List<Integer> list1 = new ArrayList<Integer>(); //ok
List<Number> numList = new ArrayList<Number>(); //ok
List<? extends Number> listEx = list1; //ok
listEx = numList; // ok List<? extends Number>是List<Number>的父类。即使listEx实际是Integer类型，我们依然使用Number来操纵他

listEx.add(3.14); // compile-time error，因为listEx也有可能是Integer类型，往里面塞Double会出问题，结合get/put principle也可知，不能对<? extends XX>调动add
```

关于容器承载：父类泛型可以承载子类元素，比如`List<Number> list`，我们可以往list中塞Integer、Double类型的数据：`list.add(1); list.add(1.1);`

关于引用赋值：父类引用可以持有子类的实例，前提是两者真的存在父子关系

```java
//ok
List<Number> list11 = new ArrayList<Number>();
list11 = new ArrayList<>();
List<?> list12 = new ArrayList<Number>();
list12 = new ArrayList<>();
List<? extends Object> list13 = new ArrayList<Number>();
list13 = new ArrayList<>();
List<? extends Number> list14 = new ArrayList<Number>();
list14 = new ArrayList<>();
List<? super Number> list15 = new ArrayList<Number>();
list15 = new ArrayList<>();
List<? extends String> list16 = new ArrayList<String>(); //编译通过。但严格来说String是final类，不应该再有子类了，所以<? extends String>改写为<String>更合适

//compile-time error
//List<Number> list01 = new ArrayList<Integer>();
//List<Number> list02 = new ArrayList<? extends Number>(); //? can't use with new  

```

## 2.2 Wildcards with extends
简单，Collections工具类有具体应用

Collection<?> 等价于 Collection<? extends Object>

## 2.3 Wildcards with super
简单，Collections工具类有具体应用

## 2.4 Get and Put Principle

* <? extends XXX> 只能用get，remove，不能用add/set
* <? YYY> 只能用add，set，不能用get

## 2.5 Arrays

```java
//Number[]是Integer[]的父类，所以第二句ok，第三句在运行时错误
Integer[] intArray = new Integer[]{1,2,3};
Number[] numArray = intArray; //ok
numArray[0] = 3.14; //run-time error

List<Integer> intList = Arrays.asList(1,2,3);
List<Number> numList = intList; // compile-time error
numList.set(2, 3.14);

List<Integer> intList2 = Arrays.asList(1,2,3);
List<? extends Number> numList2 = ints;
numList2.set(2, 3.14); // compile-time error
```

从上面可知：集合类比数组具备如下两个优势：

1. 集合类结合泛型使用，使得错误在编译期就可以被发现。而数组只能在运行期才能发现错误
2. 集合类拥有更多的操作方法，包括比较、取最大值、排序...而数组只能做set、get

三个进化历程：
1. 协变式的数组 Object[] arr  不推荐再用，除非你想兼容旧的JDK
2. 泛型数组：T[] arr  推荐使用
3. 泛型集合：List<T>  推荐使用

## 2.6 Wildcards Versus Type Parameters

Wildcards的方式，JDK源码使用该方式，为的是兼容旧的JDK

```java
interface Collection<E> {
	public boolean contains(Object o);
	public boolean containsAll(Collection<?> c);
}

//below all works
Object obj = "one";
List<Object> objs = Arrays.<Object>asList("one", 2, 3.14, 4);
List<Integer> ints = Arrays.asList(2, 4);
assert objs.contains(obj);
assert objs.containsAll(ints);
assert !ints.contains(obj);
assert !ints.containsAll(objs);
```

Type Parameters的方式

```java
interface MyCollection<E> { // alternative design
public boolean contains(E o);
public boolean containsAll(Collection<? extends E> c);
}

//MyList实现类MyCollection类
Object obj = "one";
MyList<Object> objs = MyList.<Object>asList("one", 2, 3.14, 4);
MyList<Integer> ints = MyList.asList(2, 4);
assert objs.contains(obj);
assert objs.containsAll(ints);
assert !ints.contains(obj); // compile-time error
assert !ints.containsAll(objs); // compile-time error
```

JDK使用Wildcards方式，为的是兼容旧版本JDK。但如果你自己写的API，则建议使用Type Parameters方式，因为对"MyList<Integer>是否包含Object/List<Object>"做判断是没有意义的，你应该判断的是：“MyList<Integer>里是否包含Integer/List<Integer>”。

## 2.7 Wildcard Capture

When a generic method is invoked, the type parameter may be chosen to match the unknown type represented by a wildcard. This is called wildcard capture.

```java
public static void reverse(List<?> list);
public static void <T> reverse(List<T> list);
```

第一行使用通配符?，更加简洁，适合做对外公布的API。但?等价于<? extends Object>，而reverse做不了set操作。

```java
public static void reverse(List<?> list) {
	List<Object> tmp = new ArrayList<Object>(list);
	for(int i=0; i<list.size(); i++) {
		list.set(i, tmp.get(list.size()-i-1)); //compile-time error, 因为? extends Object不能做set操作
	}
}

public static <T> void reverse(List<T> list) {
	List<T> tmp = new ArrayList<T>(list);
	for(int i=0; i<list.size(); i++) {
		list.set(i, tmp.get(list.size()-i-1));
	}
}
```

解决办法是，使用?的方法作为公布的API，而内部转调类型参数的方法。

```java
//public对外公布
public static void reverse(List<?> list) {
	rev(list);
}

private static <T> void rev(List<T> list) {
	List<T> tmp = new ArrayList<T>(list);
	for(int i=0; i<list.size(); i++) {
		list.set(i, tmp.get(list.size()-i-1));
	}
}
```

## 2.8 Restrictions on Wildcards 通配符的一些限制

限制1：new那一侧，不能含有通配符?。因为new已经是对象初始化时的最后一步了，不能再推迟了，此时必须拥有明确的数据类型

```java
List<Number> list1 = new ArrayList<?>(); //compile-time error
List<Number> list2 = new ArrayList<? extends Number>(); //compile-time error
List<?> list3 = new ArrayList<?>(); //compile-time error

List<Number> list4 = new ArrayList<>(); //ok
List<?> list5 = new ArrayList<>(); //ok
```


限制2：

Supertypes：When a class instance is created, it invokes the initializer for its supertype. Hence, any restriction that applies to instance creation must also apply to supertypes.In a class declaration, if the supertype or any superinterface has type parameters, these types must not be wildcards.

```java
class AnyList extends ArrayList<?> {...} // compile-time error
class AnotherList implements List<?> {...} // compile-time error
class NestedList extends ArrayList<List<?>> {...} // ok，通配符在第二层
```

限制3：如果方法参数含有type parameter类型参数，则调用方法时，则第一层实参不能包含通配符。道理和第一条类似，因为方法调用传递实参已经是最后一步，实参必须必须拥有明确的数据类型，不能再推迟了。

```java
class Lists {
	public static <T> List<T> factory() { return new ArrayList<T>(); }
}

List<?> list = Lists.factory(); //OK
List<?> list = Lists.<Object>factory(); //OK

List<?> list = Lists.<?>factory(); // compile-time error

List<List<?>> = Lists.<List<?>>factory(); // ok。通配符在第二层参数，这是OK的
```


## keywords

* subtyping：子类化
* wildcards：通配符，即泛型中的?
* Type Parameters：类型参数，也就是T,E这些占位参数
* arbitrary：随意的，任性的，武断的


# Chapter 3 Comparison and Bounds

## 3.1 Comparable

Comparable接口使用了type parameter，保证了只能和与自己完全一样的数据类型进行比较（即使是父子关系也不行）。

JDK中很多类都实现了Comparable接口，JDK的类都遵循一个原则：Consistent with Equals。即如果调用类的`int compareTo(T o)`方法返回0(相等)，则调用其equals方法也应该返回true。
> x.equals(y) if and only if x.compareTo(y) == 0

你实现Comparable接口时必须留意这五个问题：

1. anti-symmetric:`sgn(x.compareTo(y)) == -sgn(y.compareTo(x))`
2. transitive:`if x.compareTo(y) < 0 and y.compareTo(z) < 0 then x.compareTo(z) < 0`
3. congruence:`if x.compareTo(y) == 0 then sgn(x.compareTo(z)) == sgn(y.compareTo(z))`
4. reflexive:`x.compareTo(x) == 0`
5. Consistent with Equals:`x.equals(y) if and only if x.compareTo(y) == 0`

Integer类在实现compareTo方法时，使用的是`return (x < y) ? -1 : ((x == y) ? 0 : 1);`的方式。注意千万别返回x-y，因为这有可能会超过Integer.MAX_VALUE值。

## 3.2 Maximum of a Collection

```java
public static <T extends Comparable<T>> T max(Collection<T> coll) {
	T candidate = coll.iterator().next();
	for (T elt : coll) {
		if (candidate.compareTo(elt) < 0) {
			candidate = elt;
		}
	}
	return candidate;
}
```

`<T extends Comparable<T>>`,Comparable<T>叫做T的bound，type parameter的bound只能用extends，不能用super。