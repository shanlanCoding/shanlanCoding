@echo off
E:
cd E:\HEXO\shanlancoding.github.io
hexo g -d && mshta vbscript:msgbox("������ɣ�׼��pushԴ���򵽲ֿ�",6,"�������")(window.close) && call pushGitHub-TopLink.cmd

;;color 4
;;echo ������ɺ�pushԴ���򵽲ֿ�
::������ɺ�pushԴ���򵽲ֿ�
;;call pushGitHub-TopLink.cmd