# （容器：应用篇）List--Map--Set

## ArrayList

### 创建ArrayList

```java
List<String> list = new ArrayList<String>();  //空的list
```

### 添加元素

```java
List<String> list = new ArrayList<String>(Arrays.asList("1","2","4"));
list.add("5"); //添加一个元素
list.addAll(list); //添加多个元素
```

### 在特定位置添加元素

如果该位置上已有元素，则该元素会往后移动。

```java
List<String> list = new ArrayList<String>(Arrays.asList("1","2","4"));
list.add(2, "3"); //now is 1, 2, 3, 4
list.addAll(2, list); //now is 1, 2, 1, 2, 4, 4
```

### 更新元素

替换特定位置的元素。

```java
List<String> list = new ArrayList<String>(Arrays.asList("1","2","4"));
list.set(0, "9"); //9, 1, 4
```

### 查询元素

（1）根据元素，查询元素对应的index值。

```java
List<String> list = new ArrayList<String>(Arrays.asList("1","0","1","2","4","5"));

//返回的第一个遇到的相等元素。如果没有符合的元素，则返回-1
int a = list.indexOf("1"); //0
//返回最后一个遇到的相等元素。如果没有符合的元素，则返回-1
int a = list.lastIndexOf("1"); //2
```

（2）根据索引index，查询元素。

```java
List<String> list = new ArrayList<String>(Arrays.asList("1","0","1","2","4","5"));
String s = list.get(3); //2
```

### 删除元素

```java
List<String> list = new ArrayList<String>(Arrays.asList("1","0","1","2","4","5"));

//删除所有元素，得到一个空的List
list.clear(); 

//删除第一个匹配的元素
list.remove("1"); //[0, 1, 2, 4, 5]

//删除指定位置的元素
list.remove(0); //[0, 1, 2, 4, 5]

//删除参数集合匹配的所有元素
List<String> list2 = new ArrayList<String>(Arrays.asList("1","0"));
list.removeAll(list2); //[2, 4, 5]
```

### 取交集元素

```java
//取两个集合的交集，并返回一个交集集合
List<String> list = new ArrayList<String>(Arrays.asList("1","0","1","2","4","5"));
List<String> list2 = new ArrayList<String>(Arrays.asList("1","4","5"));
list.retainAll(list2);
```

### size相关

```java
List<String> list = new ArrayList<String>(Arrays.asList("1","0","1","2","4","5"));
int a = list.size(); //6
```

### 判断相关

```java
List<String> list = new ArrayList<String>(Arrays.asList("1","0","1","2","4","5"));

//判断list是否是空集合
boolean b = list.isEmpty(); //false

//判断是否包含指定元素
boolean b = list.contains("1"); //true

//判断是否包含指定集合的所有元素
List<String> list2 = new ArrayList<String>(Arrays.asList("1","0"));
boolean b = list.containsAll(list2); //true
List<String> list2 = new ArrayList<String>(Arrays.asList("1","7"));
boolean b = list.containsAll(list2); //false
```

### 遍历相关

（1）迭代器遍历，推荐。

```java
List<String> list = new ArrayList<String>(Arrays.asList("1","0","1","2","4","5"));
Iterator<String> it = list.iterator();
while(it.hasNext()) {
	String s = it.next();
}
```

（2）for-each遍历

```java
List<String> list = new ArrayList<String>(Arrays.asList("1","0","1","2","4","5"));
for(String s : list) {
	//...
}
```

（3）for循环遍历

```java
List<String> list = new ArrayList<String>(Arrays.asList("1","0","1","2","4","5"));
for(int i=0; i<list.size(); i++) {
	String s = list.get(i);
}
```

## HashMap

### 创建HashMap

```java
//创建空的map
Map<String, String> map = new HashMap<String, String>();

//以另一个map作为数据源创建新的map
Map<String, String> original = new HashMap<String, String>();
original.put("k1", "v1");
Map<String, String> map = new HashMap<String, String>(original);
```

### 添加/更新元素

```java
//如果已存在k1元素，则替换其value
map.put("k1", "v1");

//通过map数据源添加多个元素，如果key相同，则会进行更新覆盖
Map<String, String> map = new HashMap<String, String>();
map.put("k1", "v1");

Map<String, String> map2 = new HashMap<String, String>();
map2.put("k1", "k2");
map2.put("k3", "k3");
map.putAll(map2); //map={k1=k2, k3=k3}
```

### 查询元素

```java
//1. 如果存在k1，则返回其对应的值
//2. 如果存在k1，但其值是null，则返回null
//3. 如果不存在k1，则返回null
//4. 对于2,3的情况，可以结合使用containsKey()进一步判断
String v1 = map.get("k1"); 
```

### 删除元素

```java
//返回值是被删除的value
String v1 = map.remove("k1");

//删除所有的元素，得到一个空map
map.clear();
```

###  size相关

```java
int size = map.size();
```

### 判断相关

```java
//判断map是否包含元素
boolean b = map.isEmpty();

//判断map是否包含该key
boolean b = map.containsKey("k1");

//判断map是否包含该value
boolean b = map.containsValue("v1");
```

###  三个视图

```java
Map<String, String> map = new HashMap<String, String>();
map.put("k1", "v1");

//1.得到所有的key，保存在Set中。Set本质上是HashMap的内部类KeySet
Set<String> set = map.keySet(); //set=[k1]

//2. 得到所有的value，保存在Collection中。Collection本质上是HashMap的内部类Values
Collection<String> col = map.values(); //col=[v1]

//3. 得到所有的元素，保存在Set中。Set本质上是HashMap的内部类EntrySet。
//Set中的元素是HashMap的内部类Node的实例，Node实现了Map接口中的内部接口Map.Entry<K,V>
Set<Map.Entry<String, String>> set = map.entrySet(); 
Iterator<Map.Entry<String, String>> it = set.iterator();
while(it.hasNext()) {
	Map.Entry<String, String> node = it.next(); //set=[k1=v1]
}
```

