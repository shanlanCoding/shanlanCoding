---
title: 使用脚本批处理让Hexo一键部署和推送到远程仓库
copyright: true
comments: true
toc: true
tags:
  - Hexo
categories:
  - 博客优化
abbrlink: 69d4d350
date: 2019-08-19 15:52:31
---

# 缘由

通常Hexo博客程序需要使用命令进行生成然后再部署到服务器，如果备份博开程序的话，还需要使用Git进行push操作，异常的繁琐。为此，我将利用脚本功能，来实现自动化操作，降低重复劳动。

# 操作方法

1. 新建txt记事本文件：`deployHexo.cmd`

2. 将以下批处理代码粘贴到你刚建立的txt内，然后根据你的实际情况进行修改，下面是Hexo 的d**eploy部署脚本**

   ```powershell
   @echo off
   D: ::切换到你hexo程序所在的磁盘，例如我是在D盘
   cd D:\GitHub_Pages\Hexo-git\shanlancoding.github.io ::切换到你Hexo程序的完整目录
   hexo g -d && mshta vbscript:msgbox("部署完成，准备push源程序到仓库",6,"部署完成")(window.close) && color 4 && call pushHexo.cmd ::这一行其实有四条命令，通过&& 符号连接起来执行
   ```

   下面是把Hexo源程序通过Git push到远程仓库的批处理脚本，也就是**备份你的Hexo程序**，

   新建文件名：`pushHexo.cmd`保存

   ```powershell
   @echo off
   set /p commit=commit:
   title auto commit
   cd C:\Program Files\Git\bin\
   git.exe add -A
   git.exe commit -m %commit%
   git.exe push
   echo 命令执行完毕，请按任意键关闭
   pause >null
   ```

# 命令详解

### deployHexo.cmd 文件

1. `@echo off` 关闭不必要的批处理提示语
2. `D:` 切换到你hexo程序所在的磁盘，例如我是在D盘
3. `cd D:\GitHub_Pages\Hexo-git\shanlancoding.github.io`  切换到你Hexo程序的完整目录
4. `hexo g -d`  Hexo命令，生成静态页面文件
5. `mshta vbscript:msgbox("部署完成，准备push源程序到仓库",6,"部署完成")(window.close)`  弹出Windows对话框，用于提示
6. `color 4` 修改控制台的字体颜色
7.  `call pushHexo.cmd`  调用另一个批处理文件

### pushHexo.cmd 文件

1. `set /p commit=commit:` 设置变量用来接收你输入的push描述
2. `title auto commit` 设置批处理窗口的标题
3. `cd C:\Program Files\Git\bin\` 切换到你的`Git.exe`目录，**注意是Git.exe，而不是git-bash.exe**，由于我的Git本身安装在C盘，若你的安装在C盘以外，例如D盘，则在执行这条命命令之前还需要添加一条命令：`D:`
4. `git.exe add -A` 添加所有变动的文件到本地Git暂存区
5. `git.exe commit -m %commit%` 将本地Git暂存区的文件提交给本地仓库，并且戴上了本次提交的描述
6. `git.exe push`  将本地仓库文件推送给远程仓库，可以理解为上传
7. `echo 命令执行完毕，请按任意键关闭` 批处理的提示语
8. `pause >null` 让批处理界面暂停而不会自动关闭界面

# 使用方法

1. 当你把两个文集都修改完成后，双击启动`deployHexo.cmd`文件后，批处理将会自动调用`hexo generate `和` hexo deploy` 

2. 当`deployHexo.cmd`文件执行完毕后，将会有一个系统弹窗来提醒你，输入一个push消息，然后就可以回车确认了

   



