# PD创建oracle表结构

## 新建PD项目
file-->new-->Physical Data Model-->DBMS选择对应的数据库类型-->First Diagram:Physical Diagram

## 新建物理表
Model-->tables

## name和code的区别
name是PD特有东西，表示字段的描述，类似于注解（但其实并不是注解）。code才是表的字段。一般我们会把name设置为中文名，code为表字段。PD默认把name和code设置为相等的。为了让name不跟着code一起变化，我们可以这么设置：Tools-->GeneralOptions-->Dialog-->取消勾选Name to Code Mirroring。

## PD中的字段数据类型
Length表示长度，比如varchar2(50)中的50，number(18,2)中的18。Precision表示精度，比如number(18,2)中的2。排序字段类型用number(18)，日期类型用date(如果需要支持国际化则用timestamp)。

unique_key在keys窗口设置：打开窗口，在Gereral页面中不要勾选Primary key，在Columns页面添加对应的字段。

设置字段默认值：双击字段-->Standard Checks-->Values-->Default:SYS_GUID()

## 导出建表语句
Database-->Generate Database-->Format-Encoding记得选UTF-8

## PD中表之间的关联如何表示
假设有一张用户表，一张单位表，用户表持有deptid，则打开用户表-->Extended Dependencies-->添加部门表，这样就会产生一条从用户表指向单位表的连接线。

