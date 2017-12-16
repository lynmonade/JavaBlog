（1）调整项目结构，进行更细致的划分，加入dto、service、dao层

（2）引入myBatis.jar、myBatis-spring.jar、ojdbc.jar、C3P0.jar、mchange-commons-java-0.2.11.jar、spring-tx-3.2.18.RELEASE.jar、spring-jdbc-3.2.18.RELEASE.jar

（3）spring的配置文件分开编写：spring-web负责controller相关的东西。spring-serivce负责事务相关的东西。spring-dao负责与myBatis整合相关的东西。

（4）mybatis的版本问题很坑爹，目前测试，兼容的版本是：spring3.2.18+myBatis3.3.0+myBatis-spring1.2.3。主要原因在于myBatis-spring的jar包必须依赖特定的spring版本和myBatis版本，具体的依赖详见[maven中心站](http://mvnrepository.com/artifact/org.mybatis/mybatis/3.3.0)。

（5）spring-dao.xml中，必须这样配置需要扫描的xml文件,classpath不能少。

```xml
<!-- 扫描sql配置文件:mapper需要的xml文件 -->
<property name="mapperLocations" value="classpath:com/lyn/rbac/dao/*.xml" />

<!-- 给出需要扫描Dao接口包 -->
<property name="basePackage" value="com.lyn.rbac.dao" />
```

# References

* [手把手教你整合最优雅SSM框架：SpringMVC + Spring + MyBatis](https://github.com/liyifeng1994/ssm)