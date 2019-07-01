@echo off
set /p commit=commit:
title auto commit
D:\Git\bin\git.exe add -A
D:\Git\bin\git.exe commit -m %commit%
D:\Git\bin\git.exe push orgin master
echo 命令执行完毕，请按任意键关闭
pause >null
:exit