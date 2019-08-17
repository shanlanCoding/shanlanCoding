@echo off
set /p commit=commit:
title auto commit
D:\Git\git-bash.exe add -A
D:\Git\git-bash.exe commit -m %commit%
D:\Git\git-bash.exe push
echo 命令执行完毕，请按任意键关闭
pause >null
:exit