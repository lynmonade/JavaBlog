# 第二章 IOC的基本概念

## 核心理念

我们只需要与原先的对象绑定方式进行对比，就能明白IOC的核心思想：通过配置文件/注解，描述所依赖的对象，IOC会在对象使用之前自动完成对象注入。

**原始的方式**

```java
public class FXNewsProvider {
    //写死，绑定死了，不好
	private IFXNewsListener newsListener = new DowJonesNewsListener();
	private IFXNewsPersister newPersistener = new DowJonesNewsPersister();
}
```

**IOC的方式**

```java
public class FXNewsProvider {
	private IFXNewsListener newsListener;
	private IFXNewsPersister newPersistener;
	//getter/setter
}

/*
xml配置文件
给newsListener注入XXX对象
给newsPersister注入YYY对象
*/
```

## 三种注入方式

* 构造函数：太麻烦
* 接口注入：需要实现特定接口，已淘汰
* setter注入：只需给成员变量提供getter/setter方法即可，推荐使用

## IOC的附加好处

* 更方便的更换所绑定的对象（只需修改配置文件，不用动源码）
* 便于TDD测试

# 第三章 掌控大局的IOC Service Provider

IOC只是提出了一种思想，但具体还是需要IOC Service Provider来实现。Spring就是一个IOC Service Provider。IOC Service Provider主要有两个职责：

* 业务对象的构建管理。包括对象的创建、生命周期管理、作用域管理、销毁等。
* 业务对象间的依赖绑定：识别所依赖关系，并完成依赖对象的注入。

IOS SP可以通过如下几种方式完成上面两项工作：

* 直接编码方式：即注册+反射
* 通过xml配置文件描述这样的关系。然后再通过反射注入
* 注解方式（本质上来说也是编码方式）

# 第四、五、六章节

SpringIOC是IOC SP规范的超集，SpringIOC不仅实现了上一章提到IOC SP的职责，还提供了额外的服务：

