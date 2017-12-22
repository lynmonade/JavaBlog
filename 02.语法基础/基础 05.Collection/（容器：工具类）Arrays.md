# 容器（1）工具类Arrays

数组与容器的区别主要有三个方面：效率、类型安全、保存基本类型能力。由于数组是定长的，因此其随机访问效率和存储效率是最高的。由于数组可以显式地指定元素类型，强制保证类型安全，因此在编译期就能检查出类型转换错误。此外，数组也可以直接保存基本数据类型。

但在JDK1.5引入泛型之后，我们也可以为容器显式地指定元素类型。此外，利用自动装箱拆箱机制，也可以间接实现使用容器存储基本数据类型的需求。因此在类型安全、和保存基本类型方面，数组不再具有优势，唯一剩下的优势就是效率了。因此在评估选用数组还是容器时，只需考虑数组长度不可变是否能满足需求，如果不能满足，那就使用容器吧。

数组本质上也是在堆中分配存储空间（因为使用了new关键字），当数组元素为基本类型时，数组直接存储基本类行数据的值，如果元素为数值型，则自动初始化为0；如果为char类型，则初始化为(char)0；如果为boolean类型，则初始化为false。当数组元素为对象类型时，数组则持有对象的引用，自动初始化为null。数组唯一可以访问的字段/方法就是length，它表示数组的容量，而不是实际保存的元素个数。

## API介绍

```java
//把数组转为定长List
//其返回值本质上是一个定义在Arrays类中的内部类，名叫ArrayList。内部类ArrayList并没有提供add和remove方法，因此你无法新增、删除它的元素（保持定长）
//如果要转为边长List，则可以：new ArrayList(Arrays.asList(myArray));
static <T> List<T> asList(T... a)
  
//返回格式化的数组结果：[element0.toString(), element1.toString(), element2.toString()...]
//如果直接打印数组引用，打印出的其实是数组内存地址
static String toString(...)系列方法

//使用二分查找算法查找特定元素，并返回其下标索引值
static int binarySearch(...)系列方法
  
//比较数组是否相等，相等的条件是：1.元素个数必须相等。2.对应位置的元素也必须相等
//“比较是通过对每一个元素使用equals()作比较来判断。对于基本类型，则使用其包装类的equals方法
static boolean equals(...)系列方法

//往数组中填充入N个相同的值
static void fill(...)系列方法

//返回数组对应的hashCode值
static int hashCode(...)系列方法

//对数组进行排序
static void sort(...)系列方法
  
//拷贝数组，并返回一个新数组。如果元素是Object类型，则使用shadowCopy
static XXX[] copyOf(...)系列方法

//拷贝数组的一部分，并返回一个新数组。如果元素是Object类型，则使用shadowCopy
static XXX[] copyOfRange(...)系列方法
  
//再介绍一个方法
//该方法用于数组拷贝，如果元素是对象，则执行shadowCopy
//此外，该方法并不会自动装箱拆箱，因此两个数组必须具有相同的确切的类型
System.arraycopy(Object src, int srcPos, Object dest, int destPos, int length)
```

## asList方法示例

````java
class Snow{}
class Power extends Snow{}
class Light extends Power{}
class Heavy extends Power{}
class Crusty extends Snow{}
class Slush extends Snow{}
public class Test2 {
	public static void main(String[] args) {
		//ok
		List<Snow> snow1 = Arrays.asList(new Power(), new Crusty(), new Slush());
		
		//在JDK6会报错,JDK8编译通过
		List<Snow> snow2 = Arrays.asList(new Light(), new Heavy()); 
		
		//ok
		List<Snow> snow3 = new ArrayList<Snow>();
		Collections.addAll(snow3, new Light(), new Heavy());
		
		//ok，推荐做法
		List<Snow> snow4 = Arrays.<Snow>asList(new Light(), new Heavy());
	}
}
````

## 数组比较

数组比较本质上来说是比较数组对应位置的每一个元素。通过调用每一个元素的equals()方法进行比较，如果是基本类型，则会封装为包装类再比较。具体来说，数组相等必须满足一下两个条件：

* 数组长度必须相等
* 数组对应位置每一个元素使用equals()方法进行对比，均返回true

```java
public class ComparingArrays {
	public static void main(String[] args) {
		int[] a1 = new int[10];
		int[] a2 = new int[10];
		Arrays.fill(a1, 33);
		Arrays.fill(a2, 33);
		System.out.println(Arrays.equals(a1, a2)); //true
		a2[3] = 11;
		System.out.println(Arrays.equals(a1, a2)); //false
		String[] s1 = new String[4];
		Arrays.fill(s1, "Hi");
		String[] s2 = {new String("Hi"), new String("Hi"), 
				new String("Hi"), new String("Hi")};
		System.out.println(Arrays.equals(s1, s2)); //true
	}
}

```

