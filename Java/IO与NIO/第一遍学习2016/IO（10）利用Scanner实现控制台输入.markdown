# IO��10������Scannerʵ�ֿ���̨����
Scanner����Ҫ���ڼ��ı�ɨ�裬����ĳ������ǻ�ȡ����̨�������Ϣ��

## ��ȡ����̨����
```java
public static void main(String[] args) throws Exception {
	Scanner in = new Scanner(System.in); //System.in��ʾ����ԴΪ����̨
	System.out.println("how old are u?");
	String input = in.nextLine(); //�ӿ���̨��ȡ�û��������Ϣ
	System.out.println(input); //��ӡ������
}
```

## ���캯����ɨ�跽��
Scannerӵ�ж�����캯�������Խ��ܶ�������Դ����������Դ�����ݽ���ɨ�衣Scanner�ķ���Ҳ�ǳ��֧࣬�ֶ��ֻ�����ɨ�裬��������������ʽ����ɨ�衣�Ƚϳ��õķ����У�

```java
//�ж�����Դ���Ƿ���������Ҫ���
boolean hasNext()

//�ж�����Դ�Ƿ�����һ������
boolean hasNextLine()

//������һ�����ݣ�Ĭ���Կո���Ϊ�ָ���
String next()

//������һ������
String nextLine()
```

## References
* [java.util.ScannerӦ�����](http://lavasoft.blog.51cto.com/62575/182467/)