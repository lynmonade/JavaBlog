# （容器：应用篇1）

## ArrayList

## 日常应用

### 数组、容器之间的转换与拷贝

```java
//集合转为数组，Collection接口的方法，浅拷贝元素
Object[] toArray() //只能转为Object类型
<T> T[] toArray(T[] a) //可以转为任意类型
  
//数组转为集合，Arrays工具类，浅拷贝元素
static <T> List<T> asList(T... a) //返回长度不可变的List

//数组拷贝，Arrays工具类，底层转调System.arraycopy
static <T> T[] copyOf(T[] original, int newLength) //元素是对象时，进行浅拷贝
static int[] copyOf(int[] original, int newLength) //元素是基本类型时，进行深拷贝

//数组拷贝，System工具类，对象浅拷贝，基本类型深拷贝
//由其他语言实现，无法查看源码
static native void arraycopy(Object src,int srcPos,Object dest,int destPos,int length);

//参考 http://blog.csdn.net/abyjun/article/details/46444921
```







