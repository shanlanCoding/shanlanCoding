---
title: React部署到Nginx后图片404错误问题解决方法
copyright: true
comments: true
toc: true
abbrlink: b53e48df
date: 2019-09-10 13:46:17
tags:
  - React
categories:
  - 前端
---

# React的路由模式

路由配置是一组命令，用来告诉Router如何匹配URL以及匹配后如何执行代码，而不会去请求服务器，所以作用和计算机网络的交换机路由功能类似：根据某个条件，做某个事情。

### React路由模式有五种：

1. BrowserRouter：浏览器的路由方式，也就是在开发中最常用的路由方式
2. HashRouter：在路径前加入一个“#”成为一个哈希值，Hash模式的好处是，再也不会因为刷新而找不到页面而导致404
3. MemoryRouter：不存储Histor，所有路由过程保存在内存中，不能进行前进和后退，因为地址栏没有发生任何变化
4. NativeRouter：经常配合ReactNative使用，多用于移动端
5. StaticRouter：设置静态路由，需要和后台服务器配合设置，比如设置服务端渲染时使用

### React常用的路由模式有两种：

1.BrowserRouter：优点的是路径里不带#号，缺点是刷新会导致404，可以通过在服务器端配置反向代理解决该问题

服务器端反向代理解决方案：

```nginx
 server {
        listen       80;
        server_name  localhost;
	#防止React路由后，刷新页面404
	#定义根目录为html文件夹，这里也可以切换成React的打包文件夹dist
	#root D:/nginx-1.17.3/html;
	root E:/SRC/iotintroduction/dist;	#我这里使用的是build后的dist文件夹，因为我是先在Windows上测试，测试没问题再上传到服务器。这样的好处是每次修改后就不用再复制到Nginx的HTML文件夹内。
	index index.html;

        location / {
	    try_files $uri /index.html;
        }

	#映射图片
	location /css/img/ {
	    alias  E:/SRC/iotintroduction/dist/img/;
	    #autoindex on;
	}
}
```



2.HashRoter：缺点是路径有#号，非常难看。优点是不需要反向代理，也可以随便刷新。

# 总结：

在开发测试阶段，推荐使用HashRouter，这样可以避免每次修改页面后刷新404的问题。等产品上线之前，再修改为BrowserRouter，配合Nginx等反向代理工具即可。