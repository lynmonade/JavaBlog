# 完整删除oracle11g

```java
1. 使用bat停掉oracle11g的服务
2. 开始－＞程序－＞%ORACLE_HOME%－＞Oracle Installation Products－＞ Universal Installer，单击“卸载产品”-“全部展开”，删除里面所有oracle相关的产品
3. 运行regedit，选择HKEY_LOCAL_MACHINE\SOFTWARE\ORACLE，按del键删除这个入口。
4. 运行regedit，选择HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services，滚动这个列表，删除所有Oracle入口(以oracle或OraWeb开头的键)
5. 运行refedit，HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Eventlog\Application，删除所有Oracle入口。
6. 删除HKEY_CLASSES_ROOT目录下所有以Ora、Oracle、Orcl或EnumOra为前缀的键。

7. 我的电脑-->属性-->高级-->环境变量,删除环境变量CLASSPATH和PATH中有关Oracle的设定。
8. 删除所有与Oracle相关的目录(如果删不掉，重启计算机后再删就可以了)包括：
    8.1 C:\Program file\Oracle目录
    8.2 ORACLE_BASE目录(oracle的安装目录)
    8.3 C:\WINDOWS\system32\config\systemprofile\Oracle目录
    8.4 C:\Users\Administrator\Oracle或C:\Documents and Settings\Administrator\Oracle目录
```

[参考：完全卸载oracle11g步骤](http://blog.csdn.net/machinecat0898/article/details/7792471)