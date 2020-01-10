---
title: netlify服务器自定义域名添加自定义证书开启HTTPS的正确方法
copyright: true
comments: true
toc: true
tags:
  - Hexo
categories:
  - 博客优化
abbrlink: b5463510
date: 2019-06-13 11:34:17
---
# 什么是netlify？

netlify和GitHub pages 的作用一样，托管静态代码的服务器，可以参考我这一篇文章：[GitHub pages开启Https、自定义域名和CDN加速]( https://blog.gobyte.cn/post/bc0a861a.html)。说直白点，就是存放HTML等静态文件的服务器。

# 为什么要选择netlify？

根据我使用了不到一天的体会，

1. netlify的速度更快。服务器多，我通过工具查询，netlify提供了7、8个的IP提供用户访问。相比较GitHub的5个ip，它的访问速度远高于GitHub。

2. 它支持添加多个自定义的域名。

3. <a href="#1">持一键开启HTTPS服务（使用的是Let's Encrypt提供的证书，需要修改域名的CANME解析）</a>

4. 支持添加自定义证书

5. 支持自动部署（不再需要自己生成html文件再deploy到服务器）

   由于截止写稿时使用时间过短，所以难免还有地方没有表达完整，请见谅。

# 如何开启自定义域名的https服务？

1. 部署博客程序到GitHub

2. 通过GitHub注册netlify

3. 通过netlify读取GitHub上面的博客程序，并自动部署

   因为如何部署至netlify不在本文的重点，所以上述三个步骤还请自行搜索解决，另外我也相信你可以做到的，加油！

   ## 部署完毕以后，我们进入到项目的settings里

   1. 找到settings菜单，并点击

   2. 找到 Domian management ，并点击

   3. 找到 Costom domains ， 这个就是自定义域名项目

   4. 向下翻滚，找到 Add domain alias ， 这个按钮就是添加自定义域名了。

      ![image](https://user-images.githubusercontent.com/44717382/59402740-4d3cf580-8dd2-11e9-816a-e2b3f85f30b0.png)

      这个时候就可以添加你的域名了。例如我添加的是：`blog.gobyte.cn`，效果见上图。

      # 使用腾讯云，申请免费的SSL证书

      这里提一句，为什么我不直接使用netlify的证书，而是自己单独去申请一个。<a name="#1">上面提到过</a>，netlify使用它的自定义域名的https时，需要你修改域名的CANME指向netlify提供给你的二级域名上，具体可以看官方的文档说明：

      [SSL / HTTPS | Netlify](https://www.netlify.com/docs/ssl/#netlify-certificates)

      >### DOMAIN ALIASES
      >
      >Your certificate will include all your [domain aliases](https://www.netlify.com/docs/custom-domains/#domain-aliases) when it’s issued, but note that DNS also needs to be configured IN ADVANCE for all aliases for us to include them on your certificate. See [the troubleshooting section below](https://www.netlify.com/docs/ssl/#troubleshooting) for more information on confirming the new configuration.

      为了大家能顺利的阅读，翻译成中文如下：

      >### 域别名选项
      >
      >您的证书在发出时将包含所有[域别名](https://www.netlify.com/docs/custom-domains/#domain-aliases)，但请注意，还需要预先配置DNS，以便我们将所有别名包含在您的证书中。有关确认新配置的更多信息，[请参阅下面的故障排除部分](https://www.netlify.com/docs/ssl/#troubleshooting)。
      >
      
      其实上面的翻译不算准确。准确的说是把域名的主机记录，通过CANME指向它提供二级域名，例如提供给我的netlify二级域名是：[shanlan.netlify.com](https://shanlan.netlify.com/)。其实不把域名的CNAME指向它的二级域名也是可以访问的，只不过它的页面会提示你检查DNS解析配置，如下图 。
      
      ![image](https://user-images.githubusercontent.com/44717382/59403551-9c385a00-8dd5-11e9-90e2-407bd4709f13.png)
      
      ### 那么我为什么还要坚持去使用第三方的域名？
      
      原因是我需要启用CDN，而CDN分发的时候需要回源。我希望回源能用上https，所以我就需要提供证书给CDN，而使用netlify的证书，我没办法去下载。那么干脆就自己去申请证书然后添加到netlify上面吧。
      
      腾讯云的免费证书申请方法见我这篇文章：[GitHub pages开启Https、自定义域名和CDN加速]( https://blog.gobyte.cn/post/bc0a861a.html)，我这里不再赘述。
   
   # 亚洲诚信的证书如何配置到netlify？
   
   ![image](https://user-images.githubusercontent.com/44717382/59403616-f46f5c00-8dd5-11e9-8daa-149e24c4a6a4.png)
   
   根据上图的netlify添加自定义证书输入框来看，它需要三种数据，分别如下：
   
   1. PEM格式证书 .
   2. 私钥KEY
   3. CA证书链 *CA certificate chain*
   
   **我们来看下从腾讯云下载的亚洲诚信证书的压缩包**：
   
   ![image](https://user-images.githubusercontent.com/44717382/59403714-5760f300-8dd6-11e9-83c9-dd6f0e57f53a.png)
   
   该证书压缩包提供了四种主流服务器程序的证书，分别为：
   
   1. apache服务器
   2. IIS服务器
   3. nginx服务器
   4. tomcat 服务器
   
   ### 我翻遍了这4个文件夹，没有找到.PEM格式的文件
   
   怎么办？通过查询[netlify官方文档](https://www.netlify.com/docs/ssl/#custom-certificates)，我看到了这样描述：
   
   >## Custom Certificates
   >
   >If you already have a certificate for your domain and prefer that to Netlify’s domain-validated certificate, you can install your own.
   >
   >To install a certificate, you’ll need:
   >
   >- the certificate itself, in X.509 PEM format (usually a .crt file)
   >- the private key you used to request the certificate
   >- a chain of intermediary certificates from your Certificate Authority (CA)
   
   
   **翻译成中文如下：**
   
   >## 自定义证书
   >
   >如果您已拥有域名证书并且更喜欢Netlify的域验证证书，则可以安装自己的证书。
   >
   >要安装证书，您需要：
   >
   >- 证书本身，采用X.509 PEM格式（通常为.crt文件）
   >- 您用于请求证书的私钥
   >- 来自证书颁发机构（CA）的一系列中间证书
   
   上面描述的很清楚，需要PEM格式，通常为.crt文件
   
   好的，CRT文件在压缩包里有好2个，分别为apache和nginx里，正好他们两个都有key文件。
   
   ### 但是，选项3的CA证书链 *CA certificate chain* 去哪里找？
   
   搜索一番得知，一般会在证书申请成功以后通过email 发送给使用者。但是我看了下腾讯云给我发送的邮件，是没有该内容的。
   
   > 申请证书后，我们会发一封颁发邮件，在颁发邮件里，有证书链代码，把代码保存为crt后缀的txt文本里就可用了
   
   终于在耗费两个多小时后，我打开了亚洲诚信的官网，通过在线聊天功能，联系上了他们的技术顾问，并说明了我的情况，在这位技术同学的帮助下，我成功的收到了[亚洲诚信](https://www.trustasia.com/)提供的CA证书链 *CA certificate chain*
   
   ![image](https://user-images.githubusercontent.com/44717382/59404058-b8d59180-8dd7-11e9-9cc6-8675795b76f4.png)
   
   
   
   **在这里，由衷的感谢一下技术同学“Huang Nome”的帮助，祝他生活愉快**
   
   ### 开始添加https证书
   
   通过尝试apache服务器和nginx服务器的证书，只有nginx文件夹内的证书能添加成功
   
   1. 打开从腾讯云下载的证书压缩包，打开nginx的文件夹
   2. 以文本模式，打开文件夹内的.CRT文件，并复制粘贴到netlify的PEM输入框内
   3. 以文本模式，打开文件夹内的.KEY文件，并复制粘贴到netlify的KEY输入框内
   4. 复制由“亚洲诚信"提供的CA证书链文本，粘贴到netlify的Intermediate certs内
   5. 点击“Install certificate”完成添加。成功效果图如下：
   
   ![image](https://user-images.githubusercontent.com/44717382/59404271-8b3d1800-8dd8-11e9-82b7-497f1b134a5d.png)
   
   

# CDN设置https回源

我使用的是腾讯云CDN，操作如下图：

![image](https://user-images.githubusercontent.com/44717382/59404399-f555bd00-8dd8-11e9-8c30-d24ec0965a05.png)





---------



**至此，教程已经结束，感谢阅读。**