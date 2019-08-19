---
title: 使用Git让HEXO多备份源程序到GitHub和Coding等网站
copyright: true
comments: true
toc: true
tags:
  - Git
categories:
  - 博客优化
abbrlink: '54986170'
date: 2019-08-19 11:51:17
---

# 为什么要这样操作？

因为某些原因导致GitHub在国内的pull速度太慢了，所以我想着以后如果把代码push到国内的网站，这样初次pull项目的时候就非常的快。但是GitHub又比较常用，通常代码都是要push到GitHub上，所以如果能在push的时候，能同时push多个仓库就是极好的。

# 解决方法

完整解决教程：[一个项目push到多个远程Git仓库]( https://segmentfault.com/a/1190000011294144)

我使用的是第二种方法。注意，如果远程仓库和本地版本不一致，[我使用强制覆盖远程仓库。](git强制提交本地分支覆盖远程分支 - Master HaKu - 博客园 - https://www.cnblogs.com/davidgu/p/9072493.html)

```shell
//代码解释
git remote -v // 查远程仓库列表；仓库名和仓库地址
git remote set-url --add github https://git.oschina.net/zxbetter/test.git // git remote set-url --add 本地仓库名 远程仓库地址。这行代码的作用是指定一个本地仓库，然后添加一个远程仓库地址
```

