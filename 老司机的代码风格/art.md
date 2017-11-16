# chapter1
## 选择专业名词
size()--memoryBytes()
send-->deliver,dispatch,announce,distribute,route
find-->search,extract,locate,recover
start-->launch,create,begin,open
make-->create,set up,build,generate,compose,add,new

result,retval-->sum_square  方法返回值

## 多层for循环

```java
Club[] clubs = ...;
Member[] Members = ...;

//bad
for(int i=0; i<clubs.length; i++) {
	for(int j=0; j<clubs[i].length; j++) {
		Club club = clubs[i];
	}
}

//good
for(int ci=0; ci<clubs.length; ci++) {
	for(int mj=0; mj<clubs[i].members.length; mj++) {
		Club club = clubs[ci];
	}
}
```

## 全局控制变量只控制一个事情

```java
//bad
//控制是否打印日志，控制是否是开发环境
run_locally = true

//good
print_log = true
is_dev = true
```

## 为名字附带更多的信息
可以为变量名添加“单位信息”，“状态信息”。

```java
//bad
Long start = System.currentTimeMillis();
Long end = System.currentTimeMillis();

//good
Long start_ms = System.currentTimeMillis();
Long end_ms = System.currentTimeMillis();

password-->plain_password
password-->md5_password;

data-->plain_data;
data-->urlencode_data; 
```

## 名字应该多长？？
小作用域应该使用短小的名字，比如局部变量的名字应该短小精悍。

大作用域英爱使用更加完整的名字，比如成员变量、全局变量。

## 利用名字的格式传递含义
1. 成员变量名以m_开头：m_dept, m_node
2. 静态变量以s_开头：s_count, s_proc
3. 常量全部大写：IS_DEV，CONSTANT

# chapter2
##　函数名称歧义

```java
//bad
clip(text, length);
filter("year<2011");
```

## 使用min，max来表示包含极限

```java
//bad
CART_TOO_BIG_LIMIT = 10;
if(shop_cart.num_items()>=CART_TOO_BIG_LIMIT) {
	Error("too many items in cart");
}

//good
MAX_ITEM_IN_CART = 10;
//尽量不要使用大于等于，而是直接使用大于
if(shop_cart.num_items()>MAX_ITEM_IN_CART) { 
	Error("too many items in cart");
}
```

## 使用first、last表示包含范围

## 使用begin、end表示包含、排除范围

## 布尔值命名
1. 不要包含反义词：`is_disable`
2. 推荐使用is、has、can、should开头

## 与使用者的期望匹配（函数名）

```java
//bad 
public void getMean() {
	//涉及大量计算，很耗资源
	return this.total/this.num_samples;
} 

//good
public void computeMean() {
	return this.total/this.num_samples;
}

```