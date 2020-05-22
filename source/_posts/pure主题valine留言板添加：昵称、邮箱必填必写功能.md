---
title: pure主题valine留言板添加：昵称、邮箱必填必写功能
copyright: true
comments: true
toc: true
abbrlink: e56fdb88
date: 2020-05-22 20:47:06
tags:
- Hexo
categories:
- 博客优化
---

# 起因

很多网友在留言的时候，懒得去添加自己的邮箱，导致即使我回复对方也无法收到通知，所以需要给留言板的邮箱字段增加必填的功能。

# 解决

留言板使用的valine，该插件提供了必填的[配置项](https://valine.js.org/configuration.html#requiredFields)，但是我使用的[pure主题](https://github.com/cofess/hexo-theme-pure)由于作者没有更新，所以对该功能不支持。下面开始对pure主题进行修改：

1. 找到文件`pure\layout\_script\_comment\valine.ejs`，替换如下代码：

   ```typescript
   <% if (typeof(script) !== 'undefined' && script) { %>
     <script src="//cdn1.lncld.net/static/js/3.0.4/av-min.js"></script>
     <script src="//cdn.jsdelivr.net/npm/valine"></script>
     <script type="text/javascript">
   
     var GUEST = ['nick', 'mail', 'link'];
   
     var meta = '<%= theme.comment.valine.meta %>';
     meta = meta.split(',').filter(function(item) {
       return GUEST.indexOf(item) > -1;
     });
   
     var requiredFields = '<%= theme.comment.valine.requiredFields %>';
     requiredFields  = requiredFields.split(',');
   
   
     new Valine({
       el: '#vcomments',
       verify: <%= theme.comment.valine.verify %>,
       notify: <%= theme.comment.valine.notify %>,
       appId: '<%= theme.comment.valine.appid %>',
       appKey: '<%= theme.comment.valine.appkey %>',
       placeholder: '<%= theme.comment.valine.placeholder %>',
       avatar: '<%= theme.comment.valine.avatar %>',
       meta: meta,
       pageSize: '<%= theme.comment.valine.pageSize %>' || 10,
       visitor: <%= theme.comment.valine.visitor %>,
       requiredFields: requiredFields,
     });
     </script>
   <% } %>
   ```

2. 在你的主题配置文件`_config.yml`的`valine`配置区增加配置：`requiredFields: ['mail',] #设置必填项`。完整截图如下：
   ![QQ截图20200522205505.png](../img/QQ%E6%88%AA%E5%9B%BE20200522205505.png)

# 结束

至此，配置已经完成。可以通过：`hexo clean && hexo g && hexo s`，本地预览一下。

![QQ截图20200522205642.png](../img/QQ%E6%88%AA%E5%9B%BE20200522205642.png)