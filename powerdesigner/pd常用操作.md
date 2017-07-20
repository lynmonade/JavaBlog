# PD创建oracle表结构

## PD使用规范
* 表名所有字母大写
* 字段名采用与变量命名相同的驼峰命名法，方便使用代码生成器生成java bean
* PD导出的sql使用mix模式，即保持大小写字母不变，并采用UTF-8，防止.sql文件中文乱码
* 大量的insert语句应写在proc里面，而不是script里面，防止执行脚本时卡死
* 你无法手工调整.sql脚本中的table顺序，因为顺序是依赖与表之间的关系。但如果你的insert、update脚本是写死id的话，这也不会是问题
* 

## 新建PD项目
file-->new-->Physical Data Model-->DBMS选择对应的数据库类型-->First Diagram:Physical Diagram

## 新建物理表
Model-->tables

## 关于大小写
表名、字段名、约束名全部大写，遵循这一规范才能在PL中成功运行脚本。

## name和code的区别
name是PD特有东西，表示字段的描述，类似于注解（但其实并不是注解）。code才是表的字段。一般我们会把name设置为中文名，code为表字段。PD默认把name和code设置为相等的。为了让name不跟着code一起变化，我们可以这么设置：Tools-->GeneralOptions-->Dialog-->取消勾选Name to Code Mirroring。

## PD中的字段数据类型
Length表示长度，比如varchar2(50)中的50，number(18,2)中的18。Precision表示精度，比如number(18,2)中的2。排序字段类型用number(18)，日期类型用date(如果需要支持国际化则用timestamp)。

unique_key在keys窗口设置：打开窗口，在Gereral页面中不要勾选Primary key，在Columns页面添加对应的字段。

设置字段默认值：双击字段-->Standard Checks-->Values-->Default:SYS_GUID()

## PD中设置字段不能为空的约束
双击表-->Columns-->右键选择不能为空的字段-->Properties-->General-->勾选Mandatory

## PD中表之间的关联如何表示
假设有一张用户表，一张单位表，用户表持有deptid，则打开用户表-->Extended Dependencies-->添加部门表，这样就会产生一条从用户表指向单位表的连接线。

## 导出建表语句（有很多坑）
Database-->Generate Database，这里有几个坑需要注意：

* Format-->Encoding记得选UTF-8，否则导出的.sql的中文注释会乱码
* Format-->Character case，这里可以设置脚本的大小写。mix表示你写什么就是什么，建议使用mix。不建议使用upper，因为他会把所有小写（包括表名、字段名、字段值）都变成大写。
* 有时会把guid字段的默认值设置为sys_guid()，此时PD会自动为默认值添加单引号：`sys_guid()`，这不是我们期望的。去掉单引号的方法是：Database-->Edit Current DBMS-->Script-->Sql-->Syntax-->Quote-->去掉Value中的单引号。



