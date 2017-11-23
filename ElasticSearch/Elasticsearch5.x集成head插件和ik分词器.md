# Win7-64位安装Elasticsearch5.x，head插件，ik分词器

## 搭建Elasticsearch5.x

Elasticsearch是基于Java的，因此需要先安装JDK，ES5.X建议安装JDK8。

[Elasticsearch最新版的下载地址](https://www.elastic.co/downloads/elasticsearch)。如果想要以前的旧版，则去[这里](https://www.elastic.co/downloads/past-releases)下载。我用的是Elasticsearch5.5.2版本，下载后解压，然后双击`ES_HOME/bin/elasticsearch.bat`即可启动ES。在浏览器输入`http://localhost:9200`，如果出现下面的结果，则表明ES启动成功了。

```json
{
  "name" : "LDyhdR9",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "J3h30w8rQBGzuq76uLN0pg",
  "version" : {
    "number" : "5.5.2",
    "build_hash" : "b2f0c09",
    "build_date" : "2017-08-14T12:33:14.154Z",
    "build_snapshot" : false,
    "lucene_version" : "6.6.0"
  },
  "tagline" : "You Know, for Search"
}
```

## 在windows下修改ES的内存

在`ES_HOME/config/jvm.options`文件中，把最大和最小内存配置都都修改为256m。（ES默认配置是2g，我的小霸王学习机受不了）。

```shell
#注释掉默认配置
#-Xms2g
#-Xmx2g

#修改为256m
-Xms256m
-Xmx256m
```

## 对ES进行简单配置

ES的大部分配置都写在`ES_HOME/config/elasticsearch.yml`中，可以添加如下配置：

```shell
# 设置ES集群的名字
cluster.name: es-5.0-test

# 设置节点名称
node.name: node-101

# 修改一下ES的监听地址，这样别的机子也能访问到
network.host: 0.0.0.0

# 设置ES默认端口
http.port: 9200

# 增加新的参数，这样head插件可以访问ES
http.cors.enabled: true
http.cors.allow-origin: "*"
```

## 集成head插件

安装head插件之前，需要先安装node.js，然后安装grunt，通过grunt来启动head插件。

第一步：去[官网下载](https://nodejs.org/en/)并安装node.js，无脑下一步。打开cmd（哪个目录都可以，因为安装node.js后，node.js的安装路径会自动加入到PATH变量中），使用`node -v`命令检测node.js是否安装成功。

第二步：配置node.js。把node.js的中央库指向阿里的镜像，这样安装grunt、编译head会快很多。打开cmd，输入以下命令：

```shell
npm config set registry https://registry.npm.taobao.org 
```

第三步：安装grunt。在cmd下输入如下命令：

```shell
npm install -g grunt-cli
```

第四步：从github克隆head源码。

```java
git clone git://github.com/mobz/elasticsearch-head.git
```

第五步：修改head配置文件。修改`head_HOME/Gruntfile.js`，增加hostname属性。

```shell
connect: {
    server: {
        options: {
            port: 9100,
            hostname: '*',
            base: '.',
            keepalive: true
        }
    }
}
```

修改`head_HOME/_site/app.js`文件，把：

```shell
this.base_uri = this.config.base_uri || this.prefs.get("app-base_uri") || "http://localhost:9200";
```

修改为：

```shell
this.base_uri = this.config.base_uri || this.prefs.get("app-base_uri") || "http://192.168.2.103:9200";
```

第六步：用npm编译head源码。进入head根目录，在cmd下输入编译命令：`npm install`。这一步特别慢。

第七步：使用cmd进入head源码根目录，并使用`grunt server`命令启动head。在浏览器中访问`http://localhost:9100`，即可进入head的首页查看head所连接的ES的健康状况。

## 集成ik分词器

我们需要慎重的选择ik分词器的版本，ik分词器的版本必须ES的版本一致，这一点在[ik的github首页](https://github.com/medcl/elasticsearch-analysis-ik)有介绍。因为我们使用的是Elasticsearch5.5.2版本，因此这里下载的也是ik5.5.2版。ik的github上提供了ik源码和编译好的release版本（zip格式），使用zip包更便于集成：[下载地址](https://github.com/medcl/elasticsearch-analysis-ik/releases)

第一步：解压elasticsearch-analysis-ik-5.5.2.zip到名为elasticsearch-analysis-ik-5.5.2的文件夹下。里面还包含一个名为elasticsearch的子文件夹。子文件夹下才是ik相关的文件。

![](http://wx1.sinaimg.cn/mw690/0065Y1avgy1flsf6pty86j30it08wjri.jpg)

第二步：在`ES_HOME/config/`目录下新建一个名为ik的文件夹。然后把`IK_HOME/elasticsearch/config/`目录下的所有文件都拷贝到刚刚新建的文件夹下。

![](http://wx4.sinaimg.cn/mw690/0065Y1avgy1flsf6pcnvkj30is0bojrl.jpg)

第三步：在`ES_HOME/plugins/`目录下新建一个名为ik的文件夹。然后把`IK_HOME/elasticsearch/`目录下的所有文件都拷贝到刚刚新建的文件夹下。

![](http://wx2.sinaimg.cn/mw690/0065Y1avgy1flsf6qp6kgj30i808u0st.jpg)

## Reference

* [windows环境下ElasticSearch5以上版本安装head插件](http://blog.csdn.net/yx1214442120/article/details/55102298)
* [Windows下ElasticSearch安装中的问题解决](http://blog.csdn.net/wonderluoying/article/details/53363971)
* [[ElasticSearch5.3安装IK分词器并验证](http://blog.csdn.net/u010504064/article/details/70214040)](http://blog.csdn.net/u010504064/article/details/70214040)

