@echo off
set /p commit=commit:
title auto commit
C:\Program Files\Git\bin\git.exe add -A
C:\Program Files\Git\bin\git.exe commit -m %commit%
C:\Program Files\Git\bin\git.exe push
echo ����ִ����ϣ��밴������ر�
pause >null
:exit