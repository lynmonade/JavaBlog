# 容器（1）List

Collection接口是描述了一个集合应该具备的基本操作。List接口继承了Collection接口，List接口用于表示有序集合（known as a sequence）。List容器允许插入相同的元素，有些子类甚至允许插入null元素。

在API文档里有提到，Collection接口规定，所有Collection的子类都应该包含一个空的构造函数，以及一个以Collection作为参数的构造函数。虽然没有办法强制要求这么做，但JDK里的Collection子类都自觉遵循这一要求。



## ArrayList

ArrayList允许添加相同的元素，允许添加null元素，null元素会影响size。ArrayList在使用index下标查询元素时非常快，但新增或删除元素时性能较差。

### API分析

```java
//构造函数
ArrayList()
ArrayList(Collection<? extends E> c)
ArrayList(int initialCapacity)
  
//有坑的方法
//执行的是shadow copy，即两个集合共享其中的元素
Object clone() 

//返回的第一个遇到的相等元素。如果没有符合的元素，则返回-1
int indexOf(Object o)
  
//使用capacity初始化的list，isEmpty()也是true，因为list本身并没包含元素，只是有空位而已
boolean isEmpty()
  
//返回最后一个遇到的相等元素。如果没有符合的元素，则返回-1
int lastIndexOf(Object o)

//删除第一个相等的元素
boolean remove(Object o)

//闭开区间[fromIndex, toIndex)
void removeRange(int fromIndex, int toIndex)
  
//两个toArray方法对于元素都是shadowCopy
Object[] toArray()
<T> T[] toArray(T[] a) //把元素拷贝到方法参数数组中
```

## LinkedList

LinkedList是有序链表，它可以作为栈、队列的实现类。LinkedList的新增、删除元素操作效率非常高，但随机遍历的速度较慢。

