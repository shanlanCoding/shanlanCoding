---
title: 重启centOS丢失nginx.pid导致无法启动nginx的解决方法
copyright: true
comments: true
tags:
  - centOS
  - linux
  - nginx
categories:
  - 服务器
abbrlink: 2f01b863
date: 2019-06-10 06:13:22
---

# 找到nginx

首先，如果你忘记了你的nginx的安装目录，不妨使用以下命令，找到你的nginx：

```java
find / -name nginx
```

这个时候，不出意外的话，你的界面将会出现一堆nginx路径，但是一般可执行的文件是在``/sbin/``或者``/bin/``目录下。
当然，如果你的shell工具支持关键字高亮的话，一眼就能区分该是目录还是可执行文件了，以下是目录示例：


```java
/run/nginx
/usr/lib64/nginx
/usr/sbin/nginx
/usr/share/nginx
/usr/libexec/initscripts/legacy-actions/nginx
/etc/logrotate.d/nginx
/etc/sysconfig/nginx
/etc/nginx
/var/lib/yum/repos/x86_64/7/nginx
/var/cache/nginx
/var/cache/yum/x86_64/7/nginx
/var/log/nginx
```

上述列表中，带有``/sbin/``或者``/bin/``的目录仅有一个，那就是：``/usr/sbin/nginx``

# 找到nginx的配置文件

也就是找到*nginx.conf*文件，同样是使用查找命令：

```java
find / -name nginx.conf
```

centOS这个时候一般只会出现一个配置文件路径，如下：

```java
/etc/nginx/nginx.conf
```

# 拼接命令，启动nginx

将目录``/usr/sbin/nginx``加上参数 ``-c``，再加上配置文件目录：``/etc/nginx/nginx.conf``

最终变成了:

```java
/usr/sbin/nginx -c /etc/nginx/nginx.conf
```

此时按下Enter执行，屏幕将会没有其他的提示，意味着nginx程序启动成功。

nginx -c 它是设置配置文件。其实nginx -c 它还有一个默认的配置文件路径。它默认的路径：``/etc/nginx/nginx.conf``，所以上述命令修正后是：

```java
/usr/sbin/nginx -c
```

怎么知道nginx还有其他的命令呢？

你只需要输入以下命令即可：

```java
/usr/sbin/nginx -?
```



# Nginx指令拓展知识（中英对照）：

```java
-?,-h 			: this help (这个帮助)
-v 				: show version and exit （显示版本并退出）
-V 				: show version and configure options then exit （显示版本和选项，然后退出）
-t 				: test configuration and exit （测试配置和退出）
-T 				: test configuration, dump it and exit （测试配置，转储并退出）
-q 				: suppress non-error messages during configurationtesting （在配置非错误期间，禁止显示非错误消息）
-s signal 		: send signa1 to a master process: stop, quit, reopen, reload  （向主进程发送信息：停止；退出；重新打开；重新加载）
-p prefix 		: set prefix path (default: /etc/nginx/)  （设置前缀路径，默认：/etc/nginx/）
-c filename 	: set configuration file (default: /etc/nginx/nginx. conf)  （设置配置文件，默认为：/etc/nginx/nginx. conf ）

-g directives 	: set global directives out of configuration file （将配置文件设置为全局指令）

```

``` html /blog/index.html Tyrion Yu tyrionyu-blog
<!DOCTYPE html><html lang="en">
<head>	
<meta charset="UTF-8">	<title>Document</title></head><body></body></html>
```
