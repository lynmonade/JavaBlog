# 批量插入insert

```xml
<!--mapper的配置-->

<!--方法1：正确-->
<insert id="batchInsert" parameterType="java.util.List">
	insert into TBL_ACCOUNT (ACCOUNT_ID, XGSJ, ACTIVATE)
	<foreach close=")" collection="list" item="item" index="index"
		open="(" separator="union">
		select
		#{item.accountId},
		#{item.xgsj},
		#{item.activate}
		from dual
	</foreach>
</insert>

<insert id="insert" parameterType="java.util.List">
	BEGIN
	<foreach collection="list" item="item" index="index"
		separator=";">
		INSERT INTO TBL_ACCOUNT (ACCOUNT_ID, XGSJ, ACTIVATE) VALUES
		(#{item.accountId},#{item.xgsj},#{item.activate})
	</foreach>
	;END ;
</insert>
```

```java
//客户端调用
public class Client {
	private SqlSessionFactory sqlSessionFactory;
	public static void main(String[] args) {
		Client c = new Client();
		c.initMyBatis();
		List<AccountSave> list = c.createAss("added");
		c.batchInsert(list);
		
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
	
	public void batchInsert(List<AccountSave> list) {
		SqlSession sqlSession = sqlSessionFactory.openSession();
		AccountDao accountDao = sqlSession.getMapper(AccountDao.class);
		int count = accountDao.batchInsert(list);
		System.out.println(count);
		sqlSession.commit(); // 提交事务
        sqlSession.close(); // 释放资源
	}

	public List<AccountSave> createAss(String state) {
		AccountSave as1 = new AccountSave();
		as1.set_state(state);
		as1.setAccountId("玉林供电");
		as1.setXgsj(new Date());
		as1.setActivate(0);
		
		AccountSave as2 = new AccountSave();
		as2.set_state(state);
		as2.setAccountId("桂林供电");
		as2.setXgsj(new Date());
		as2.setActivate(0);
		
		List<AccountSave> list = new ArrayList<AccountSave>();
		list.add(as1);
		list.add(as2);
		return list;
	}
}
```

# Reference

[批量插入数据(基于Mybatis的实现-Oracle)](http://www.cnblogs.com/robinjava77/p/5530681.html)