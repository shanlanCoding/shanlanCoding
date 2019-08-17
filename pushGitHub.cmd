@echo off
set /p commit=commit:
title auto commit
C:\Program Files\Git\bin\git.exe add -A
C:\Program Files\Git\bin\git.exe commit -m %commit%
C:\Program Files\Git\bin\git.exe push
echo 命令执行完毕，请按任意键关闭
pause >null
:exit