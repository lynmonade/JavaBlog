# chapter2
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

# chapter3
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
# chapter4

## 对齐式的注释

这么写注释：

```java
public class PerformanceTester {
  //TcpConnectionSimulator(throughput, laterncy, jitter, packet_loss)
  //						[kbps]      [ms]      [ms]    [percent]
  
  public static final TcpConnectionSimulator wifi = 
    new TcpConnectionSimulator(500, 80, 200, 1);
  public static final TcpConnectionSimulator wifi = 
    new TcpConnectionSimulator(45000, 10, 0, 0);
  public static final TcpConnectionSimulator wifi = 
    new TcpConnectionSimulator(100, 400, 250, 5);
}
```

## 列对齐，并确保顺序一致

```
//与html中的字段顺序一致
//从“最重要”到“最不重要”排序
//列对齐也能防止你打错字

details  = request.POST.get("details");
location = request.POST.get("location");
phone    = request.POST.get("phone");
email    = request.POST.get("email");
url      = request.POST.get("url");
```

## 分块组织相似的模块

```java
public class Controller {
  	//系统字段，与业务无关
  	private String id;
  	private Date modifiedTime;
  	private Date px;
  
  	//人员信息字段
  	private String userId;
  	private String deptName;
  
  	//业务字段
  	private String posId;
  	private String posId;
}
```

# chapter5 

注释

简单的方法，使用方法名字自行解释即可，无需注释。

先给方法、变量名字起一个优美的名字，再写注释。

名字不应该有歧义。

对于涉及复杂算法的方法，可以写一下算法的主题思想。

对于目前有瑕疵的函数，可以写注释提醒自己后需改进它。

一定要给常量加注释。

对于工具类函数，可以在注释中提供例子。

```java
//example:strip("abba/a/ba", "ab") returns "/a/"
public String strip(String src, String chars){...}
```

对于函数的特殊情况，应该在注释中说明，比如形参为-1时，会返回null。

# chapter6

注释应该精确描述函数的行为：

```java
//统计文件行数的函数

//bad
//return the number of lines inthis file
int countLines(String filename) {...}

//good
//count how many newline bytes ('\n')are in the file
int countLines(String filename){...}

//bad
public void displayProduct() {List<Product> products} {
  products.sort(compareProductByPrice);
  //iterate through the list in reverse order
  Interator<Product> it_reverse = products.iterator().reverse();
  while(it_reverse.hasNext()) {
    ...
  }
}

//good
public void displayProduct() {List<Product> products} {
  products.sort(compareProductByPrice);
  //display each price, from highest to lowest
  Interator<Product> it_reverse = products.iterator().reverse();
  while(it_reverse.hasNext()) {
    ...
  }
}

```



对实参写行内注释

```java
pulbic void connect(long timeout, boolean useEncryption) {...}

//调用方法
connect(/*timeout_ms=*/10, /*use_uncryption*/false);
```



# chapter7

不要用尤达表达式，那是过时的玩意。

```java
//best practice
if(i==10) {}

if("abc".equals(str)) {}
```

if..else的顺序：

* 先处理证逻辑而不是负逻辑
* 先处理简单的情况，再处理复杂情况。
* 先处理有趣、可疑的情况。

三目运算符只能用于简单情况。

禁止用do..while

从函数中提前返回是推荐做法。不必拘泥于“一个函数只能有一个return语句”，这时过时的玩意。

## 最小化嵌套

* if不要多余2层嵌套。
* 解决办法1：使用return，break，continue提早返回
* 解决办法2：重新梳理业务逻辑，变成更加线性的思维，一次只做一件事。

# chapter8

简化超长表达式：

* 引用临时变量
* 引用总结性变量
* 使用德摩根订定理找到超长布尔表达式的反面。

注意java中的短路和断路。

把重复的东西封装到新的函数中，don't repeat yourself

# chapter9

减少没用的、并没有增加解释价值的、后续代码用得很少的临时变量。

尽量不要引入flag变量，那是过时的玩意。

尽量减小变量的作用域。如果一个成员变量只在一两个成员函数中用到，那就把它变成局部变量把。

把局部变量定义在最靠近的地方。

如果可以的话，把变量定义为final的起始非常安全，因为一个变量不会变的话，就会少很多坑。（操作一个变量的地方越多，越南确定它当前的值）。

这一章的“最后的例子”很值学习。

# chapter10

归纳出函数的最高目标，函数中的代码应该直接为最高目标所服务，那些不和最高目标挂钩的代码，应该放到工具类或者其他的private函数中。

多创建工具类，可以多看看jeesite的源码，里面好多工具类。多做一劳永逸的事。

# chapter11 一次只做一件事

一次只做一件事，这也是重新梳理业务逻辑，解决多层if嵌套的办法。

```java
//bad
public void method() {
  //一个if里做了太多的事,多个任务同时进行，交织在一起了
  if() {
    if() {
      if() {
        
      }
    } else {
      
    }
  } else {
    
  }
}

//good
public void method() {
  //step 1
  if() {
    
  }
  else {
    
  }
  //step 2
  if() {
    
  }
  //step 3
  ....
}
```

# chapter12

梳理清楚业务，清晰地描述逻辑：

```java
//业务
//如果你是管理员，你可以看文档
//如果你不是管理员，但你拥有访问权限，则你可以看文档

//bad
String userName = getFromSession("userName");
boolean isAdmin = isAdmin(uesrName);
Document doc = getDocument();
if(doc!=null) { 文档存在
  if(!isAdmin && !doc.isPermit(userName)) { //不是管理员，但没访问权限，则不能看
    return not_authorized();
  }
  else { //文档不存在
    return doc_not_exist();
  }
  //permit, dosth
}

//good
String userName = getFromSession("userName");
boolean isAdmin = isAdmin(uesrName);
Document doc = getDocument();
if(doc==null) {
  return doc_not_exist();
}
if(isAdmin) { 
	//permit
}
else if(!isAdmin && doc.isPermit(userName)) {
  	//permit
}
else {
  return not_authorized();
}
```

# chapter13

少写代码，因为代码越少，就越难出错！















