# JFinal 1.0.6 changelog
JFinal 新版本最大的改变是加入了EhCachePlugin。其它一些小更新如下：
1：activerecord.Page类实现了 Serializable接口实现了序列化支持
2：JFinal类中添加方法 public List<String> getAllActionKeys()，开发者可以这样使用: JFinal.me().getAllActionKeys();
3：JsonBuild 添加对 Record的支持
4：添加 com.jfinal.lib.ContextPathHandler
5：JspRender添加对 ${model.attr支持}
6：com.jfinal.plugin.activerecord.CPI加了getColumns()方法
7：JspRender 支持ActiveRecord，render.CPI添加了setJspRenderSupportActiveRecord()
8: render.CPI 添加 getFreeMarkerConfiguration()
9:  render404  render500 使用异常跳出
10: Controller中的方法签名变化，以及getSessoin尽量用了getSession(false)：
getFromSession ---> getSessionAttr
putToSession ---> setSessionAttr
removeInSession ---> removeSessionAttr
11: Constants 中添加了 setBaseViewPath(String baseViewPath) 方法
12: Controller 添加 renderHtml(String) renderJavascript(String)
13: JFinalConfog.loadPropertyFile(..) 添加返回值
14: JetteryServer 接受scanIntervalSeconds < 1 的值， 以便支持关闭热加载 hot swap
15: JFinal.java 添加 getConstants 方法，以便开发者在开发过程中需要使用有些变量:JFinal.me().getConstants()
16: MultipartRequest 加入对 jsp 文件的安全检测方法   isSafeFile()。考虑使用异常方式终止请求
17: 添加 EhCachePlugin，支持 EhCache

# JFinal 1.0.7 changelog
JFinal 1.0.7 添加了 OracleDialect、AnsiSqlDialect多数据库支持，重新设计了EhCachePlugin。另外对系统进行了诸多优化，添加了一些小的实用功能，去掉了一些多余的功能，具体变化如下：
1：添加OracleDialect支持Oracle数据库，添加 AsniDialect支持遵守 ANSI Sql标准的库，分页暂未实现。
2：EhCache 全新设计，去掉了 EhCacheConfig，相关类名去除了前面两个字母"Eh"， 如  CacheKit。
3: I18N 添加了 me()方法，可以setAttr("i18n", I18N.me())并在view中使用该对象
4: Controller添加如下方法：renderJson(String[] attrs)，renderText(String text, String contentType)。
5: JFinal.java 中增加 getAction() 方法
6: com.jfinal.render.CPI添加 setVelocityProperties 方法
7：com.jfinal.plugin.ehcache.DataLoader 重构为IDataLoader。com.jfinal.plugin.activerecord.Atom 重构为 IAtom。com.jfinal.plugin.activerecord.Callback 重构为 ICallback。
8: Controller.getParaToBoolean 添加对 0 与   1 的逻辑支持。 0: false  1: true
9: Db.queryInt 去掉了将 Long 自动转成 Integer。注意 select count(*) 返回 Long型结果，需要Db.queryLong("select cont(*)...")
10: AciveRecord transaction 重构至 tx 包下
11: cp3p0 jar 包升级到 0.9.1.2 版，mysql connector jar包升级至 5.1.20 版。
12：ActiveRecord 增加 cache 支持,如 Blog.dao.find(cacheName, key, sql, prams)， Db.find(cacheName, key, sql, params);
13: Db 中删除全部 insert 方法以及部分 delete 方法。由于没有了insert方法，若想在插件记录后立即得到id值，请用 Db.save(String,Record), 在 record保存后可以 record.get("id")来获取
14: Db 加入 queryNumber 方法， 可以方便地返回 Number以后再转成 long更好支持程序通用性， 如: queryNumber(...).longValue();
15: Db 加入 batch 批量处理方法
16: Model Record 中添加了 getNumber 方法，增强通用性，如 long cash = User.dao.findById(88).getNumber("cash").longValue();
17: ActiveRecordPlugin 添加了show sql 功能，只需  new ActiveRecordPlugin(..).setShowSql(true) 即可;
18: com.jfinal.render.CPI 中添加了对 VelocityRender 的配置CPI.setVelocityProperties(Properties properties)
19: 添加C3p0Plugin.setDriverClass(String)方法。
20: 添加Constants.setMainRenderFactory(IMainRenderFacotry mf)，以便在 Controller.render(String) 支持自定义 Render 类，使用方法如下:
    1：先创建自定义Render如 YourRender。
    2：再创建YourMainRenderFacotry 实现 IMainRenderFactory接口,getRender方法中返回 YourRender对象
    3: 在JFinalFilter.constant中设置 me.setMainRenderFactory(...)
    4: 在Controller 中就可以这样使用 YourRender了 render(String)

