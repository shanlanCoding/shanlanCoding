---
title: 篡改页面的Js代码，从而达到"为所欲为"的目的
copyright: true
comments: true
toc: true
abbrlink: 32b605b3
date: 2019-06-23 10:41:39
tags: 
- JavaScript
categories: 
- 骚操作
---

### 声明

本教程仅适用于技术交流学习，切勿用作违反国家法律法规等途径，否则应由操作人承担，本作者不承担任何责任。本教程仅做科普，如果你认为自己已经领会，还请勿喷，不要以**“幸存者偏差”**视角来看待任何事物。

-----

# 缘由

不少网站都是通过JavaScript来判断用户的输入数据，通常我们是自己构造一个Http的请求，来跳过这些JavaScript验证，但是这样需要你掌握Http请求中的各个参数的构造，所以比较繁琐。

# 那么如何在不模拟Http请求的情况下跳过这些验证？

答案当然有！
使用浏览器的开发者工具进行对页面的JavaScript代码修改。我使用带有Chromium内核的浏览器，篡改JavaScript代码之前，应该先找到需要篡改的关键JavaScript代码。
我一般是通过监听对应的事件来找到对应的JavaScript代码。

### 调试方法1
 1. 例如我需要监听Click事件，那么按下F12打开“开发者工具”，切换到“Sources”选项页面，在右侧的菜单栏里找到“Event Listener Breakpoints”，依次点击“Mouse”分类 => “Click”，勾选，如下图：
![click事件监听](https://p2.pstatp.com/large/pgc-image/03030fd45d79421ab8eaf2fced00b0e1)
 2. 点击页面的按钮，从而浏览器会自动跳转到JavaScript代码。接着在“Sources”页面内的右侧，会有一排调试按钮可供我们使用![调试按钮](https://p2.pstatp.com/large/pgc-image/e8fad73a5d484f9ab47a97dcfeb4543e)
 3. 上面这种调试方法我并不推荐，因为调试过程中的不相关代码太多，很难找到我们需要的关键代码。通常我是用下面一种方法。
### 调试方法2
1. 以该页面为例，我需要篡改对身份证号的判断![表单](https://p2.pstatp.com/large/pgc-image/f8633c8770924f91af807742ac179268)
2. 通过开发者工具，定位该输入框，查看它的“Element”页的详细信息：![身份证号输入框](https://p2.pstatp.com/large/pgc-image/12a718265b52465d9434f17af0743786)
3. 可以看到该输入框有id，但是没有class，根据经验判断。本页面的JavaScript代码应该是通过id来获取该输入框内的Value，所以我们使用“开发者调试工具”的全局搜索功能，搜索这个id名“txtCard”，从而能快速定位到对应的JavaScript代码。
4. 快捷键`Ctrl + Shif + F`，搜索结果如图：![搜索结果](https://p2.pstatp.com/large/pgc-image/d709df583bdc4192bd2a5af4283b2df0)
5. 我们可以点击上面的搜索结果，从而能跳转到对应的JavaScript源码。例如上图有两个文件，分别为`Sign.js`和`yidong.html`。43行的这个结果肯定不匹配。27行的注释，也可以忽略。那么55行的这个trim方法很关键，用过JavaScript的朋友都知道这个方法是取出字符串的前后空格的，通常是用来取值。所以我们直接点击55行，效果如下图：![55行结果](https://p2.pstatp.com/large/pgc-image/a7c3cfa4241446b7b8da82640dbc4338)
6. 可以根据上步骤得知，最终身份证号赋值给变量`CentNo`，继续搜索`CentNo`，结果如下图：![CentNo搜索结果](https://p2.pstatp.com/large/pgc-image/56fb0082f4f04c7ba3dc1e6beaa6a247)
7. 在页面输入错误的身份证号，会有提示：“请输入正确的身份证号”。所以步骤6的搜索结果应该选择第81行的代码，如下图：![81行代码](https://p2.pstatp.com/large/pgc-image/a7ac720ab3164b10994fd32044183b90)
8. 简单看了一下81行代码，它是一个if判断，判断内调用一个检查身份证号方法，从而来拦截页面`不合法`的操作。这里我们只需要将if内的取反符号`!`删除，即可跳过不合法身份证号的判断了，删除后记得按下快捷键`Ctrl + S`保存。页面的文件名前面将会出现一个感叹号ICO，如下图：![感叹号](https://p2.pstatp.com/large/pgc-image/03a03ef74f814417bee7faac0313dbb6)
9. 最后，点击提交，测试一下篡改JavaScript代码是否生效~
10. 我测试通过，如下图：![执行if通过](https://p2.pstatp.com/large/pgc-image/be0b7511d5ff43ac9e3de6898e76f5f8)代码已经执行100行结束了，准备执行下一个if，说明100行的if修改成功。另外还有一个判断成功的方法就是页面会发送http请求到服务器，所以`network`选项里会有数据包，如下图：![http请求](https://p2.pstatp.com/large/pgc-image/d6e579831d7944009f9220c40f290eb2)
11. 最后，页面出现喜闻乐见的弹窗提醒![成功](https://p2.pstatp.com/large/pgc-image/b0ea500d9d704a61a0096423c518bb54)

----------

# **通过本文，作为后端程序员，一定不可相信前端数据的合法性，一定要再次进行校验，本文完。**



