# 容器（00）Collection接口与AbstractCollection抽象类

## Collection接口 

Collection是一个接口，它有两个分支List和Set。Collection接口规定了所有Collection都应该具备的操作，下面我们来一一分析Collection接口中方法。

```java
//可选操作：涉及到修改集合本身
boolean add(E e)
boolean addAll(Collection<? extends E> c)
boolean remove(Object o)
boolean removeAll(Collection<?> c)
boolean retainAll(Collection<?> c)
void clear()

//必选操作：只涉及查看集合状态，而不会修改集合
boolean contains(Object o)
boolean containsAll(Collection<?> c)
boolean isEmpty()
Iterator<E> iterator()
int size()
Object[] toArray()
<T> T[] toArray(T[] a)
  
//Object类继承过来的方法
int hashCode()
boolean equals(Object o)
```

###  boolean add(E e)

```java
boolean add(E e)
```

把参数对象加入到集合中，确保集合中拥有该对象参数。调用该方法后，如果集合发生变化，则返回true，如果集合不允许包含重复的元素，则返回false。此外，该方法会在下列情况下抛出异常，而不是返回false，这点需要特别注意：

* UnsupportedOperationException：该集合不支持add方法

* ClassCastException：该类型元素无法加入到集合中（集合泛型的限制）

* NullPointerException：该集合不支持插入null元素

* IllegalArgumentException：该类型元素无法加入到集合中（元素本身限制）

* IllegalStateException：元素在此刻无法加入到集合中（多线程的限制）

从上面的异常信息中也可以看出一些门道，对于具体的集合类需要考虑这些问题：

* 是否支持add方法
* 哪些类型的元素可以加入到集合中
* 是否支持null元素
* 集合在多线程下的操作

此外，该方法还是一个**可选操作**(optional operation)。也就是说，在集合中我们可以选择支持该操作或者不支持该操作。但由于add方法是定义在接口中的，Java规定子类必须实现接口中的方法，因此这里所说的**可选操作**并不是表示子类无需实现该方法，而是表示：子类还是得实现add方法，但只是提供一个空的实现函数，并抛出UnsupportedOperationException告知开发者，这个集合并不支持add操作。通过**抛出异常**来实现**可选操作**的设计方式非常好，值得开发者学习。

### boolean addAll(Collection<? extends E> c)

```java
boolean addAll(Collection<? extends E> c)
```

该方法的参数是一个集合，而方法目的是把参数集合的元素全部加入到当前集合中。方法执行完毕后，**只要当前集合发生了变化，就返回true**。注意，在方法调用的过程中，如果参数集合发生了变化，将会造成不可预知的错误（在多线程下可能会碰到这类问题）。该方法是可选方法，其抛出的异常与add方法是一样的，因为addAll本质上也是通过迭代器遍历集合，并调用add方法添加每一个元素。

### void clear()

```java
void clear()
```

把集合中的所有元素移除。最后得到的是一个empty集合，集合的size()也会变成0。该方法也是可选操作，可以返回UnsupportedOperationException。

### boolean contains(Object o)

```java
boolean contains(Object o)
```

这是**必选操作**，每一个集合都必须支持该操作。该方法用于判断集合是否包含此元素。是否包含的标准是`(o==null ? e==null : o.equals(e))`。

### boolean containsAll(Collection<?> c)

```java
boolean containsAll(Collection<?> c)
```

这是**必选操作**，每一个集合都必须支持该操作。该方法用于判断集合是否包含参数集合的元素。只有当前集合包含参数集合的所有元素时，才返回true。一般来说，该方法内部会通过迭代器遍历集合，并循环调用contains方法一一判断。

### int hashCode()和boolean equals(Object o)

```java
//从Object类继承过来的方法
int hashCode()
boolean equals(Object o)
```

### boolean isEmpty()

```java
boolean isEmpty()
```

这是**必选操作**。判断集合是否为空empty。如果size()等于0，集合就为空。

### Iterator<E> iterator()

```java
Iterator<E> iterator()
```

**必选操作**，用于获取迭代器，迭代器的遍历方向由具体的迭代器确定。即有可能从头开始遍历，也可能从尾部倒回去开始遍历。

### boolean remove(Object o)

```java
boolean remove(Object o)
```

**可选操作**，用于删除指定元素。方法调用后，只要集合发生改变（元素被删除），就返回true。

###　boolean removeAll(Collection<?> c)

```java
boolean removeAll(Collection<?> c)
```

**可选操作**，删除当前集合中，参数集合的元素。方法调用后，只要集合发生了改变，就返回true。