# JFinal 1.0.8 changelog
1：添加Controller.isParaExists(int), Controller.isParaBlank(int)。
2：与cache有关的查询签名变化：Model.find变Model.findByCache，Model.paginate变Model.paginateByCache
   Db.find变Db.findByCache，Db.paginate变Db.paginateByCache。
3：JsonBuilder所有方法去掉final关键字，添加普通java bean 的 isXxx 方法支持
4： 添加 GET POST 拦截器， 使action分别仅接受GET POST方法的请求
5： 删除了 com.jfinal.lib.handler.WebAppContextPathHandler 类文件，与 ContextPathHandler功能重复了
6：com.jfinal.lib.handler.SkipExcludedUrlHandler更名为 UrlSkipHandler
7： Model Record 添加  get(String attr, Object defaultValue) 方法
8：Model添加 getModifyFlag()方法，以提升空间性能
9：ActiveRecordPlugin.addTableMapping方法更名为 addMapping，原方法名被 @Deprecated。
10：Active Record 下 ICallback IAtom 接口中的方法更名为 run()
11：去掉了 com.jfinal.plugin.activerecord.CPI.getColumns(Record record)方法，因为Record已有此方法
12：添加 SessionInViewHandler， 以便开发者能在view中直接使用session变量，如FreeMarker中这样用
   ${session["key"]}或者${session.key}。使用之前需要配置一下: handlers.add(new SessionInViewHandler());

# JFinal 1.0.9 changelog
1：DbKit.setDataSource(DataSource) 改为public 可见性，方便使用多数据源时切换数据源 
2：DbKit.setDialect(IDialect) 改为 public 可见性，方便多数据源时切换到另外的数据库类型
3：com.jfinal.lib 重构为 com.jfinal.ext
4：CaptchaRender 由 captcha 包重构至 com.jfinal.ext.render包
5：ActionReporter添加源代码定位功能，只需在eclipse控制台单击链接即可进入源码，提升开发效率
6：添加SpringPlugin，用法如下：
 a：放入applicationContext.xml到 WebRoot/WEB-INF下，否则需要在new SpringPlugin时指定参数
 b：在需要 IOC的 controller 之上添加 IocInterceptor拦截器
 c：在需要IOC的controller 之中添加属性    

# JFinal 1.1.0 changelog
1：添加 com.jfinal.plugin.activerecord.tx.TxByRegex 与 TxByActionKeys，分别支持正则声明式事务、actionKeys声明式事务。
2：改进ActionReporter，缩小链接范围、Interceptor 输出格式化，提升开发体验。
3：C3p0Plugin.start() 将 return false改为抛出 RuntimeException。
4：删除TokenIdGenerator，简化 tokenId 生成算法。

# JFinal 1.1.1 changelog
1：添加 PostgreSqlDialect 支持 PostgreSql
2： 添加Sqlite3Dialect 支持 Sqlite3
3： AnsiSqlDialect 支持分页
4： C3p0Plugin 默认配置 maxPoolSize、minPoolSize、initialPoolSize 分别改为 100、10、20 以便使默认配置能支持更大规模应用
5： 添加 FakeStaticHandler 支持伪静态 action
6： IDialect 重构为 Dialect 并添加 isSupportAutoIncreatementKey() 等方法
7： 改进Validator.validateUrl() 与 validateEmail()，增加对 null 的处理
8： 删除SessionInViewHandler添加SessionInViewInterceptor
9： 删除 JettyServer 中对 context 值的重复判断
10： ActionHandler 中的catch (Error404Exception e) 提示信息改为 Resource not found
11： Controller.getParaValues 方法重构为 getParas， 原方法 Deprecated
12： JFinalConfig 中删除了 afterJFinalStop 并添加了 beforeJFinalStop，以便在那时能使用 ActiveRecord 等插件功能
13：JFinalFilter中捕捉到的异常为JFinal内部异常,不再抛出。chain.doFilter 仍然抛出 IOException, ServletException
14：Constants.java 中的setJspViewExtension、setFreeMarkerViewExtension、setVelocityViewExtension 添加自动补"."前缀功能
15：去除了 MysqlDialect.forModelUpdate 以及 forDbUpdate 方法中的 limit 1
16：JspRender 添加对 Page<Model> 处理
17： Db.batch 设置 setAutoCommit(false)，添加Db.batch(...) 系列方法
18： 优化 ActionHandler JFinalFilter 中 log 处理
19： 优化 DbKit.getConnection()，提升性能，消除重复代码
20： ActionHandler JFinalFilter 日志中添加当前请求 url与 queryString
21：改进SqlReporter，解决在某些jdbc驱动下的 ClassCastExcetion
22：添加 com.jfinal.render.CPI.setFreeMarkerProperties(Properties p) 方法，便于在 JFinalConfig.afterJFinalStart()中一次性加载freemarker配置

