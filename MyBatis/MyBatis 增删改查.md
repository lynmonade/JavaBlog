# MyBatis 增删改查

## 输入对象的映射

如果查询需要接收多个参数，则可以把多个参数封装为对象，在mapper.xml文件中使用parameterType属性引用该对象。

```java
//POJO对象（用于封装参数）
public class Dlscqk {
	private String guid;
	private String dwdm;
	private int nian;
	private int yue;
	private double priBy;
	private String tjm;
	private String xiangmu;
	private Date xgsj;
	//省略getter/setter
}

//mapper接口
public interface DlscqkMapper {
	public String findDlscqkByObject(Dlscqk dlscqk);
}

//DlscqkMapper.xml
<mapper namespace="com.dao.DlscqkMapper">
	<select id="findDlscqkByObject" parameterType="com.model.Dlscqk"
		resultType="java.lang.String">
		SELECT xiangmu FROM tbl_data_dlscqk WHERE dwdm=#{dwdm} and tjm=#{tjm}
	</select>
</mapper>
      
//Mybatis全局配置文件，引入mapper.xml
<mappers>
	<mapper resource="com/model/DlscqkMapper.xml" />
</mappers>
      
//service方法
public void findDlscqkByObject() {
	SqlSession sqlSession = sqlSessionFactory.openSession();
	DlscqkMapper dlscqkMapper = sqlSession.getMapper(DlscqkMapper.class);
	Dlscqk dlscqk = new Dlscqk();
	dlscqk.setDwdm("09D08A3785FB4C6CB743FDBE4C550E6B");
	dlscqk.setTjm("01");
	String xiangmu = dlscqkMapper.findDlscqkByObject(dlscqk);
	System.out.println(xiangmu);
}
```

## 输入对象是包装类

```java
//POJO（封装参数）
public class DlscqkWrapper {
	private Dept dept;
	private Dlscqk dlscqk;
}

//mapper接口
public interface DlscqkMapper {
	public String findDlscqkByObject(DlscqkWrapper dlscqkWrapper);
}

//DlscqkMapper.xml
<mapper namespace="com.dao.DlscqkMapper">
	<select id="findDlscqkByObject" parameterType="com.model.DlscqkWrapper"
		resultType="java.lang.String">
		SELECT xiangmu FROM tbl_data_dlscqk WHERE dwdm=#{dept.guid} and tjm=#{dlscqk.tjm}
	</select>
</mapper>

//service方法
public void findDlscqkByObject() {
	SqlSession sqlSession = sqlSessionFactory.openSession();
	DlscqkMapper dlscqkMapper = sqlSession.getMapper(DlscqkMapper.class);
	DlscqkWrapper dlscqkWrapper = new DlscqkWrapper();
	Dept dept = new Dept();
	dept.setGuid("09D08A3785FB4C6CB743FDBE4C550E6B");
	Dlscqk dlscqk = new Dlscqk();
	dlscqk.setTjm("01");
	dlscqkWrapper.setDlscqk(dlscqk);
	dlscqkWrapper.setDept(dept);
	String xiangmu = dlscqkMapper.findDlscqkByObject(dlscqkWrapper);
	System.out.println(xiangmu);
}
```



## 输出对象的映射

只需修改mapper.xml，resultType属性为输出的对象全名。serivce方法中使用输出对象作为返回值。

```xml
//mapper.xml
<select id="findDlscqkByObject" parameterType="com.model.DlscqkWrapper"
	resultType="com.model.Dlscqk">
	SELECT xiangmu,xgsj FROM tbl_data_dlscqk WHERE dwdm=#{dept.guid} and tjm=#{dlscqk.tjm}
</select>

//service方法
Dlscqk dlscqkResult = dlscqkMapper.findDlscqkByObject(dlscqkWrapper);
```

## 输出对象的属性与查询结果集字段不一致

遇到这种情况，可以在mapper.xml中定义resultMap标签实现属性与查询结果集字段的映射。

```xml
<mapper namespace="com.dao.DlscqkMapper">
	<resultMap type="com.model.Dlscqk" id="dlscqkResultMap"> <!-- id是映射的名称，用于后面的引用 -->
		<id column="guid" property="guid"/> <!-- 映射主键，不是必须的 -->
		<result column="pri_by" property="priBy"/>
	</resultMap>
	
	<!-- 不再使用resultType定义结果对象，而是使用resultMap（通过它的id值来引用） -->
	<select id="findDlscqkByObject" parameterType="com.model.DlscqkWrapper"
		resultMap="dlscqkResultMap">
		SELECT pri_by,xiangmu,xgsj FROM tbl_data_dlscqk WHERE dwdm=#{dept.guid} and tjm=#{dlscqk.tjm}
	</select>
</mapper>
```

