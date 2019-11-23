---
title: ' AutoJs获取的Text文本是乱码解决方案 '
copyright: true
comments: true
toc: true
date: 2019-11-23 11:50:19
tags:
- AutoJs
categories:
- JavaScript
---

# 源由

AutoJs可以获取Android原生的空间，比如TextView里的文字。实践中发现，大部分的textView是可以正常获取到文本的，但是某些App做了防止爬取的功能，将TextView的字体设置为冷僻的字体，导致即使被获取了文本，也无法正常的显示出来，俗称“乱码”。针对这种问题，我自己另辟途径发现了一个比较完美的解决方案。

方案的原理较为简单，适用性也比较广。通过反编译Apk文件，获取内部的资源，例如字体文件.ttf。得到ttf字体文件以后，可以安装到Windows系统上，然后从手机里复制出无法识别的字体，在Windows上打开，正常情况下是可以显示的。