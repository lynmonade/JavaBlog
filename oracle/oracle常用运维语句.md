# oracle常用运维语句

## 整库导入导出

```sql
--在PL中构造alter语句，执行空表初始化操作
select 'alter table '||table_name||' allocate extent;' from user_tables where num_rows=0;

--在cmd下执行整库导出语句
exp dwjhb/dwjhb@orcl_82 buffer=4096000 owner=dwjhb  file="d:\bak\BAK_82_dwjhb%date:~0,4%%date:~5,2%%date:~8,2%.DMP" log="BAK_82_dwjhb%date:~0,4%%date:~5,2%%date:~8,2%.txt"

--整库导入
--在自己的电脑上打开cmd，建立与139数据库的连接
sqlplus /nolog
conn system/123456@172.16.8.139:1521/orcl

--表空间下线
alter tablespace dwjhb offline;

--删除用户
drop user dwjhb cascade;

--删除表空间的物理文件
DROP TABLESPACE dwjhb INCLUDING CONTENTS AND DATAFILES;

--创建表空间，需要制定物理文件的位置
create tablespace dwjhb  logging   datafile 'G:\dwjhb_data\DWJHB_DATA.DBF'   size 4096m   autoextend on   next 100m  maxsize unlimited extent management local;

--创建用户
create user dwjhb identified by dwjhb default tablespace dwjhb temporary tablespace temp; 

--给用户赋DBA权限
grant connect,resource,dba to dwjhb;

--或者给用户赋普通权限
REVOKE DBA FROM dwjhb;
grant connect to dwjhb;
grant resource to dwjhb;
grant create session to dwjhb;
grant exp_full_database to dwjhb;
grant imp_full_database to dwjhb;
grant unlimited tablespace to dwjhb;
grant select any table to dwjhb;
grant insert any table to dwjhb;
grant delete any table to dwjhb;
grant update any table to dwjhb;

--回到cmd中，整库导入
imp dwjhb/dwjhb@orcl_139 file="D:\bak\BAK_82_dwjhb.DMP" fromuser=dwjhb touser=dwjhb commit=yes ignore=yes

--或者用这条语句导入
imp dwjhbmp/dwjhbmp@orcl_139 full=y file=e:\mp.dmp statistics=none
```

## 创建DBLink

```sql
--创建DBLink
create public database link gdzc
connect to dwjhb identified by dwjhb
using '(DESCRIPTION =
(ADDRESS_LIST =
(ADDRESS = (PROTOCOL = TCP)(HOST = 172.16.8.139)(PORT = 1521))
)
(CONNECT_DATA =
(SERVICE_NAME = orcl)
)
)';
```

## 删除顽固表空间的方法

```sql
--1.得出alter语句
select 'alter table '||owner||'.'||table_name||' drop constraint '||constraint_name||' ;' 
from dba_constraints 
where constraint_type in ('U', 'P') 
   and (index_owner, index_name) in 
       (select owner, segment_name 
          from dba_segments 
         where tablespace_name = upper('evsjsb'));
		 
--2.执行alter语句

--3.如果2搞不掂，则改为执行drop table语句
drop table EVSJSB0805.DPS_ISSUETYPE cascade constraints; 
```
## 数据库关闭开启

```sql
SHUTDOWN IMMEDIATE --关闭数据库
STARTUP  --开启数据库
```

## 数据库监听器

```sql
lsnrctl status  --检查当前监听器的状态
lsnrctl start [listener-name]  --启动所有的监听器,可以指定名字来启动特定的监听器
lsnrctl stop [listener-name]   --关闭所有的监听器，可以指定名字来关闭特定的监听器
lsnrctl reload  --重启监听器，此命令可以代替lsnrctl stop,lsnrctl start
lsnrctl hep  --可以显示所有可用的监听器命令

/*
注
1. 使用oracle的startup命令并不会重启监听，必须使用监听的关闭、开启命令重新加载监听配置文件，重启监听
2. 监听配置文件名为listener.ora，位于D:\software\instantclient_11_2\NETWORK\ADMIN\下面

listener.ora的格式：
SID_LIST_LISTENER =
  (SID_LIST =
    (SID_DESC=
     (GLOBAL_DBNAME = ORCL)
     (ORACLE_HOME =D:\software\app\Roger\product\11.1.0\db_1)
     (SID_NAME = ORCL)
    )
  )

LISTENER =
  (DESCRIPTION =
    (ADDRESS =(PROTOCOL = TCP)(HOST = localhost)(PORT = 1521))
  )
*/
```



