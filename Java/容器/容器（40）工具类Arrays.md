# 容器（1）工具类Arrays

数组与容器的区别主要有三个方面：效率、类型安全、保存基本类型能力。由于数组是定长的，因此其随机访问效率和存储效率是最高的。由于数组可以显式地指定元素类型，强制保证类型安全，因此在编译期就能检查出类型转换错误。此外，数组也可以直接保存基本数据类型。

但在JDK1.5引入泛型之后，我们也可以为容器显式地指定元素类型。此外，利用自动装箱拆箱机制，也可以间接实现使用容器存储基本数据类型的需求。因此在类型安全、和保存基本类型方面，数组不再具有优势，唯一剩下的优势就是效率了。因此在评估选用数组还是容器时，只需考虑数组长度不可变是否能满足需求，如果不能满足，那就使用容器吧。

数组本质上也是在堆中分配存储空间（因为使用了new关键字），当数组元素为基本类型时，数组直接存储基本类行数据的值，如果元素为数值型，则自动初始化为0；如果为char类型，则初始化为(char)0；如果为boolean类型，则初始化为false。当数组元素为对象类型时，数组则持有对象的引用，自动初始化为null。数组唯一可以访问的字段/方法就是length，它表示数组的容量，而不是实际保存的元素个数。



## API分析

```java
//把数组转为定长List
//其返回值本质上是一个定义在Arrays类中的内部类，名叫ArrayList。内部类ArrayList并没有提供add和remove方法，因此你无法新增、删除它的元素（保持定长）
//如果要转为边长List，则可以：new ArrayList(Arrays.asList(myArray));
static <T> List<T> asList(T... a)

//使用二分查找算法查找特定元素，并返回其下标索引值
static int binarySearch(...)系列方法

//拷贝数组，并返回一个新数组。如果元素是Object类型，则使用shadowCopy
static XXX[] copyOf(...)系列方法

//拷贝数组的一部分，并返回一个新数组。如果元素是Object类型，则使用shadowCopy
static XXX[] copyOfRange(...)系列方法
  
//比较数组是否相等，相等的条件是：1.元素个数必须相等。2.对应位置的元素也必须相等
//“比较是通过对每一个元素使用equals()作比较来判断。对于基本类型，则使用其包装类的equals方法
static boolean equals(...)系列方法

//往数组中填充入N个相同的值
static void fill(...)系列方法

//返回数组对应的hashCode值
static int hashCode(...)系列方法

//对数组进行排序
static void sort(...)系列方法

//返回格式化的数组结果：[element0.toString(), element1.toString(), element2.toString()...]
//如果直接打印数组引用，打印出的其实是数组内存地址
static String toString(...)系列方法
```





1. asList把数组转为定长List
2. binarySearch使用二分查找搜索指定元素
3. ​