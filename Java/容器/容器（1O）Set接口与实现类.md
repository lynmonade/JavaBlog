# 容器（1O）Set接口与AbstractSet抽象类

Set接口规定，Set中的元素必须是唯一的，即任意两个元素不能出现`e1.equals(e2)`，即使是null元素也只能有一个。对于**Set是否有序、Set是否能包含null元素、Set可以包含哪一种数据类型的元素**，Set接口并未强制规定，具体由子类来确定。所以根据**元素必须唯一**这个特性，我们常用Set作为**排他性判断**。Set接口继承自Collection接口，Set接口中定义的方法与Collection接口中的方法完全一致，不存在额外的方法。

## AbstractSet抽象类

AbstractSet继承自AbstractCollection类，并实现了Set接口，就像其他抽象类一样，如果想要创建自定义的Set，只需要继承AbstractSet即可。AbstractSet的源码非常简单，它只提供了`equals()`、`hashCode()`、`boolean removeAll(Collection<?> c)`三个方法的实现。还需注意的是，在创建具体的Set子类时，比如在构造函数和ad相关方法上判断是否插入了相同的元素，这与List的不同的。

## HashSet类

HashSet继承自AbstractSet类，它内部持有一个HashMap成员变量。HashSet内部的元素是无序的，所以每次遍历时，元素的顺序都有可能不一样。如果对Intertor遍历的性能要求较高，则在调用构造函数`HashSet(int initialCapacity, float loadFactor)`时，initialCapacity不能太大loadFactor也不能太小。此外HashSet允许插入null值，但HashSet是线程不安全的。

HashSet的实现方式非常优雅，它本质上是借助HashMap中的一个内部类来实现。HashSe持有一个HashMap成员变量，因此HashSet便获得了HashMap所有的能力（组合）。HashMap的`keySet()`方法可以返回一个Set，这个Set使用Map中所有的key作为元素。而Map中的key是不能重复的，这也正好符合Set的特征。具体来说，`keySet()`方法返回的是一个定义在HashMap类中的一个内部类，名为KeySet。KeySet继承自AbstractSet。因此我们可以发现，HashSet只是一个壳，本质上是通过HashMap的KeySet类来提供Set的操作。