---
title: Clover资源管理器你在干什么？
copyright: true
comments: true
toc: true
tags:
  - 
categories:
  - windows
abbrlink: c7144fb7
date: 2019-08-18 13:31:55
---

偶然间查看杀毒软件的日志，发现有个木马病毒的记录，原来是Clover程序在后台自动联网下载，不过被杀软拦截了，详情如下图：

![1566106657051](//ws1.sinaimg.cn/large/96e311f0gy1g63rzqjibbj20s508lwez.jpg)

通过浏览器打开：[down.shusw.com/clv/upd/clv_sp3.5.1.gif](down.shusw.com/clv/upd/clv_sp3.5.1.gif)后，发现确实是一张很小的图片。但是，你以为事情就是这么简单吗？![image](//ws2.sinaimg.cn/large/96e311f0gy1g63rwtqu8fj20yc0ihaaz.jpg)

仔细看waterfall的进度条很长，可以简单的理解为网页是由图片、js文件、css文件等组成的。而网页在打开的时候是优先级的顺序来下载的。如果一个文件的waterfall进度条很长，说明这个文件加载的时间也很长。

然后我们仔细看Time这一列，发现总用时4.19S，但是页面中的图片很小，看起来不超过10KB，为什么需要加载4.19S？是对方服务器太慢了吗？直觉判断不是这样，然后仔细看network工具里面的Size列，发现了吗？11.7，单位MB。天哪，什么图片有11.7MB大？果然有问题，根据经验判断，这不是一张普通的图片，更像是图片和文件打包在一起伪装成图片。所以我复制该图片链接，通过浏览器的下载管理下载了下来，下载后的文件属性图如下：

![image](//wx1.sinaimg.cn/large/96e311f0gy1g63sbooi2aj20dg0iamy5.jpg)

![image](//wx2.sinaimg.cn/large/96e311f0gy1g63sbatm05j20dg0hcwf2.jpg)

我仔细查询了这个签名，Shanghai Oriental Webcasting Co. Ltd.它是“上海东方网股份有限公司”，看样子是家正规公司，应该不会去破坏普通人的电脑。

------------------

重点来了，一张图片没什么内容，但是体积缺异常庞大，这肯定不正常。为了验证我上面的猜测，猜测它是一个伪装的文件。所以我将该文件的后缀名修改为“rar”压缩文件，确实打开成功，如下图：

![image](//ws4.sinaimg.cn/large/96e311f0gy1g63sfyma8ej20x00f4jtf.jpg)

从目录结构以及文件名来看，它确实是Clover的安装包，目前杀软没有报毒，也没有其他行动。我只能单纯的认为作者是想通过这种方式，去更新它的软件，而不是有其他的图谋在里面。另外还是希望作者少一些流氓，多一些真诚，不要用技术作恶，毕竟电脑软件是否该更新应该让消费者去决定，而不是喧宾夺主成为电脑的主人。

-----

### 解决方法

使用火绒的联网控制功能，对这个EXE程序进行阻止联网即可，如下图：

![image](//ws2.sinaimg.cn/large/96e311f0gy1g63swyuc7nj20mo0er759.jpg)

