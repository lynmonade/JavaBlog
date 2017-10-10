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

## concrete parameterized type

> An instantiation of a generic type where all type arguments are concrete types rather than wildcards.
> Examples of concrete parameterized types are List<String> , Map<String,Date> , but not List<? extends Number> or Map<String,?>.



# How do I define a generic type? 

> Like a regular type, but with a type parameter declaration attached.

# How is a generic type instantiated?

> By providing a type argument per type parameter.



# Can I cast to a parameterized type?

> Yes, you can, but under certain circumstances it is not type-safe and the compiler issues an "unchecked" warning.
>
> All instantiations of a generic type share the same runtime type representation, namely the representation of the raw type. For instance, the instantiations of a generic type `List` ,  such as `List<Date>` , `List<String>` , `List<Long>` , etc. have different **static types** at compile time, but the same dynamic type `List `at runtime.

A cast consists of two parts: 

- a static type check performed by the compiler at compile time and 
- a dynamic type check performed by the virtual machine at runtime. 

The static part sorts out nonsensical casts, that cannot succeed, such as the cast from `String` to `Date` or from`List<String>` to `List<Date>` .

The dynamic part uses the runtime type information and performs a type check at runtime.  It raises a`ClassCastException` if the dynamic type of the object is not the target type (or a subtype of the target type) of the cast. Examples of casts with a dynamic part are the cast from `Object` to `String` or from `Object` to `List<String>` .  These are the so-called downcasts, from a supertype down to a subtype. 

Not all casts have a dynamic part. Some casts are just static casts and require no type check at runtime.  Examples are the casts between primitive types, such as the cast from `long` to `int `or `byte` to `char` .  Another example of static casts are the so-called upcasts, from a subtype up to a supertype, such as the casts from `String` to `Object` or from`LinkedList<String>` to `List<String>` . Upcasts are casts that are permitted, but not required.  They are automatic conversions that the compiler performs implicitly, even without an explicit cast expression in the source code, which means, the cast is not required and usually omitted.  However, if an upcast appears somewhere in the source code then it is a purely static cast that does not have a dynamic part. 

Type casts with a dynamic part are potentially unsafe, when the target type of the cast is a parameterized type.  The runtime type information of a parameterized type is non-exact, because all instantiations of the same generic type share the same runtime type representation. The virtual machine cannot distinguish between different instantiations of the same generic type.  Under these circumstances the dynamic part of a cast can succeed although it should not. 

Example (of unchecked cast): 

```java
void m1() { 
  List<Date> list = new ArrayList<Date>(); 
  ... 
  m2(list); 
} 
void m2(Object arg) { 
  ... 
  List<String> list = (List<String>) arg;    // unchecked warning at compile-time
  ... 
  m3(list); 
  ... 
} 
void m3(List<String> list) { 
  ... 
  String s = list.get(0);      // ClassCastException at runtime
  ... 
}
```

The cast from `Object` to `List<String> `in method `m2` looks like a cast to `List<String>` , but actually is a cast from `Object` to the raw type `List` . It would succeed even if the object referred to were a `List<Date>`   instead of a `List<String>` .

After this successful cast we have a reference variable of type `List<String>` which refers to an object of type `List<Date>`. When we retrieve elements from that list we would expect `String` s, but in fact we receive `Date` s - and a`ClassCastException `will occur in a place where nobody had expected it. 

We are prepared to cope with `ClassCastException` s when there is a cast expression in the source code, but we do not expect `ClassCastException` s when we extract an element from a list of strings.  This sort of unexpected `ClassCastException`is considered a violation of the type-safety principle.  In order to draw attention to the potentially unsafe cast the compiler issues an "unchecked" warning when it translates the dubious cast expression. 

**As a result, the compiler emits "unchecked" warnings for every dynamic cast whose target type is a parameterized type.  Note that an upcast whose target type is a parameterized type does *not* lead to an "unchecked" warning, because the upcast has no dynamic part.**

# Is List<Object> a supertype of List<String>?

> No, different instantiations of the same generic type for different concrete type arguments have no type relationship.
> It is sometimes expected that a List<Object> would be a supertype of a List<String> , because Object is a supertype of String .  This expectation stems from the fact that such a type relationship exists for arrays:  Object[] is a supertype of String[] , because Object is a supertype of String . (This type relationship is known as covariance .)  The super-subtype-relationship of the component types extends into the corresponding array types. No such a type relationship exists for instantiations of generic types. (Parameterized types are not covariant.) 

# Can I use a concrete parameterized type like any other type?

> They can NOT be used for the following purposes:
>
> * for creation of arrays
> * in exception handling
> * in a class literal
> * in an instanceof expression

# Reference

* [JavaGenericsFAQ](http://www.angelikalanger.com/GenericsFAQ/JavaGenericsFAQ.html#Parameterized Types Fundamentals)
* [What is](http://www.angelikalanger.com/GenericsFAQ/FAQSections/Features.html#Which language features are related to Java generics?)