# IO��6��ѧϰFile


## File���
File�����ڱ�ʾһ���ļ������ļ��С������õľ�̬��Ա�������Է��㿪���߻�ȡ��ƽ̨��ص�·���ָ�����File����ʹ�á�����·���������·��������ʾһ���ļ����ļ��С�����UNIX��˵��ʹ��`/`����ʾ����·����������Windows��˵��ʹ���̷�`D:`��ʾ����·������ֱ�����ļ������ƻ����ļ����ƿ�ͷ�����ʾ���·�������⣬File������ʵ�ֶ�File��access permisssion���ƣ����ļ��ķ���Ȩ�޿��ƣ��������File��������File��д�������������û�File�ɶ��� 

## ���׻����ĸ���
* abstract pathname�������·����Ҳ���ǹ���File����ʱ����ȥ��String·��ֵ���������Ǿ���·����Ҳ���������·��
* parent��Ҳ���ǳ������һ��Ŀ¼����ĸ�·��
* name��File��������ƣ�������·���������ļ���.�ļ���׺��
* prefix��name��ǰ׺��һ����.ǰ��Ĳ��֣�Ҳ�����ļ���
* suffix��name�ĺ�׺��һ����.����Ĳ��֣�Ҳ�����ļ���׺
* dictionary���ļ���
* absolute pathname������·��
* relative pathname�����·��

### ��б���뷴б��
* ��б����λ�ڴ��ں��ұߵİ���`/`
* ��б����λ�ڻس����Ϸ��İ���`\`

��Windows�з����ļ�Ŀ¼ʱ������ʹ����б�ܣ�Ҳ����ʹ�÷�б�ܣ�������������б�ܻ��ã�

```
d:/developer
d:\developer
d:/developer\maven
```

��Java�з���Windows���ļ�Ŀ¼������ʹ��һ����б��`\`������������б��`\\`��Ϊ�ָ�����������ΪJava��`\`��ʾת���ַ�����˱���ʹ��`\\`��ʾ"������б���ַ�"��

```java
File file = new File("d:/developer");
File file = new File("d:\\developer");
File file = new File("d:\\developer/maven");
```


##API����
### ��̬��Ա����
```java
//pathSeparator��·���ָ�����Winndows��·���ָ�����;�������·��֮����;���зָ���UNIX��·���ָ�����:
static String pathSeparator
static char pathSeparatorChar
//separator��һ��·��֮���еķָ�����Windows�ķָ�����\����parentFolder\childFolder��UNIX�ķָ�����/
static String separator
static char separatorChar
```

### ���캯��
```java
File(File parent, String child) 
File(String pathname) 
File(String parent, String child) 
File(URI uri)
```


### ����File
```java
//���ҽ����丸·�����ڣ��Ҹ��ļ������ڣ����ܳɹ������ļ�
boolean createNewFile()

//��Ĭ��·���´���һ����ʱ�ļ���Ĭ��·����System.getProperty("java.io.tmpdir");����
//prefix���ļ��������������ַ���suffix����չ��������jpg�����Ϊnull����Ĭ��Ϊ.tmp
//ǰ׺�ͺ�׺����󳤶�ȡ���ڵײ�Ĳ���ϵͳ���÷������Զ��Թ�����ǰ׺����׺���вü�����
static File createTempFile(String prefix, String suffix)

////���ض�·�����´���һ����ʱ�ļ����ض�·�������һ������������
static File createTempFile(String prefix, String suffix, File directory)

//�����ļ��У�ǰ���Ǳ�Ҫ�ĸ�Ŀ¼�������
boolean mkdir()

//�����ļ��У������Ŀ¼�����ڣ����Զ�������Ŀ¼����ʹ����ʧ�ܣ�֮ǰ�����Ĳ��ָ�Ŀ¼Ҳ�����
boolean mkdirs()
```


### �޸�File
```
//ɾ��file�����file��ʾ�ļ��У���ֻ���ļ���Ϊ��ʱ����ɾ��
boolean delete()

//��file���б�ǣ���JVM�����ر�ʱɾ������ǵ�file��ɾ����˳���뵱������ǵ�˳���෴
//������ļ��У���ֻ�е��ļ���Ϊ��ʱ���ܱ�ɾ�����������ǵ�file�Ѿ���ǰִ����delete()����������Ӱ��
//ֻ�е�JVM�����ر�ʱ���Ż�Ա�ǵ�fileɾ��
void deleteOnExit()

//�������Ͽ����ļ�������������ʵ�������ڲ�ͬ����ϵͳ���ǲ�һ���ġ�
//��Windows�µĲ��Խ���ǣ�����+�������Ĳ����������File���е�destĿ¼��Ȼ��������Ϊdest��Ӧ������
//����Windows��ֻ�ܶ��ļ�ִ��renameTo���������ܶ��ļ���ִ��renameTo������
boolean renameTo(File dest)
```


### ·��ʱ���
```java
//��ȡ��������Fileʱ�����·���������Ǿ���·����Ҳ���������·��
//File�Ĺ��캯����Ҫ����һ��abstractPath��Ϊ·��
String getPath()

