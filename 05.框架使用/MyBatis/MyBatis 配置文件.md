# MyBatis 配置文件

## 通过配置文件读取数据库信息

**第一步：**在src目录下创建名为oracle-config.properties，并添加如下内容

```properties
jdbc.driver=oracle.jdbc.driver.OracleDriver
jdbc.url=jdbc:oracle:thin:@127.0.0.1:1521:ORCL
jdbc.username=jhb
jdbc.password=jhb
```

**第二步：**在MyBatis配置文件中通过properies的resource文件引入数据库配置文件。并在<dataSource>元素中通过OGNL表达式映射数据库配置的属性值。

```
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE configuration
  PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
  "http://mybatis.org/dtd/mybatis-3-config.dtd">
<configuration>
	<!-- 1.引入配置文件 -->
	<properties resource="oracle-config.properties"/>
	
	<environments default="development">
		<environment id="development">
			<transactionManager type="JDBC" />
			<dataSource type="POOLED">
				<property name="driver" value="${jdbc.driver}" /> <!-- OGNL映射属性值 -->
				<property name="url" value="${jdbc.url}" />
				<property name="username" value="${jdbc.username}" />
				<property name="password" value="${jdbc.password}" />
			</dataSource>
		</environment>
	</environments>
	<mappers>
		<mapper resource="com/model/DeptMapper.xml" />
	</mappers>
</configuration>
```



