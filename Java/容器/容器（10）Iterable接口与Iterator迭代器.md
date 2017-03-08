# 容器（10）迭代器

## Iterable接口和Iterator接口

由于**遍历**操作非常普遍，因此JDK专门提炼出了一个遍历接口，当一个类想要具有遍历功能时，直接让其实现Iterable接口即可。Iterable接口只有一个方法`iterator()`，我们可以把它当做是一个工厂方法，通过该方法可以获得一个Iterator类型的对象，并通过Iterator来执行具体的遍历操作。

```java
public interface Iterable<T> {
    /**
     * Returns an iterator over a set of elements of type T.
     *
     * @return an Iterator.
     */
    Iterator<T> iterator();
}
```

具体Iterable的规范如下：

1. 对于需要拥有遍历功能的类，首先你要实现iterator()方法。
2. iterator()方法返回一个Iterator实例。
3. Iterator实例一般使用内部类创建，并实现Iterator接口的具体方法。
4. 使用Iterator接口的具体方法来做遍历。

因此，我们通过Iterable接口和Iterator接口，共同规范了所有类的遍历操作，各个类只需要提供接口的具体实现即可。这也反映了接口的思想：接口规范了**要做什么**，实现类提供了**怎么做**。

在下面的例子中，就实现了让NonCollectionSequence类具备遍历功能，由于Iterable是接口，不会影响子类去继承其他类。此外，还有一个**不成文的契约：**由于需要遍历，因此子类一般来说会持有一个Collection成员变量，这个成员变量就是需要遍历的集合。由于接口并不能强制规定一个类必须具备某个成员变量，因此这也算是一个遗憾吧。

```java
public class PetSequence {
	protected Pet[] pets = Pets.createArray(8);
}

public class NonCollectionSequence extends PetSequence implements Iterable<Pet>{
	@Override
	public Iterator<Pet> iterator() {
		return new Iterator<Pet>() {
			private int index = 0;
			@Override
			public boolean hasNext() {
				return index<pets.length;
			}
			@Override
			public Pet next() {
				return pets[index++];
			}
		};
	}
	
	public static void main(String[] args) {
		NonCollectionSequence nc = new NonCollectionSequence();
		InterfaceVsIterator.display(nc.iterator());
	}
}
```

此外，在《Think In Java》一书的11.12章节中也提到，Collection及其子类也带有遍历的功能，因为他们都实现了Iterable接口。如果你希望你的类也拥有遍历功能，你无需去继承/实现Collection接口或子类，只需实现iterable接口即可。Collection接口及其子类都实现了Iterable接口。但Map接口及其子类并没有实现Iterable接口。

for-each语法可以用于任何Iterable类或数组。但数组并不一定是Iterable类型，当尝试把数组当做一个Iterable参数传递会导致失败，这说明并不存在任何数组到Iterable的自动转换。必须手动转换。如果想让数组变成Iterable，则需要使用`Arrays.asList(stringArray)`把数组转为具备Iterable能力的List。

### Iterator源码分析

对于ArrayList来说，Iterator的实现类是作为内部类存在于ArrayList之中，我们可以分析ArrayList中的Iterator，窥探其中的秘密。

```java
private class Itr implements Iterator<E> {
  
  int cursor;       //游标默认初始值是0
  int lastRet = -1; //用于记录执行next()或previous()方法后的cursor位置，它是执行set()和remove()的依据
  int expectedModCount = modCount;

  //当游标指向最后一个元素时，执行hasNext方法，依然返回true
  public boolean hasNext() {
    return cursor != size;
  }

  //注意：next()方法返回的是目前游标指向的元素，而不是游标指向元素的下一个元素。
  //先：lastRet=cursor;
  //后：cursor++;
  @SuppressWarnings("unchecked")
  public E next() {
    checkForComodification();
    int i = cursor; //存储next()操作之前的cursor值
    if (i >= size)
      throw new NoSuchElementException();
    Object[] elementData = ArrayList.this.elementData;
    if (i >= elementData.length)
      throw new ConcurrentModificationException();
    cursor = i + 1; //cursor像右移动一位
    return (E) elementData[lastRet = i]; //返回当前元素。lastRet也设置为next()操作之前的cursor值
  }

  //和set类似，只有执行了next()或previous()才能够
  //remove操作的是lastRet位置的元素
  //cursor也会被重置lastRet值
  //lastRet重置为-1
  public void remove() {
    if (lastRet < 0)
      throw new IllegalStateException();
    checkForComodification();

    try {
      ArrayList.this.remove(lastRet); //删除lastRet位置的元素
      cursor = lastRet; //cursor位置重置
      lastRet = -1; //remove()会把lastRet还原为-1
      expectedModCount = modCount;
    } catch (IndexOutOfBoundsException ex) {
      throw new ConcurrentModificationException();
    }
  }

  final void checkForComodification() {
    if (modCount != expectedModCount)
      throw new ConcurrentModificationException();
  }
}
```

