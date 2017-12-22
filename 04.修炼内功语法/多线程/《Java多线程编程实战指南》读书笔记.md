# 问题列表

**你要解决的终极问题是什么？**

如何使用并发甚至是并行，最大限度地利用多核CPU提高程序运行效率。

**编程语言如何实现并发？**

使用多线程技术。并发是业务需求目标（做什么），而多线程则是具体的实现办法（怎么做）。

**多线程编程的目标是什么？**

将任务的处理方式由串行改为并发。

**多线程编程会带来哪些问题？**

多线程编程实现了并发，但在使用多线程编程时，会引起别的问题，比如竞争，资源冲突。

**如何解决多线程所带来的问题？**

解决办法很多，但都需要对症下药，并且下药的同时也有可能带来其他副作用。

# chapter1

> 多线程有什么好熟悉的，只是一个过度定型的模式。
> 多线程要解决的问题说到底只有一个，如何并发，包括共享资源和最大化利用资源两种。而并发本身是真实世界的本原，也是事物/问题可以通过细分独立再关联成为一个整体的固有特性。
> 在计算中模拟并发的基本手段是调度，而多线程就是抢占式调度模式在编程语言下的具体特征。这么说你就知道多线程本身是怎么回事。
> 至于其他问题，都是源于并发自身，就是如何高效的同步，如何访问共享资源不发生冲突，如何解决共享资源的释放或者叫所有权问题，以及避免使用一些手段解决这些问题时可能导致的一些其他问题，比如死锁等等。
> 总之，困难的是并发本身，而不是什么多线程，虽然目前的编程模式都过度的甚至是错误的把前者嫁接在后者之上。
>
> --来自知乎回答

## 目标

我们实际上要解决的问题是：**如何并发？因为冰河可以最大限度地利用多核CPU提高程序运行效率**。

## 多线程

**多线程是编程语言模拟（实现）并发的手段。**虽然多线程编程能实现并发，但其实现过程中会带来一些问题，资源访问冲突，竞争等，虽然可以使用一些手段解决这些问题，但也可能导致其他问题，比如死锁。

## Java使用两种方式创建线程

（1）直接重写Thread类的run()方法。

```java
public class WelcomeApp {
	public static void main(String[] args) {
		Thread welcomeThread = new WelcomeThread();
		welcomeThread.start();
		System.out.printf("1. Welcome! i m %s.%n", Thread.currentThread().getName());
	}
	
}

class WelcomeThread extends Thread {
	@Override
	public void run() {
		System.out.printf("2.Welcome! i m %s.%n", Thread.currentThread().getName());
	}
}
```

（2）实现Runnable接口，并作为成员变量初始化Thread类。

```java
public class WelcomeApp1 {
	public static void main(String[] args) {
		Thread welcomeThread = new Thread(new WelcomeTask());
		welcomeThread.start();
		System.out.printf("1. Welcome! i m %s.%n", Thread.currentThread().getName());
	}
}

class WelcomeTask implements Runnable {
	@Override
	public void run() {
		System.out.printf("2.Welcome! i'm %s.%n", Thread.currentThread().getName());
	}
}
```

## 优先级属性

一般不需要显式的设置优先级，使用默认优先级即可。不恰当地设置优先级可能会导致线程饥饿的问题。

## 用户线程和守护线程

用户线程会组织java虚拟机正常停止，因此java虚拟机只有在所有用户线程都运行结束的情况下才能正常停止。

守护线程不会影响java虚拟机的正常停止，即应用程序中有守护线程在运行也不影响java虚拟机的正常停止。因此守护线程通常用于执行一些重要性不是很高的任务。例如用于监视其他线程的运行情况。

## 简易倒计时器的例子

```java
public class SimpleTimer {
	private static int count;
	public static void main(String[] args) {
		count = args.length>=1?Integer.valueOf(args[0]):60;
		int remaining;
		while(true) {
			remaining = countDown();
			if(0==remaining) {
				break;
			} else {
				System.out.println("Remaining " + count +"second(s)");
			}
			try {
				Thread.sleep(1000);
			} catch (Exception e) {
			}
		}
		System.out.println("Done.");
	}
	
	private static int countDown() {
		return count--;
	}
}
```

## 线程的层次关系-父子关系

假设线程A所执行的代码创建了线程B，那么称线程B为线程A的子线程，线程A是编程B的父线程。JVM负责创建main线程（主线程），因此所有用户线程都是主线程的子线程。

默认情况下，如果父线程是守护线程，则子线程也是守护线程。如果福线程是用户线程，则子线程也是用户线程。

父-子线程的生命周期并没有必然关系，父线程运行结束后，子线程可以继续运行，子线程运行结束后也不妨碍其父线程继续运行。

## 工作者线程/后台线程

比如tomcat里专门对get/post请求进行处理的线程就是tomcat的工作者线程，JVM中对内存进行回收的线程成为GC工作者线程。

## 线程的生命周期状态

图很复杂，需要多看多理解。

* NEW：start()调用之前的状态。一个线程只可能有一次处于该状态。因为只能start一次。
* RUNNABLE
* BLOCKED
* WATING
* TIMED_WATING
* TERMINATED：已经执行借宿的线程处于该状态，一个线程只可能又一次处于该状态，Thread.run()正常返回或者由于排除异常而提前终止都会导致相应线程处于该状态。

## 线程监视-可视化

* jvisualvm：适合开发和测试使用
* JMC：功能更强大

## 多线程编程的有点和缺点

优点就不说，缺点包括：

* 线程安全问题：多个线程共享数据的时候，多线程如果没有采取相应的并发访问控制措施，name就可能产生数据一致性问题，如读取脏数据（过期额数据），丢失更新（某些线程所做的更新被其他线程所做的更新覆盖）等。
* 线程活性问题，带来线程饥饿问题，导致某些线程永远无法获取CPU执行的机会而永远处于RUNNABLE状态的READY子状态。
* 上下文切换：单个CPU从执行一个线程专项执行另一个线程的时候，操作系统需要执行“上下文切换”。
* 可靠性：线程毕竟依赖于进程的资源，如果进程本身都挂了，那再多的线程也没法保证高可靠，这时起多个进程更靠谱（tomcat集群）。

# chapter2

## 串行-并发-并行

串行：投入1个人。1个人按顺序执行三件事。

并发：投入1个人。1个人执行事情A，并在事情A的等待时间内执行事情B，最后在B的等待时间内执行事情C。

并行：投入3个人。没人负责一件事。3个人统一是开始齐头并进地完成这些事情。

