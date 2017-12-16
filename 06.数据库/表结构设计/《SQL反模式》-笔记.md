# 第二章 不要乱穿马路

问题：

不要用分隔符拼接的方式，来保存多一对多、多对多的关系。

```java
product_id         bug_id
100				   11,12,13,14,15
```

解决办法：使用中间表product_bug

# 第三章 单纯的树

需要先复习数据结构

# 第四章 需要ID 

问题：

1. 对于单体表，存在无意义的id字段作为主键，这也成为伪主键。
2. 对于中间表，存在无意义的id字段作为主键，这也成为伪主键。(以此来代替符合主键)

解决办法：

1. 对于单体表，应该使用具有实际意义的主键名，比如dept_id
2. 对于中间表，个人认为，既可以采用伪主键id来避免符合主键，也可以直接采用符合主键，但无论如何，都要对中间表的两个关联字段做UNIQUE索引，确保唯一性。

```java
create table product_bug (
	id varchar(50) primary key, 
  	bug_id varchar(50) not null,
  	product_id varchar(50) not null,
  	unique key(bug_id, product_id)
);
```

备注：阿里规范建议对中间表创建伪主键id。

# 第5章 不用钥匙的入口

问题：

两个有关联的表，如果需要删除一条记录，如果不用外键，则需要手工在两个表中都删除记录，才能避免垃圾数据的存在。

解决办法：

* 书中建议使用外键，级联更新，删除。这样如果你删除主表的记录，如果设置了外键，则数据库是不允许你删除的，因为这样子表中的记录就变成了孤魂。
* 此外数据库提供了级联更新、级联删除的功能，当你删除主表记录时，数据库会自动删除子表的相关记录。
* 互联网企业的做法：**不使用外键，而是用Java代码来处理级联删除、孤魂记录的问题。这样的做法是把一致性问题转移到了Java端去解决，有效减轻数据库的压力。**[详见知乎帖子](https://www.zhihu.com/question/19600081)。

# 第6章 实体-属性-值

实体-属性-值简称EAV，也就是说把物理表设置为key-value的dictionary形式，使之可以无限扩展属性：

```java
create table dic (
	guid varchar(50) primary key,
  	key  varchar(100) not null,
  	value varchar(1000)
);
```

问题：

EAV模式与传统的行列存储思路不同，它把“原本的列”放到了行进行存储，虽然获得了“无限扩展key”的优势，但在查询时非常麻烦，经常要涉及到行列转换。

解决办法：

在设计物理表时如果使用EAV模式，则需要慎重的考虑在写select语句时是否需要复杂的行列转换，如果不需要，则EAV模式是一个不错的选择。否则，你应该采用如下三种解决办法：

(1) 单表继承：也就是把共有属性和私有属性都塞到一张表里，虽然这会造成某些格子是空值，但写select语句时非常简单有效。

```sql
create table Issues (
	issue_id varchar(50) primary key,
  	report_by varchar(50) not null, --both
  	priority varchar(20), --both
  	status varchar(20), --both
  	issue_type varchar(20),  --both
  	severity varchar(10), --only for bugs
  	version_affected varchar(20), --only for bugs
  	sponsor varchar(20) --only for feature requests
);
```

(2) 实体表继承：把bugs和feature requests两个实体保存的独立的物理表中。虽然有些字段是一模一样的。这样的是不会出现“空洞格子”。但如果你对公共字段进行函数操作时，则不得不把量表join在一起。或者在java代码中操作。

```sql
create table bugs (
	issue_id varchar(50) primary key,
  	report_by varchar(50) not null, --both
  	priority varchar(20), --both
  	status varchar(20), --both
  	issue_type varchar(20),  --both
  	severity varchar(10), --only for bugs
  	version_affected varchar(20) --only for bugs
);
create table feature_requests (
	issue_id varchar(50) primary key,
  	report_by varchar(50) not null, --both
  	priority varchar(20), --both
  	status varchar(20), --both
  	issue_type varchar(20),  --both
  	sponsor varchar(20) --only for feature requests
);
```

(3) 类表继承：把公共字段保存在issues表中，把私有字段保存在bugs和feature_requests表中。但这样做查询时有时得要join一次。

```sql
create table Issues (
	issue_id varchar(50) primary key,
  	report_by varchar(50) not null, --both
  	priority varchar(20), --both
  	status varchar(20), --both
  	issue_type varchar(20)  --both
);
create table bugs (
	issue_id varchar(50) primary key,
  	severity varchar(10), --only for bugs
  	version_affected varchar(20) --only for bugs
);
create table feature_requests (
	issue_id varchar(50) primary key,
  	sponsor varchar(20) --only for feature requests
);
```

(4) 半结构化数据模型：把各自的私有字段值格式化为JSON字符串，并创建名为attributes的text字段保存json字符串。这样做的好处是可以"无限扩展私有字段"，但数据库无法对私有字段的类型\值做约束，也无法解析，约束和解析工作都转嫁到了java端。

```sql
create table Issues (
	issue_id varchar(50) primary key,
  	report_by varchar(50) not null, --both
  	priority varchar(20), --both
  	status varchar(20), --both
  	issue_type varchar(20),  --both
  	attibutes text not null --all dynamic attributes for the row
);
```









