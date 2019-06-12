---
title: GitHub pages开启Https、自定义域名和CDN加速
copyright: true
comments: true
tags:
  - GitHub pages
categories:
  - 博客优化
abbrlink: bc0a861a
date: 2019-06-12 17:56:56
toc: true #目录索引
sidebar: # 是否启用sidebar侧边栏，none：不启用
---

# GitHub page是什么？

我只是简短讲一讲自己的理解，更详细的还请自行搜索，如果错误还请指出。

GitHub pages 是一个能存放静态资源的服务器。你可以把它当做apache服务器使用。同时支持使用自定义域名解析，而且也支持HTTPS加密访问。

但是如果用上了CDN服务器，它这个HTTPS加密就无法使用了，具体请看图：

![image](https://user-images.githubusercontent.com/44717382/59343470-8c216b80-8d3e-11e9-83d6-12300bd9c79f.png)

![image](https://user-images.githubusercontent.com/44717382/59343384-541a2880-8d3e-11e9-9969-e09f8444750e.png)

# 为什么不能使用Https访问？

上面试验过了Https访问浏览器会报错“不安全”，原因是因为该证书它是由CDN服务器提供的。而不是我们访问的GitHub pages服务器提供的。

而且，该证书是CDN的域名，并不是给我们自己域名的，所以当我们使用自己**自定义的域名**访问GitHub pages，浏览器自然而言就会报错。

# 如何将解决？

我使用的是腾讯云的CDN，有免费流量，反正我是用不完的。同时腾讯云还提供免费的SSL证书，也就是HTTPS证书使用。另外我将自己的域名DNS服务器设置为dnspod，也就是腾讯云的dns解析，这样后面设置的时候也会方便不少，同时dnspod口碑也不错。

## 1. 创建证书

1. 打开腾讯云-云产品-SSL证书-申请免费证书-亚洲诚信（写稿时是亚洲诚信提供的SSL证书）-确定
2. 通用名称；输入需要加证书的域名，例如我需要给”test.gobyte.cn“加上证书，那么在”通用名称“里输入”test.gobyte.cn“即可
3. 申请邮箱；自己的邮箱，我是填QQ邮箱，因为电脑每次都会登陆QQ
4. 证书备注名；自己随便写
5. 私钥密码；我嫌麻烦，没有设置
6. 所属项目；默认项目

最后设置如图：

![image](https://user-images.githubusercontent.com/44717382/59344164-1a4a2180-8d40-11e9-87e6-33dc1ca6d4d0.png)





## 2. 域名验证

域名验证一共有三种方式，如果你的DNS解析服务器是腾讯云的，那么可以使用第一种自动验证。

1. 自动DNS验证；原理是它自动帮你创建一条TXT解析，来进行验证。但是我试过，自动验证需要耗费十几分钟甚至更久才能验证通过。而且证书创建后一小时内不可删除，所以**不建议使用**。
2. 手动DNS验证；会提供一个二级域名和一串字符串，让你去dns解析里添加，**建议使用**
3. 文件验证；在你的网站里创建一个文件，文件内同样是指定的一串随机的字符串，网站如果变动了验证会失效，**不建议**

![1560335520808](https://user-images.githubusercontent.com/44717382/59348147-fd661c00-8d48-11e9-958a-adf28b15431a.png)

## 3. 添加DNS解析完成验证

![image](https://user-images.githubusercontent.com/44717382/59344652-1ec30a00-8d41-11e9-8835-b16b9a8d90f5.png)

![image](https://user-images.githubusercontent.com/44717382/59344768-4c0fb800-8d41-11e9-86dd-da84f85ae2a1.png)

1. 进入你的域名解析管理

2. 添加记录；主机记录如图：`_dnsauth.test`    ；记录类型：`TXT`；记录值：`201906111036051a20pp0b9x741e6lkn3xa302034gai8q61314oiyu4zogq8r1x`    ；最终效果如下图：![image](https://user-images.githubusercontent.com/44717382/59345001-cf310e00-8d41-11e9-8289-be096b62f0eb.png)

3. 回到证书详情页面，点击刷新按钮，查看域名解析是否生效![1560336333758](https://user-images.githubusercontent.com/44717382/59348455-bc223c00-8d49-11e9-888f-3b2eca0012a3.png)

4. 如果显示这样，说明已经成功了，等待服务商给你生成SSL证书即可。![1560336371178](https://user-images.githubusercontent.com/44717382/59348471-c93f2b00-8d49-11e9-8ad7-98226f0a31e4.png)![image](https://user-images.githubusercontent.com/44717382/59345294-65653400-8d42-11e9-86d5-52f5f55b4151.png)

   到这里证书这块已经搞定，下一步是解决CDN设置的问题。

   # 设置CDN服务

   ![image](https://user-images.githubusercontent.com/44717382/59345655-2be0f880-8d43-11e9-9e05-8bd217a50602.png)

   1. 进入CDN；路径：云产品-CDN-添加域名

   2. 配置见图。域名是你要加速的域名。源站是指你网站的服务器ip。我这里是使用的GitHub pages，所以使用了这4个ip。如果你不知道自己的ip，你可以去的空间商查询。另外如果你想使用类似GitHub的服务器，可以使用`ping www.xxxx.com` 命令查询。我是使用站长工具批量ping命令查询的。

   3. 缓存过期配置，根据自己需要酌情设置，因为是写教程，我这里就默认了。说个尝试，如果是动态的链接是不应该缓存的，所以过期时间应该是0秒。

   4. 进入高级配置，设置HTTPS证书。![image](https://user-images.githubusercontent.com/44717382/59346342-a8280b80-8d44-11e9-8bcc-84314d569cd1.png)**按图下图设置**![1560337398913](https://user-images.githubusercontent.com/44717382/59348386-8b420700-8d49-11e9-9b60-bab9fc76c72c.png)

      

   5. 设置完成后，点击提交，进入CDN的域名管理列表。

   6. 稍等片刻，CDN会给你提供一个域名，该域名是你把要加速的域名，通过CNAME类型解析的。如下图：![image](https://user-images.githubusercontent.com/44717382/59346004-effa6300-8d43-11e9-8740-11c5dd9823dd.png)

   7. 设置域名解析到CDN上。进入域名解析，添加解析。如：我需要用的域名为`test.gobyte.cn`，那么添加的主机名应该是`test`，解析类型为`CNAME`，记录值为`test.gobyte.cn.cdn.dnsv1.com`。如下图：![image](https://user-images.githubusercontent.com/44717382/59346250-72832280-8d44-11e9-8b57-613cb980085a.png)

   8. 浏览器输入你的域名，按下F12打开开发者工具，点击`network`，如我的域名是[http://test.gobyte.cn](http://test.gobyte.cn)，打开看看能不能访问。顺带看一下head的主机ip是多少，如图：

      ![image](https://user-images.githubusercontent.com/44717382/59346675-677cc200-8d45-11e9-8868-3da449e72ec6.png)

      明显看出，这个IP不是上面自己设置的源IP，通过IP查询得知，它是湖南岳阳的IP，说明它就是CDN服务器的IP了。![image](https://user-images.githubusercontent.com/44717382/59346814-be829700-8d45-11e9-9d2d-7fde58d5ef6b.png)

      9. 我们再测试下HTTPS[https://test.gobyte.cn](https://test.gobyte.cn)，我这边已经成功了，如下图。![image](https://user-images.githubusercontent.com/44717382/59346963-13261200-8d46-11e9-9b95-0c501acc4983.png)

         鼠标单击一下地址栏的小锁，点击证书![image](https://user-images.githubusercontent.com/44717382/59347094-5ed8bb80-8d46-11e9-8ddd-4fcc948b5d5c.png)

         ![1560338137845](https://user-images.githubusercontent.com/44717382/59348409-9c8b1380-8d49-11e9-95c8-7c98cedecce3.png)

         从证书中可以看到，是授予我的域名的。颁发者是：TrustAsia，而TrustAsia就是亚洲诚信公司，所以说明我们的HTTPS已经配置成功了！

         ![1560338216413](https://user-images.githubusercontent.com/44717382/59348435-af054d00-8d49-11e9-8d05-56b372e91c96.png)

         但是别着急，还有最后重要的一步设置没有完成。我们需要设置为强制跳转HTTPS访问，因为目前http还是可以访问的。

         10. 设置HTTPS强制跳转；打开CDN-域名管理-点击`test.gobyte.cn`-高级配置-HTTPS配置-强制跳转HTTPS-打开![image](https://user-images.githubusercontent.com/44717382/59347442-369d8c80-8d47-11e9-8a2d-d05d72690f7c.png)

         11. 至此，我们打开浏览器隐身模式，尝试输入不带https的域名，看看能否强制跳转。通过抓包得知，浏览器成功的利用302跳转到https协议了。![image](https://user-images.githubusercontent.com/44717382/59347633-bd526980-8d47-11e9-8036-32db49c6fb41.png)

             # 至此，使用GitHub pages + CDN + HTTPS教程已经完成，如果你在搭建的过程中遇到什么问题，或者发我的有遗漏、错误的地方，欢迎留言，最后祝大家生活愉快~

             









