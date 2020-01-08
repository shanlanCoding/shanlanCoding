---
title: React使用andt的table翻页按钮不更新的问题
copyright: true
comments: true
toc: true
tags:
  - React
categories:
  - 前端
abbrlink: f54c318f
date: 2019-11-07 17:22:00
---

# 起因

使用相同的table组件，相同的参数，结果一个页面可以正常显示翻页效果。另一个能正常显示翻页数据，翻页的按钮不会改变。代码如下：

```JavaScript
const Data = {
    //这个是table内展示的数据
    list: list,
    //这个就是翻页参数
    pagination: {
        total,
        pageCurrent,
        pageSize
    },
};
```

# 不完美的解决

具体原因最终没找到，但是通过[查阅Andt的文档](https://ant.design/components/pagination-cn/)，得知翻页的当前页码变量名为`cureent`,而非使用`pageCurrent`。于是我将不正常页码的翻页参数对象改为如下：

```JavaScript
const Data = {
    list: list,
    //分页；current:
    pagination: {
        total,
        current : pageCurrent,
        pageSize
    },
};
```

页码立马就正常的。当我将正常页码的：`pageCurrent`数据也改为：`current : pageCurrent`。原本正常的页面却开始报错了，报错如下：

```
backend.js:6 Warning: Failed prop type: Invalid prop `current` of type `function` supplied to `Pagination`, expected `number`.
    in Pagination (created by Context.Consumer)
    in LocaleReceiver (created by Pagination)
    in Pagination (created by Context.Consumer)
    in div (created by Context.Consumer)
    in div (created by Context.Consumer)
    in Spin (created by Context.Consumer)
    in div (created by Context.Consumer)
    in Table (created by SimpleTable)
    in div (created by SimpleTable)
    in div (created by SimpleTable)
    in SimpleTable (created by order)
    in div
    in div
    in Unknown (created by order)
    in order (created by Connect(order))
    in Connect(order) (created by AsyncComponent)
    in AsyncComponent (created by Route)
    in Route (created by TIndexPage)
    in Switch (created by TIndexPage)
    in div (created by TIndexPage)
    in div (created by Basic)
    in Basic (created by Context.Consumer)
    in Adapter (created by TIndexPage)
    in div (created by BasicLayout)
    in BasicLayout (created by Context.Consumer)
    in Adapter (created by TIndexPage)
    in div (created by Scrollbars)
    in div (created by Scrollbars)
    in Scrollbars (created by TIndexPage)
    in div (created by BasicLayout)
    in BasicLayout (created by Context.Consumer)
    in Adapter (created by TIndexPage)
    in div (created by BasicLayout)
    in BasicLayout (created by Context.Consumer)
    in Adapter (created by TIndexPage)
    in TIndexPage (created by Connect(TIndexPage))
    in Connect(TIndexPage) (created by Route)
    in Route
    in Switch
    in Router (created by HashRouter)
    in HashRouter
    in LocaleProvider
    in Unknown
    in Provider
```

上面报错我的理解是： `Pagination`需要一个Number类型的属性，而不是function类型。所以我只能将`current`删去便恢复正常。

具体为什么一个页面使用`current`值就会变成function，另一个页面使用则依然是Number类型无法得知了，先记录一下，以后能想到原因再来更新，或者有知道的朋友也可以留言回复。