# JFinal 1.1.2 changelog
Controller 添加 getParaToLong(String) 系列方法
JspRender.handePage(...) 增加对 list的处理
Model 所有 return this 的方法返回值强制转化泛型
改进SessionInViewInterceptor，采用 JFinalSesion以便支持 get(String)以外的功能
改进 Controller 的 getParaToInt 系列与 getParaToLong 系列方法，使字母"N"与"n"代表负号，以便在 urlParaSeparator 为 "-" 时支持负数, http://abc.com/search/2-N8-5 请求的 getParaToInt(1) 值为 -8
将默认 urlParaSeparator 由 "_" 改成了 "-"， 有利于 seo， 使用 "_" 值的原有项目可以通过 constants.urlParaSeparator("_") 来升级 jfinal
Controller.getParas 被 Deprecated， 启用与 getParaNames 相对应的 getParaValues
FreeMarkerRender中的 config.setNumberFormat("#") 改为了 config.setNumberFormat("#0.#####")
去掉了 JFinal.initOreillyCos() 中的自动创建上传目录相关代码
去掉了 ActiveRecordPlugin中的 addTableMapping(...) 方法
重新设计 json 模块
添加 DruidPlugin (Druid)

# JFinal 1.1.3 changelog
1：添加 Restful 拦截器，支持标准的 restful url 风格
2：添加DruidStatViewHandler，无需在 web.xml配置即可使用Druid内置监控界面
3：添加IDruidStatViewAuth实现监控功能权限控制接口
4：PathUtil.getWebRootPath() 返回值去掉了末尾的 "/" 字符
5：改进 JsonBuilder 使其支持 char 类型
6：Db 中带有三个参数的 findById(...)两个方法参数由Object改为 Number类型避免调用时引起混淆
7：改进 MysqlDialect 中的 limit 0 为  where 1 = 2， 以防 Druid WallFilter 误杀
8：Model.getAttrs 改为 protected，继承类可以决定是否public此方法
9：改进日志被wrap后无法正常输入日志记录地点的问题
10：去掉所有与 LogLevel 相关代码
11：删除 RestfulUrlHandler
12：IMainRenderFactory 接口增加 getViewExtension() 方法
13：ViewType添加 OTHER枚举常量
14：Constants中的setMainRenderFactory()及 setViewType()方法中添加对 ViewType.OTHER的处理
15：删除 Controller.getParas() 方法，可使用 getParaValues 代替
16：Model添加getAttrNames() 与 getAttrValues()方法
17：Controller 中 addCookie系列更名为 setCookie系列
18：Controller 中 getCookieValue更名为 getCookie，并添加 getCookieToInt、getCookieToLong，原getCookie 更名为 getCookieObject

# JFinal 1.1.4 changelog
1：FileRender 添加自动生成所下载的文件名功能
2：JFinal.initLogFactory()移至 Config.configJFinal(...)之中，以便支持在Plugin中能使用 logger
3：Record添加 getColunmNames()与 getColumnsValues()
4：ActiveRecordPlugin 添加防重复启动功能
5：UploadFile.getFilesystemName()更名为 getFileName()
6：改进 SessionInViewInterceptor，改变JFinalSession实现方式
7：ActiveRecord 添加 IMapFactory，添加CaseInsensitiveMapFactory 便于支持属性名大小写不敏感
8：DbKit.replaceFormatSqlOrderBy(...)添加对中文字段名的支持
9：添加 com.jfinal.util.HandlerKit，辅助在 Handler中做些render或redirect操作
10：SessionIdGenerator 移至 com.jfinal.ext.util 下
11：Model Record 中添加 toJson() 方法
12：I18N.java 加入 DCL
13：Controller.getPara(String, String)添加对空字符串的判断
14：改进 DruidStatViewHandler，使其支持非 druid且非index.html结尾url访问

