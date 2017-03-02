# 数理知识（2）Math类和math包
## Math
Math类提供了众多数学运算的便捷方法。Math类并没有public的构造函数，其所有的成员变量和方式均是static的。下面列出常用的方法，其他的自己翻API吧！

### 静态成员变量 
```java
//底数
static double E 
//圆周率
static double PI
```

### 取整数
#### rint方法
rint()方法会返回最接近这个double参数的整数。（在正无穷和负无穷方向都考虑）。如果在正无穷和负无穷方向上都有一个最接近的整数(这个double正好在中间)，则返回偶数整数。（even偶数，odd基数）

```java
//返回最接近这个double参数的整数，返回值用double表示
//如果参数本身就是个整数，则返回自身
static double rint(double a)

//例子
double d0 = 18.5;
double d1 = -19.5;
double d2 = 19.498;
double d3 = 20.574;
System.out.println(Math.rint(d0));//18
System.out.println(Math.rint(d1));//-20
System.out.println(Math.rint(d2));//19
System.out.println(Math.rint(d3));//21
```

#### ceil方法
ceil这个单词翻译过来就是天花板，它会返回double参数在正无穷方向上最接近的整数，并把返回值转为double类型。

```java
static double ceil(double a)

//例子
//ceil:天花板，往正无穷方向取最接近的整数
System.out.println(Math.ceil(0.5)); //1.0
System.out.println(Math.ceil(-0.5)); //-0.0 这是negative zero
System.out.println(Math.ceil(12.569)); //13.0
System.out.println(Math.ceil(-12.569)); //-12.0
```

#### floor方法
floor这个单词翻译过来就是地板，它会返回double参数在负无穷方向上最接近的整数，并把返回值转为double类型。

```java
static double floor(double a)

//例子
//floor:地板，往负无穷方向取最接近的整数
System.out.println(Math.floor(0.5)); //+0.0 这是positive zero
System.out.println(Math.floor(-0.5)); //-1.0 
System.out.println(Math.floor(12.569)); //12.0
System.out.println(Math.floor(-12.569)); //-13.0
```

####round方法
严格来说，round方法并不能算作是精确的“四舍五入”，它只能用于"保留整数的四舍五入算法"。在API文档中有描述：

>static long round(double a)等价于(long)Math.floor(a + 0.5d)

>static int round(float a) 等价于 (int)Math.floor(a + 0.5f)

```java
static int round(float a)
static long round(double a)

//例子
//round()的结果等价于(long)Math.floor(a + 0.5)
System.out.println(Math.round(0.4213)); //0 
System.out.println(Math.round(0.9845)); //1
System.out.println(Math.round(-0.2366)); //0
System.out.println(Math.round(-0.5901)); //-1
System.out.println(Math.round(12.123)); //12
System.out.println(Math.round(12.569)); //13
System.out.println(Math.round(17.51)); //18
System.out.println(Math.round(-17.42)); //-17
```

注意，round方法的返回值是整数类型，因此它不能用做“保留后两位小数的四舍五入算法”。网上有一些做法，会尝试把参数先放大100倍（乘以100），然后再缩小100倍的（除以）的方式，变相的实现“保留两位小数的四舍五入”。这样的做法其实并规范，不推荐使用。此外，也不推荐使用DecimalFormat类的格式化来实现四舍五入（取决于JDK版本）。他们在某些情况下无法满足四舍五入的要求，最佳的方式是使用BigDecimal类来实现四舍五入。

```java
double d1 = 4.015;
double d2 = d1*100;
long v1 = Math.round(d2);
System.out.println(d2); //401.49999999999994
System.out.println(v1/100.0); //4.01，但我们期望4.02

//JDK1.6得到4.02，JDK1.8得到4.03
System.out.println(new java.text.DecimalFormat("0.00").format(4.025));
```

#### signum方法

```java
如参数>0则返回1.0，如参数<0则返回-1.0，如参数=0则返回0
static double signum(double d)
static float signum(float f)
```

### 绝对值

```java
//对于int和long来说，如果int/long的值等于int/long范围的最小值，则abs()后，返回值依然是最小值，因为已经超出范围了。
static double abs(double a)
static float abs(float a)
static int abs(int a)
static long abs(long a)
```

