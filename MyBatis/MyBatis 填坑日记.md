# MyBatis填坑

## like语句

在Mapper文件中，like语句有几种写法：

**方法一：用${}**

这个做法会造成潜在的sql注入，因此不推荐。

```xml
<select id="findDeptLikeName" parameterType="java.lang.String" resultType="com.model.Dept"> 
		SELECT * FROM tbl_dept WHERE deptname LIKE '%${value}%' 
</select>
```

**方法二：用concat进行字符串拼接**

虽然可以消除sql注入，但sql语句特别繁琐。

```xml
<select id="findDeptLikeName" parameterType="java.lang.String" resultType="com.model.Dept"> 
		SELECT * FROM tbl_dept WHERE deptname LIKE concat(concat('%',#{value}),'%') 
</select>
```

**方法三：参数自带%%**

在传入参数之前，直接先为参数拼接%%。推荐此做法，简单易懂。

```xml
<select id="findDeptLikeName" parameterType="java.lang.String" resultType="com.model.Dept" 
		> SELECT * FROM tbl_dept WHERE deptname LIKE #{value} 
</select>

List<Dept> list = sqlSession.selectList("test.findDeptLikeName", "%供电局%");
```

