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

我使用的是第二种方法。注意，如果远程仓库和本地版本不一致，[我使用强制覆盖远程仓库。](https://www.cnblogs.com/davidgu/p/9072493.html)

###### 操作步骤：

1. 查询目前Git的远程仓库列表

   ```shell
   $ git remote -v
   origin  https://github.com/shanlanCoding/shanlancoding.github.io.git (fetch)
   origin  https://github.com/shanlanCoding/shanlancoding.github.io.git (push)
   ```
   
2. 添加需要备份的远程仓库URL

   `git remote set-url --add 本地仓库名 需要push的新仓库地址` 

   ```shell
   git remote set-url --add origin git@git.dev.tencent.com:shanl/shanl.git
   ```

###### 完整命令：

```shell
git remote set-url --add git@git.dev.tencent.com:shanl/shanl.git
```

再次查询远程仓库列表：

```shell
$ git remote -v
origin  https://github.com/shanlanCoding/shanlancoding.github.io.git (fetch)
origin  https://github.com/shanlanCoding/shanlancoding.github.io.git (push)
origin  git@git.dev.tencent.com:shanl/shanl.git (push)
```

这时候我们发现多了一个链接，而这个就是我们刚添加进入的。另外还有链接后面的括号，里面有push和fetch两种参数。fetch代表我们pull的地址，也就是我们上传代码到哪个仓库的地址，一般fetch地址只生效一个，即使多个也只使用第一个fetch地址。

我最初在添加新的远程仓库地址后，发现了我的fetch地址替换成新的仓库地址了，所以我还需要修改fetch的地址，具体解决方法参考这里：[Git 修改远程仓库URL，添加Fetch/Pull的URL的解决方法 | 山岚 - 90码农历险记]( https://shanlan.netlify.com/post/58974e7c.html)