### 迭代相关

HashMap并没有实现Iterable接口，因此不能直接对HashMap使用迭代器遍历，也不能对其使用for-each遍历。唯一的办法就是调用entrySet()方法获得所有元素组成的set，再对set进行遍历。

```java
Map<String, String> map = new HashMap<String, String>();
map.put("k1", "v1");
map.put("k2", "v2");
Set<Map.Entry<String, String>> set = map.entrySet(); 
Iterator<Map.Entry<String, String>> it = set.iterator();
while(it.hasNext()) {
	Map.Entry<String, String> node = it.next();
}
```

## HashSet

### 创建HashSet

```java
//创建空的set
Set<String> set = new HashSet<String>();

//以collection为数据源创建新的set，此时会自动剔除重复元素，并且set元素的顺序随机
String[] array = {"9", "7", "1","0","1","2","4"};
List<String> list = new ArrayList<String>(Arrays.asList(array));
Set<String> set = new HashSet<String>(list); //[0, 1, 2, 4, 7, 9]
```

### 添加元素

```java
//返回值表示是否添加成功，成功为true，如果已存在该元素，则什么也不干，返回false
String[] array = {"9", "7", "1","0","1","2","4"};
List<String> list = new ArrayList<String>(Arrays.asList(array));
Set<String> set = new HashSet<String>(list); 

boolean b1 = set.add("9"); //false
boolean b2 = set.addAll("8"); //true
```

### 删除元素

```java
//成功删除则返回true。否则返回false
String[] array = {"9", "7", "1","0","1","2","4"};
List<String> list = new ArrayList<String>(Arrays.asList(array));
Set<String> set = new HashSet<String>(list); 

boolean b = set.remove("9"); //true

//清空set，得到一个空set
set.clear();
```

###  size相关

```java
int size = set.size(); 
```

### 判断相关

```java
String[] array = {"9", "7", "1","0","1","2","4"};
List<String> list = new ArrayList<String>(Arrays.asList(array));
Set<String> set = new HashSet<String>(list); 

//是否包含特定元素
boolean b = set.contains("9"); //true

//是否是空set
boolean b = set.isEmpty();
```

### 遍历相关

（1）迭代器遍历，推荐

```java
String[] array = {"9", "7", "1","0","1","2","4"};
List<String> list = new ArrayList<String>(Arrays.asList(array));
Set<String> set = new HashSet<String>(list); 
Iterator<String> it = set.iterator();
while(it.hasNext()) {
	String str = it.next();
}
```

（2）for-each遍历

```java
String[] array = {"9", "7", "1","0","1","2","4"};
List<String> list = new ArrayList<String>(Arrays.asList(array));
Set<String> set = new HashSet<String>(list); 
for(String str : set) {
	print(str);
}
```

## 日常应用

### List转为数组

```java
List<String> list = new ArrayList<String>(Arrays.asList("1","0","1","2","4","5"));

//不支持泛型，只能转为Object[]数组。shadowCopy
Object[] array = list.toArray(); 

//支持泛型，但需要创建一个空的数组，让函数可以识别其泛型。shadowCopy
String[] array = {};
array = list.toArray(array);
```

### Set转为数组

```java
String[] source = {"9", "7", "1","0","1","2","4"};
List<String> list = new ArrayList<String>(Arrays.asList(source));
Set<String> set = new HashSet<String>(list); 

//不支持泛型，只能转为Object[]数组。shadowCopy
Object[] array = set.toArray(); 
print(Arrays.toString(array));

//支持泛型，但需要创建一个空的数组，让函数可以识别其泛型。shadowCopy
String[] array = {};
array = list.toArray(array);
```

### 数组转为List

```java
String[] array1 = {"1","2","3"};
List<String> listTemp = Arrays.asList(array1);
//List<String> listTemp = Arrays.asList("1", "2", "3"); //也支持可变参数
List<String> list = new ArrayList<String>(listTemp);
```

### 数组转为Set

```java
//需要先转为list，再转为set
String[] source = {"9", "7", "1","0","1","2","4"};
List<String> list = new ArrayList<String>(Arrays.asList(source));
Set<String> set = new HashSet<String>(list); 
```



### 数组拷贝

```java
/*
方法一：Arrays工具类，底层转调System.arraycopy
newLength表示拷贝源数组中的多少个元素
static <T> T[] copyOf(T[] original, int newLength) //元素是对象时，进行浅拷贝
static int[] copyOf(char[] original, int newLength) //元素是基本类型时，进行深拷贝
*/

//拷贝对象
String[] original = {"1","2","3"};
String[] newArray = Arrays.copyOf(original, original.length);
//拷贝基本类型
int[] original = {2,4,6};
int[] newArray = Arrays.copyOf(original, original.length);


/*
方法二：System工具类，对象浅拷贝，基本类型深拷贝
static native void arraycopy(Object src,int srcPos,Object dest,int destPos,int length);
src：源数组
srcPos：源数组起始拷贝位置
dest：目标数组
destPos：目标数组起始拷贝位置
length：拷贝元素的个数
*/

int[] original = {1,2,3,4,5,6,7,8,9,10};
int[] destination = new int[10];
System.arraycopy(original, 0, destination, 0, 5); //只拷贝前5个元素
```









