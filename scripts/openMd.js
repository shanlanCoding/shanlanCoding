var spawn = require('child_process').exec;

// Hexo 3 用户复制这段
hexo.on('new', function(data){
  spawn('start  "D:\软件\Typora\Typora.exe" ' + data.path);
});

// 给img添加referer policy 标签，解决referer图片防盗链
hexo.extend.tag.register('s', function(args){
  const image_url = args[0], alt = args[1];
  return `<img src="${image_url}" alt="${alt}" referrerpolicy="no-referrer"></img>`
});