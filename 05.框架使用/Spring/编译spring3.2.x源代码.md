# 编译spring3.2.x源代码

## 下载spring3.2.x源码

spring3的源码在github上，因此必须先安装git。spring已经到了spring5版本，而我想编译的是3.2.x版本，因此clone后必须check out 3.2.x版本。

```shell
https://github.com/spring-projects/spring-framework.git
```

![](http://wx1.sinaimg.cn/mw690/0065Y1avgy1fmbzkxbajsj30cj092t8s.jpg)

## 修改gradle配置文件

修改gradlew.bat文件：

```shell
# 原始值
set GRADLE_OPTS=-XX:MaxPermSize=1024m -Xmx1024m -XX:MaxHeapSize=256m %GRADLE_OPTS%
# 修改为
set GRADLE_OPTS=-XX:MaxPermSize=512m -Xmx512m -XX:MaxHeapSize=256m %GRADLE_OPTS%
```

修改gradle.properties文件：

```shell
# 增加一行配置
org.gradle.jvmargs=-Xmx4096m -XX:MaxPermSize=4096m -XX:+HeapDumpOnOutOfMemoryError
```

修改build.gradle文件：

```shell
# 原始值
task schemaZip(type: Zip) {
		group = "Distribution"
		baseName = "spring-framework"
		classifier = "schema"
		description = "Builds -${classifier} archive containing all " +
			"XSDs for deployment at http://springframework.org/schema."
		duplicatesStrategy 'exclude'
		moduleProjects.each { subproject ->
			def Properties schemas = new Properties();

			subproject.sourceSets.main.resources.find {
				it.path.endsWith("META-INF/spring.schemas")
			}?.withInputStream { schemas.load(it) }

			for (def key : schemas.keySet()) {
				def shortName = key.replaceAll(/http.*schema.(.*).spring-.*/, '$1')
				assert shortName != key
				File xsdFile = subproject.sourceSets.main.resources.find {
					it.path.endsWith(schemas.get(key))
				}
				assert xsdFile != null
				into (shortName) {
					from xsdFile.path
				}
			}
		}
	}
# 修改为
task schemaZip(type: Zip) {
        group = "Distribution"
        baseName = "spring-framework"
        classifier = "schema"
        description = "Builds -${classifier} archive containing all " +
            "XSDs for deployment at http://springframework.org/schema."
        duplicatesStrategy 'exclude'
        moduleProjects.each { subproject ->
            def Properties schemas = new Properties();

            subproject.sourceSets.main.resources.find {
                it.path.endsWith("META-INF\\spring.schemas")
            }?.withInputStream { schemas.load(it) }

            for (def key : schemas.keySet()) {
                def shortName = key.replaceAll(/http.*schema.(.*).spring-.*/, '$1')
                assert shortName != key
                File xsdFile = subproject.sourceSets.main.resources.find {
                    it.path.endsWith(schemas.get(key).replaceAll('\\/','\\\\'))
                }
                assert xsdFile != null
                into (shortName) {
                    from xsdFile.path
                }
            }
        }
    }
```

做这些配置都是为了避免出现GC内存溢出，或者gradle编译中的一些奇葩错误。

## gradle编译spring3.2.x源码

在cmd中cd到spring-framework的目录并执行如下命令：

```shell
# 编译spring所有的子项目，但不包括测试用例，我的机子大概花了30分钟，因为需要联网下载很多东西
gradlew build -x test

# 第二步
gradlew cleanEclipse :spring-oxm:compileTestJava eclipse -x :eclipse

# 第三步
gradlew :eclipse
```

编译成功后，每一个spring子项目下都会出现exclipse项目所特有的配置文件。

## 导入eclipse

eclipse-->import-->General-->Existing Projects into Workspace，导入所有的spring子项目。



## 参考

* [springFramework 源码学习日记（一）源码下载与编译](http://blog.csdn.net/wilsonke/article/details/23036847)
* [【转】Spring源码编译](http://www.cnblogs.com/kofxxf/p/3723434.html)
* [Spring3.2源码编译过程](http://blog.csdn.net/wqc19920906/article/details/78423586?locationNum=10&fps=1)