## 数组排序

数组的排序是基于数组元素的比较来实现的。实现数组元素的比较可采用下面两种方式。本质上来说他们都是让类具备`compareTo()`的能力，这样JDK就可以调用你编写的对比规则进行排序。JDK针对排序算法进行了优化，当集合元素是基本数据类型时，采用**快速排序**。当集合元素是对象类型时，采用**稳定归并排序**。Comparator实际上是一种比较策略，因此我们采用策略模式，把由程序猿来决定的比较策略独立出来，确保比较策略不与其他代码发生耦合，也使得比较策略可以复用。

* 数组元素类实现Comparable接口
* 自行创建一个实现了Comparator接口的排序策略类，并在排序时传入该策略类

```java
//实现Comparable接口
public class CompType implements Comparable<CompType>{
	int i;
	int j;
	private static int count = 1;
	private static Random r = new Random(47);
	
	public CompType(int n1, int n2) {
		i = n1;
		j = n2;
	}
	
	public String toString() {
		String result = "[i=" + i + ", j=" + j + "]";
		if(count++ %3 ==0) {
			result += "\n";
		}
		return result;
	}
	
	@Override
	public int compareTo(CompType o) {
		return(i<o.i ? -1 : (i==o.i ? 0 : 1));
	}
	
	public static Generator<CompType> generator() {
		return new Generator<CompType>() {
			public CompType next() {
				return new CompType(r.nextInt(100), r.nextInt(100));
			}
		};
	}
	
	public static void main(String[] args) {
		CompType[] a = Generated.array(new CompType[12], generator());
		System.out.println("before sorting:");
		System.out.println(Arrays.toString(a));
		Arrays.sort(a);
		System.out.println("after sorting");
		System.out.println(Arrays.toString(a));
	}
}
```

```java
//自行创建一个实现了Comparator接口的排序策略类
public class CompTypeComparator implements Comparator<CompType>{

	@Override
	public int compare(CompType o1, CompType o2) {
		return (o1.j < o2.j ? -1 : (o1.j==o2.j ? 0 : 1));
	}
	
	public static void main(String[] args) {
		CompType[] a = Generated.array(new CompType[12], CompType.generator());
		System.out.println("before sorting");
		System.out.println(Arrays.toString(a));
		Arrays.sort(a, new CompTypeComparator());
		System.out.println("after sorting");
		System.out.println(Arrays.toString(a));
	}
}
```

```java
//对字符串进行排序
public class StringSorting {
	public static void main(String[] args) {
		String[] sa = Generated.array(new String[20], new RandomGenerator.String(5));
		System.out.println("before sorting");
		System.out.println(Arrays.toString(sa));
		Arrays.sort(sa);
		System.out.println("after sorting");
		System.out.println(Arrays.toString(sa));
		System.out.println("reverse sorting");
		Arrays.sort(sa, Collections.reverseOrder());
		System.out.println(Arrays.toString(sa));
		System.out.println("case insensitive sort");
		Arrays.sort(sa, String.CASE_INSENSITIVE_ORDER);
		System.out.println(Arrays.toString(sa));
	}
}
```

## 数组查找

如果数组已经排序好了，就可以使用`binarySearch()`执行快速查找。如果要对未排序的数组使用`binarySearch()`，那么将产生不可预料的结果。如果在数组中找到目标对象，则返回该目标对象在数组中的索引，所以如果找到目标对象，则返回值必然>=0。如果返回值是负数，则表示未找到目标对象。如果数组中包含重复元素，`binarySearch()`无法保证找到的是哪一个元素，虽然其返回值依然会>0。如果需要对没有重复元素的数组排序，可以考虑使用TreeSet。此外，我们也可以往`binarySearch()`方法中传入Comparator对象作为查找之前的排序规则：`static <T> int binarySearch(T[] a, T key, Comparator<? super T> c)`。

```java
public class ArraySearching {
	public static void main(String[] args) {
		Generator<Integer> gen = new RandomGenerator.Integer(1000);
		int[] a = ConvertTo.primitive(Generated.array(new Integer[25], gen));
		System.out.println("sorted array");
		Arrays.sort(a);
		System.out.println(Arrays.toString(a));
		while(true) {
			int r = gen.next();
			int location = Arrays.binarySearch(a, r);
			if(location>=0) {
				System.out.println("Location of " + r + " is " + location + 
						", a["+location+"] = " + a[location]);
			}
			break;
		}
	}
}
```
