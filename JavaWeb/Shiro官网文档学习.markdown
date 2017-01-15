# Shiro官网文档学习
## Authentication

>Authentication is the process of identity verification - that is, proving a user actually is who they say they are.

Authentication翻译过来是认证，最常见的例子就是登录认证。即证明**“你是你”**。

### Authentication中容易混淆的概念
#### Principals
Principals可以理解为是用户名。也就是能唯一辨别你的东西，比如邮箱地址，手机号之类的。 

#### Credentials
Credentials可以理解为是密码。这里说的密码是广义上的，比如你使用生物认证，那密码有可能就是指纹了...

#### Subject
Subject可以理解为是一个用户

#### Token
用于封装用户提供的认证信息。当用户使用用户名/密码的形式进行认证时，就可以使用`UsernamePasswordToken`类来封装用户名和密码。此外，用户也可以使用其他信息进行认证，如果证书认证，则使用其他Token类来封装。

#### Realm
用于封装系统中保存的认证信息。系统可以把用户名和密码保存在数据库中，也可以保存在文件中，甚至其他方式。无论如何，最终系统都把这些认证信息封装到一个Realm中。在认证时，如果Realm与Token信息匹配，则认证成功。


## 类介绍

* AuthenticationToken：用户传过来的认证信息会被封装到AuthenticationToken的具体实现类中，常用的实现类有UsernamePasswordToken。在Realm接口有有一个support()方法，专门用于验证这个realm的认证是否支持该Token。
* SecurityManager：它持有认证器，调用login()方法进行认证时，实际是转调其内部的认证器进行认证。
* Authenticator：认证器，它持有AuthenticationStrategy，并调用各个Realm进行认证，最后根据AuthenticationStrategy策略，把各个realm的认证结果进行组合。常用实现类有：ModularRealmAuthenticator
* AuthenticationInfo：用于封装登录验证后，成功或失败的信息。
* AuthenticationStrategy：认证组合策略，各个realm的结果将按照该策略进行组合，实现类包括：`AtLeastOneSuccessfulStrategy, FirstSuccessfulStrategy,AllSuccessfulStrategy`
* AuthenticatingRealm、CredentialsMatcher：用于具体的密码匹配比对工作。shiro也提供了一些默认比对实现类： SimpleCredentialsMatcher、 HashedCredentialsMatcher。


## 认证过程 [参考](http://shiro.apache.org/authentication.html#Authentication-sequence)
在认证过程中，SecurityManager持有一个Authenticator，具体的实现类一般是ModularRealmAuthenticator，这是shiro提供的类，大多数情况下够用了。ModularRealmAuthenticator将按顺序调用你的Realm的getAuthenticationInfo方法，以获取该realm的认证结果，最终再根据AuthenticationStrategy策略，对多个realm的认证结果进行组合形成最终结果，最终结果以AuthenticatinoInfo形式作为产出。

如果你要实现自定义realm，可以继承AuthorizingRealm抽象类，不用去实现Realm接口。这样节约时间。