//��ȡFile�ľ���·����
//���File�ɿմ����ɣ��򷵻�user.dirĿ¼
//���File�ɾ���·�����ɣ���ȼ��ڵ���getPath()�����File�����·�����ɣ��򷵻�File�ľ���·��
String getAbsolutePath()

//��ȡ����·�����ɵ�File���ȼ���new File(this.getAbsolutePath())
File getAbsoluteFile()

//��ȡһ��Ȩ����·����Ȩ��·���϶���һ������·�������Ҳ�ͬ�Ĳ���ϵͳ���·�����ַ�����һ���Ĵ���
//����������CanonicalPath��AbsolutePath��һ����
String getCanonicalPath()

//��ȡһ��Ȩ����·�����ȼ���new File(this.getCanonicalPath())
File getCanonicalFile()

//��ȡFile·�������һ�����ƣ����һ����Ч/����������ƣ�
String getName()

//��ȡFile�ĸ�·����Ҳ����File·���г���getName()֮���·��
String getParent()

//��ȡFile�ĸ�·�����ȼ���new File(this.getParent())
File getParentFile()

//�ж��ǲ��Ǿ���·��
//UNIX�ľ���·����/��ͷ����Windows�ľ���·�����̷���ͷ
boolean isAbsolute()

//תΪURI��ʽ
URI toURI()

//��д��toString�������ײ������getPath()����
String toString()
```


### ��ȡFile������Ϣ
```java
//��ȡ����޸�ʱ��
long lastModified()

//��ȡFile�Ĵ�С����λ��byte��
long length()

//�г�FileĿ¼�����е�subFile����
//���File���ļ����򷵻�null�����File���ļ��У��򷵻��ļ���������subFile������
//����ֵString[]������ġ��÷���Ҳ������еݹ��ѯ����ֻ���ѯ��һ�㡣��Windowsƽ̨�³��Թ��������ļ�Ҳͬ�������ء�
String[] list()

//�г�FileĿ¼�����е�subFile������File����װ���ײ㱾�����ǵ�����list()������
//���File�Ǿ���·������ģ���subFileҲ�Ǿ���·������ġ����File�����·������ģ���subFileҲ�����·�������

//�г�FileĿ¼�з��Ϲ����subFile����
//���ܺ�list()����һ�����ײ�Ҳ���ȵ���list()������Ȼ�������Ԫ���������filter.accept()�����ж�subFile�Ƿ����Ҫ��
String[] list(FilenameFilter filter)

//�г�FileĿ¼�з��Ϲ����subFile����
//���ܺ�String[] list(FilenameFilter filter)һ�������Ƕ�����н�һ����װ����
File[] listFiles(FilenameFilter filter)

//�г����е��̷�������Windows�¾ͻ��г���C:\��D:\��E:\��F:\
static File[] listRoots()
```


### File�ж�
```java
//�Ա�File·�����ײ�ʵ����ʹ��compareTo(File pathname)�������жԱ��ж�
boolean equals(Object obj)

//�Ա�File��·����UNIX��Сд���У�Windows��Сд������
int compareTo(File pathname)

//�ж�File�Ƿ����
boolean exists()

//�ж��ǲ����ļ���
boolean isDirectory()

//�ж��ǲ����ļ�
boolean isFile()

//�ж�File�ǲ������ص�
//UNIX�������ļ���.��ͷ����Windows�������ļ�ͨ���������
boolean isHidden()
```


### ���ʿ���(access permission)
```java
boolean canExecute() //��ִ��
boolean canRead() //�ɶ�
boolean canWrite() //��д
boolean setExecutable(boolean executable) 
boolean setExecutable(boolean executable, boolean ownerOnly)
boolean setReadable(boolean readable)
boolean setReadable(boolean readable, boolean ownerOnly)
boolean setWritable(boolean writable) 
boolean setReadable(boolean readable, boolean ownerOnly)

//����Ϊֻ������ֻ��File�Ƿ��ɾ���ɵײ����ϵͳ����
boolean setReadOnly()
```

### ��ȡ�ռ���Ϣ
```java
//���Եػ�ȡ�ܿռ䣨��λ��byte��
long getTotalSpace()

//���Եػ�ȡ���ÿռ䣨��λ��byte��
 long getUsableSpace()
 
//���Եػ�ȡFileʣ����ÿռ��С����λ��byte�������ÿռ��Сֻ�Ǵ��ԵĹ��㣬�����Ǿ�ȷֵ
long getFreeSpace()
```