### 两者比较大小
```java
//如果两者值相等，则返回相等值
static double max(double a, double b)
static float max(float a, float b)
static int max(int a, int b)
static long max(long a, long b)
static double min(double a, double b)
static float min(float a, float b)
static int min(int a, int b)
static long min(long a, long b)
```

### N次幂
```java
//a的b次方，这个函数坑超级多，详见API文档
static double pow(double a, double b)

//例子
double d = 1.0/4.0;
System.out.println(Math.pow(256,d)); //4.0
```

### 平方根
```java
//返回参数的平方根
static double sqrt(double a)

//例子
double d = 25;
System.out.println(Math.sqrt(d));//5.0
```

## java.math.BigDecimal

在《Effective Java》一书中有提到，double和float只能用于科学计算和工程计算，在商业计算中我们需要使用BigDecimal。先看下面的例子就知道double和float有多坑：

```java
double d0 = 0.04d + 0.01d;
System.out.println(d0); //0.05
double d1 = 0.05d+0.01d;
System.out.println(d1); //0.060000000000000005
double d2 = 0.66d-0.01d;
System.out.println(d2); //0.65
double d3 = 0.66d-0.55d;
System.out.println(d3); //0.10999999999999999
double d4 = 0.01d*0.32d;
System.out.println(d4); //0.0032
double d5 = 0.01d*0.68d;
System.out.println(d5); //0.0068000000000000005

float f0 = 0.04f + 0.01f;
System.out.println(f0); //0.049999997
float f1 = 0.05f+0.01f;
System.out.println(f1); //0.060000002
float f2 = 0.66f-0.01f;
System.out.println(f2); //0.65000004
float f3 = 0.66f-0.55f;
System.out.println(f3); //0.110000014
float f4 = 0.01f*0.32f;
System.out.println(f4); //0.0032
float f5 = 0.01f*0.68f;
System.out.println(f5); //0.0068
```

再看一个在《effective java》中提到的例子：假设你的口袋里有1美元，你看到货架上有一排糖果，标价分别是10美分、20美分、30美分、40美分、等等，一直到1美元。你打算从标价为10美分的糖果开始，每种买一颗，一直到不能支付货架上下一种价格的糖果为止，那么你可以爱多少克糖果？还会找回多少零钱？

```java
public static void test4() {
  double funds = 1.0;
  int itemsBought = 0;
  for(double price=0.1; funds>=price; price+=0.1) {
    funds -= price;
    itemsBought++;
  }
  System.out.println("itemBought="+itemsBought);
  System.out.println("changes="+funds);
}

//itemBought=3
//changes=0.3999999999999999
```

解决此类问题的办法就是使用BigDecimal，或者使用int、long放大N倍来表示货币。推荐使用BigDecimal，推荐使用BigDecimal，因为使用int、long来放大N倍的做法会对业务逻辑代码有一定的干扰，不方便阅读。正确的实现代码如下：

```java
public static void test5() {
  final BigDecimal TEN_CENTS = new BigDecimal("0.1");
  int itemsBought = 0;
  BigDecimal funds = new BigDecimal("1.0");

  for(BigDecimal price=TEN_CENTS; funds.compareTo(price)>=0; price=price.add(TEN_CENTS)) {
  funds = funds.subtract(price);
  itemsBought++;
  }
  System.out.println("itemBought="+itemsBought);
  System.out.println("changes="+funds);
}
```

### 7种舍入模式

#### 科普概念：舍弃位

如果保留两位小数，则舍弃位就是小数点后第三位数字。比如12.3578，则舍弃位就是7。

#### ROUND_UP

向远离0的方向进位。如果舍弃位以及舍弃位之后的位非全0，则进位；如果全0，则舍弃。

#### ROUND_DOWN

向靠近0方向舍弃，不涉及任何进位。简单来说，就是把舍弃位以及舍弃位之后的数全部扔掉。

#### ROUND_CEILING

向正无穷方向进位，如果是正数，则舍入方式与ROUND_UP相同，如果为负数，则输入方式与ROUND_DOWN相同。

#### ROUND_FLOOR

向负无穷方向进位，如果是正数，则舍入方式与ROUND_DOWN相同，如果为负数，则输入方式与ROUND_UP相同。

