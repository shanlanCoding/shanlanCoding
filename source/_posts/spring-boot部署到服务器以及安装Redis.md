---
title: spring boot部署到服务器、安装Redis、配置Nginx、MySQL
copyright: true
comments: true
toc: true
abbrlink: c621cb41
date: 2019-07-02 00:39:26
tags:
 - nginx
categories:
 - 服务器部署
---

[TOC]

# 部署到服务器

1. 使用idea的Maven工具，`package`命令，即可对项目进行打包。也可以手动输入maven命令打包`mvn clear package`

2. 打包完成以后，是一个jar文件，会存放在你项目的target目录下。我通过WinSCP软件上传到我的阿里云服务里。

3. 项目需要用到Redis，所以我还把Redis压缩包上传到了服务器内，参考了该教程进行安装。[Centos7下安装redis - 醉东风](https://www.cnblogs.com/zuidongfeng/p/8032505.html)

4. 在设置Redis开机自动启动过程中，使用命令启动和停止Redis命令时，碰到了报错：env: /etc/init.d/redisd: Permission denied

   ```shell
   [root@github init.d]# service redisd start
   env: /etc/init.d/redisd: Permission denied
   ```

   **最后解决方法是：**

   ```shell
   chmod a+x /etc/init.d/redis
   
   a+x 是给所有人加上可执行权限，包括所有者，所属组，和其他人
   o+x 只是给其他人加上可执行权限
   ```

5. 配置nginx；由于已经有了一个tomcat项目，所以第二个项目必须要在nginx里添加配置，否则访问就需要加端口访问了，我的配置如下：

      ```shell
      # 第二个项目
      		location ^~ /apply {
      			#转发给tomcat处理
      			proxy_pass http://127.0.0.1:9090/;
      			proxy_set_header  Host       $host;
      			proxy_set_header  X-Real-IP    $remote_addr;
      			proxy_set_header  X-Forwarded-For $proxy_add_x_forwarded_for;
      		}		
      	}
      ```

      我的nginx配置文件目录是`/etc/nginx/nginx.conf`，如果你不知道，可以使用`find / -name nginx.conf`命令进行全局搜索。

6. 解决nginx的SpringBoot 静态文件404问题：

         单独匹配项目还不够，还需要**匹配项目的静态文件**，否则你的css和js等静态文件加载会出现404的情况，我的匹配规则如下：
     
      ```shell
      location ~ \.(css|html|htm|js|gif|jpg|jpeg|png|bmp|swf)$  { 
      	proxy_pass http://127.0.0.1:9090; 
} 
      ```
     
      **最后记得重新加载nginx配置，命令：**`nginx -s reload`
     
      

# 找回MySQL密码

我MySQL安装很久了，但是很少使用，所以密码也不记得。

尝试使用MySQL登陆，结果提示被拒绝：`ERROR 1045 (28000): Access denied for user 'root'@'localhost' (using password: NO)`

1. 使用命令停止MySQL服务：`systemctl stop mysqld`

2. 用以下命令启动MySQL，以不检查权限的方式启动：`mysqld --skip-grant-tables &`

3. 登录mysql：`mysql -uroot`或`mysql`

4. 登陆MySQL后，使用 `\s`命令查询MySQL版本号

   ```shell
   mysql> \s
   --------------
   mysql  Ver 14.14 Distrib 5.7.24, for Linux (x86_64) using  EditLine wrapper
   
   Connection id:          4
   Current database:
   Current user:           root@localhost
   SSL:                    Not in use
   Current pager:          stdout
   Using outfile:          ''
   Using delimiter:        ;
   Server version:         5.7.24 MySQL Community Server (GPL)
   Protocol version:       10
   Connection:             Localhost via UNIX socket
   Server characterset:    latin1
   Db     characterset:    latin1
   Client characterset:    utf8
   Conn.  characterset:    utf8
   UNIX socket:            /var/lib/mysql/mysql.sock
   Uptime:                 6 min 22 sec
   
   Threads: 1  Questions: 20  Slow queries: 0  Opens: 110  Flush tables: 1  Open tables: 105  Queries per second avg: 0.052
   --------------
   
   mysql>
   
   ```

   

5. 然后更新root密码

   ```shell
   mysql5.7以下版本：
   UPDATE mysql.user SET Password=PASSWORD('root') where USER='root';
   
   mysql5.7版本：
   UPDATE mysql.user SET authentication_string=PASSWORD('root') where USER='root';
   ```

6. 刷新权限：`flush privileges;`

7. 退出mysql命令：`exit`或`quit`

8. 使用root用户重新登录mysql

      ```shell
      mysql -uroot -proot
      ```

      参考自：[解决MySQL登录报ERROR 1045 (28000): Access denied for user 'root'@'localhost' (using password: YES)的问题 ](https://blog.csdn.net/qq_32786873/article/details/79225039)


# 总结：

1. 打包SpringBoot 项目使用：`mvn clear package`

2. 在Linux 启动项目使用命令：` nohup java -jar xxx.jar & `

3. 安装和设置Redis参考该教程：[Centos7下安装redis - 醉东风](https://www.cnblogs.com/zuidongfeng/p/8032505.html)

4. 多个项目，可以使用反向代理Nginx工具，它的优点是支持80端口访问多个项目；负载均衡（目前我没用上）；反向代理其他服务器（例如反向代理新浪微博做图床）等等

5. ~~MySQL密码也忘了，后面还要更新下找回MySQL密码。~~ 已经在2019-7-2 18:32:12更新。 [找回MySQL密码](# 找回MySQL密码)

   

   

   

