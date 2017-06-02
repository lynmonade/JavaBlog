（1）调整项目结构，进行更细致的划分，加入dto、service、dao层

（2）引入myBatis.jar、myBatis-spring.jar、ojdbc.jar、C3P0.jar、mchange-commons-java-0.2.11.jar、spring-tx-3.2.18.RELEASE.jar、spring-jdbc-3.2.18.RELEASE.jar

（3）spring的配置文件分开编写：spring-web负责controller相关的东西。spring-serivce负责事务相关的东西。spring-dao负责与myBatis整合相关的东西。

# References

* [手把手教你整合最优雅SSM框架：SpringMVC + Spring + MyBatis](https://github.com/liyifeng1994/ssm)