#### ROUND_HALF_UP

这就是最常用的小学体育老师的**四舍五入**模式。简单来说就是，如果舍弃位>=5，则进位；如果舍弃位<5，则舍弃。

#### ROUND_HALF_DOWN

这个和四舍五入有点类似，唯一的区别是当舍弃位=5时的处理方式：

* 如果舍弃位>5时，则进位
* 如果舍弃位<5时，则舍弃
* 当舍弃位等于5时，如果舍弃位之后的位全为0，则舍弃；如果舍弃位之后的位非全0，则进位。

#### ROUND_HALF EVEN 

银行家舍入模式：

* 当舍弃位的数值小于5时，直接舍去。
* 当舍弃位的数值大于5时，进位后舍去。
* 当舍弃位的数值等于5时，分为两种情况：A. 当5后面的数字非全0，则进位B.当5后面的数字全为0，则根据5前一位的奇偶性判断是否进位：奇数进位，偶数舍去。



#### 实验结果

```java
//测试代码
public static void testRoundMode(String value, int roundMode) {
  BigDecimal bd0 = new BigDecimal(value);
  bd0 = bd0.setScale(2, roundMode); //scale=2表示保留两位小数
  System.out.println(bd0); 
}
```

|    保留两位小数     | 8.16325 | 8.16000 | 8.16001 | -8.16325 | -8.16000 | -8.16001 |
| :-----------: | :-----: | :-----: | :-----: | :------: | :------: | :------: |
|   ROUND_UP    |  8.17   |  8.16   |  8.17   |  -8.17   |  -8.16   |  -8.17   |
|  ROUND_DOWN   |  8.16   |  8.16   |  8.16   |  -8.16   |  -8.16   |  -8.16   |
| ROUND_CEILING |  8.17   |  8.16   |  8.17   |  -8.16   |  -8.16   |  -8.16   |
|  ROUND_FLOOR  |  8.16   |  8.16   |  8.16   |  -8.17   |  -8.16   |  -8.17   |

|     保留两位小数      | 8.16427 | 8.16627 | 8.16501 | 8.16500 | 8.13500 |
| :-------------: | :-----: | :-----: | :-----: | :-----: | :-----: |
|  ROUND_HALF_UP  |  8.16   |  8.17   |  8.17   |  8.17   |  8.14   |
| ROUND_HALF_DOWN |  8.16   |  8.17   |  8.17   |  8.16   |  8.13   |
| ROUND_HALF_EVEN |  8.16   |  8.17   |  8.17   |  8.16   |  8.14   |

###  构造函数

BigDecimal的构造函数有很多，常用的是下面两个。我们可以把一个double或者float浮点数转为字符串，来构造一个BigDecimal。此外，我们还可以传入MathContext，MathContext可以显式地设置BigDecimal的成员变量precision和成员变量scale。一般第一个构造函数已经可以满足日常使用需求了。

* precision表示当前BigDecimal封装的数字的有效精度。比如用BigDecimal来封装18.1234567，则bigDecimal的precision为9。如果使用scale进行保留小数的舍入，会影响precision的值，比如对18.1234567进行四舍五入，保留两位小数，则BigDecimal的值变为18.12，而precision的值变为4。
* scale表示保留多少位小数：scale的值可以通过setScale方法设置。如果不显式地指定scale值，则scale值等于小数位数。

```java
BigDecimal(String val)
BigDecimal(String val, MathContext mc)
```

MathContext可以看作是BigDecimal类配置参数的封装类。通过MathContext，你可以显式地设置precision和roundMode舍入模式。

```java
MathContext(int setPrecision)
MathContext(int setPrecision, RoundingMode setRoundingMode)
```





此外，还有两个以double为参数的构造函数。在API中有详细的说明。千万不要使用这两个构造函数来创建BigDecimal，因为他们的结果是不可预知的！

```java
BigDecimal(double val)
BigDecimal(double val, MathContext mc)
```

