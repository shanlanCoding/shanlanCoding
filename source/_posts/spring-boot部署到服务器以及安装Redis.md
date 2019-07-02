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

   ## 配置nginx

   ### 第一种方法（不推荐）

   由于已经有了一个tomcat项目，所以第二个项目必须要在nginx里添加配置，否则访问就需要加端口访问了，我的配置如下：

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
     
     ### 第二种方法
     
     2019-7-2 19:42:50更新：
     
     第一种方法有弊端。因为项目的请求链接基本是固定的。
     
     例如项目的登陆地址是：www.gobyte.cn/login
     
     如果使用了第一种，那么必须加一个目录：www.gobyte.cn/xxx/login。
     
     而多了一层目录以后，预先项目的请求地址实际上还是www.xxxx.cn/login。仅仅只是匹配了xxx只能解决页面的加载，实际post的时候会导致404，如果不想404，就只能把所有的请求都转发。那样其他的项目就会发生冲突。或者修改项目的post请求，给请求也加上/xxx/目录，但是这样弊端很大，因为需要改动源代码，所以可以通过第二种方法，使用二级域名来对应新的项目。
     
     1. 添加dns解析，例如我第二个项目打算使用二级域名为：b.gobyte.cn，那么把dns的解析为b，至于记录值还是你的服务器ip
     
     2. 修改nginx.conf配置：
     
        ```shell
        # 第二个项目
           server {
                listen	80; #你要监控的端口。https是监控443
                server_name b.gobyte.cn; #填写你要项目域名
                index index.html index.htm index.php default.html default.htm default.php;
        
                location / {
                    proxy_pass http://127.0.0.1:9090;
        			proxy_set_header  Host       $host;
        			proxy_set_header  X-Real-IP    $remote_addr;
        			proxy_set_header  X-Forwarded-For $proxy_add_x_forwarded_for;
                }
                error_page   500 502 503 504  /50x.html;
                location = /50x.html {
                    root   html;
                }
            }
        ```
     
        3. `nginx -s reload` 进行重新加载nginx配置
        
           参考：[[nginx在一个服务器上配置两个项目，并通过两个不同的域名访问](https://www.cnblogs.com/banma/p/9069858.html)

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

# CentOS7开启MySQL远程访问

<details>
    <summary>点击查看完整的脚本命令</summary>
```shell
    [root@github ~]# mysql -uroot -proot #登陆MySQL
    mysql> use mysql #选择MySQL表
    Reading table information for completion of table and column names
    You can turn off this feature to get a quicker startup with -A
    Database changed
    mysql> update user set host='%' where user='root' and host='localhost'; #修改登陆主机
    Query OK, 1 row affected (0.00 sec)
    Rows matched: 1  Changed: 1  Warnings: 0
    mysql> UPDATE user SET password=password("root") WHERE user='root'; 	#重新设置一下密码，因为这时密码已失效，虽然本地还可以原密码登录，可远程改了host后还是没法访问
    mysql> flush privileges; #刷新权限
    Query OK, 0 rows affected (0.00 sec)
    mysql> exit #退出 MySQL
    Bye
    [root@github ~]# service mysqld restart; #重启MySQL
    Redirecting to /bin/systemctl restart  mysqld.service
    Job for mysqld.service failed because the control process exited with error code. See "systemctl status mysqld.service" and "journalctl -xe" for details.
</details>

​		参考：[CentOS7和CentOS6怎样开启MySQL远程访问](https://blog.csdn.net/u014066037/article/details/55194802)

# 总结：

1. 打包SpringBoot 项目使用：`mvn clean package`

2. 在Linux 启动项目使用命令：` nohup java -jar xxx.jar &    `   ；停止运行使用:`ps -ef|grep xxxx.jar`查询出pid，然后使用：`kill -9 pid`命令杀死进程，你还可以使用脚本来管理程序：

   <details>
       <summary>点击展开完整的脚本</summary>
          ```shell
               #!/bin/bash
               #这里可替换为你自己的执行程序，其他代码无需更改
               APP_NAME=apply-0.0.1-SNAPSHOT.jar
               #使用说明，用来提示输入参数
               usage() {
                   echo "Usage: sh 执行脚本.sh [start|stop|restart|status]"
                   exit 1
               }
               #检查程序是否在运行
               is_exist(){
                 pid=`ps -ef|grep $APP_NAME|grep -v grep|awk '{print $2}' `
                 #如果不存在返回1，存在返回0     
                 if [ -z "${pid}" ]; then
                  return 1
                 else
                   return 0
                 fi
               }
               #启动方法
               start(){
                 is_exist
                 if [ $? -eq "0" ]; then
                   echo "${APP_NAME} is already running. pid=${pid} ."
                 else
                   nohup java -jar $APP_NAME > /dev/null 2>&1 &
                 fi
               }
               #停止方法
               stop(){
                 is_exist
                 if [ $? -eq "0" ]; then
                   kill -9 $pid
                 else
                   echo "${APP_NAME} is not running"
                 fi  
               }
               #输出运行状态
               status(){
                 is_exist
                 if [ $? -eq "0" ]; then
                   echo "${APP_NAME} is running. Pid is ${pid}"
                 else
                   echo "${APP_NAME} is NOT running."
                 fi
               }
               #重启
               restart(){
                 stop
                 start
               }
               #根据输入参数，选择执行对应方法，不输入则执行使用说明
               case "$1" in
                 "start")
                   start
                   ;;
                 "stop")
                   stop
                   ;;
                 "status")
                   status
                   ;;
                 "restart")
                   restart
                   ;;
                 *)
                   usage
                   ;;
               esac
       		```
   </details>


3. 安装和设置Redis参考该教程：[Centos7下安装redis - 醉东风](https://www.cnblogs.com/zuidongfeng/p/8032505.html)

4. 多个项目，可以使用反向代理Nginx工具，它的优点是支持80端口访问多个项目；负载均衡（目前我没用上）；反向代理其他服务器（例如反向代理新浪微博做图床）等等

5. ~~MySQL密码也忘了，后面还要更新下找回MySQL密码。~~ 已经在2019-7-2 18:32:12更新。 [找回MySQL密码](#找回MySQL密码)