### boolean retainAll(Collection<?> c)

```java
boolean retainAll(Collection<?> c)
```

**可选操作**，仅保留当前集合中，参数集合的元素，删除其他元素。方法调用后，只要集合发生了改变，就返回true。

### int size()

```java
int size()
```

**必选操作**，返回集合中的元素个数 。如果元素个数大于`Integer.MAX_VALUE`，则返回`Integer.MAX_VALUE`。

### Object[] toArray()

```java
Object[] toArray()
```

**必选操作**，把集合中的元素**浅拷贝**到新的数组中，返回值是一个Object[]数组。数组元素的顺序与Iterator遍历的顺序一致。该方法是集合与数组之间的一个桥梁。在下一章节分析AbstractCollection源码时，你就会发现，`toArray`方法对元素确实使用的是浅拷贝。

### <T> T[] toArray(T[] a)

```java
<T> T[] toArray(T[] a)
  
//一般这么用
String[] strArray = list.toArray(new String[list.size()]); //line1
String[] strArray = list.toArray(new String[]{}); //line2
```

**必选操作**，其作用与`toArray()`一样，把集合中的元素**浅拷贝**到新的数组中。返回值是一个T[]数组（泛型数组）。数组元素的顺序与Iterator遍历的顺序一致。该方法是集合与数组之间的一个桥梁。

注意，该方法可以传入一个泛型数组作为参数，泛型数组参数的目的在于可以指定返回数组的具体类型，这样可以避免强制类型转换。而`toArray()`方法只能返回Object类型的数组。参数一般可以有两种方式：

1. 传一个size足够容纳元素的数组作为参数（line1），此时会把元素拷贝到参数数组中，并把参数数组作为返回值返回。如果参数数组的长度大于集合的长度，则拷贝时，会往数组中多余为的位置添加null。
2. 传一个空数组（line2），此时参数只能决定返回值的具体类型，由于是空数组，无法往里面添加元素，因此将在底层创建一个同类型且长度为集合长度的数组，并把元素放入其中，最后返回新创建的数组。相较之下，第一种方式效率更高（只创建一个数组）。

## AbstractCollection抽象类

AbstractCollection抽象类直接实现了Collection接口，并实现了接口中的部分方法。因此，如果你想创建自定义的Collection实现类，你无需直接实现Collection接口，而是直接继承AbstractCollection即可。

```java
//可选操作：涉及到修改集合本身
boolean add(E e) //未实现
boolean addAll(Collection<? extends E> c) //实现
boolean remove(Object o) //实现
boolean removeAll(Collection<?> c) //实现
boolean retainAll(Collection<?> c) //实现
void clear() //实现

//必选操作：只涉及查看集合状态，而不会修改集合
boolean contains(Object o) //实现
boolean containsAll(Collection<?> c) //实现
boolean isEmpty() //实现
Iterator<E> iterator() //未实现
int size() //未实现
Object[] toArray() //实现
<T> T[] toArray(T[] a) //实现
  
//Object类继承过来的方法
int hashCode() //未覆盖
boolean equals(Object o) //未覆盖
```

###  AbstractCollection源码分析

