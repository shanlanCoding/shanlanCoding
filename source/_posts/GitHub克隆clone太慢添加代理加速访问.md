---
title: GitHub克隆clone太慢添加代理加速访问
copyright: true
comments: true
toc: true
date: 2019-11-13 11:51:13
tags:
  - Git
categories:
  - 服务器
---

#### GitHub由于不可描述的原因，克隆clone非常非常慢，此时如果你有个提子可以按下面的方法解决

# 方法一，全局代理（不推荐）

下面是你提子的本地代理端口，我的端口是10808，打开git base窗口，复制下面的2行命令粘贴即可

```shell
git config --global http.proxy socks5://127.0.0.1:10808
git config --global https.proxy socks5://127.0.0.1:10808
```

取消

```shell
git config --global --unset http.proxy
git config --global --unset https.proxy
```

-------------

# 方法二，只针对部分域名代理（推荐）

上述方法挂了全局代理，但是如果要克隆码云、coding等国内仓库，速度就会很慢。更好的方法是**只对github进行代理**，不会影响国内仓库：

```shell
git config --global http.https://github.com.proxy socks5://127.0.0.1:1080
git config --global https.https://github.com.proxy socks5://127.0.0.1:1080
```



# 教程结束