# JFinal 1.1.5 changelog
1：添加Oracle主键自动生成支持(只需创建序列并将其名称设置为id值，详见JFinal手册)
2：添加CaseInsensitiveContainerFactory，支持字段名大小写不敏感，方便oracle用户
3：添加 ActionKey注解，便于在Controller.method()上直接指定 actionKey
4：开放所有Render，将可见性变为public，便于开发者继承扩展
5：开放 ILoggerFactory接口、以及相关实现类。便于开发者扩展新的日志实现
6：添加JFinalConfig.setLoggerFactory(...)
7：NullRender去单例模式，避免可能的线程安全问题
8：Dialect 中去掉 isSupportAutoIncrementKey()，添加 isOracle()方法
9：删除com.jfinal.render.CPI，将其中相关方法转移至各自的实现类中
10：Dialect、OracleDialect中添加 fillStatement()支持oracle date数据类型
11：Controller添加 renderJson(String) renderJson(Object)
12：RenderFactory添加getJsonRender(String)、getJsonRender(Object)
13：Render.encoding 添加默认值
14：IMapFactory更名为IContainerFactory，并添加getModifyFlagSet()方法
15：删除CaseInsensitiveMapFactory
16：ActiveRecordPlugin.setMapFactory()更名为setContainerFactory()
17：Model.getModifyFalg()利用DbKit.containerFactory得到Set
18：Render实现类添加对writer的null值判断，以防NullPointerException掩盖try块中更重要的异常
19：Logger添加setLoggerFactory(...)、init()
20：JsonRender添加JsonRender(String)、JsonRender(Object)构造方法

# JFinal 1.1.6 changelog
1：CaseInsensitiveContainerFactory中内部类改成静态内部类，以便支持EhCache、Memcache之类的序列化
2：Logger 添加 static 代码块调用 init()，支持在非web环境下ActiveRecord独立使用日志
3：com.jfinal.util 更名为 com.jfinal.kit
4：PathUtil 更名为 PathKit
5：JsonBuilder 更名为 JsonKit
6：Dialect、OracleDialect 添加getDefaultPrimaryKey()
7：TableInfo 构造方法使用 getDefaultPrimaryKey()
8：CacheKit.handle(...)更名为CacheKit.get(...)
9：CacheKit 添加重载方法 get(String, String, Class<? extends IDataLoader>)节省时空

# JFinal 1.3 changelog
JFinal 1.3 Changelog
1：改进Tx，使其在showSql打开时能输入sql
2：添加JFinal.getContextPath()
3：Controller中redirect(...)与redirect301(...)自动支持context path
4：FileRender 解决中文文件名乱码问题
5：EhCachePlugin 添加 EvictInterceptor 支持缓存自动化清除
6：jetty-server-8.8.8.jar 重新规划，去除 jstl相关包，以便使项目在tocmat与jetty间无缝迁移

# JFinal 1.4 changelog
JFinal 1.4 继续缩减了代码量，改进并增加了一些功能。较大的两个变化：1：重新设计了异常处理结构，提供了IErrorRenderFactory便于灵活定制错误处理。2：增加了嵌套事务支持。
1：Active Record 添加嵌套事务支持
2：添加JsonKit.setConvertDepth(int)方法，新增对Enum类型支持
3：添加JsonRender.setConvertDepth(int)方法
4：添加Render.setView() 与 getView()方法
5：添加 com.jfinal.core.ActionException
6：添加Controller.renderError()系列方法
7：删除Controller.renderError404/renderError500系列方法，由renderError系列取而代之
8：添加 com.jfinal.render.ErrorRender/IErrorRenderFactory
9：删除 com.jfinal.render.Error404Render/Error500Render/Error404Exception/Error500Exception
10：添加Constants.setErrorRenderFactory/setError401View/setError403View
11：添加FileKit，改进 JettyServer，解决session数据反序列异常问题
12：改进PathKit.getRootClassPath/getWebRootPath，支持带空格与中文的路径

