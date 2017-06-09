# select

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

## 查询返回多条记录

此时，resultType依然设置为单条记录对应的POJO类型，而不是集合类型。

```xml
<select id="queryByAccountId" resultType="com.lyn.rbac.entity.Resource">
	SELECT RESOURCE_NAME RESOURCENAME, 
	RESOURCE_ID RESOURCEID, PID, URL
	FROM TBL_RESOURCE
	WHERE VISIBLE=1
	START WITH RESOURCE_ID=(SELECT RESOURCE_ID FROM TBL_RESOURCE WHERE
	RESOURCE_NAME='权限管理')
	CONNECT BY PRIOR RESOURCE_ID = PID
</select>
```

# insert

（1）在J2SE项目中集成myBatis时，需要在插入后显式地commit，才能实现数据插入。而在J2EE项目中无需显式地commit。

```java
//J2SE项目
public void batchInsert(List<AccountSave> list) {
	SqlSession sqlSession = sqlSessionFactory.openSession();
	AccountDao accountDao = sqlSession.getMapper(AccountDao.class);
	int count = accountDao.batchInsert(list);
	System.out.println(count);
	sqlSession.commit(); // 提交事务
	sqlSession.close(); // 释放资源
}

//J2EE项目的service层，直接调用dao，之后自动commit
public int batchInsert(List<AccountSave> list) {
	return accountDao.batchInsert(list);
}
```

（2）**插入时可能部分字段会是空值，此时必须显式地设置jdbcType，这样myBatis才能帮你处理空值的问题。**具体处理方法是：根据对应的POJO类的成员变量的默认值来设置。如果成员变量是数字类型（比如是int类型），则myBatis置为0。如果是非数字类型（String，Date...），则置为null。因此如果想设置特殊的默认值，则必须在成员变量声明时就设置。

关于Date类型，即使你在PL设置了字段的默认值为SYSDATE，如果参数为空，则myBatis依然会认为你期望执行的是`xgsj=null`，而不是`xgsj=SYSDATE`。因此唯一的做法就是在成员变量声明时同时初始化。`Private Date xgsj = new Date();`。

```xml
<insert id="batchInsert" parameterType="java.util.List">
	insert into TBL_ACCOUNT (ACCOUNT_ID, XGSJ, ACTIVATE)
	<foreach close=")" collection="list" item="item" index="index"
		open="(" separator="union">
		select
		#{item.accountId, jdbcType=VARCHAR},
		#{item.xgsj, jdbcType=DATE},
		#{item.activate, jdbcType=INTEGER}
		from dual
	</foreach>
</insert>
```

## 单行插入

myBatis会自动识别参数类型，因此即使你传入的是一个POJO对象，他也能帮你识别。

```xml
<insert id="insert">
  insert into tbl_account (account_id, xgsj, activate)
  values (#{accountId},#{xgsj},#{activate})
</insert>

//传入的是对象类型
public void insert(AccountSave as) {
	SqlSession sqlSession = sqlSessionFactory.openSession();
	AccountDao accountDao = sqlSession.getMapper(AccountDao.class);
	int count = accountDao.insert(as);
	System.out.println(count);
	sqlSession.commit(); // 提交事务
	sqlSession.close(); // 释放资源
}

//插入专用的DTO类，其字段与数据库表无完全一致
public class AccountSave {
	private String _id;
	private String _uid;
	private String _state;
	
	private String accountId;
	private String password;
	private Date xgsj;
	private int activate;
	//省略getter/setter
}
```

## 批量插入

`collection="list" index="index" item="item"`，在你的配置文件中，这三个值是不用改的。item表示批量插入中，单条记录对应的POJO对象的占位符，你用其他名字比如myObj也可以。

```xml
<!--正确-->
<insert id="batchInsert" parameterType="java.util.List">
	insert into TBL_ACCOUNT (ACCOUNT_ID, XGSJ, ACTIVATE)
	<foreach close=")" collection="list" index="index" item="item" 
		open="(" separator="union">
		select
		#{item.accountId, jdbcType=VARCHAR},
		#{item.xgsj, jdbcType=VARCHAR},
		#{item.activate, jdbcType=INTEGER}
		from dual
	</foreach>
</insert>
```

# update

其注意事项与insert一致，J2SE项目需要显式commit，而J2EE项目会自动commit。对于空值的处理，也需要显式地指定jdbcType。

## 单行更新

```xml
<update id="update">
  update TBL_ACCOUNT set
    XGSJ = #{xgsj, jdbcType=DATE},
    PASSWORD = #{password, jdbcType=VARCHAR} 
  where ACCOUNT_ID = #{accountId}
</update>

public void update(AccountSave as) {
	SqlSession sqlSession = sqlSessionFactory.openSession();
	AccountDao accountDao = sqlSession.getMapper(AccountDao.class);
	int count = accountDao.update(as);
	System.out.println(count);
	sqlSession.commit(); // 提交事务
	sqlSession.close(); // 释放资源
}

public AccountSave createAs4Update() {
	AccountSave as1 = new AccountSave();
	as1.setAccountId("南宁供电");
	as1.setXgsj(new Date());
	as1.setActivate(0); //没有效果 ，因为sql语句中不涉及更新activate字段
	as1.setPassword("22222");
	return as1;
}
```

## 批量更新

```xml
<!--正确，但无法获得更新条数-->
<update id="batchUpdate" parameterType="java.util.List">
    begin  
        <foreach collection="list" item="item" index="index" separator=";" > 
            update TBL_ACCOUNT 
            set
            XGSJ = #{item.xgsj, jdbcType=DATE},
			PASSWORD = #{item.password, jdbcType=VARCHAR}
            where ACCOUNT_ID = #{item.accountId}
        </foreach>
	;end;
</update>
```





