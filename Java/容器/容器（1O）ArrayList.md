# 容器（10）ArrayList
ArrayList继承了AbstractList抽象类，并实现了List接口。ArrayList实现了所有可选操作，并允许把null元素加入到集合中。相较于List接口，ArrayList还提供了一些自身内部使用的方法，用于操纵/扩充内部的数组大小。ArrayList的功能基本等价于Vector，但ArrayList是线程不安全的，而Vector是线程安全的。

ArrayList可以使用Iterator和ListIterator迭代器，ArrayList的这两个迭代器都遵循**fail-fast机制**：当我们获取迭代器之后，如果尝试对ArrayList进行**structually modified**操作，即那些会改变集合size的操作（ListIterator自带的add、remove方法除外），就会抛出ConcurrentModificationException。

ArrayList内部持有一个数组`Object[] EMPTY_ELEMENTDATA`作为成员变量，在添加元素时，本质上是把元素添加到`EMPTY_ELEMENTDATA`数组中。如果数组容量不足以容纳新元素，则会进行数组扩容，保证ArrayList可以容纳新的元素。此外，ArrayList还是用成员变量size来表示目前容器持有的元素个数，size一般会小于`EMPTY_ELEMENTDATA.length`。严格来说，ArrayList的元素个数也不是无穷大的，由于ArrayList底层依赖于数组，而数组的长度是int类型，因此理论上来说ArrayList的容量可以达到`Integer.MAX_VALUE`，该值约等于2GB。但是默认的JVM的内存是小于2GB的，因此ArrayList的容量实际上会小于Integer.MAX_VALUE。

## 源码分析

### add添加元素

```java
public boolean add(E e) {
    ensureCapacityInternal(size + 1);  // Increments modCount!!
    elementData[size++] = e;
    return true;
}
public void add(int index, E element) {
    rangeCheckForAdd(index);
    ensureCapacityInternal(size + 1);  // Increments modCount!!
    System.arraycopy(elementData, index, elementData, index + 1,
    size - index);
    elementData[index] = element;
    size++;
}
```

每次再添加新元素之前，都需要调用`ensureCapacityInternal()`方法进行扩容检查，如果当前容量不足以容纳新元素，则把底层数组扩容为当前容量的1.5倍。`add(int index, E element)`需要在特定位置插入元素，因此需要结合使用`System.arraycopy()`方法，实现数组**腾位子**的操作。

### 清空、删除操作

```java
public void clear() {
    modCount++;

    // clear to let GC do its work
    for (int i = 0; i < size; i++)
    elementData[i] = null; //设为null

    size = 0; //size设为0
}

public E remove(int index) {
    rangeCheck(index);
    modCount++;
    E oldValue = elementData(index); //提取当前位置的元素作为返回值
    int numMoved = size - index - 1;
    if (numMoved > 0)
      System.arraycopy(elementData, index+1, elementData, index,
                       numMoved); //移动元素的操作
    elementData[--size] = null; // clear to let GC do its work //数组最后一个有效元素设置为null
    return oldValue;
}
```

`clear()`操作只是把数组的每一个元素设置为null，并把size直接设置为0。但其实数组的长度依然维持不变。`remove()`方法则先提取出当前元素，再通过`System.arraycopy()`实现数组**移动元素**的操作。

### 获取、修改特定元素

```java
public E get(int index) {
    rangeCheck(index);
    return elementData(index);
}

public E set(int index, E element) {
    rangeCheck(index);
    E oldValue = elementData(index);
    elementData[index] = element;
    return oldValue;
}
```

直接使用数组下标index，实现get、set操作。

### index相关

```java
public int indexOf(Object o) {
    if (o == null) {
    for (int i = 0; i < size; i++)
    if (elementData[i]==null)
    return i;
    } else {
    for (int i = 0; i < size; i++)
    if (o.equals(elementData[i]))
	return i;
}
	return -1;
}

public boolean contains(Object o) {
	return indexOf(o) >= 0;
}
```

`indexOf()`直接使用for循环遍历底层数组，获得对应元素的位置。对于null元素和非null元素的判断方式值得学习。此外，`contains()`直接借助`indexOf()`来判断是否包含元素，这样的判断方式值得学习。

### size相关

```java
public boolean isEmpty() {
    return size == 0;
}

public void trimToSize() {
    modCount++;
    if (size < elementData.length) {
      elementData = Arrays.copyOf(elementData, size);
    }
}
```

`isEmpty()`通过size来判断集合是否为空。而`trimToSize()`则通过`Arrays.copyOf()`实现数组**删除空位置**的操作。

### 转为数组

```java
public Object[] toArray() {
	return Arrays.copyOf(elementData, size);
}

public <T> T[] toArray(T[] a) {
    if (a.length < size)
    // Make a new array of a's runtime type, but my contents:
    return (T[]) Arrays.copyOf(elementData, size, a.getClass());
    System.arraycopy(elementData, 0, a, 0, size);
    if (a.length > size)
    a[size] = null;
    return a;
}
```

ArrayList实现了Collection接口，因此也必须提供集合转为数组的功能，从源码可以看出，ArrayList转为数组时，底层会转调`Arrays.copyOf()`，因此本质上来说实现了元素的浅拷贝。