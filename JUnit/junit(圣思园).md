# 让项目集成junit
项目右键--->Properties--->Java Build Path--->libraries--->Add Library--->JUnit--->JUnit4--->finish。

建立source folder：test

在test包中，建立与目标类同样的包层次结构。在.java目录中，目标类和测试类是在不同文件夹下，而在.class编译好的目录下，目标类和测试类是在同一个文件夹下。

测试类的命名规则：我的类名+Test.java

在junit3.8中，测试类和测试方法必须满足：

* 必须继承TestCase类，初始化配置放在setUp()中，清理工作放在tearDown()中
* 测试方法必须是public、void、无方法参数、方法名必须以test开头

Test Case之间一定要保持完全的独立性，不允许出现任何的依赖关系。即测试方法A绝不应该依赖于测试方法B。

junit的测试方法执行顺序是不一定的，因此我们不能依赖于junit测试方法的执行顺序。

setUp()和tearDown()的执行时机是：在每一个测试用例方法执行之前，setUp()执行一次。在每一个测试用例方法执行之后，tearDown()执行一次。

error表示测试用例方法有运行时错误，测试无法进行下去。而Failures表示期望值与实际值不符合。

当执行到`Assert.fail();`则表明测试方法失败了failures。

```java
public void testDevideByZero() {
		
	int result = 0;
	try {
		result = cal.divide(6, 2);
	} catch (Exception e) {
		e.printStackTrace();
		Assert.fail();
	}
	Assert.assertEquals(3, result);
}
```

```java
//测试该方法是否会像预期的那样抛出异常。
public void testDevideByZero() {
	Throwable tx = null;
	try {
		cal.divide(6, 0);
		Assert.fail();
	} catch (Exception ex) {
		tx = ex;
	}
	Assert.assertEquals(Exception.class, tx.getClass());
	Assert.assertEquals("除数不能为0", tx.getMessage());
}
```

`Assert.fail()`一般放在你觉得程序不可能到达的地方。


```java
//测试目标方法
public int getLargest(int[] array) throws Exception {
	if(array==null || array.length==0) { //先判断null，再判断length=0
		throw new Exception("数组不能为空");
	}
	int max=array[0];
	for(int i=1;i<array.length;i++){
    	if(array[i]>max){
    		max=array[i];
    	}
	}
	return max;
}

public void testGetLargestNormal() {
	Throwable tx = null;
	int max = 0;
	try {
		int[] arr = {1,2,3,4,5};
		max = cal.getLargest(arr);
	} catch (Exception ex) {
		Assert.fail("测试失败");
	}
	Assert.assertEquals(5, max);
}
	
public void testGetLargestExceptionForLength0() {
	Throwable tx = null;
	int max = 0;
	try {
		int[] arr = {};
		max = cal.getLargest(arr);
		Assert.fail("测试失败");
	} catch (Exception ex) {
		tx = ex;
	}
	Assert.assertNotNull(tx);
	Assert.assertEquals(Exception.class, tx.getClass());
	Assert.assertEquals("数组不能为空", tx.getMessage());
}
	
public void testGetLargestExceptionForNull() {
	Throwable tx = null;
	int max = 0;
	try {
		int[] arr = null;
		max = cal.getLargest(arr);
		Assert.fail("测试失败");
	} catch (Exception ex) {
		tx = ex;
	}
	Assert.assertNotNull(tx);
	Assert.assertEquals(Exception.class, tx.getClass());
	Assert.assertEquals("数组不能为空", tx.getMessage());
}
```

