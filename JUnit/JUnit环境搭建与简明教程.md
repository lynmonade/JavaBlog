# JUnit环境搭建

## 第一步：建立项目

新建一个Java Project，并编写一个简单的计算器类Calculator，接下来我们会对这个类的方法进行测试。

```java
public class Calculator {
    private static int result; // 静态变量，用于存储运行结果
    public void add(int n) {
        result = result + n;
    }
    public void substract(int n) {
        result = result - 1;  //Bug: 正确的应该是 result =result-n
    }
    public void multiply(int n) {
    }         // 此方法尚未写好
    public void divide(int n) {
        result = result / n;
    }
    public void square(int n) {
        result = n * n;
    }
    public void squareRoot(int n) {
        for (; ;) ;            //Bug : 死循环
    }
    public void clear() {     // 将结果清零
        result = 0;
    }
    public int getResult() {
        return result;
    }
}
```

## 第二步：引入JUnit4的jar包

项目右键--->Properties--->Java Build Path--->libraries--->Add Library--->JUnit--->JUnit4--->finish。

## 第三步：编写测试类

在Eclipse的Package Explorer窗口中，右键Calculator类--->New--->JUnit Test Case，类名为CalculatorTest，并勾选setUp()方法。

## 第四步：完善CalculatorTest类

```java
//可以省略@RunWith这个注解，因为JUNIT提供了默认的runner
public class CalculatorTest {
	private static Calculator calculator = new Calculator();
	
	@Before
	public void setUp() throws Exception {
		 calculator.clear();
	}

	@Test
	public void testAdd() {
		calculator.add(2);
        calculator.add(3);
        assertEquals(5, calculator.getResult());
	}

	@Test
	public void testSubstract() {
		calculator.add(10);
        calculator.substract(2);
        assertEquals(8, calculator.getResult());
	}

	@Ignore("Multiply() Not yet implemented")
	@Test
	public void testMultiply() {
	}
	

	@Test
	public void testDivide() {
		calculator.add(8);
        calculator.divide(2);
        assertEquals(4, calculator.getResult());
	}
	
	@Test(timeout=1000)
	public void squareRoot()  {
		calculator.squareRoot( 4 );
		assertEquals( 2 , calculator.getResult());
	}
	
	 @Test(expected=ArithmeticException. class )
	 public void divideByZero()  {
		 calculator.divide( 0 ); 
	 }
}
```

## 第五步：运行JUnit测试用例

选中CalculatorTest类，点击Run As JUnit Test。

# 常用配置

## 测试前的重置

```java
@Before
public void setUp() throws Exception {
	calculator.clear();
}
```





# Reference

* [在Eclipse中使用JUnit4进行单元测试（初级篇）](http://blog.csdn.net/andycpp/article/details/1327147)
* [在Eclipse中使用JUnit4进行单元测试（中级篇）](http://blog.csdn.net/andycpp/article/details/1327346)
* [在Eclipse中使用JUnit4进行单元测试（高级篇）](http://blog.csdn.net/andycpp/article/details/1329218)

