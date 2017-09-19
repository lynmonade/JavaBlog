# Git安装

Git安装分为两步：

1. 安装Git：[下载地址](https://git-scm.com/downloads)。注意，这里只安装了Git本身，并没有安装Git的GUI软件（都21世纪了，安装Git的GUI工具吧，省得敲一堆git命令）
2. Windows安装[TortoiseGit](https://tortoisegit.org/download/)。Mac安装[SourceTree](https://www.sourcetreeapp.com/)

# Git容易混淆概念与操作

* 临时被叫去做hotfix
* origin是什么
* 各种状态：
* ​

其他的不再啰嗦了，参考下面文章：

* [Git Community Book 中文版](http://gitbook.liuhui998.com/index.html)
* [Git教程-廖雪峰](https://www.liaoxuefeng.com/wiki/0013739516305929606dd18361248578c67b8067c8c017b000)
* [阮一峰的网络日志](http://www.ruanyifeng.com/blog/)

# 四种分支管理开发模式

## 集中式工作流

只包含一个master分支，所有commit都pull到该分支上，这与svn的开发模式类似，比较原始，难以实现开发、测试、生产的版本控制。

## 功能分支工作流

增加了feature分支，开发人员在feature分支上开发新功能，然后再把feature分支merge到master分支上。如果是个人开发的简单项目，可以使用此模式，并建议增加develop分支作为feature分支的父分支。

## GitFlow工作流

包含feature分支、develop分支、release分支、master分支、hotfix分支。

1. feature分支：开发人员应该为每一个新开发的功能创建一个feature分支，功能开发完毕后，把feature分支合并到develop分支上。**（feature的父分支是develop）**
2. develop分支：该项目的所有开发完毕的功能都汇聚在develop分支上。开发人员在进组一个新项目时，都应该以checkout develop分支，并以它为基础创建feature分支。**（develop的父分支是release）**
3. release分支是发布前的黑盒测试分支。比如develop分支上新增了3个功能，这三个功能将作为大版本发布，这时应该以develop分支为父分支，创建一个release分支。测试人员在release分支上做测黑盒试、回归测试，开发人员在release分支作为父分支创建bugfix分支，并在bugfix分支上进行bug修缺。***修缺完毕后，bugfix要合并到release和develop上。最后，把release合并到master上形成稳定的生产环境版本，合并成功后，通常可以删除release分支。*****（release的父分支是master）**
4. master分支：可用于生产环境的分支。修缺完毕后的release分支将被merge到master分支。
5. hotfix分支：如果master分支上的代码出现bug，则基于master分支创建hotfix分支，在hotfix上快速修复bug，并merge到master分支和develop分支上。

## Forking工作流

严格来说，它并不是一种工作流，而是利用pull request操作实现code review，使项目能接受不信任贡献者的提交。在GitFlow工作流中，feature被pull到远端的develop上。然而在规范的团队中，开发人员的代码是不能直接把代码pull到远端develop分支上的，因为这可能会污染中心仓库的develop分支（比如提交一些不符合规范的代码）。

正确的做法是使用pull request，向远端仓库的管理员（通常是开发负责人）提出pull request申请，开发负责人先对pull request的代码进行code review，审核通过后才把代码合并到远端仓库的develop分支。

## 参考

* [[Comparing Workflows--译文](https://github.com/oldratlee/translations/blob/master/git-workflows-and-tutorials/README.md)]
* [Git 分支管理最佳实践](https://www.ibm.com/developerworks/cn/java/j-lo-git-mange/index.html)
* [git 分支-->知乎，第一个回答挺好的](https://www.zhihu.com/question/21995370)
* [Git分支管理策略](http://www.ruanyifeng.com/blog/2012/07/git.html)
* [总结\]静态白盒测试 - Code Review 1](http://blog.csdn.net/jiher/article/details/2674293)

# 场景1：Eclipse创建Git项目

假设老板看你骨骼惊奇，决定让你做开发负责人，那么你就需要从零开始为开发人员搭建好一个Git项目的骨架了。以eclipse为例：

1. `New-->Git-->Git Repository`创建一个Git仓库(不用选择bare repository)。比如我创建的目录地址：`D:\workspace\eclipse4x\gitProject`。至此，你在资源管理器下就能看到一个叫做gitProject的文件夹，里面只包含一个.git文件夹。
2. `File-->Import-->Git-->Projects from Git-->Existing local repository-->New Project wizard`把Git项目转化为Eclipse的模板项目，比如可以转化为Dynamic Web Project。至此，你的项目就具备了WebProject的特性，同时被Git所管理。
3. 添加`.gitignore`文件，忽略不需要git管理的文件。
4. 身为开发负责人，你应该根据项目需求，添加一些常用的代码到项目中，比如工具类，Spring配置文件等。
5. commit代码到本地/master分支。
6. 基于本地/master分支，创建本地/master分支。
7. push本地/master、本地/develop到远端仓库。此时远端仓库也将含有master、develop两个分支。

# 场景2：简单的多人项目开发

很多小公司、小团队还做不到code review，因此遵循以下步骤也基本可以得到版本控制的目标：

1. 开发负责人在Eclipse上创建Git项目，项目包含master分支和develop分支，两个分支都pull到远端代码库。
2. 开发人员clone项目到本地，并在本地/develop分支上做开发，功能开发完毕后把本地/develop推送至远端/develop分支。
3. 开发负责人对develop分支进行简单的review，并把远端/develop分支合并至远端/master分支。

# 场景3：Code Review项目开发

1. 开发负责人在Eclipse上创建Git项目，项目包含master分支和develop分支，两个分支都pull到远端代码库（中心仓库）。
2. 开发人员把中心仓库的项目fork到自己的GitHub账号（后面简称GitHub仓库）下。然后clone GitHub仓库到本地计算机。
3. 以本地/develop为父分支，创建本地/feature分支，并在feature上做开发。
4. 开发人员开发完该功能后，将本地/feature推送至GitHub仓库，至此GitHub仓库下将出现一个feature分支。
5. 开发人员以GitHub仓库/feature为源，以中心仓库/develop为目的地，像开发负责人发出pull request请求。**如果中心仓库/develop的代码已经较上一次拉取时发生了变化，则pull request失败。开发人员必须先把中心仓库/develop的代码合并到本地/feature分支中，合并成功后再pull request。**
6. 开发负责人收到pull request后，对代码进行code review（静态走查），如果代码没问题，开发负责人则把代码合并至中心仓库/develop。
7. 进行版本发布时，开发负责人以中心仓库/develop为父分支创建中心仓库/release分支，测试人员对中心仓库/release进行黑盒测试。开发人员以中心仓库/release为父分支创建本地/bugfix分支，并在bugfix上做修缺。修缺完毕后，bugfix合并到develop分支，并pull request到中心仓库/release。
8. 测试、修缺完毕后，开发负责人把release分支合并至master分支。最后可以把release分支删除。
9. 如果master分支的代码出错了，则直接在master分支上创建hotfix分支，在hotfix上修缺完毕后，把hotfix合并到develop和master上。

# 场景4：个人项目开发

方法同场景3：包含feature、develop、release、master、hotfix分支。唯一区别是feature分支直接pull到develop分支上，毕竟单人开发，没有pull request、code review一说了，都是自己做了。

# 场景5：对GitHub的开源项目做贡献

可参考[在Github和Git上fork之简单指南](https://linux.cn/article-4292-1-rss.html)，讲的实在是太好了。这里简单总结一下：

## 第一次fork

1. 使用fork操作（这是GitHub的操作，不是Git），把Joe的开源项目复制到你的GitHub账号下。此时，你的本地计算机还没有这个项目仓库。
2. 使用clone命令，把你的GitHub账号下的项目仓库复制到你本地计算机。这时，你的本地计算机就存储着这个项目了。
3. 切换至本地/develop分支（开源项目一般都有），并以develop为父分支创建feature分支，在feature上添加新的功能。
4. 使用commit命令，把修改的内容提交到本地/feature分支上。此时，你的GitHub仓库、Joe的GitHub仓库并不受影响。
5. 使用push命令，把修改本地/feature分支推送至你的GitHub仓库。此时你的GitHub仓库将生成一个新的feature分支。但Joe的仓库并不受影响。
6. 使用pull request操作（这是GitHub的操作），向Joe发送一个pull request请求，如果Joe觉得你的代码有价值，就会接受你的修改请求，把你的代码合并到Joe的仓库中。否则Joe将忽略你的pull request请求。

![摘至《在Github和Git上fork之简单指南》](https://dn-linuxcn.qbox.me/data/attachment/album/201411/24/162415ki4zz0z7zy14zv3y.png)

## 修改时获取最新代码

 如果你正处在“第一次fork”的第三步，此时另一个贡献者已经成功pull request，他的代码已经被Joe所采纳，这时你本地计算机的仓库、你的GitHub仓库与Joe的仓库代码是不一致的。这时应该这么做：

1. 使用fetch命令，从Joe的仓库中取出那些变化的文件，此时这些文件已经存储在你本地计算机中，但还没有合并到你的项目里（被git保存在一个临时分支中）
2. 使用merge命令把变化的内容合并到你的本地计算机项目仓库中（1和2两个步骤合并起来就是pull命令）。如果有冲突的话还必须手工解决冲突。
3. 使用commit命令，提交修改的内容到本地计算机项目仓库的feature分支上，最后使用push命令把本地feature分支提交至你的GitHub仓库下。
4. 使用pull request命令，请求把GitHub仓库的feature分支合并到Joe仓库的develop分支中。

![摘至《在Github和Git上fork之简单指南》](https://dn-linuxcn.qbox.me/data/attachment/album/201411/24/162416icr0h6wzr6ec2jze.png)

# 一些有用的技巧

- 团队开发时遵循git-flow，使用5个分支的模式进行版本控制，使用pull request开展code review。
- 推荐使用Maven开发。只提交必要的文件，无需提交eclipse自动生成的文件。
- 多人开发时，规划每一个开发人员所负责的模块，尽量不要重叠，不要出现多个开发人员编辑同一个文件，这样在合并时轻松很多。
- 对于公共的配置文件，建议按模块拆分。拆分不了的话，合并时要特别留意，防止覆盖人家写的配置信息。
- 据说集成Jenkins会更牛逼
- ​