> Notes: 
>
> 1. The results of this constructor can be somewhat unpredictable. One might assume that writing new BigDecimal(0.1) in Java creates a BigDecimal which is exactly equal to 0.1 (an unscaled value of 1, with a scale of 1), but it is actually equal to 0.1000000000000000055511151231257827021181583404541015625. This is because 0.1 cannot be represented exactly as a double (or, for that matter, as a binary fraction of any finite length). Thus, the value that is being passed in to the constructor is not exactly equal to 0.1, appearances notwithstanding. 
> 2. The String constructor, on the other hand, is perfectly predictable: writing new BigDecimal("0.1") creates a BigDecimal which is exactly equal to 0.1, as one would expect. Therefore, it is generally recommended that the String constructor be used in preference to this one. 

### 成员变量

上面提到的7种舍入模式都是BigDecimal的成员变量。此外，还提供了3个表示0、1、10的成员变量，他们的scale系数都是0，即没有小数部分。如果你需要BigDecimal来封装0、1、10，可以直接用这三个成员变量。

```java
public static final BigDecimal ZERO
public static final BigDecimal ONE
public static final BigDecimal TEN
```

### 常用函数

#### 运算操作

```java
//绝对值
public BigDecimal abs()
public BigDecimal abs(MathContext mc)

//加法
//返回值的scale=max(this.scale(), augend.scale())
public BigDecimal add(BigDecimal augend)
public BigDecimal add(BigDecimal augend, MathContext mc)

//减法
BigDecimal subtract(BigDecimal subtrahend) 
BigDecimal subtract(BigDecimal subtrahend, MathContext mc)
  
//乘法
BigDecimal multiply(BigDecimal multiplicand) 
BigDecimal multiply(BigDecimal multiplicand, MathContext mc)

//除法
BigDecimal divide(BigDecimal divisor) 
BigDecimal divide(BigDecimal divisor, int roundingMode) 
BigDecimal divide(BigDecimal divisor, RoundingMode roundingMode)
BigDecimal divide(BigDecimal divisor, int scale, int roundingMode)
//最常用，可以显式地控制保留位数和舍入方式
BigDecimal divide(BigDecimal divisor, int scale, RoundingMode roundingMode)
BigDecimal divide(BigDecimal divisor, MathContext mc)
  
//除法（保留整数部分）
//第一个方法默认使用ROUND_DOWN模式
//第二个方法可以用mc控制精度和舍入模式，但精度必须要能容纳整数部分，不然会报错。
BigDecimal divideToIntegralValue(BigDecimal divisor)
BigDecimal divideToIntegralValue(BigDecimal divisor, MathContext mc)
  
//除法（保留整数部分和余数部分）
public BigDecimal[] divideAndRemainder(BigDecimal divisor)
public BigDecimal[] divideAndRemainder(BigDecimal divisor,MathContext mc)
  
//取余操作
BigDecimal remainder(BigDecimal divisor) 
public BigDecimal remainder(BigDecimal divisor, MathContext mc)

//n次幂，即this的n次方
BigDecimal pow(int n)
BigDecimal pow(int n, MathContext mc)
  
//舍入操作
BigDecimal round(MathContext mc)
  
//乘以(+1)，等价于(+this)，考虑符号
BigDecimal plus() 
BigDecimal plus(MathContext mc) 

//乘以(-1)，等价于(-this)，考虑符号
BigDecimal negate() 
BigDecimal negate(MathContext mc)
  
//返回this * 10的n次方
scaleByPowerOfTen(int n)
  
//signNum，如果this>0,则return 1;如果this<0,则return-1;如果this=0;则return 0;
int signum()
```

#### 获取值

```java
double doubleValue()
float floatValue()
int intValue() 
long longValue()
int precision() //获取精度
int scale() //获取保留小数位数

```



#### 比较

```java
//对于值相同但scale不同的数，compareTo认为他们是相等的
//比如2.0和2.00是相等的
int compareTo(BigDecimal val)

//对于值相同当scale不同的数，equals方法认为它们是不相等
boolean equals(Object x)

//使用compareTo的规则进行比较
//如果两者相等，则返回this
BigDecimal max(BigDecimal val)
BigDecimal max(BigDecimal val)
```

#### 属性设置

```java
//设置scale和roundMode
BigDecimal setScale(int newScale)
BigDecimal setScale(int newScale, int roundingMode) 
BigDecimal setScale(int newScale, RoundingMode roundingMode) 
```

