---
title: Hexo优化教程
abbrlink: ad2324d4
date: 2019-06-09 21:17:09
toc: true
tags:
- Hexo
categories:
- 博客优化
---
# 优化教程

###### [hexo的next主题个性化教程:打造炫酷网站](http://shenzekun.cn/hexo的next主题个性化配置教程.html)

###### [使用hexo，如果换了电脑怎么更新博客？ - 知乎]( https://www.zhihu.com/question/21193762)

###### [hexo链接持久化终极解决之道 ](https://blog.csdn.net/yanzi1225627/article/details/77761488)
###### [bat批处理脚本自动部署Hexo博客 ](https://blog.csdn.net/qq_21808961/article/details/84868482) 

###### [window下bat脚本自动push/pull ](https://blog.csdn.net/ekey_code/article/details/79587742)

###### [Hexo使用攻略-添加分类及标签](https://linlif.github.io/2017/05/27/Hexo%E4%BD%BF%E7%94%A8%E6%94%BB%E7%95%A5-%E6%B7%BB%E5%8A%A0%E5%88%86%E7%B1%BB%E5%8F%8A%E6%A0%87%E7%AD%BE/)

###### [解决新浪/微博图床图片403错误防盗链问题](https://blog.gobyte.cn/post/cfce32d8.html)

###### [解决git停留在writing objects和上传慢的情况](https://www.jianshu.com/p/704dc6b0bb18)



# Git本地和仓库冲突，Pull报错怎么办？

冲突解决三部曲：

```shell
git stash // 备份工作区和恢复上次提交后的状态
git pull // 拉取仓库的代码
git stash pop // 恢复 git stash 的备份
```

流程如下

1. 备份当前的工作区，并恢复到上次提交后的状态
2. 拉取服务器的代码
3. 恢复第一步备份的数据到工作区

相关命令解释

`git stash`：备份当前的工作区的内容，从最近的一次提交中读取相关内容，让工作区保证和上次提交的内容一致。同时，将当前的工作区内容保存到Git栈中。

`git pull`:拉取服务器上的代码；

`git stash pop`：从Git栈中读取最近一次保存的内容，恢复工作区的相关内容。由于可能存在多个Stash的内容，所以用栈来管理，pop会从最近的一个stash中读取内容并恢复。

`git stash list`：显示Git栈内的所有备份，可以利用这个列表来决定从那个地方恢复。

`git stash clear`：清空Git栈。此时使用gitg等图形化工具会发现，原来stash的哪些节点都消失了。