![](http://wx2.sinaimg.cn/mw690/0065Y1avgy1ffzqvd1q2mj30dg08m3z6.jpg)

## Spring的两个IOC容器

**（1）BeanFactory**：基础类型的IOC容器，实现了IOC SP所规定的两个职责。默认采用延迟初始化策略（用到时才初始化并注入对象）。适合资源有限的项目。

**（2）ApplicationContext**：ApplicationContext在BeanFactory的基础上构建（间接继承了BeanFactory），除了拥有BeanFactory的所有支持，还具备其他高级特性：事件发布、国际化等。默认在容器启动时自动完成初始化和绑定。常用于大项目。

最初我们都直接在main入口中显式的new创建对象，然后绑定到变量上。有了Bean Factory之后，我们无需显式地new创建对象了，但创建的对象的工作还是得有人来做，具体就是由BeanFactory来做，我们只需把**生产线图纸（即xml配置文件）**交给BeanFactory即可。

**从4.2一直到第六章全面讲解了IOC的xml方式的配置和注解方式的配置。**

## 使用BeanFactory

```java
//POJO定义
public interface IFXListener {}
public interface IFXPersister {}

public class BBFXListener implements IFXListener{
	public BBFXListener() {
		super();
		System.out.println("BBFXListener 初始化");
	}
}
public class BBFXPersister implements IFXPersister{
	public BBFXPersister() {
		super();
		System.out.println("BBFXPersister 初始化");
	}
}
public class AAFXProvider {
	private IFXListener listener;
	private IFXPersister persister;
	//省略getter/setter
	public String toString() {
		return "listener="+listener+",persister="+persister;
	}	
}

//Main函数
public class Main {
	public static void main(String[] args) {
		DefaultListableBeanFactory beanRegistry = new DefaultListableBeanFactory();
		BeanFactory container = (BeanFactory)bindViaCode(beanRegistry);
		AAFXProvider newProvider = (AAFXProvider)container.getBean("aaFXProvider");
		System.out.println(newProvider);
	}
	
	public static BeanFactory bindViaCode(BeanDefinitionRegistry registry) {
		AbstractBeanDefinition newProvider = new RootBeanDefinition(AAFXProvider.class, true);
		AbstractBeanDefinition newListener = new RootBeanDefinition(AAFXListener.class, true);
		AbstractBeanDefinition newPersister = new RootBeanDefinition(AAFXPersister.class, true);
		
		//将bean定义注册到容器中
		registry.registerBeanDefinition("aaFXProvider", newProvider);
		registry.registerBeanDefinition("aaFXListener", newListener);
		registry.registerBeanDefinition("aaFXPersister", newPersister);
		
		//setter注入
		MutablePropertyValues propertyValues = new MutablePropertyValues();
		propertyValues.addPropertyValue("listener", newListener);
		propertyValues.addPropertyValue("persister", newPersister);
		newProvider.setPropertyValues(propertyValues);
		
		//绑定完成
		return  (BeanFactory)registry;
	}
}

```

## 使用XML的方式

```java
//applicationContext.xml 放在src目录下
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:context="http://www.springframework.org/schema/context"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:mongo="http://www.springframework.org/schema/data/mongo"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
        http://www.springframework.org/schema/beans/spring-beans.xsd
         http://www.springframework.org/schema/data/mongo   
          http://www.springframework.org/schema/data/mongo/spring-mongo-1.0.xsd    
         http://www.springframework.org/schema/context  
        http://www.springframework.org/schema/context/spring-context-3.0.xsd
        ">
	
	<bean id="aaFXProvider" class="com.impl.AAFXProvider">
		<property name="listener">
			<ref bean="aaFXListener"/>
		</property>
		<property name="persister">
			<ref bean="aaFXPersister"/>
		</property>
	</bean>
	<!-- 成员变量的定义顺序在前在后都没问题 -->
	<bean id="aaFXListener" class="com.impl.AAFXListener" />
	<bean id="aaFXPersister" class="com.impl.AAFXPersister" />
</beans>

//Main.java
public class Main {
	public static void main(String[] args) {
		DefaultListableBeanFactory beanRegistry = new DefaultListableBeanFactory();
		BeanFactory container = (BeanFactory)bindViaXMLFile(beanRegistry);
		AAFXProvider newProvider = (AAFXProvider)container.getBean("aaFXProvider");
		System.out.println(newProvider);
	}
	
	public static BeanFactory bindViaXMLFile(BeanDefinitionRegistry registry) {
		XmlBeanDefinitionReader reader = new XmlBeanDefinitionReader(registry);
		reader.loadBeanDefinitions("applicationContext.xml");
		return (BeanFactory)registry;
	}
}
```

## 使用注解的方式

主要思路包括

* 对POJO类添加注解
* 在xml中配置自动扫描auto-scan

```java
//POJO
@Component
public class AAFXProvider {
	@Autowired
	private IFXListener listener;
	@Autowired
	private IFXPersister persister;
	//省略getter/setter
	public String toString() {
		return "listener="+listener+",persister="+persister;
	}	
}

@Component
public class AAFXListener implements IFXListener{
	public AAFXListener() {
		super();
		System.out.println("AAFXListener 初始化");
	}
}

@Component
public class AAFXPersister implements IFXPersister{
	public AAFXPersister() {
		super();
		System.out.println("AAFXPersister 初始化");
	}
}

//applicationContext.xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:context="http://www.springframework.org/schema/context"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:mongo="http://www.springframework.org/schema/data/mongo"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
        http://www.springframework.org/schema/beans/spring-beans.xsd
         http://www.springframework.org/schema/data/mongo   
          http://www.springframework.org/schema/data/mongo/spring-mongo-1.0.xsd    
         http://www.springframework.org/schema/context  
        http://www.springframework.org/schema/context/spring-context-3.0.xsd
        ">
	
	<context:component-scan base-package="com.impl" />
</beans>

//Main.java
public class Main {
	public static void main(String[] args) {
		ApplicationContext ctx = new ClassPathXmlApplicationContext("applicationContext.xml");
		AAFXProvider newProvider = (AAFXProvider)ctx.getBean("AAFXProvider");
		System.out.println(newProvider.toString());
	}
}
```

## XML配置详解

### beans标签

这是最外层的标签，用于定义一些全局信息，比如遵循哪些xsd声明。beans的属性包括：

**（1）xmlns声明、xmlns:schemaLocation的声明。这个需要认真学习，因为你用到的Spring组件都要引入对应的声明。**

**（2）default-autowire：设置全局的自动绑定方式，可选值为no、byName、byType、constructor、autodetect。默认值为no。**

（3）default-dependency-check。设置是否做依赖检查。默认为不做。

（4）default-init-method：没啥用

（5）default-destroy-method：没啥用

### beans的子标签：<description>

用来写一些描述性的信息，没啥用

### beans的子标签：<import>

引入多个配置Spring的配置文件，没啥用

### beans的子标签：<alias>

用来给bean起外号，没啥用

### beans的子标签：<bean>非常有用！

<bean>标签是定义bean的地方，非常有用，主要有如下属性需要配置：

```xml
<!-- 常见的定义方式 -->
<bean id="aaFXProvider" class="com.impl.AAFXProvider" />
```

**（1）id属性（有用）：bean的唯一标识符，这样才能再其他地方引用这个bean**。

（2）**class属性（有用）：用于配置class路径，有用**

（3）name属性：用于配置别名，作用与alias一样，没啥用

（4）depends-on属性：涉及静态代码块时才会用，没啥用

**（5）autowire属性（有用）：**设置绑定方式，可选值为no、byName、byType、constructor、autodetect。默认值为no。no表示不使用自动绑定，byName是按名称绑定（setter注入），byType是按类型绑定（setter注入），constructor是用构造函数绑定。autodetect的方式是：如果只有空构造函数，则先用byType，否则用contructor。**如果要用自动绑定的话，建议用byName或者byType。另外，**

**书中说，Spring2.5.6版本的自动绑定只能应用于原生类型、String类型、Class类型以外的对象类型。**

（6）depandency-check属性：绑定关系的校验，没啥用

（7）lazy-init属性：是否延迟初始化，ApplicationContext默认是在容器启动时就初始化所有的bean，这样的好处是能在启动时就检查是否有错误。建议保持对IOC容器的默认值。

（8）parent属性：实现bean的继承，没啥用

### bean的子标签：<property>标签：setter注入

setter注入需要先定义好所涉及的所有bean，包括root bean和成员变量bean，然后通过<property>标签设置关联关系。

```xml
<bean id="aaFXProvider" class="com.impl.AAFXProvider">
	<property name="listener" ref="aaFXListener" />
	<property name="persister" ref="aaFXPersister" />
	<property name="str" value="StringValue" />
	<property name="number" value="999" />
</bean>
```

#### 关联普通类型

如果要关联的成员变量是String类型、普通数据类型、以及对应的包装类，则可以使用<value>标签或value属性来引用：

```xml
<bean id="aaFXProvider" class="com.impl.AAFXProvider">
	<property name="str">
		<value>StringValue</value> <!-- 标签形式 -->
	</property>
	<property name="number" value="999" /> <!-- 属性形式 -->
</bean>

<!--注入空串-->
<property name="str">
  	<value></value>
</property>
```

#### 关联对象类型

用<ref>标签来关联对象，其属性包括local、parent、bean，**基本上只有bean属性有用**。

```xml
<bean id="aaFXProvider" class="com.impl.AAFXProvider">
	<!-- 下面两种方式 等价 -->
	<property name="listener" ref="aaFXListener" />
	<property name="persister">
		<ref bean="aaFXPersister" />
	</property>
</bean>
```

#### 内部bean

如果你确定BeanB只会在BeanA中引用，那么可以直接把BeanB定义在BeanA的<property>中。在下例中，aaFXListener、aaFXPersister只能被aaFXProvider所引用。

```xml
<bean id="aaFXProvider" class="com.impl.AAFXProvider">
	<property name="listener">
		<bean id="aaFXListener" class="com.impl.AAFXListener" />
	</property>
	<property name="persister">
		<bean id="aaFXPersister" class="com.impl.AAFXPersister" />
	</property>
</bean>
```

#### 关联list类型和数组类型

必须依靠<list>标签的帮助

```xml
public class MyContainer {
	private List objectList;
	private String[] stringArray;
	//省略getter/setter
}

<bean id="myContainer" class="com.impl.MyContainer">
	<property name="objectList">
		<list>
			<value>myValue</value>
			<ref bean="aaFXPersister" />
		</list>
	</property>
	<property name="stringArray">
		<list>
			<value>str1</value>
			<value>str2</value>
		</list>
	</property>
</bean>
<!-- 成员变量的定义顺序在前在后都没问题 -->
<bean id="aaFXPersister" class="com.impl.AAFXPersister" />
<bean id="aaFXListener" class="com.impl.AAFXListener" />
</beans>
```

#### 关联set类型

必须依靠<set>标签的帮助。

```xml
public class MyContainer {
	private Set objectList;
	//省略getter/setter
}

<bean id="myContainer" class="com.impl.MyContainer">
	<property name="objectList">
		<set>
			<value>myValue</value>
			<ref bean="aaFXPersister" />
		</set>
	</property>
</bean>
```

#### 关联map类型

```xml
public class MyContainer {
	private Map objectMap;
	//省略getter和setter
}
<bean id="myContainer" class="com.impl.MyContainer">
	<property name="objectMap">
		<map>
			<!-- 普通类型 -->
			<entry key="key1">
				<value>StringValue</value>
			</entry>
			<!-- 对象类型-->
			<entry key="key2">
				<ref bean="aaFXPersister" />
			</entry>
		</map>
	</property>
</bean>
<bean id="aaFXPersister" class="com.impl.AAFXPersister" />
```

#### 注入null值

```xml
<bean id="myContainer" class="com.impl.MyContainer">
	<property name="objectMap">
		<null/>
	</property>
</bean>

//等价于
public class MyContainer {
	private Map objectMap = null;
	//省略getter/setter
}
```

### bean的作用域（个数）

bean的作用域主要关注两个方面的问题：

* bean在容器中的个数：单个还是多个
* bean的声明周期：什么时候被销毁

**（1）singleton。**：它表示这个bean在容器中永远只存在一份实例，其生命周期与IOC容器的生命周期相同。这与单例比较类似。tsingleton也是Spring的默认方式。下面的三种定义方式的效果是一样的：

```xml
<!-- DTD or XSD -->
<bean id="obj1" class="...." />
<!-- DTD -->
<bean id="obj1" class="...." singleton="true"/>
<!-- XSD -->
<bean id="obj1" class="...." scope="singleton"/>
```

**（2）prototype：**每次向容器请求该bean时，容器都会为我们创建一个新的bean对象。此后，IOC容器变不再负责该bean的声明周期，而是由请求方负责bean的销毁。因此对于有状态类型的bean，比如model对象，就必须用prototype类型。定义方式如下：

```xml
<!-- DTD -->
<bean id="obj1" class="..." singleton="false" />
<!-- XSD -->
<bean id="obj1" class="..." scope="prototype" />
```

**（3）request：**用于web应用，效果与prototype类似，会存在多个对象。其生命周期类似于HttpRequest。

```xml
<bean id="requestProcessor" class="..." scope="request" />
```

**（4）session：**用于web应用，效果与prototype类似，会存在多个对象。其生命周期类似于HttpSession。

```
<bean id="userPreferences" class="..." scope="session" />
```

（5）global session：没啥用

### 工厂方法与FactoryBean

目前的做法是像下图所示那样，你会直接从IOC容器中获取对象，关联信息都写在xml配置文件中。如果以后创建创建对象的方式改变了，你的配置文件也要跟着变。

![](http://wx1.sinaimg.cn/mw690/0065Y1avgy1fg270faq57j30k3037dgp.jpg)

```java
public class Foo {
	private BarInterface barInterface;
	public Foo() {
		//旧的做法，应噶避免这么做
		barInterface = new BarInterfaceImpl();
	}
}
```

新的做法是，IOC容器允许我们再隔离多一层，这样未来遇到变化时，你的代码无需变动，只需修改工厂方法。

![](http://wx4.sinaimg.cn/mw690/0065Y1avgy1fg272i8s47j30ta03775m.jpg)

```java
public class Foo {
	private BarInterface barInterface;
	public Foo() {
		//barInterface = BarInterfaceFactory.getInstace();
		//或者
		//barInterface = new BarInterfaceFactory().getInstance();
	}
}

public class BarInterfaceFactory {
	public static BarInterface getInstance(Foobar foobar) {
		return new BarInterfaceImpl(foobar);
	}
}

<bean id="foo" class="....Foo">
	<property name="barInterface" ref="bar">
	</property>
</bean>
<bean id="bar" class="....BarInterfaceFactory" factory-method="getInstance">
	<constructor-arg>
  		<ref bean="foobar" />
  	</constructor-arg>
</bean>
<bean id="foobar" class="...FooBar" />
```

### 注解方式

（1）@Component：用于POJO类

（2）@Repository：用于DAO层的实现类

（3）@Service：用于Service层的实现类

（4）@Controller：用于Controller层的实现类

（5）@Autowired：自动绑定与注入，用来修饰成员变量

（6）@Qualifier：如果容器中有一个以上匹配的Bean，则需要使用这个注解实现精确匹配。

```
@Service
public class LoginService {
	@Autowired
	private LoginDao loginDao
	
	@Autowired
	@Qualifier("userDao")
	private UserDao userDao;
}
```

（7）@Scope：设置bean的作用域。

```
@Scope("prototype")
@Component
public class Car {
....
}
```

### 自动扫描

```xml
<context:component-scan base-package="com.impl" />
```

### 经验

建议采用**基于XML配置+基于注解配置的方式进行开发。**对于第三方库，比如要引入第三方ORM框架MyBatis，则在XML中配置，对于自己开发的实现类，比如你自己写的POJO、Controller、Service、Dao，则采用注解的方式。





