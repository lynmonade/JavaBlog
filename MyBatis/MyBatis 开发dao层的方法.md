# MyBatis 开发dao层的方法

## 原始的做法

### 第一步：声明dao层的接口

```java
public interface DeptDao {
	public Dept findDeptByName(String name);
	public List<Dept> findDeptLikeName(String name);
}
```

### 第二步：dao层实现类

```java
public class DeptDaoImpl implements DeptDao{
	private SqlSessionFactory sqlSessionFactory;
	
	public DeptDaoImpl(SqlSessionFactory sqlSessionFactory) {
		super();
		this.sqlSessionFactory = sqlSessionFactory;
	}

	@Override
	public Dept findDeptByName(String name) {
		SqlSession sqlSession = sqlSessionFactory.openSession();
		Dept dept = sqlSession.selectOne("findDeptByName", "南宁供电局");
		sqlSession.close();
		return dept;
	}

	@Override
	public List<Dept> findDeptLikeName(String name) {
		SqlSession sqlSession = sqlSessionFactory.openSession();
		List<Dept> list = sqlSession.selectList("findDeptLikeName", "%"+name+"%");
		sqlSession.close();
		return list;
	}
}
```

### 第三步：service层

```java
public class DeptServiceImpl {
	private SqlSessionFactory sqlSessionFactory;

	public static void main(String[] args) {
		DeptServiceImpl service = new DeptServiceImpl();
		service.initMyBatis();
		//service.findDeptByName();
		service.findDeptLikeName();
	}
	
	public void initMyBatis() {
		String resource = "mybatis-config.xml";
		try {
			InputStream inputStream = Resources.getResourceAsStream(resource);
			sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	public void findDeptByName() {
		DeptDao dao = new DeptDaoImpl(sqlSessionFactory);
		Dept dept = dao.findDeptByName("南宁供电局");
		System.out.println(dept);
	}
	
	public void findDeptLikeName() {
		DeptDao dao = new DeptDaoImpl(sqlSessionFactory);
		List<Dept> list = dao.findDeptLikeName("供电局");
		System.out.println(list);
	}
}
```

## 分析

1. dao接口实现类方法中存在大量模板方法，设想能否将这些代码提取出来，大大减轻程序员的工作量。
2. 调用sqlsession方法时将statement的id硬编码了
3. 调用sqlsession方法时传入的变量，由于sqlsession方法使用泛型，即使变量类型传入错误，在编译阶段也不报错，不利于程序员开发。

## 新的做法：编写mapper接口

### 第一步：修改mapper.xml的namespace属性

namespace的值为Mapper接口的完整路径。

```xml
<mapper namespace="com.dao.DeptMapper">
...
...
</mapper>
```

### 第二步：创建mapper接口

此时你只需要一个mapper接口，不需要再创建烦人的dao接口和dao实现类了。

```java
public interface DeptMapper {
	public Dept findDeptByName(String name);
	public List<Dept> findDeptLikeName(String name);
}
```

### 第三步：service层这么写

```java
public class DeptServiceImpl {
	private SqlSessionFactory sqlSessionFactory;

	public static void main(String[] args) {
		DeptServiceImpl service = new DeptServiceImpl();
		service.initMyBatis();
		service.findDeptByName();
		//service.findDeptLikeName();
	}
	
	public void initMyBatis() {
		String resource = "mybatis-config.xml";
		try {
			InputStream inputStream = Resources.getResourceAsStream(resource);
			sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	public void findDeptByName() {
		SqlSession sqlSession = sqlSessionFactory.openSession();
		DeptMapper deptMapper = sqlSession.getMapper(DeptMapper.class);
		Dept dept = deptMapper.findDeptByName("南宁供电局");
		System.out.println(dept);
	}
	
	public void findDeptLikeName() {
		SqlSession sqlSession = sqlSessionFactory.openSession();
		DeptMapper deptMapper = sqlSession.getMapper(DeptMapper.class);
		List<Dept> list = deptMapper.findDeptLikeName("%供电局%");
		System.out.println(list);
	}
}
```

**此时，Mapper接口就充当了我们的dao接口，MyBatis会自动根据接口创建dao层的实现类。当我们使用Mapper来访问数据库时，本质上还是使用SqlSession来做操作。**