# JFinal 1.5 changelog
本次升级一个大的提升是利用自定义 ClassLoader 加强了对maven的支持，当 class与jar 文件不在 WEB-INF 之下时仍然支持热加载。
1：添加JFinalClassLoader，支持 class与jar文件不在WEB-INF 下也可正常工作，便于使用 maven
2：增强JsonKit 使 renderJson()系列方法支持 Data、Timestamp、Time 类型按指定格式转换
3：添加 TxByActionMethods 对指定的action method name 支持声明式事务，便于使用方法命名约定事务
4：Db.tx(int, IAtom)将 return false改为抛出异常，以免异常被掩盖不方便排错
5：Model Record 添加对  msyql unsigned bigint 类型支持，TypeConverter 添加 BigInteger 分支
6：Db.execute(ICallback) 添加 Object 类型返回值
7：改进 RedirectRender，支持原 url 与 重定向后的 url 中同时具有 queryString 的情况
8：Validator添加getActonMethod()与getViewPath()方法
9：TypeConverter boolean 转换添加对 1/0 值的支持
10：添加 Controller.createToken(String)，Const.DEFAULT_TOKEN_NAME 值改为 "jfinal_token"
11：添加 Controller.getParaToDate() 系列方法，优化 getParaToBoolean() 系列方法
12：C3p0Plugin 添加属性 setter 方法
13：ActionException 改为获取 ErrorRender
14：删除 ModelInjector中的 ModelInjectException
15：喜欢 JFinal 就推荐给朋友们去用 ^_^

# JFinal 1.6 changelog
JFinal 1.6 主要升级了 ActiveRecord 插件，本次升级全面支持多数源、多方言、多缓存、多事务级别等相关配置，本次升级还对 ARP 所有代码做了大量重构，结构更合理，代码更整洁。
1：ActiveRecord 全面支持多数源、多方言、多缓存，每个 ARP 实例拥有独立的配置
2：改进 DruidPlugin，添加防止连接泄露相关配置
3：FreeMarkerRender 的 date、time、date_time 默认格式分别设置为："yyyy-MM-dd"、"HH:mm:ss"、"yyyy-MM-dd HH:mm:ss"
4：CaseInsensitiveContainerFactory.CaseInsensitiveSet 添加 addAll(...)
5：JsonKit 转换深度将顶层也计算在内，此版本将比过往版多转换一层
6：TableInfo 重构为 Table，并重构了内部相关方法
7：TableInfoBuilder 重构为 TableBuilder，并重构了内部相关方法
8：TableInfoMapping 重构为 TableMapping，并重构了内部相关方法
9：添加 NestedTransactionHelpException，改进嵌套事务 return false 处理方式
10：Config 中添加对 ActiveRecrodPlugin devMode 初始化，JFinal.init() 中去掉 initActiveRecord()
11：事务拦截器添加 TxConfig annotatoin，可以指定事务的配置
12：Model 去掉 TableInfoMappiing 引用，避免某些第三方库在序列化时对其可能的处理，提升时空性能
13：Record 中添加 configName 属性，并相应修改了 hashCode 方法
14：Db 去掉了所有带 DataSource 参数的方法，添加了带 configName 参的方法，可同时切换数据源、方言、事务级别、缓存等配置
15：去掉JFinal.initActiveRecord，在 Config 中添加对ARP的初始化操作

# JFinal 1.8 changelog
1：改进 Db + Record 设计
2：改进 Controller 文件上传设计
3：ActiveRecordPlugin.start() 添加对 Db.init() 的调用
4：改进 Model Record 中 keep(String...) 实现
5：Db.queryDate 返回类型改为 java.util.Date
6：Model、Record getDate() 返回类型改为 java.util.Date
7：Druid 升级至最新版 1.0.5，DruidStatViewHandler 支持 druid 最新内置监控页面
8：StringKit 更名为 StrKit，保留了 Deprecated 的 StringKit 类
9：TxByActionKeys、TxByActionMethods、TxByRegex 事务代码改为 Db.use(configName).tx(...)

