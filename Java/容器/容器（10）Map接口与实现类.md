# 容器（10）Map接口与AbstractMap抽象类

Map接口是与Collection接口平级的接口，用于存储key-value键值对。Map最重要的两个特点是：

1. 一个Map不能包含重复的key
2. 一个key值只能映射一个value值（一一映射）

Map提供了三种集合视图，让我们可以从不同角度审视Map的数据，此外，Map中元素的顺序由其对应的Iterator决定，比如TreeMap有特定的顺序，而HashMap没有特定的顺序。

1. set of keys：对应`Set<K> keySet()`方法
2. collection of values：对应`Collection<V> values()`方法
3. set of key-value mappings：对应`Set<Map.Entry<K,V>> entrySet()`方法

在API中还提到，不要使用可变的对象作为Map的key值，例如，不要用Map自身作为key值。有些Map子类还规定不允许key或value为null值，或者是对key或value的数据类型进行严格的限制。如果你往这类Map中放入不规范的数据类型，有可能会抛出`NullPointerException` 或者`ClassCastException`异常，亦或仅仅返回false。

Map接口规范建议每个子类都必须至少包含两个构造函数：一个空的构造函数和一个以另一个Map作为参数的构造函数，这一点与Collection接口很类似。Map接口中还定义了许多**修改结构**的方法，如果子类不支持这种操作，则应该抛出``UnsupportedOperationException` `异常。

## Map接口方法分析

### 三个视图

```java
Set<K> keySet() //key视图
Collection<V> values() //value视图
Set<Map.Entry<K,V>> entrySet() //mapping视图
```

`Set<K> keySet()`将得到一个有所有key组成的Set。如果对Map进行修改，就会影响Set，反之亦然。我们可以对该Set使用Iterator进行遍历，如果此时你尝试修改Map（Map的`Iterator.remove()`除外），则Set的Iterator迭代将会出现不可预知的错误。当我们修改Set时，包括使用`Iterator.remove`, `Set.remove`, `Set.removeAll`, `Set.retainAll`, `Set.clear `操作时，其对应Map也会受到影响（比如对应的mapping会被删除）。但这个Set并不支持`add()`和`addAll()`的操作。从返回的Set特定可以看出，返回的Set应该是一个内部类。

`values()`方法会返回Map中所有value所组成的Collection，返回的Collection需要注意的地方与上面的`keySet`类似。`entrySet()`也与上述类似。



### 新增、修改、删除

```java
//这四个方法都是可选操作
V put(K key, V value)
void putAll(Map<? extends K,? extends V> m)
V remove(Object key)
void clear()
```

`put()`会把一个mapping添加到Map中，如果Map中已经包含这个key，则用新的value来替换旧的value。如果返回值非null，则表明Map中已经包含了这个key，则会把旧的mapping返回。如果返回值为null，则表明Map没有对应的key或者Map有对应的Key，但其value值为null。

`putAll()`会把一个Map添加到当前Map中，在底层实际上循环调用`put()`。注意，如果在调用`putAll()`时，尝试修改当前Map，会造成不可预知的错误。

`remove()`会根据`(key==null ? k==null : key.equals(k))`，判断当前Map是否包含对应的key，如果包含，则删除这个mapping，并把被删除的mapping返回。如果不包含，则返回null。注意，该方法的返回值与`put()`类似，如果返回null，既可能表示不包含对应的mapping，也可能表示包含这个key，但对应的value为null。

`clear()`会移除Map中所有的mapping，并把size设置为0。

### 查看Map的状态

```java
//都是必选操作，子类必须实现
boolean containsKey(Object key) //是否有这个key
boolean containsValue(Object value) //是否有这个value
V get(Object key) //获取key对应的value
boolean isEmpty() //通过size判断
int size() //mapping个数
int hashCode()
boolean equals(Object o)
```

`get()`可以获取key对应的value。如果map包含key，则把mapping返回。如果不包含key，则返回null。与`put()`类似，如果返回值为null，既可能表示不包含对应的mapping，也可能表示包含这个key，但对应的value为null。对于这种情况，可以结合使用`containsKey()`进一步精确判断。

##  Map.Entry<K,V>内部接口

Map.Entry接口定义在Map接口的内部，它可以看做是一个内部接口，就像内部类一样。`Map.entrySet()`方法返回Set时，Set内部持有的元素就是Map.Entry类型。如果我们希望访问Map.Entry，唯一的办法就是使用Map的Iterator。在使用Iterator访问Map.Entry时，如果底层的Map发生变化，就会造成不可预知的错误（通过Map.Entry的setValue）。

```
//必选操作
int hashCode()
boolean equals(Object o)
K getKey()
V getValue()

//可选操作
V setValue(V value)
```

## AbstractMap<K,V>抽象类

AbstractMap实现了Map接口，如果你想要创建自定义的Map，你只需要继承AbstractMap类。如果你想实现一个不可修改的Map（immuable），你只需继承AbstractMap，并实现`entrySet()`方法，该方法返回一个Set，这个Set必须继承自AbstractSet，并且还是一个不提供add、remove方法Set，此外，该Set的Iterator也不提供remove方法。

如果你想要实现一个可修改的Map（muable），你还需要实现`put()`方法和``entrySet().iterator()`，并为Set的Iterator提供remove方法。

AbstractMap的源码比较简单，基本上都是通过`entrySet()`获取底层的Set，再通过Set的Iterator操纵元素即可。

## HashMap

HashMap继承自AbstractMap，它允许key和value为null。HashMap的元素无序的，每一次遍历都有可能不一样，因为它的key使用KeySet来存储的。HashMap的操作基本等价于HashTable的操作，唯一的区别是HashMap是线程不安全的，并且HashMap允许null值。为保证Itertor遍历效率如果通过`HashMap(int initialCapacity, float loadFactor)`来创建HashMap，initialCapacity不应太大，而loadFactor不应太小。

