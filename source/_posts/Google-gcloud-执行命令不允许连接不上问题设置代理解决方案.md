---
layout: w
title: Google gcloud 执行命令不允许连接不上问题设置代理解决方案
date: 2020-02-27 11:01:09
copyright: true
comments: true
toc: true
tags:
  - Shell
categories:
  - 服务器
---

# 问题原因

gcloud执行命令后，无法进如下一步，通常是因为在大陆不能连接Google服务器导致的。

解决方案很简单，找一个能连接Google代理，设置gcloud代理即可。

# 解决方法

1. `gcloud config list `查询当前的配置

![QQ图片20200227110753.png](E:\Sources\hexo\source\img\QQ图片20200227110753.png)

2. 我一开始连接gcloud的时候，提示让我设置一个代理，我这个代理ip以及端口都是正常的，对应的我本机的v2ray软件。但是一直连接不成功，原因是下面的type错误了。v2ray的type = socks5。所以这时我应该修改这个type类型为socks5
3. `gcloud config set proxy/type socks5`，CMD里输入这个命令，即设置成功。
4. `gcloud components list`命令，联网测试下看看能不能获取服务器的组件列表![QQ截图20200227111338.png](E:\Sources\hexo\source\img\QQ截图20200227111338.png)从上图看到，数据是成功的，说明此时命令可以执行了。
5. 我是要安装alpha组件，所以我执行命令:`gcloud components install alpha` ![QQ截图20200227111504.png](E:\Sources\hexo\source\img\QQ截图20200227111504.png)
6. 一顿操作猛如虎，组件安装成功，问题解决。

# 总结

1. 思考为什么不能执行命令？猜测是谷歌的服务器连接不上。

2. 如何连接谷歌的服务器？代理！V2ray本地端口的代理协议是socks5，如果是其它软件，你可以试试sockes4，或者http

   

   