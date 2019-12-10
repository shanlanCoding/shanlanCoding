---
title: React不同环境使用不同配置：开发、内网、外网、客户
copyright: true
comments: true
toc: true
tags:
  - React
categories:
  - 前端
abbrlink: fbb1b617
date: 2019-10-18 17:33:53
---

# 起因
实际开发中一个项目需要多个版本，不同版本之间的参数各不相同，举例说明：
1. 开发版：需要有报错信息显示；需要使用本机服务器；需要使用本机mock功能
2. 内网版：开发完成以后，部署到内网服务器供其他同事查看。测试，需要用内网服务器数据库
3. 外网版：测试正常以后，发布到外网服务器，给客户展示。需要用外网服务器数据库。
4. 客户版：项目需要持续性的解决bug，以及部署到客户的服务器。需要用客户内网服务器数据库
-----

以上四个版本都需要使用不同的参数重复的说明了一个项目需要不同版本的情况。通常在上面情况发生时，是**手动**的去修改配置信息，然后就是build生成静态文件。

这样不仅繁琐、累，还更容易出错。因为当客户火急火燎的催你改完bug以后，你大概率的情况下会直接build然后上传部署了。等你花了时间部署以后测试，你缺发现页面加载是空白的，原因就是因为你build的时候没有修改配置信息，导致部署后项目不正常。

另外在尝试了几种教程以后，无法达到效果，最终花费3小时才成功，菜到自己不忍直视，所以下决心记录解决方案，为后来者提供一下参考。

# 解决方法
## 安装cross-env的插件：

```shell
npm install --save-dev cross-env
```

> 当您像那样使用NODE_ENV=production设置环境变量时，大多数Windows命令提示符都会阻塞。(Windows上的Bash是个例外，它使用本机Bash。)类似地，windows和POSIX命令利用环境变量的方式也有所不同。使用POSIX时，使用:$ENV_VAR，在windows上使用%ENV_VAR%。 

**一句话概括插件作用：**解决Window和Linux系统之间环境变量不通用的问题。

你还可以看视频学习，具体可以在视频2：35秒的处：[webpack-dev-server的配置和使用](https://www.imooc.com/video/16404)

插件地址：[cross-env - npm](https://www.npmjs.com/package/cross-env)

## 准备参数配置文件

文件名随意，我自己是：processENV.js

```
/*****************************************************************
 * Copyright (C), 2017-2019, *******有限公司
 * FileName:       processENV.js
 * Version:        0.1
 * Author:         Zhou Liang
 * Date:           2019-10-18 5:13 PM
 * TODO:           本文件是用来区分开发环境、内网环境、外网环境、索特内网的作用
 *****************************************************************/
//读取数据
const NODE_ENV = process.env.APP_ENV;
// const NODE_ENV = 'start';
const config = {
    start: {
        API_CONFIG: 'start'
    },
    production: {
        API_CONFIG: 'production'
    },
    devmes: {
        API_CONFIG: 'devmes'
    },
    soot: {
        API_CONFIG: 'soot'
    }
};
console.log( 'config[\'start\']', config[NODE_ENV]);
module.exports = config[NODE_ENV];
```

## 配置DefinePlugin()传值

打开WebPack配置文件`webpack.base.config.js`

再引入上面准备好的文件：`const processENV = require( './processENV' );`

然后编写代码，下面这段代码是在：

```javascript
new webpack.DefinePlugin( {
    'process.env': {
    	APP_ENV: JSON.stringify( processENV ),
    }
} ),
```

`webpack.base.config.js`文件是配置在`package.json`的start{}代码块中，如下：

```json
  "scripts": {
    "start": "cross-env APP_ENV=start webpack-dev-server --config ./scripts/webpack.dev.config.js",
    "build": "cross-env APP_ENV=production webpack --config build/webpack.config.js",
    "build-devmes": "cross-env APP_ENV=build-devmes webpack --config ./scripts/webpack.prod.config.js",
    "build-soot": "cross-env APP_ENV=build-soot webpack --config ./scripts/webpack.soot.config.js",
    "lint": "eslint ./ --cache --fix --ignore-pattern .gitignore",
    "mock": "supervisor -i node_modules mock/http.js",
    "test": "cross-env APP_ENV=production"
  },
```

## 关键：传值

不论是启动，还是build，其实都是执行`package.json`文件里面的`scripts`代码块的命令，而传值就是在这里配置。

固定格式：cross-env APP_ENV=start

start：就是传入的值

APP_ENV：就是在其它JS文件里的取值变量

## 最终效果

在JS文件里调用：

```javascript
console.log( 'process.env.APP_ENV', process.env.APP_ENV );
```

浏览器输入的效果：

![效果图](https://i.loli.net/2019/10/18/kTxhXRJS9WMlEKD.png)



# 参考教程

1. [webpack-dev-server的配置和使用](https://www.imooc.com/video/16404)
2. [使用DefinePlugin通过NODE_ENV配置环境变量](https://blog.csdn.net/qq_31403519/article/details/90905649)
3. [NODE_ENV和webpack](https://juejin.im/post/5a4ed5306fb9a01cbc6e2ee2)
4. 以及QQ群友 `flipped(675576674)`  的热心帮助

# 安利

最后安利一下自己开发油猴子脚本-掘金版面优化：[掘金界面宽屏布局-山岚](https://greasyfork.org/zh-CN/scripts/386796-%E6%8E%98%E9%87%91%E7%95%8C%E9%9D%A2%E5%AE%BD%E5%B1%8F%E5%B8%83%E5%B1%80)

更多油猴子脚本，可以进我的个人页面索取：[山岚的GreasyFork主页](https://greasyfork.org/zh-CN/users/174840-misterchou-qq-com)

![掘金版面优化](https://i.loli.net/2019/10/19/W3um8s6OTp21L5E.png)