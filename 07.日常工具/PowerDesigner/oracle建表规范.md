# oracle建表规范

每个表都必须带有guid, gmt_create, gmt_modified字段。

guid的类型为varchar2(50)，他作为物理表的pk，默认值是sys_guid()。不能命名为id，因为id是oracle的保留关键字。

guid作为一个表的主键后，就无需另外创建另一个唯一字段了，比如无需在部门表里再创建一个dept_id。

gmt_create表示创建时间，gmt_modified表示修改时间，数据类型都是date。

排序字段使用INTEGER类型，其范围与java的INTEGER数据范围相同，基本上够用了。建议逻辑相邻的行之间间隔10，并且每隔一段时间检查物理表的排序稀疏性，并在必要时重新排序以确保稀疏性。排序字段建议命名为sorting，不能命名为sort，那是oracle的保留关键字。

可选值少于等于5时建议使用枚举类型，枚举类型使用char(1)，并且在sys_dirt字典表里创建枚举key与value的映射。

不建议创建外键，只需要提前约定好即可。比如在sys_user用户表里需要添加一个字段引用sys_dept表的guid，则只需要在sys_user表里添加dept_id字段即可。






