# 文件对比
场景：show log，针对某次提交记录中的单个文件进行对比。(1),(2)主要用于对比，(3)因为涉及到working tree，所以可以根据对比结果修改working tree。**修改的方法是：直接编辑working tree那一侧窗口的源码，直接键入、复制、粘贴都可以。**

(1) Compare with base
打开的对比窗口基于所选中的commit，左边的窗口是“这个commit之前的版本(也就是上一个commit所产生的稳定版本)”，右边的窗口是“这个commit之后产生的稳定版本”。

(2) Show changes with unified diff
这个对比可以看做是Compare with base的另一个视图。它对比的东西和Compare with base完全一致，只不过该视图只显示修改的地方，不冗余显示相同的代码。

(3) Compare with working tree
打开的对比窗口基于所选中的commit，左边的窗口是“这个commit之后产生的稳定版本”，右边的窗口是“当前本地工作区的代码”。