```java
package java.util;
public abstract class AbstractCollection<E> implements Collection<E> { //直接实现了Collection接口
    //构造函数
    protected AbstractCollection() {
    }

    //未提供iterator()的实现
    public abstract Iterator<E> iterator();

	//未提供size()的实现
    public abstract int size();

    //通过size()来判断是否为空，遵循接口
    public boolean isEmpty() {
        return size() == 0;
    }

    //通过迭代器遍历集合，逐一判断是否包含
    public boolean contains(Object o) {
        Iterator<E> it = iterator();
        if (o==null) { //参数为null时用==判断
            while (it.hasNext())
                if (it.next()==null)
                    return true;
        } else {//参数非null时，用equals()判断
            while (it.hasNext()) 
                if (o.equals(it.next()))
                    return true;
        }
        return false;
    }

    //浅拷贝，转为数组
    public Object[] toArray() {
        // Estimate size of array; be prepared to see more or fewer elements
        Object[] r = new Object[size()]; //数组初始化长度为集合长度
        Iterator<E> it = iterator();
        for (int i = 0; i < r.length; i++) {
            if (! it.hasNext()) // fewer elements than expected
                return Arrays.copyOf(r, i);
            r[i] = it.next(); //数组元素引用引用直接指向集合中的元素，即浅拷贝
        }
        return it.hasNext() ? finishToArray(r, it) : r;
    }

    //浅拷贝，转为数组
    public <T> T[] toArray(T[] a) {
        // Estimate size of array; be prepared to see more or fewer elements
        int size = size();
		//如果参数数组能容纳集合元素，则把参数数组作为返回数组，
		//否则将创建一个长度为集合长度的数组
        T[] r = a.length >= size ? a :
                  (T[])java.lang.reflect.Array
                  .newInstance(a.getClass().getComponentType(), size); //反射创建同类型数组
        Iterator<E> it = iterator();

        for (int i = 0; i < r.length; i++) {
            if (! it.hasNext()) { // fewer elements than expected
                if (a == r) {
                    r[i] = null; // null-terminate
                } else if (a.length < i) {
                    return Arrays.copyOf(r, i);
                } else {
                    System.arraycopy(r, 0, a, 0, i);
                    if (a.length > i) {
                        a[i] = null;
                    }
                }
                return a;
            }
            r[i] = (T)it.next(); //浅拷贝
        }
        // more elements than expected
        return it.hasNext() ? finishToArray(r, it) : r;
    }

    //数组最大长度，避免JVM内存不足
    private static final int MAX_ARRAY_SIZE = Integer.MAX_VALUE - 8;

    //私有方法，转为数组时用
    private static <T> T[] finishToArray(T[] r, Iterator<?> it) {
        int i = r.length;
        while (it.hasNext()) {
            int cap = r.length;
            if (i == cap) {
                int newCap = cap + (cap >> 1) + 1;
                // overflow-conscious code
                if (newCap - MAX_ARRAY_SIZE > 0)
                    newCap = hugeCapacity(cap + 1);
                r = Arrays.copyOf(r, newCap);
            }
            r[i++] = (T)it.next();
        }
        // trim if overallocated
        return (i == r.length) ? r : Arrays.copyOf(r, i);
    }

    private static int hugeCapacity(int minCapacity) {
        if (minCapacity < 0) // overflow
            throw new OutOfMemoryError
                ("Required array size too large");
        return (minCapacity > MAX_ARRAY_SIZE) ?
            Integer.MAX_VALUE :
            MAX_ARRAY_SIZE;
    }

    //抽象类不提供add的实现，因此选择抛出异常
    public boolean add(E e) {
        throw new UnsupportedOperationException();
    }

    //通过迭代器遍历，删除指定元素
    public boolean remove(Object o) {
        Iterator<E> it = iterator();
        if (o==null) { 
            while (it.hasNext()) { 
                if (it.next()==null) { //参数为null用==判断
                    it.remove();
                    return true;
                }
            }
        } else {
            while (it.hasNext()) {
                if (o.equals(it.next())) { //参数不为null用equals()判断
                    it.remove();
                    return true;
                }
            }
        }
        return false;
    }

	//迭代器遍历判断是否包含
    public boolean containsAll(Collection<?> c) {
        for (Object e : c)
            if (!contains(e))
                return false; //只要一个不包含就返回false
        return true; //全包含才返回true
    }

    //for-each遍历进行多次add操作
    public boolean addAll(Collection<? extends E> c) {
        boolean modified = false;
        for (E e : c)
            if (add(e))
                modified = true; //只要成功添加其中一个元素，就返回true
        return modified;
    }

    //迭代器遍历集合，删除对应元素
    public boolean removeAll(Collection<?> c) {
        boolean modified = false;
        Iterator<?> it = iterator();
        while (it.hasNext()) {
            if (c.contains(it.next())) {
                it.remove();
                modified = true; //只要成功删除其中一个元素，就返回true
            }
        }
        return modified;
    }
    
    public boolean retainAll(Collection<?> c) {
        boolean modified = false;
        Iterator<E> it = iterator();
        while (it.hasNext()) {
            if (!c.contains(it.next())) {
                it.remove();
                modified = true; //只要成功删除其中一个元素（导致集合发生变化），就返回true
            }
        }
        return modified;
    }

    //迭代器遍历删除
    public void clear() {
        Iterator<E> it = iterator();
        while (it.hasNext()) {
            it.next();
            it.remove();
        }
    }

    //重写toString()方法，使得打印更加格式化
    public String toString() {
        Iterator<E> it = iterator();
        if (! it.hasNext())
            return "[]";

        StringBuilder sb = new StringBuilder();
        sb.append('[');
        for (;;) {
            E e = it.next();
            sb.append(e == this ? "(this Collection)" : e);
            if (! it.hasNext())
                return sb.append(']').toString();
            sb.append(',').append(' ');
        }
    }
}
```

