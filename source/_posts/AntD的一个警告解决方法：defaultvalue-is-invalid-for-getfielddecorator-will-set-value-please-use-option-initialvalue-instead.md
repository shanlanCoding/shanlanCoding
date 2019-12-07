---
title: >-
  AntD的一个警告解决方法：defaultvalue is invalid for getfielddecorator will set value
  please use option.initialvalue instead
copyright: true
comments: true
toc: true
tags:
  - React
categories:
  - 前端
abbrlink: 7080982b
date: 2019-12-07 16:58:03
---

# 症状

控制台报错截图：

![控制台报错截图](https://i.loli.net/2019/12/07/uhHVsOg5qNtp6nz.png)

点击提示后会展开详细信息：

![展开详细信息](https://i.loli.net/2019/12/07/JCFj9PrlMOITixw.png)

# 错误原因

根据报错的提示语得知，在设置默认值的时候，应该使用：`option.initialValue`，而不是直接使用：`defaultValue`

错误代码：

```javascript
getFieldDecorator('name', {  
	rules: [{ required: true, message: '请输入姓名!' }], 
   })
   (  
   	<Input defaultValue="测试" value="测试" />, 
   	)
}
```

正确代码：

```javascript
getFieldDecorator('name', {  
	rules: [{ required: true, message: '请输入姓名!' }], 
	initialValue: "你需要设置的默认值",
   })
   ( 
   	<Input />, 
   	)
}
```

# 如何解决？

在展开报错详情的第四行，就是我代码有问题的地方，详细如下：

```javascript
{
    getFieldDecorator(
        item.name,
        {
            rules: item.rules,
            initialValue: defaultValue
        }
    )
    (
        <RadioGroup
            buttonStyle="solid"
            onChange={item.onChange}
            //组件里不应该设置默认值，如果需要设置应该在：initialValue里设置
            defaultValue={item.defaultValue}
        >
            {
                item.options.map( item =>
                    <Radio
                        key={item.value}
                        onChange={item.onchange}
                        value={item.value}
                        checked={item.checked}
                    >
                        {item.text || item.value}
                    </Radio> )
            }
        </RadioGroup>
    )
}
```

所以我只需要把`defaultValue={item.defaultValue}`这张注释即可。

# 总结

本问题不难，以为我看到这一大串的报错提醒都会选择略过，然后使用搜索引擎苦苦搜索。事实上只要多观察报错提醒，就可以很简单的解决问题。