# JFinal 1.9 changelog
1：添加PropKit、Prop方便全局使用配置，配置文件加载默认目录改为类路径之下，符合maven习惯
2：增强jsp之下的jstl的EL输出，添加ModelRecordElResolver，JspRender.isSupportActiveRecord默认值改为false，默认使用EL增强
3：添加HttpKit及EncryptionKit方便与第三方API进行通信与加密，便于开发微信公众号这类项目
4：添加Controller.renderXml(String)方便开发xml服务端项目
5：增强FileRender，文件下载支持多线程下载以及断点续传功能
6：改进DbPro.tx()与Tx拦截器事务功能，添加对抛出Error时的回滚，增强事务安全
7：优化ActionHandler对静态资源判断性能，支持对抛出Error时写日志，方便jvm当掉时排查错误
8：提升Oracle在表数据量极大时ARP初始化性能，OracleDialect.forTableBuilderDoBuild()中sql条件改为rownum<1，fillStatement()添加对Timestamp的判断
9：优化JsonRender，添加JsonRender.addExcludeAttrs()方法，可以排除renderJson()时不想转换为json的属性，默认已经排除tomcat开启SSL后自动生成的属性，方便tomcat支持SSL
10：优化 StrKit.firstCharToLowerCase、firstCharToUpperCase，性能提升 2.1 倍
11：增强HandlerKit，添加renderError404()，方便在Handler中使用404页面进行渲染
12：增强FakeStaticHandler，支持对非伪静态action请求的过滤
13：精简JFinalConfig与配置加载、读取有关代码
14：ICallback.run()更名为call()
15：开放Table.getColumnTypeMap()方便开发者扩展ARP功能，并使其返回的map为只读确保安全
16：添加Controller.renderText(String, ContentType)方便各种Content Type的text渲染
17：添加com.jfinal.plugin.activerecord.OrderedFieldContainerFactory 类，方便开发数据库查询工具项目，以便model中的属性迭代输出顺序与sql select后的字段次序保持一致 
18：优化DruidPlugin，driverClass 默认值改为 null，以便让新版本Druid自动探测该值
19：改进EhCachePlugin，添加RenderInfo、RenderType解决对render对象缓存时线程安全问题
20：优化SessionInViewInterceptor，跳过处理JsonRender提升性能
21：支持Controller内public无参方法成为非action，添加com.jfinal.ext.interceptor.NotAction，通常用于在拦截器中需要控制器提供public无参方法的场景
22：优化JsonKit，listToJson、mapToJson方法可见性改为private，对这些方法有依赖的代码可改为调用toJson()方法
23：优化Render，去掉对Serializable接口的实现，删除所有Render继承类中的transient关键字以及serialVersionUID属性

# JFinal 2.0 changelog
1：极速化业务层 AOP 支持
2：极速化 redis 支持
3：极速化 ActiveRecord 复合主键支持
4：极速化 Model 多数据源多table支持
5：极速化 i18n 支持
6：ActionInvocation 更名为 Invocation
7：ClearInterceptor更名为Clear，并增强功能，支持移除指定的拦截器，删掉ClearyLayer
8：添加 Model.findFirstByCache(...)、Db.findFirstByCache(...)，方便对单个对象进行缓存，省时省力省代码
9：Model.findById 带String columns 参数的方法更名为 findByIdLoadColumns
10：删除 Db.findById 带String columns 的方法，可用 Db.findFirst 代替
11：改进 Validator，添加系列方法支持 urlPara 验证。添加setDatePattern(...)方法可指定Date的pattern
12：Db.batch(...) 系列方法添加事务及嵌套事务支持
13：添加 Config.isInTransaction() 方法
14：EncryptionKit 更名为 HashKit，并添加盐值生成方法generateSalt()
15：改进 Tx 拦截器，放行 ActionException，便于 renderError 正确响应 error code
16：添加 Sqls 工具类，用于加载和使用外部 sql 文件，例如：User.dao.find(Sqls.get("findAll"));
17：ActiveRecord 添加 SqlServerDialect 支持 SqlServer 数据库
18：添加 Controller.getParaValuesToLong(String)方法
19：添加 OreillyCos.setFileRenamePolicy(...) 支持自定义上传文件重名时的更名策略
20：改进 ActionMapping，在 actionKey 重复时终止启动而非输出警告，优化Action映射，进一步提升系统启动速度
21：TableBuilder 重构，进一步减少代码量、提升性能，提高可读性
22：添加 com.jfinal.ext.kit.ElResolverListener 支持 weblogic 等容器注册 EL增强
23：CacheInterceptor 添加 JsonRender 支持
24：去掉了 Render 类中所有方法的 final 关键字，更加便于扩展自定义 render
25：添加 PathKit.setRootClassPath(...) 方法，便于在如Resin这类容器下无法自动探测class目录时使用
26：JsonKit、JsonRender 默认转换深度增大到 15 层
27：添加 DbKit.removeConfig(...) 方法，便于动态管理多数源
28：改进 JettyServer 在启动过程中允许抛出异常终止启动并退出 JVM
29：改进 ActionException 在 renderError(...) 时支持 viewPath
30：移除 SpringPlugin
31：改进 PropKit，对多线程更加严格，让 PropKit 的重度使用者以及有代码洁癖工程师更加顺爽
32：改进 Controller，urlPara 转换错误由 500 error 改为 404 error
33：添加 Controller.checkUrlPara(...) 系列方法，支持严格 url，避免出现多余 urlPara
34：Tx 拦截器开放 getConfigWithTxConfig() 方法，方便扩展自定义事务拦截器
35：改进OneConnectionPerThread支持事务以及嵌套拦截
36：TxByActionMethods 更名为 TxByMethods，可用于拦截控制层于业务层
37：删除 Controller、Constants 中与 i18n 有关代码

