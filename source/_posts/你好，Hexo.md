---
title: GIT push三部曲
abbrlink: 8ec25db2
date: 2019-06-07 03:39:47
tags:
  - Hexo
categories:
  - 博客优化
---



### GIT push三部曲：

```Git
git add .
git commit –m "注释"  # 或者：git push origin hexo
git push 
```

HEXO命令：

编写文章之前，请pull：

`git pull`

```bash
hexo generate//简写hexo g 
hexo g -d//文件生成后立即部署网站
hexo g -w//监视文件变动
```