`next()`和`hasNext()`方法名具有一定的欺骗性。从源码可知，Iterator是基于cursor游标进行元素访问的。cursor的默认值是0，只要cursor值不等于list.size()，或者说即使cursor目前正在指向最后一个元素，hasNext()方法依然返回true。这与我们平常的认知不太符合。hasNext()翻译过来就是**是否还有下一个元素**，然后即使cursor在最后一个元素，hasNext()依然返回true。此外，`next`方法返回的是cursor所指向的元素，而不是cursor所指向的元素的下一个元素。这与我们理解的**下一个元素**也不符合。

虽然`next()`和`hasNext()`方法最终都能达到遍历的目的，但研究过源码后，我们更加清晰地了解到方法背后的实现方式，而不是被方法名所迷惑。

## ListIterator接口

ListIterator接口继承自Iterator接口，它提供了更强大的遍历功能，包括向前/向后的遍历。相比而言，ListIterator提供的previous相关方法并不会产生歧义，它确实是返回cursor所在元素的前一个元素。

### 工厂方法获取ListIterator

ListIterator只能用于各种List类的访问。它提供了从头位置遍历数组的方式，也提供了从特定位置遍历数组的方式。

```java
//从头开始遍历
ListIterator<E> listIterator()
//从index位置开始遍历
ListIterator<E> listIterator(int index)
```

### ListIterator源码分析

```java
//List是ItrArrayList的内部类
//ListItr继承自Itr，Itr是也是是ItrArrayList的内部类，Itr实现了Iterator接口
//因此ListItr通过继承，直接具备了Itr的能力，并新增了向前遍历和修改功能
private class ListItr extends Itr implements ListIterator<E> {
    //构造函数，指定cursor的起始位置
	ListItr(int index) {
		super();
		cursor = index;
	}

    //只要cursor不等于0，就返回true
	public boolean hasPrevious() {
		return cursor != 0;
	}

    //返回当前cursor元素的index值
    //nextIndex()并不会影响cursor的值
	public int nextIndex() {
		return cursor;
	}

    //返回cursor元素的上一个元素的index值
    //previousIndex()并不会影响cursor的值
	public int previousIndex() {
		return cursor - 1;
	}

    //返回cursor元素的上一个元素
    //先：cursor--;
  	//后：lastRet = cursor;
	@SuppressWarnings("unchecked")
	public E previous() {
		checkForComodification();
		int i = cursor - 1; //获取cursor左移的位置
		if (i < 0)
			throw new NoSuchElementException();
		Object[] elementData = ArrayList.this.elementData;
		if (i >= elementData.length)
			throw new ConcurrentModificationException();
		cursor = i; //cursor左移
		return (E) elementData[lastRet = i]; //返回cursor左移的位置。lastRet也设置为cursor-1值
	}

    /**
    在API中有提到，只有执行了next()或previous()后，才能执行set()方法。
    原因就在于：lastRet的初始值是-1，只有执行了next()或previous()方法后，lastRet的值才会>0，才符合执行set()的条件。
    此外，set()方法操作的是lastRet所在的元素。
    */
	public void set(E e) {
		if (lastRet < 0) //lastRet检查
			throw new IllegalStateException();
		checkForComodification();

		try {
			ArrayList.this.set(lastRet, e);
		} catch (IndexOutOfBoundsException ex) {
			throw new ConcurrentModificationException();
		}
	}

    //add()是在cursor所在位置插入一个新元素，而后面的元素自动向后挪位置
	public void add(E e) {
		checkForComodification();

		try {
			int i = cursor;
			ArrayList.this.add(i, e);
			cursor = i + 1;
			lastRet = -1;
			expectedModCount = modCount;
		} catch (IndexOutOfBoundsException ex) {
			throw new ConcurrentModificationException();
		}
	}
}
```

通过上面的源码分析可以得出如下结论：

* Iterator和ListIterator是通过cursor游标来操纵数据
* `hasNext()`通过cursor != list.size()来判断是否含有下一个元素
* `hasPrevious()`通过cursor != 0来判断是否含有上一个元素
* `next()`返回的是cursor所在位置的元素，即`get(cursor)`; 并且`next()`会把lastRet设置为cursor的值。最后，cursor会右移一位
* `previous()`返回的是cursor所指向元素的左边一个元素，即`get(--cursor)`; 并且`previous()`会把lastRet设置为--cursor。最终，cursor会左移一位
* `add()`是在cursor位置插入新元素，后面的元素自动挪位置，cursor置为cursor+1，最后把lastRet置为-1
* `remove()`是在lastRet位置删除元素，cursor置为lastRet，cursor置为lastRet，最后lastRet置为-1
* `set()`用于设置lastRet位置的元素，只有lastRet>0时才能调用次方法。（即调用了next()或previous()方法之后）