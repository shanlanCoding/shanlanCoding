---
title: Ajax请求XMLHTTPRequest请求返回GBK编码中文乱码解决方法
copyright: true
comments: true
toc: true
tags:
  - JavaScript
categories:
  - 前端
abbrlink: 6258b05e
date: 2019-10-26 09:43:52
---

# 前言

当我通过跨域Ajax请求京东的商品库存接口时，返回的中文出现了乱码。有意思的是，当我多次请求尝试时，返回提会改变，并且返回的编码也会改变，所以偶尔会返回一个UTF-8的返回体。示例的请求接口如下：

` http://c0.3.cn/stocks?callback=getStockCallback&type=getstocks&skuIds=32399605916&area=15_1213_1214_0&1572054766314 `

- skuIds						商品的id
- getStockCallback		回调函数；可以使用这个名字来编写一个回调处理函数
- area							地区编码；需要查询库存的地区

正常的请求如下，会乱码：

![返回体截图](https://i.loli.net/2019/10/26/WObqrEwfxujoHGd.png)!

可是当多次请求以后，返回体会发生改变，并且中文也能显示了：

![返回体发生了改变](https://i.loli.net/2019/10/26/jlV3iBoRawDQZNY.png)

# 解决方法

## 1.全局查找中文判断

由于第一种返回体中文是乱码的，起初我第一种判定方法是查找有无“现货”和“无货”两种关键词。例如我想查询“现货”，代码如下：

```JavaScript
if (r.responseText.indexOf( '现货' ) > 0) {
    alert( '现货' );
}
```

但是这种方法比较蠢。原因有下几点：

1. 每次返回中不一定都是中文，即使“有货”，也不一定是中文显示
2. 当“有货”时，但是不是中文，代码还一直以为无货。时间过去了以后很有可能被他人购买了，即使“有货”也真的会变成“无货”

## 2.使用Script的标签来完成跨域以及GBK解码

使用`<script>`标签来跨域请求；因为浏览器的同源策略限制，请求非当前页码的域名的时候，会被浏览器阻止，但是`<script>`标签受此影响。其实Ajax的跨域请求也是利用该原理。但是，`<scprit>`标签的优点是可以设置编码格式，也就是说即使后台返回了GBK编码，我们照样能够得到中文字符串，下面是代码示例：

```JavaScript
//检查库存
function checkStock() {
    //创建一个script对象
    var script = document.createElement( 'script' );
    //设置请求地址
    script.src = 'http://c0.3.cn/stocks?callback=getStockCallback&type=getstocks&skuIds=32399605916&area=15_1213_1214_0&1572054766314' + new Date().getTime();
    //设置GBK编码
    script.charset = 'gbk';
    //将script对象添加到dom中
    document.body.appendChild( script );
    //错误时触发事件；当请求服务器返回错误代码时，会自动调用该事件
    script.onerror = function () {
        //错误时重复执行本身函数
        checkStock();
    }
}
```

其实光有一个请求函数还是不够的。我们还需要编写一个**回调函数**来处理返回值。这里啰嗦几句，很多新人对这个玩意理解不够很容易造成困扰，包括我之前也是这样。所谓回调函数个人理解是：当向服务器发送请求成功以后，我们会定义一个函数来进行处理。也就是：返回后调用函数，简称回调函数。

回调函数是定义在请求链接中，也就是上面URL参数里的：`callback=getStockCallback`，那么函数名就是：`getStockCallback`，我的回调函数如下：

```javascript
//回调函数
function getStockCallback( data ) {

    //取出数据
    for (var sk1 in data) {
        console.log( data[sk1]['StockStateName'] );
        var productStockStatus = data[sk1]['StockStateName'];
        var stockState = data[sk1]['stockState'];
        console.log( 'productStockStatus=', productStockStatus, 'stockState=', stockState );
    }
    //判断是否有货
    if (productStockStatus !== '无货') {
        alert( 'Baby! 现在有货了！快买！' );
        window.clearTimeout( t1 );
    } else {
        window.clearTimeout( t1 );
        //设置定时执行
        t1 = window.setTimeout( checkStock, 3 * 1000 );
    }
}
```

至此，该代码就能完整的解析GBK编码了

## 3.意外发现，不需要判断中文也能知道库存状态

其实，在我编码的过程中发现，能不能解析中文不重要，因为在返回体重已经有一个字段已经表明了库存状态了，请参考以下代码：

```JavaScript
//判断状态
var stockName = '';
if (stockState === 33) {
    stockName = '现货';
} else if (stockState === 39 || stockState === 40) {
    stockName = '有货';
} else if (stockState === 36) {
    stockName = '预定';
} else {
    stockName = '无货';
}
console.log( 'stockName=', stockName );
```

所以如果只需要监测库存的话，判断下这个`stockState`字段就可以了。

# 其它解决方法

1. [GBK编码下jQuery Ajax中文乱码终极暴力解决方案](https://blog.csdn.net/shimiso/article/details/5721640)；我未尝试



我依然希望能找到Ajax 解码GBK方法，因为script标签还是有些繁琐。