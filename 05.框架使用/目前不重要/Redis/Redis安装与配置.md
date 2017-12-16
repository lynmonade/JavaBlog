#Redis for Windows安装

git源码地址：`https://github.com/MSOpenTech/redis`

压缩包地址：`https://github.com/MSOpenTech/redis/releases`，就像tomcat的压缩包一样，解压后即可使用。

#启动Redis
点击%REDIS_HOME%/redis-server.exe启动redis，然后点击%REDIS_HOME%/redis-cli.exe进入redis console。

#一些常用语句
在redis console中：

```
--测试redis是否可用：
set myKey aaa --设置一个key
get myKey --显示aaa

--给redis设置密码（redis默认没有密码）
CONFIG SET requirepass 123
```

# Reference
* [Redis本地环境搭建](https://github.com/cncounter/cncounter/blob/master/cncounter/src/test/resources/Redis%E6%9C%AC%E5%9C%B0%E7%8E%AF%E5%A2%83%E6%90%AD%E5%BB%BA.md)