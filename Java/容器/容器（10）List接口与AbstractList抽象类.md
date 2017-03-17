# 容器（10）List接口与AbstractList抽象类

## List接口

List接口是一种特殊的集合：**有序集合（ordered collection）**，有时也被称为sequence。用户可以使用index下标快速访问List中的元素。一般来说，List类型的集合允许持有多个相同的对象作为元素，也允许插入null值作为元素，当然，你也可以自行创建不能持有相同对象，不能持有null对象的集合。

正因为其有序的特性，一次List接口在Collection接口的基础上，另外增加了4个index相关的方法。在遍历List时推荐使用迭代器进行遍历。List接口还提供了一个特殊的迭代器ListIterator，它允许新增元素或者替换指定位置的元素，还允许从特定位置遍历集合、反向遍历List。List还提供了2个与搜索元素相关的方法。相较于Collection接口，List接口在**有序**的基础上，添加了如下方法：

```java
//可选操作
void add(int index,E element) //在指定位置插入元素
boolean addAll(int index,Collection<? extends E> c) //在指定位置插入多个元素，只要集合发生改变就返回true
E remove(int index) //删除指定位置的元素
E set(int index, E element) //替换指定位置的元素


//必选操作
int indexOf(Object o) //返回第一个相等元素的index值，找不到则返回-1
int lastIndexOf(Object o) //返回最后一个相等元素的index值，找不到则返回-1
E get(int index) //获得指定位置的元素
List<E> subList(int fromIndex, int toIndex) //截取获得子集合  
ListIterator<E> listIterator() //ListIterator工厂方法，从头开始遍历
ListIterator<E> listIterator(int index) //ListIterator工厂方法，从特定位置开始遍历
```

### subList方法注意事项

```java
List<E> subList(int fromIndex,int toIndex)

//例子
List<Integer> list1 = new ArrayList<Integer>(Arrays.asList(0,1,2,3,4,5,6,7,8,9));
List<Integer> list2 = list1.subList(0, 5);
```

该方法可以截取一个子集合，并返回截取到的子集合。首先，截取元素时，遵循左闭右开的原则[fromIndex, toIndex)。

再科普一个概念：**非结构化修改（non-structural changes ）**，即对集合进行操作时，该操作不会对集合的长度造成影响，这样的操作称为非结构化修改，比如`set()`就是非结构化修改。而与之对立的则是**结构化修改**，结构化修改将会改变集合的长度，比如`add()`就是结构化修改。

在上面的例子中，我们暂且把list1称为原集合，list2称为子集合。在截取的过程中，实际上是发生了浅拷贝，这点可以通过下面的代码证明：

```java
System.out.println(list1.get(3)==list2.get(3)); //true
```

其次，如果对原集合list或者子集合list执行**非结构化修改**的操作，则两者均受到影响。这点很容易理解，因为大家的元素都指向同一对象。

```java
list1.set(0, 99);
list2.set(1, 100);
System.out.println(list1.get(0)==list2.get(0)); //true
System.out.println(list1.get(1)==list2.get(1)); //true
```

**如果对子集合执行结构化修改的操作**，将同时会影响到原集合的元素。

```java
list2.clear(); //结构化修改
System.out.println(list1); //[5, 6, 7, 8, 9]
System.out.println(list2); //[]
```

**如果对元集合执行结构化修改的操作**，则会包`java.util.ConcurrentModificationException`错误。

```java
list1.remove(0); //报错
```

总的来说，你可以把子集合理解为一个原集合的一个视图，对视图的修改会作用于原集合上，但如果要对原集合进行结构化的修改，则会造成视图的混乱。因此，我们会利用**子集合的修改会作用于原集合**的特性，通过修改子集合，间接修改原集合的目的。比如像下面这样，通过删除子集合中的元素，间接的删除了原集合中的range元素。

```java
list1.subList(from, to).clear();
```

## AbstractList抽象类

AbstractList抽象类直接实现了List接口，它实现了List接口中的部分方法，它的实现方式主要是针对**"random access" data store**，比如数组这类的数据结构。而AbstractSequentialList抽象类则提供了对应于**linked list**数据结构的操作方法，所以如果你希望创建一个基于数组作为底层数据结构的集合，则应该继承AbstractList，如果你希望创建一个基于linked list作为底层数据结构的集合，则应该继承AbstractSequentialList。

### 源码分析

```java
//只列出关键源码
package java.util;
public abstract class AbstractList<E> extends AbstractCollection<E> implements List<E> {
    //在末尾增加元素
    public boolean add(E e) {
        add(size(), e);
        return true;
    }

	//未提供实现
    abstract public E get(int index);
	
	//未提供实现
    public E set(int index, E element) {
        throw new UnsupportedOperationException();
    }

    //可选操作
    public void add(int index, E element) {
        throw new UnsupportedOperationException();
    }

    //可选操作
    public E remove(int index) {
        throw new UnsupportedOperationException();
    }

	//通过ListIterator迭代查找
    public int indexOf(Object o) {
        ListIterator<E> it = listIterator();
        if (o==null) {
            while (it.hasNext())
                if (it.next()==null)
                    return it.previousIndex();
        } else {
            while (it.hasNext())
                if (o.equals(it.next()))
                    return it.previousIndex();
        }
        return -1;
    }

	//通过ListIterator反向迭代查找
    public int lastIndexOf(Object o) {
        ListIterator<E> it = listIterator(size());
        if (o==null) {
            while (it.hasPrevious())
                if (it.previous()==null)
                    return it.nextIndex();
        } else {
            while (it.hasPrevious())
                if (o.equals(it.previous()))
                    return it.nextIndex();
        }
        return -1;
    }


    //通过ListIterator迭代删除
    public void clear() {
        removeRange(0, size());
    }

    //for-eech循环add
    public boolean addAll(int index, Collection<? extends E> c) {
        rangeCheckForAdd(index);
        boolean modified = false;
        for (E e : c) {
            add(index++, e);
            modified = true; //只要集合发生改变就返回true
        }
        return modified;
    }

	//Iterator工厂方法
    public Iterator<E> iterator() {
        return new Itr();
    }

    //ListIterator工厂方法
    public ListIterator<E> listIterator() {
        return listIterator(0);
    }

    //ListIterator工厂方法，从特定位置开始迭代
    public ListIterator<E> listIterator(final int index) {
        rangeCheckForAdd(index);

        return new ListItr(index);
    }
	
	//截取子集合
    public List<E> subList(int fromIndex, int toIndex) {
        return (this instanceof RandomAccess ?
                new RandomAccessSubList<>(this, fromIndex, toIndex) :
                new SubList<>(this, fromIndex, toIndex));
    }

    //比较结合是否相等
    public boolean equals(Object o) {
        if (o == this) //与自身比较，直接返回true
            return true; 
        if (!(o instanceof List)) //如果参数不是List类型，则肯定不一样，直接返回false
            return false;
		
		//迭代器遍历
        ListIterator<E> e1 = listIterator();
        ListIterator e2 = ((List) o).listIterator();
        while (e1.hasNext() && e2.hasNext()) {
            E o1 = e1.next();
            Object o2 = e2.next();
            if (!(o1==null ? o2==null : o1.equals(o2)))
                return false; //只要有一个不相等就返回false
        }
		//如果每一个元素都相等，且list长度也相等，则返回true
        return !(e1.hasNext() || e2.hasNext());
    }

    //重写hashCode方法
    public int hashCode() {
        int hashCode = 1;
        for (E e : this)
            hashCode = 31*hashCode + (e==null ? 0 : e.hashCode());
        return hashCode;
    }    
}
```

