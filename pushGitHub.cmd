@echo off
set /p commit=commit:
title auto commit
D:\Git\bin\git.exe add -A
D:\Git\bin\git.exe commit -m %commit%
D:\Git\bin\git.exe push orgin master
echo ����ִ����ϣ��밴������ر�
pause >null
:exit