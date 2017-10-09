# What is

##  generic type

> A generic type is a type with formal type parameter.
>
> 下面的例子中，Collection<E>和MyClass<T,S>就是generic type。

```java
interface Collection<E> {
	public void add(E x);
  	public Iterator<E> iterator();
}

public class MyClass<T,S> {
	private T t;
  	private S s;
}
```

## type parameter

> generic type has one or more type parameters.
>
> 占位符E表示type parameter。

```java
interface Comparable<E> {
  	int compareTo(E other);
}
```

## parameterized type

> A parameterized type is an instantiation(实例化) of a generic type with actual type arguments.
>
> Collection<String>表示parameterized type。

```java
Collection<String> coll = new LinkedList<String>();
```

## type argument

> A reference type that is used for the instantiation of a generic type or for the instantiation of a generic method, or a wildcard that is used for the instantiation of a generic type .
>
> 在line1中，等号左右两边的String都表示type argument，但等号左边的可以用通配符，等号右边的只能用concrete type。
>
> 同理，在line2中可以包含通配符，而line3只能用concrete type。
>
> 

```java
Collection<String> coll = new LinkedList<String>(); //line1

public MyClass {
	public static <T> void m(List<? extends T> col){} //line2
  	public static void main(String[] args) {
    	MyClass.m(new ArrayList<Integer>()); //line3
    }
}
```





# How to work

# Reference

* [JavaGenericsFAQ](http://www.angelikalanger.com/GenericsFAQ/JavaGenericsFAQ.html#Parameterized Types Fundamentals)
* [What is](http://www.angelikalanger.com/GenericsFAQ/FAQSections/Features.html#Which language features are related to Java generics?)