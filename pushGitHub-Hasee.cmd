@echo off
set /p commit=commit:
title auto commit
D:\Git\git-bash.exe add -A
D:\Git\git-bash.exe commit -m %commit%
D:\Git\git-bash.exe push
echo ����ִ����ϣ��밴������ر�
pause >null
:exit