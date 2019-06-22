@echo off
D:
cd D:\GitHub_Pages\Hexo-git\shanlancoding.github.io
hexo g && hexo d

call .\pushGitHub.cmd
