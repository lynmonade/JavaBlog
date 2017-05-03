# Maven安装
1. 下载maven
2. 环境变量中配置MAVEN_HOME：`D:\workspace_maven\maven_3.0.3\apache-maven-3.0.3`
3. 环境变量中配置Path：`%MAVEN_HOME%\bin;`
4. 把setting.xml拷贝到`C:\Users\Roger\.m2`目录下，这样对setting.xml的修改只会影响该用户。
```

# Maven常用命令
## 使用Maven创建项目
```
/*
在cmd中，cd到workpsace目录，然后输入下面的指令：
1. 我们的项目由多个工程组成时，我们就会给每个工程设置一个groupId，表示该工程。
2. artifactId表示工程名称。
3. packageName表示包。
*/

mvn org.apache.maven.plugins:maven-archetype-plugin:2.2:create -DgroupId=com.blit.maven -DartifactId=firstProject -DpackageName=com.blit.maven.test1
```

## 其他
```
mvn install  --生成target，并放到repository，这样的话，其他工程才能依赖该工程
mvn test
mvn compile
mvn test-compile
mvn clean
mvn package  --只生成target，不放到repository
mvn eclipse:eclipse  --把maven工程转为eclipse工程

mvn install:install-file Dfile=D:\antlr\2.7.7\antlr-2.7.7.jar -DgroupId=antlr -DartifactId=antlr -DVersion=2.7.7 Dpackaging=jar  --把一个jar包放到repository中，让maven管理这个jar包

--重新修改pom.xml后，让eclipse生效：
mvn eclipse:clean  -- 把依赖从classPath中删除
mvn eclipse:eclipse --重新依赖
```
