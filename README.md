# 本项目为HEXO博客的后台程序

### 本程序的博客地址为：[博客](https://blog.gobyte.cn/)，部署在GitHub pages和Coding上，再配合CDN就能够达到我当前博客的效果，最为重要的是，这一切都是**免费**的！

### 如果你也想使用该程序部署博客，请自行搜索：HEXO+GitHub pages等关键字

### 另外，部署完毕以后，你还需要做一些优化操作，添加一些你需要的功能。具体可以参考该教程：[Hexo优化教程](https://blog.gobyte.cn/post/ad2324d4.html)

### 本博客使用的[Pure](https://github.com/cofess/hexo-theme-pure)主题（私有访问），目前已经通过Git备份至[GitHub](https://github.com/shanlanCoding/myPure)和[Coding](https://dev.tencent.com/u/shanl/p/myPure/git)，推荐你也可以这样做。具体的方法是：

1. 创建一个私有的仓库

2. 使用下面的命令备份至第一步创建的私有仓库内：

   ```shell
   echo "# myPure" >> README.md
   git init
   git add -A
   git commit -m "first commit"
   git remote add origin 你创建的仓库地址 #这里注意把地址替换
   git push -u origin master
   
   ```

   

