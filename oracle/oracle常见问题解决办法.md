# oracle常见问题解决办法

## PL连接本机上的64位oracle

```
第一步：
去oracle官网下载oracle11g 32位 client版本（免费的）。地址是：http://www.oracle.com/technetwork/database/features/instant-client/index-097480.html

第二步：
（1）解压客户端即可，无需安装。
（2）在解压目录instantclient_11_2下面新建目NETWORK\ADMIN。
（3）把oracle企业版安装目录下的product\11.1.0\db_1\NETWORK\ADMIN\tnsnames.ora文件拷贝到（2）中的ADMIN文件夹下。

第三步：
（1）打开PL，不登录任何账号，选择Cancel，以非登录模式进入PL。
（2）在PL工具栏下面选择Tools-->Preferences-->Oracle-->Connection：
    * 勾选check connection
    * Oracle Home = D:\software\oracle11g client\instantclient_11_2
    * OCI library = D:\software\oracle11g client\instantclient_11_2\oci.dll

第四步：
重启PL即可。
```

参考：[PL/SQL Developer如何连接64位的Oracle图解](http://blog.csdn.net/cselmu9/article/details/8070728/)

## 修改ORACLE的字符编码为UTF-8

```java
第一步：
进入注册表：HKEY_LOCAL_MACHINE-->SOFTWARE-->ORACLE-->ORACLE_HOME:把NLS_LANG值改为：
NLS_LANG=AMERICAN_AMERICA.UTF8

第二步：
以sys_dba的方式进入sqlplus，然后输入：
shutdown immediate;
startup mount;
alter system enable restricted session;
alter system set job_queue_processes=0;
alter system set aq_tm_processes=0;
alter database open;
alter database character set internal_use utf8;
alter database character set utf8;
shutdown immediate;
startup;
```

参考：[oracle数据库字符集的修改(改Oracle字符集到utf-8为例)](http://blog.csdn.net/nsj820/article/details/6571105/)