# JFinal 2.1 changelog
1：添加BaseModelGenerator，极速合体Model与传统java bean
2：添加MappingKitGenerator，极速映射table与model，极速配置主键/复合主键
3：添加ModelGenerator，极速生成Model
4：添加DataDictionaryGenerator，极速生成数据字典
5：添加json模块，极速json与object互转。提供jfinal、jackson、fastjson三种json实现，按需选用
6：增强Clear注解，极速支持类级别拦截器清除
7：添加Controller.renderCaptcha()，极速验证码渲染
8：添加Validator.validateCaptcha()、Controller.validateCaptcha()极速校验验证码
9：添加Db.batchSave()、batchUpdate()，极速批量插入/更新数据
10：增强Controller.getModel()、keepModel()，支持传入""作为 modelName，极速友好支持纯API项目
11：添加ActiveRecordPlugin.useAsDataTransfer()极速支持Model在分布式场景下承载/传输数据，极速支持在无数据源场景下使用Model
12：添加Json、IJsonFactory抽象，极速扩展自己喜爱的json实现
13：改进所有paginate()方法，合并select与sqlExceptSelect参数，并兼容老版本用法。改进正则对order by、group by支持更完备
14：改进Controller.setCookie()系列方法，添加isHttpOnly参数，方便保护敏感cookie值不被js读取
15：增强文件上传功能，支持设置baseUploadPath在项目根路径之外，便于支持单机多实例共享上传目录
16：增强文件下载功能，支持设置baseDownloadPath在项目根路径之外，便于支持单机多实例共享上传目录
17：改进ActiveRecord，默认事务隔离级别提升为Connection.TRANSACTION_REPEATABLE_READ
18：增强TypeConverter，对Timestamp类型转换时根据字符串长度选择转换pattern，添加对boolean、float、double三种primitive类型的转换支持以便更适合传统java bean应用场景
19：添加StrKit.toCamelCase()、支持下划线命名转化为驼峰命名
20：增强I18nInterceptor，支持404、500页面国际化
21：重构log模块，所有Logger更名为Log,所有getLogger()更名为getLog()
22：优化、重构HashKit，提升性能，缩减代码量
23：改进Json转换规则，避免对"/"字符的转义，与jackson、fastjson转换行为一致
24：改进TxByRegex，将其拆分成TxByActionKeyRegex与TxByMethodRegex，语义更加明确
25：改进Prop.getBoolean()添加对value值前后空格的处理，避免开发者粗心带来难以发现的错误
26：添加Controller.setHttpServletRequest()、setHttpServletResponse()便于拦截注入做更深扩展
27：改进Db.delete(String, String, Record)支持复合主键参数
28：添加Constants.setReportAfterInvocation()设置Action Report时机，默认值为true，有利于纯API项目
29：添加Controller.getBean()、keepBean()系列方法，支持传统java bean以及合体后的Model，有利于无数据源使用Model的场景
30：JFinalConfig.loadPropertyFile()直接使用Prop，避免影响PropKit，删除unloadAllPropertyFiles() 方法
31：改进OracleDialect.fillStatement()添加对Timestamp的判断
32：改进Validator，其内部属性全部改为protected可见性，便于继承扩展
33：添加Handler.next属性代替nextHandler，原属性被Deprecated
34：添加CaptchaRender，极速生成更加美观安全的验证码
35：改进Controller.getModel()系列方法，添加skipConvertError参数，便于在获取model时跳过无法转换的字段
36：添加LogKit支持在任意地方快捷使用日志
37：改进Model，getAttrNames、getAttrsEntrySet、getAttrValues、setAttrs方法名添加 "_"前缀，便于和getter、setter区分开来
38：添加FreeMarkerRender.setTemplateLoadingPath()，支持指定freemarker模板基础路径
39：改进HttpKit，支持非Oracle JDK，readIncommingRequestData()更名为 readData()、添加 setCharSet()方法
40：添加IBean接口，标记识别Model继承自BaseModel带有getter、setter
41：改进Redis Cache，添加对hash、set数据结构的field字段转换，支持field字段使用任意类型。改进支持通过继承Cache实现自定义Cache。
42：添加Constants.setJsonFactory()方法，用于切换json实现
43：改进Constants，setUploadedFileSaveDirectory()更名为setBaseUploadPath()，setFileRenderPath()更名为setBaseDownloadPath()
44：添加Constants.setXmlRenderFactory()用于切换XmlRender工厂实现类
45：改进ActionReporter，可设置JFinal Action Report时机
46：添加IXmlRenderFactory接口，支持Xml Render实现类的切换
47：添加InterceptorManager，支持缓存类级别拦截器栈
48：添加FreeMarkerRender.getContentType()，有利于重用freemarker，并利用其重构XmlRender，缩减代码量
49：改进SqlServerDialect，避免将sql转成小写字母，更好支持model字段取值
50：改进CacheInterceptor，支持未调用render时的场景
51：改进Redirect301Render，支持对已有queryString进行追加
52：改进异常处理，对所有catch块中忽略的异常添加适当处理，例如添加日志
53：添加ActiveRecordPlugin.setPrimaryKey()用于强制指定主键名或复合主键名及其次序
54：优化com.jfinal.aop.Callback，提升性能
55：重构合并InterceptorBuilder、ActionInterceptorBuilder，去除冗余代码
56：改进Controller.renderJson(Object)，识别JsonRender类型对象，避免对其进行toJson转换
57：改进Controller中cookie操作，默认不设置domain与path值
58：改进Model.set()使Model可在未启动ActiveRecordPlugin场景下充当java bean使用
59：添加RedisInterceptor.getCache()，便于继承扩展切换Cache
60：改进FileRender，支持baseDownloadPath为应用以外的路径
61：添加Constants.setJsonDatePattern()，支持配置json转换Date类型时的pattern
62：I18nInterceptor.ge2：I18nInterceptor.ge2：I18nInterceptor.getLocalPara()更名为getLocalParaName()
63：c3p0升至0.9.5.1版本
64：删除 StringKit、NullLoggerFactory
1：改进BaseModelGenerator，引入JavaKeywork，支持表字段名为java语言关键词的情况
2：改进MetaBuilder，更好地支持Oracle，生成更友好的类名、方法名
3：改进MetaBuilder，抽取更多可用于扩展的方法有利于个性化扩展，例如 isSkipTable、buildModelName、buildAttrName等等
4：改进pagiante方法，支持 order by 子句中使用函数
5：改进paginate方法，添加带有String[] selectAndSqlExceptSelect参数的paginate、paginateByCache方法，支持select子句中嵌套select
6：改进Redis Cache，添加hincrBy与hincrByFloat方法
7：改进getModel()，支持CaseInsensitiveContainerFactory
8：改进keepModel()、keepBean()，支持""空串参数：keepModel(modelClass, "")

