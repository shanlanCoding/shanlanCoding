---
title: Git 修改远程仓库URL，添加Fetch/Pull的URL的解决方法
copyright: true
comments: true
toc: true
tags:
  - Git
categories:
  - 博客优化
abbrlink: 58974e7c
date: 2019-08-19 11:49:45
---

# 缘由

由于之前操作，将仓库的fetch地址也就是pull地址，设置成了coding了，但是我需要从GitHub上面pull，所以需要修改。之前设置远程仓库地址都是设置的push，还没有找到设置pull（fetch）地址的方法。所以我直接是修改Git的配置文件config来解决。

# 解决方法

1. 打开你的仓库目录，打开Windows设置，显示系统隐藏文件，然后就可以看见`.git`文件夹，而`config`文件就在这个文件夹内

2. Git里远程仓库地址是这样的：

   ```shell
   $ git remote -v
   origin  git@git.dev.tencent.com:shanl/shanl.git (fetch)
   origin  git@git.dev.tencent.com:shanl/shanl.git (push)
   origin  https://github.com/shanlanCoding/shanlancoding.github.io.git (push)
   ```

3. 现在需要把第三个链接`origin  https://github.com/shanlanCoding/shanlancoding.github.io.git (push)`

   改成`origin  https://github.com/shanlanCoding/shanlancoding.github.io.git (fetch)`

   而第一个链接`origin  git@git.dev.tencent.com:shanl/shanl.git (fetch)`应当删除

4. git的config文件打开后长这样：

   ```shell
   [core]
   	repositoryformatversion = 0
   	filemode = false
   	bare = false
   	logallrefupdates = true
   	symlinks = false
   	ignorecase = true
   [remote "origin"]
   	fetch = +refs/heads/*:refs/remotes/origin/*
   	url = git@git.dev.tencent.com:shanl/shanl.git
   	url = https://github.com/shanlanCoding/shanlancoding.github.io.git
   [branch "HEXO"]
   	remote = origin
   	merge = refs/heads/HEXO
   ```

5. 将`[remote "origin"]`栏目下的`url = https://github.com/shanlanCoding/shanlancoding.github.io.git`剪切，然后移动到`fetch = +refs/heads/*:refs/remotes/origin/*`上一行粘贴，最终如下：

   ```shell
   [core]
   	repositoryformatversion = 0
   	filemode = false
   	bare = false
   	logallrefupdates = true
   	symlinks = false
   	ignorecase = true
   [remote "origin"]
   	url = https://github.com/shanlanCoding/shanlancoding.github.io.git
   	fetch = +refs/heads/*:refs/remotes/origin/*
   	url = git@git.dev.tencent.com:shanl/shanl.git
   [branch "HEXO"]
   	remote = origin
   	merge = refs/heads/HEXO
   ```

6. 回到Git命令行查询结果：

   ```shell
   $ git remote -v
   origin  https://github.com/shanlanCoding/shanlancoding.github.io.git (fetch)
   origin  https://github.com/shanlanCoding/shanlancoding.github.io.git (push)
   origin  git@git.dev.tencent.com:shanl/shanl.git (push)
   ```

   此时可以看到GitHub的仓库地址已经变成了fetch了，而腾讯的已经只剩下push了，达到预期效果，**成功解决问题！**

