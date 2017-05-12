# MyBatis3环境搭建

## 第一步：下载MyBatis的jar包

[下载MyBatis的jar包](https://github.com/mybatis/mybatis-3/releases)

## 第二步：创建项目

这里使用eclipse创建一个Java项目，在项目根目录下创建一个lib文件夹。把MyBatis的jar包和oracle的jar包拷贝进去。然后设置build path引入这两个jar包。

## 第三步：新建物理表

```sql
-- Create table
create table TBL_DEPT
(
  guid     VARCHAR2(50) default sys_guid() not null,
  xgzt     INTEGER,
  deptname VARCHAR2(100),
  xgsj     DATE default sysdate
)
tablespace JHB
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
-- Add comments to the columns 
comment on column TBL_DEPT.xgzt
  is '0 or 1';
-- Create/Recreate primary, unique and foreign key constraints 
alter table TBL_DEPT
  add constraint TBL_DEPT_GUID primary key (GUID)
  using index 
  tablespace JHB
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );


insert into TBL_DEPT (guid, xgzt, deptname, xgsj)
values ('35B8C85742E14587A040E0F587523C61', 0, '南宁供电局', to_date('11-05-2017 14:31:23', 'dd-mm-yyyy hh24:mi:ss'));
insert into TBL_DEPT (guid, xgzt, deptname, xgsj)
values ('342EB2FE4F1746A58561D73E8BAB3070', 1, '柳州供电局', to_date('12-05-2017 15:43:14', 'dd-mm-yyyy hh24:mi:ss'));
insert into TBL_DEPT (guid, xgzt, deptname, xgsj)
values ('C72A6EE7EE064EA096EB4FD73C7DDDF6', 2, '桂林供电局', to_date('21-03-2017 09:15:40', 'dd-mm-yyyy hh24:mi:ss'));
insert into TBL_DEPT (guid, xgzt, deptname, xgsj)
values ('D9FE01F67B744983999618B97D1FC3E0', 3, '河池供电局', to_date('05-02-2017 11:05:59', 'dd-mm-yyyy hh24:mi:ss'));
insert into TBL_DEPT (guid, xgzt, deptname, xgsj)
values ('39CB371715354EADAFD971C1C1AF07C8', 4, '玉林供电局', to_date('03-01-2017 19:20:30', 'dd-mm-yyyy hh24:mi:ss'));
```

**第四步：编写MyBatis配置文件**

在src目录下创建一个名为mybatis-config.xml的文件，并添加如下内容：

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE configuration
  PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
  "http://mybatis.org/dtd/mybatis-3-config.dtd">
<configuration>
  <environments default="development">
    <environment id="development">
      <transactionManager type="JDBC"/>
      <dataSource type="POOLED">
        <property name="driver" value="oracle.jdbc.driver.OracleDriver"/>
        <property name="url" value="jdbc:oracle:thin:@127.0.0.1:1521:ORCL"/>
        <property name="username" value="jhb"/>
        <property name="password" value="jhb"/>
      </dataSource>
    </environment>
  </environments>
  <mappers>
    <mapper resource="com/model/DeptMapper.xml"/>
  </mappers>
</configuration>
```

## 第四步：创建POJO类

在com.model包下创建名为Dept的POJO类，并提供getter/setter方法：

```
public class Dept {
	private String guid;
	private int xgzt;
	private String deptname;
	private Date xgsj;
	//省略getter/setter
}
```

## 第五步：创建sql映射文件

在com/model包下创建一个名为DeptMapper.xml的文件，并添加如下内容：

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="test">
    <select id="findDeptByName" parameterType="java.lang.String" resultType="com.model.Dept">
        SELECT * FROM tbl_dept WHERE deptname=#{value}
    </select>
</mapper>
```

## 第六步：创建Cilent进行测试

```java
public class Client {
	private InputStream inputStream;
	private SqlSessionFactory sqlSessionFactory;
	public static void main(String[] args) {
		Client c = new Client();
		c.initMyBatis();
		c.findDeptByName();
	}
	
	public void initMyBatis() {
		String resource = "mybatis-config.xml";
		try {
			inputStream = Resources.getResourceAsStream(resource);
			sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	public void findDeptByName() {
		SqlSession sqlSession = sqlSessionFactory.openSession();
		Dept dept = sqlSession.selectOne("test.findDeptByName", "南宁供电局");
		System.out.println(dept);
		sqlSession.close();
	}
}
```

