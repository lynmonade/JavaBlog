# workspace与tomcat之间的映射关系

一般来说，我们会在在IDE的工作空间中创建JavaWeb项目，然后把项目部署到Tomcat中。以eclipse为例，工作空间的项目目录一般是这样：左边是eclipse的工程视图，中间是工作空间视图，右边是tomcat中的文件夹视图。

![](http://wx2.sinaimg.cn/mw690/0065Y1avly1fefie5z5nrj30m80dw0u0.jpg)



## Java源代码

在eclipse的工程视图中，Java源码放在`myproject\Java Resources\src`目录下，而在工作空间视图中，源码放在myproject\src目录下。也就是说，**eclipse视图中的Java Resources是虚拟路径，并不是实际存在的文件夹**。src目录下创建的每一个包，都对应一个物理文件夹。当部署到tomcat时，并不会把源码也部署过去。

对于配置文件config.properties（比如数据库连接的配置文件）也应该放在src目录下，这样外部浏览器就无法访问该配置文件了，安全！

## WebRoot目录

**WebRoot只在eclipse视图和Windows视图下出现，在tomcat中并没有WebRoot文件夹。**这其实是由eclipse的项目配置决定的，下图中有三条映射关系，可以从项目-->properties-->Deployment Assembly中查看。

![映射关系](http://wx2.sinaimg.cn/mw690/0065Y1avgy1fefbz2yoc9j30rn068aac.jpg)

第三条映射关系表示：把第三方jar包部署到`WEB-INF/lib`目录下。

第二条映射关系表示：工程视图中`/WebRoot`目录经过部署之后映射为`/`目录，`/`表示项目根目录，即`/myproject`。因此，**工程视图的WebRoot下面的文件、文件夹在部署到tomcat后，都会放置在`/myproject`目录下**。

其实这也很好理解，WebRoot翻译过来就是**Web项目根目录**，经过部署后，Web项目根目录自然等价于Web项目本身。

第一条映射关系表示：Java源代码放在src目录下，那编译后的.class文件放在哪呢？

* 在eclipse工程视图中我们无法看到编译后的.class文件。
* 在工作空间视图中，.class文件放在`myproject/WebRoot/WEB-INF/classes`目录下。
* 在tomcat中，.class文件放在`myproject/WEB-INF/classes`目录下，这便是第一条映射关系的作用，把源码编译，经过部署后，映射到`WEB-INF/classes`目录下。它少了一层WebRoot，这是第二条映射的功劳。

另外，src目录下配置文件也会部署到`/WEB-INF/classes`目录下。有些开发者会在`WEB-INF\`目录下创建一个config目录，专门存放配置文件。个人认为这并没有必要，最好还是放在src目录下比较直观，原因是：最好把源文件环境和编译后的环境区分开来，src本质上是源文件环境，而WEB-INF是编译后的环境，现在的IDE在编译整个项目后，都会自动把源文件部署编译后的环境去。如果直接把配置文件放到编译后的环境中，这就好比是手动放置配置文件到到编译后的环境中，源文件环境并没有该配置文件，这样就无法实现对配置文件的源码管理。

## 理想的目录结构

![理想的目录结构](http://wx2.sinaimg.cn/mw690/0065Y1avly1fefht8f63vj308n0ce74k.jpg)

* Java源代码放在src目录下
* 配置文件放在`src/config`目录下，在编译后会自动部署至`WEB-INF/classes`目录下
* 对外提供下载的文件放在`src/download`目录下，编译后会自动部署至`WEB-INF-classes/config`目录下
* js、css、图片等静态资源文件放在`WebRoot\resource`目录下，也就是项目根目录下，因为前端浏览器经常要访问这些资源，它们也不是机密，不会误访问。但有些静态资源需要权限才能访问，那就必须放在WEB-INF目录中保护起来。
* jsp等视图文件放在`WEB-INF\view`目录下，因为绝大多数jsp都不会被前端浏览器直接访问，而是先经过action映射、数据处理后，再间接访问jsp。所以把jsp放在WEB-INF中，可以防止浏览器直接访问jsp文件。
* 用户上传的文件放在`WEB-INF\upload`目录下，安全！
* 第三方jar包放在`WEB-INF\lib`目录下