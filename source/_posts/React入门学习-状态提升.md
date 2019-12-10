---
title: React入门学习--状态提升
copyright: true
comments: true
toc: true
tags:
  - React
categories:
  - 前端
abbrlink: 6b4a429b
date: 2019-08-21 09:22:17
---

# 什么是状态提升？

官网是这样解释的：

> 通常，多个组件需要反映相同的变化数据，这时我们建议将共享状态提升到最近的共同父组件中去。

我对“状态提升”的理解是，子组件A和子组件B需要进行**数据交换/共享**，则需要把他们俩需要交换数据的变量temp，放在他们最近的共同父组件内创建。这样，这两个子组件都可以访问到temp变量，并且还可以对temp变量进行修改。

**说人话，“状态提升”可以帮你解决不同组件之间的赋值问题。**



# 详细代码执行流程

## 1.首先React先挂载`Calculator`组件。而`Calculator`组件会调用`render()`渲染页面UI

## 2. `Calculator`组件的`render()`内定义一些变量接收数据。其中用到了三元表达式来调用温度单位换算或者赋值

```react
// 页面初始值
const scale = this.state.scale;
const temperature = this.state.temperature;
// 如果是f，就调用tryConvert()进行温度换算，否则赋值temperature给scale
const celsius =
  scale === "f" ? tryConvert(temperature, toCelsius) : temperature;
const fahrenheit =
  scale === "c" ? tryConvert(temperature, toFahrenheit) : temperature;
```

## 3.在`Calculator`组件的`render()`内的**`return()`**有三个组件。

### A. 两个输入框组件：`TemperatureInput`

#### 1. `TemperatureInput`输入框组件需要接收3个参数：`scale`温度符号、`temperature`温度数值、`onTemperatureChange`调用哪个温度单位转换函数

```react
return (
    <div>
        {/* 
              传入摄氏度
              传入摄氏度函数
         */}
        <TemperatureInput
            scale="c"
            temperature={celsius}
            onTemperatureChange={this.handleCelsiusChange}
        />
        <TemperatureInput
            scale="f"
            temperature={fahrenheit}
            onTemperatureChange={this.handleFahrenheitChange}
         />
        <BoilingVerdict celsius={parseFloat(celsius)} />
    </div>
);
```
#### 2. 在`render()`内接受父组件`Calculator`的值，例如温度`temperature`，以及`onChange`事件执行函数

```react
render() {
  // 接收父组件传递来的温度数值
  const temperature = this.props.temperature;
  // 接收温度标识符。如c或者f。C是摄氏度，F是华氏度
  const scale = this.props.scale;
  // 输入框，带有onChange处理函数
  return (
    <fieldset>
      <legend>请输入温度 / {scaleNames[scale]}</legend>
      <input value={temperature} onChange={this.handleChange} />
    </fieldset>
  );
}
```
#### 3. 该组件的`render()`会渲染出一个输入框

```react
render() {
    // 接收传递来的温度数值
    const temperature = this.props.temperature;
    // 接收温度标识符。如c或者f。C是摄氏度，F是华氏度
    const scale = this.props.scale;
    // 输入框，带有onChange处理函数
    return (
        <fieldset>
            // scaleNames[]数组里是存放华氏度和摄氏度的全称，如 c: "Celsius"
            <legend>请输入温度 / {scaleNames[scale]}</legend>
            <input value={temperature} onChange={this.handleChange} />
        </fieldset>
    );
}
```

#### 4. 上面的input框有一个`onChange`事件，调用了`handleChange()`方法，代码如下：

```react
handleChange(e) {
    // 调用父组件的handleCelsiusChange方法。而handleCelsiusChange方法是由父组件内的this.handleCelsiusChange提供的。
    // 而this.handleCelsiusChange是保存数据的作用，最终该数据会被tryConvert()方法调用，来做温度单位转换
    // 这行代码是调用父组件的onTemperatureChange()方法，然后传入当前输入框的value值，也就是用户输入的数字
    this.props.onTemperatureChange(e.target.value);
}
```

在input输入框里输入数字的时候，会实时把value传入到 `this.props.onTemperatureChange(e.target.value)`并调用。而`onTemperatureChange()`实际上在调用`handleCelsiusChange()`来保存用户输入的数据到state内。

```react
// 保存 摄氏度 数据
handleCelsiusChange(temperature) {
  this.setState({ scale: "c", temperature });
}
// 保存 华氏度 数据
handleFahrenheitChange(temperature) {
  this.setState({ scale: "f", temperature });
}
```

例如在`handleCelsiusChange(temperature)`的`temperature`就是

### B. 一个提供沸腾信息显示的`BoilingVerdict`，判断`celsius`是否大于等于100

```react
// 是否是开水
function BoilingVerdict(props) {
    if (props.celsius >= 100) {
        return <p>水开了</p>;
    }
    return <p>水还没有沸腾</p>;
}
```

#    总结

1. React挂载组件`<Calculator />`

2. `<Calculator />`里，定义了初始值温度、温度单位、温度转换函数，以及渲染了2个输入框，1个文本提示。初始值均为空字符串

3. 给输入框组件`<TemperatureInput />`传递了三个参数：*scale*、*temperature*、*onTemperatureChange*。这三个参数初始值默认为空

   *scale*：	温度的单位；初始值为空，后续根据用户在哪个输入框里输入，来赋值。

   *temperature*：	已经计算好温度；初始值空字符串，后续根据用户的输入框来赋值。

   *onTemperatureChange*：	调用父组件的`handleCelsiusChange`方法。而`handleCelsiusChange`方法是由父组件内的`this.handleCelsiusChange`提供的。而`this.handleCelsiusChange`是保存数据的作用，最终该数据会被`tryConvert()`方法调用，用来做温度单位转换。**其中这个参数重中之重，因为该参数准确的作用是将父组件的方法传递给子组件调用，从而实现了子组件向父组件赋值的功能，也就是所谓的状态提升**

   

   

# 完整代码

完整注释：[https://gist.github.com/shanlanCoding/725bc0b068f359e29f6e1bf31a1019cc](https://gist.github.com/shanlanCoding/725bc0b068f359e29f6e1bf31a1019cc)

在线演示： [https://codepen.io/gaearon/pen/WZpxpz](https://codepen.io/gaearon/pen/WZpxpz)

# 效果图

![效果图](https://zh-hans.reactjs.org/react-devtools-state-ef94afc3447d75cdc245c77efb0d63be.gif)