# jfinal 2.2 changelog
1：改进paginate，sql参数为 select与sqlExceptSelect，简单、粗爆、高效、可靠。
2：添加boolean isGroupBy 的pagiante重载方法，用于强制指定sql语句是否为grup by sql
3：改进ModelRecordElResolver，添加setResolveBeanAsModel()，使用生成器生成的实现了IBean接口的 Class 将被当成 Model来处理
4：改进Controller中cookie操作，默认path值设置为"/"，避免某些浏览器不支持无默认path
5：Jackson、JFinalJson 中 private 可见性改为protected，便于扩展出个性化 json 转换实现
6：改进CaptchaRender,添加CaptchaRender.setCaptchaName()方法便于定义captchName，cookie的path设置为 "/"
7：改进Model、Db 的 paginate 方法
8：FileRender.encodeFileName() 改为 protected 便于扩展，字符集改为使用 getEncoding() 来获取

# JFinal 3.0 changelog
https://www.oschina.net/news/81225/jfinal-3-0-released

# JFinal 3.1 changelog
https://www.oschina.net/news/84455/jfinal-3-1

# JFinal 3.2 changelog
https://www.oschina.net/news/87553/jfinal-3-2

# JFinal 3.3 changelog
https://www.oschina.net/news/90815/jfinal-3-3

