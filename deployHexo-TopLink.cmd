@echo off
E:
cd E:\HEXO\shanlancoding.github.io
hexo g -d && mshta vbscript:msgbox("部署完成，准备push源程序到仓库",6,"部署完成")(window.close) && call pushGitHub-TopLink.cmd

;;color 4
;;echo 部署完成后，push源程序到仓库
::部署完成后，push源程序到仓库
;;call pushGitHub-TopLink.cmd