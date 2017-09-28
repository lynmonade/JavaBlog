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
Substitution Principle

```java
//Collection<Number>是LinkedList<Number>的父类
Collection<Number> col1 = new LinkedList<Number>(); //ok

//Collection<Number>不是LinkedList<Integer>的父类
List<Number> list1 = new LinkedList<Integer>(); //error

//List<Integer>是ArrayList<Integer>的父类
//listEx是list1的父类
List<Integer> list1 = new ArrayList<Integer>(); //ok
List<? extends Number> listEx = list1;
listEx.add(3.14); // compile-time error，因为listEx也有可能是Integer类型，往里面塞Double会出问题。

```

Get and Put Principle

? extends XXX 只能用get，remove
? super YYY 只能用add，set

Arrays小章节

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
1. 协变式的数组 Object[] arr  不推荐再用 
2. 泛型数组：T[] arr  推荐使用
3. 泛型集合：List<T>  推荐使用


Collection<?> 等价于 Collection<? extends Object>