```java
public class DeleteAll {
	public static void deleteAll(File file) {
		if(file.isFile() || file.list().length == 0) {
			file.delete();
		}
		else {
			File[] files = file.listFiles();
			for(File f: files) {
				deleteAll(f);
				f.delete();
			}
		}
	}
}

public class DeleteAllTest extends TestCase{
	public void testDeleteAll() {
		File file = new File("test.txt");
		try {
			file.createNewFile();
			DeleteAll.deleteAll(file);
		} catch (IOException e) {
			Assert.fail();
		}
		Assert.assertFalse(file.exists());
	}
	
	public void testDeleteAll2() {
		File dirctory = new File("dir");
		try {
			dirctory.mkdir();
			File file1 = new File(dirctory, "file1.txt");
			File file2 = new File(dirctory, "file2.txt");
			file1.createNewFile();
			file2.createNewFile();
			File d1 = new File(dirctory, "d1");
			File d2 = new File(dirctory, "d2");
			d1.mkdir();
			d2.mkdir();
			File subFile1 = new File(d1, "subFile1.txt");
			File subFile2 = new File(d1, "subFile2.txt");
			subFile1.createNewFile();
			subFile2.createNewFile();
			DeleteAll.deleteAll(dirctory);
			
		} catch (IOException e) {
			Assert.fail();
		} 
		Assert.assertNotNull(dirctory);
		String[] names = dirctory.list();
		Assert.assertEquals(0, names.length);
		dirctory.delete(); //做完一定要删掉，因为要保持和测试前的状态一致
		
	}
}
```

使用反射来测试私有方法：

```java
public class Calculator2 {
    private int add(int a, int b) {
        return a + b;
    }
}

public class Calculator2Test extends TestCase{
	public void testAdd() {
		Calculator2 cal = new Calculator2();
		Class<Calculator2> clazz = Calculator2.class;
		Method method = null;
		Object result = null;
		try {
			method = clazz.getDeclaredMethod("add", new Class[]{Integer.TYPE, Integer.TYPE});
			method.setAccessible(true);
			result = method.invoke(cal, new Object[]{2,3});
			
		} catch (Exception e) {
			Assert.fail("测试失败");
		}
		Assert.assertEquals(5, result);
	}
}
```

我们可以通过eclipse，直接为我们new创建几个Test类的模板。

自动化测试，点击一次测试，一次性运行多个测试类。这是通过test suite测试套件执行的。

```java
public class TestAll extends TestSuite{
	public static Test suite() {
		TestSuite suite = new TestSuite();
		suite.addTestSuite(CalculatorTest.class);
		suite.addTestSuite(Calculator2Test.class);
		suite.addTestSuite(DeleteAllTest.class);
		
		return suite;
	}
}
```

让某个测试用例方法执行N次，此时你需要为测试类提供带参数的构造函数：

```java
public class DeleteAllTest extends TestCase{
    //传入的参数是方法名称
	public DeleteAllTest(String name) {
		super(name);
	}

	public void testDeleteAll() {
		File file = new File("test.txt");
		try {
			file.createNewFile();
			DeleteAll.deleteAll(file);
		} catch (IOException e) {
			Assert.fail();
		}
		Assert.assertFalse(file.exists());
	}
}

public class TestAll extends TestSuite{
	public static Test suite() {
		TestSuite suite = new TestSuite();
		suite.addTest(new RepeatedTest(new DeleteAllTest("testDeleteAll"), 20)); //重复测试20次
		return suite;
	}
}
```

# junit4
junit4的测试类不需要继承TestCase。在一个测试类中，所有被@Test注解所修饰的public、void方法都是test case，都可以被junit4所执行。

建议junit4的测试类类名、方法名的命名规则保持与junit3一致。虽然junit4并不强制要求这么做。

@Before修饰的方法等价于junit3的setUp()。即每个test case执行之前都会调用before。
@After修饰的方法等价于junit3的tearDown()。

@BeforeClass和@AfterClass是全局的初始化和全局的销毁。他在测试类调用@Before之前、@After之后调用，并且只调用一次。另外，他们修改的方法必须是pulbic static void 无参数的方法。

```java
//timeout属性的用法，timeout的最大时间是500
@Test(timeout=500) 
public void testAdd() {
    //...
}

//expected属性的用法，期望抛出异常
@Test(expected=Exception.class)
public void testDivide() throws Exception {
    cal.divide(1,0);
}
```

@Ignore可以让测试类或者测试方法不参与测试运行。

@RunWith(Parameterized.class)可以实现参数化运行。
