# Introduction 2 多线程程序的评量标准

* 安全性：不损坏对象，即不要出现同时两个线程操作存款。
* 生存性：不要出现死锁、不工作的情况。
* 复用性
* 性能

安全性和生存性一定要满足，复用性和性能尽量满足。

thread-safe表示线程安全。Vector类就是线程安全的类。而ArrayList不是线程安全的类，但只要有做适当的共享互斥，还是可以放心使用，这种情况也称为thread-compatible（线程兼容 ）。

# 第1章 Single Threaded Execution(STE)

## 例子1：不使用STE

这是一个人通过门的例子，这里会统计通过门的人数，如果人名的首字母与国籍的首字母不一致，则打印出该人。

```java
//Gate类，表示门
public class Gate {
	private int counter = 0;
	private String name = "Nobody";
	private String address = "Nowhere";
	
	public void pass(String name, String address) {
		this.counter++;
		this.name = name;
		this.address = address;
		check();
	}
	
	public String toString() {
		return "No." + counter + ":" + name + "," + address;
	}
	
	public void check() {
		if(name.charAt(0)!=address.charAt(0)) {
			System.out.println("******BROKEN******"+toString());
		}
	}
}

//UserThread类，表示人
public class UserThread extends Thread{
	private final Gate gate;
	private final String name;
	private final String address;
	
	public UserThread(Gate gate, String name, String address) {
		this.gate = gate;
		this.name = name;
		this.address = address;
	}
	
	public void run() {
		System.out.println(name + " BEGIN");
		while(true) {
			gate.pass(name, address);
		}
	}
}

//客户端测试
public static void main(String[] args) {
	System.out.println("TESTING GATE........");
	Gate gate = new Gate();
	new UserThread(gate, "Alice", "America").start();
	new UserThread(gate, "Bobby", "Brazil").start();
	new UserThread(gate, "Chris", "Canada").start();
}
```

从执行结果来看可以发现几个问题：

* 当执行了100W次以后，才会出现BROKEN的问题，也就是说，如果我们循环执行几万次的话，很可能就无法重新这个问题。
* 即使人名首字母和国籍首字母一致，还是会出现BROKEN，这就是不使用STE的后果。

原因大概分析下：因为gate只有一份实例，而UserThread有三个实例，gate是UserThread的成员变量，三个UserThread共用一个gate。当三个线程启动后，他们都有机会调用`gate.pass()`，甚至是同时调用。这就会出现Alice调用gate.pass()赋值gate.name属性后，下一帧Bobby又调用gate.pass()赋值gate.address属性，**即pass()方法可以被多个线程穿插执行。**因为gate实例永远只有一份，因此三个线程间接调用gate实例的方法，就会破坏gate对象的属性。

## 例子2：使用STE改造上例

```java
//修改gate.pass()和gate.toString()方法，用synchronized关键字修改这两个方法，这样就永远不会BROKEN了
public class Gate {
	private int counter = 0;
	private String name = "Nobody";
	private String address = "Nowhere";
	
	public synchronized void pass(String name, String address) {
		this.counter++;
		this.name = name;
		this.address = address;
		check();
	}
	
	public synchronized String toString() {
		return "No." + counter + ":" + name + "," + address;
	}
	
	public void check() {
		if(name.charAt(0)!=address.charAt(0)) {
			System.out.println("******BROKEN******"+toString());
		}
	}
}
```

