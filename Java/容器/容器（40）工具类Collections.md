# 容器（40）工具类Collections

```java
//把对象o进行浅拷贝n次，然后放入一个List中
//并返回一个不可修改(immuble)的list(无法调用add/remove/set)
static <T> List<T> nCopies(int n, T o)

//使用同一个对象把容器填充满，但无法新增元素
static <T> void fill(List<? super T> list, T obj)
```

