---
title: React入门学习-State和生命周期
copyright: true
comments: true
toc: true
tags:
  - React教程
categories:
  - 前端
abbrlink: cc206ca3
date: 2019-08-16 17:20:04
---
# 先讲几个React常识

1. React一共有两种组件；而组件类似于函数的概念，它最主要的作用是为了代码复用，拼装你需要的功能，你前期可以这么粗略的理解，但是我相信随着你的学习深入，到了后期又会有不一样的理解。另外，React官方强烈建议：**不要创建自己的组件【基类】。** 在 React 组件中，[代码重用的主要方式是组合而不是继承](https://zh-hans.reactjs.org/docs/composition-vs-inheritance.html)。

   两个组件分别为：**函数式组件**和**Class式组件**。函数式组件和原生JavaScript的函数是相同的，而Class式组件是ES6新增的，大体的作用是引入了面向对象的概念，这是以前没有的。[Class语法请参考MDN](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Statements/class#语法)

2. 为什么要用Class组件而不是用Function组件呢？使用State、生命周期等新的特性需要用到Class组件。

# 生命周期

## 什么是生命周期？

每个组件都包含“生命周期方法”，你可以重写这些方法，以便于在运行过程中特定的阶段执行这些方法。**你可以使用此生命周期图谱作为速查表**。在下述列表中，常用的生命周期方法会被加粗。其余生命周期函数的使用则相对罕见。

## 为什么要使用生命周期？

当组件比较多的时候，如果能把不需要使用的组件销毁掉，可以释放非常宝贵的系统资源。说人话就是不要的东西丢垃圾桶里，释放你家里宝贵的可用空间。应用场景例如：当页面有一个定时器，我们这个定时器使用完毕以后应该去销毁，以释放内存，所以这个时候可以用上生命周期方法。

## 挂载-mount

当 `Clock` 组件第一次被渲染到 DOM 中的时候，就为其[设置一个计时器](https://developer.mozilla.org/en-US/docs/Web/API/WindowTimers/setInterval)。这在 React 中被称为“挂载（mount）”。

当组件实例被创建并插入 DOM 中时，其生命周期调用顺序如下：

1. [**constructor()**](https://zh-hans.reactjs.org/docs/react-component.html#constructor)
2. [`static getDerivedStateFromProps()`](https://zh-hans.reactjs.org/docs/react-component.html#static-getderivedstatefromprops)
3. [**render()**](https://zh-hans.reactjs.org/docs/react-component.html#render)
4. [**componentDidMount()**](https://zh-hans.reactjs.org/docs/react-component.html#componentdidmount)

> 注意:
>
> 下述生命周期方法即将过时，在新代码中应该[避免使用它们](https://zh-hans.reactjs.org/blog/2018/03/27/update-on-async-rendering.html)：
>
> - [`UNSAFE_componentWillMount()`](https://zh-hans.reactjs.org/docs/react-component.html#unsafe_componentwillmount)

## 卸载-unmount

同时，当 DOM 中 `Clock` 组件被删除的时候，应该[清除计时器](https://developer.mozilla.org/en-US/docs/Web/API/WindowTimers/clearInterval)。这在 React 中被称为“卸载（unmount）”。当组件从 DOM 中移除时会调用如下方法：

- [**componentWillUnmount()**](https://zh-hans.reactjs.org/docs/react-component.html#componentwillunmount)

**除了挂载和卸载，还有[更新](https://zh-hans.reactjs.org/docs/react-component.html#updating)，有兴趣你也可以点击学习。上面的两种方法，都称为“生命周期方法”**

# State

## 什么是State？

本次学习后我对State的理解为它是用来保存一些你需要数据的变量，而**子组件**可以在这个变量里提取你**在父组件里**传递的数据，类似一个存**数据的容器**，仅此而已。

# 正确的使用State

关于 `setState()` 你应该了解三件事：

### 不要直接修改 State

例如，此代码不会重新渲染组件：

```react
// 错误的
this.state.comment  = "你好";
```

而是应该使用`setState()`

```react
// 正确的
this.setState({comment: "你好"});	
```

另外**构造函数constructor**是唯一可以给 `this.state` 赋值的地方：

### State的更新可能是异步的

出于性能考虑，React 可能会把多个 `setState()` 调用合并成一个调用。

因为 `this.props` 和 `this.state` 可能会异步更新，所以你不要依赖他们的值来更新下一个状态。

例如，此代码可能会无法更新计数器：

```react
// 错误
this.setState({
  counter: this.state.counter + this.props.increment,
});
```

要解决这个问题，可以让 `setState()` 接收一个函数而不是一个对象。这个函数用上一个 state 作为第一个参数，将此次更新被应用时的 props 做为第二个参数：

```React
// 正确
this.setState((state, props) => ({
  counter: state.counter + props.increment
}));
```

上面使用了[箭头函数](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Functions/Arrow_functions)，不过使用普通的函数也同样可以：

```React
// 正确
this.setState(function(state, props) {
  return {
    counter: state.counter + props.increment
  };
});
```

### State 的更新会被合并

当你调用 `setState()` 的时候，React 会把你提供的对象合并到当前的 state。

例如，你的 state 包含几个独立的变量：

```React
this.state = {
  title : 'React',
  content : 'React is an wonderful JS library!'
}
```

当只需要修改状态`title`时，只需要将修改后的`title`传给`setState`：

```React
this.setState({title: 'ReactJs'});
```

React会合并新的`title`到原来的组件状态中，同时保留原有的状态`content`，合并后的State为：

```React
{
  title : 'ReactJs',
  content : 'React is an wonderful JS library!'
}
```

所以 `this.setState({title})` 替换了原来的“React”，但是"Content"的内容没有修改。





# 数据的流动

不管是父组件还是子组件都无法知道某个组件是有状态还是无状态的，并且也不关心它是函数式组件还是Class组件。

这就是为什么称State为局部的或者是封装的原因。除了拥有并设置了它的组件，其它组件都无法访问。

组件可以选择把它的State作为props向下传递到它的子组件中：

```React
<h1> 现在是北京时间： {this.state.date.toLocaleTimeString() } </h2>
```

 也可以用在自定义的组件上：

```React
<FormattedDate date = { this.state.date } />
```

FormattedDate组件会在它的props中接收参数Date，但是组件本身无法知道它是来自于`Clock`的state，或者`Clock`的props，又或者是手动输入的：

```React
function FormattedDate(props) {
  return <h2>现在是北京时间： {props.date.toLocaleTimeString()}</h2>;
}
```

这种叫做“自上而下”或者“单向”数据流。任何的State总是所属于特定的组件，而且该State派生的任何数据或者UI只能影响“低于”他们的组件。

如果你把一个以组件构成的树，想象成一个props的数据瀑布的话，那么每一个组件的State就像是在任意一个点上给瀑布增加额外的水源，但是它只能向下流动。

为了证明每个组件都是真正独立的，我们可以创建一个渲染三个 `Clock` 的 `App`组件：

```
function App() {
  return (
    <div>
      <Clock />
      <Clock />
      <Clock />
    </div>
  );
}

ReactDOM.render(
  <App />,
  document.getElementById('root')
);
```

每个 `Clock` 组件都会单独设置它自己的计时器并且更新它。

在 React 应用中，组件是有状态组件还是无状态组件属于组件实现的细节，它可能会随着时间的推移而改变。你可以在有状态的组件中使用无状态的组件，反之亦然。

# 完整代码

```react
// 函数式组件
function Clock1(props){
  return(
    <div>
      <h1>你好，朋友</h1>
      <h2>现在是{ props.date.toLocaleTimeString() }</h2>
    </div>
  );
}

// Class式组件
class Clock2 extends React.Component{
  // 构造函数默认加载并执行一次，起到传递数据的作用
  constructor(props){
    // 获取父类的数据；Class 组件应该始终使用 props 参数来调用父类的构造函数。
    super(props);
    // 添加一个data到state内
    this.state = { date : new Date() };
  }
  // 生命周期-挂载-渲染后运行；可以用来加装定时器等作用
  componentDidMount(){
    // 添加定时器,接受返回ID
    this.timerID = setInterval(
      () => this.tick(),1000
    );

  }
  // 生命周期-卸载-
  componentWillUnmount(){
    // 清除定时器
    clearInterval(this.timerID);
  }
  // 修改时间
  tick(){
    // 修改data数据
    this.setState({
      date: new Date()
    });
  }

  // 渲染
  render(){
    return(
      <div>
        <h2>现在是{ this.state.date.toLocaleTimeString() }</h2>
        <FormattedDate date = { this.state.date }/>
      </div>
    );
  }
}
// Class组件-end

// 多个组件渲染，他们是相互独立的
function App(){
  return (
    <div>
      <Clock2 />  
      <span>---</span>
      <Clock2 />
      <span>---</span>
      <Clock2 />
      <span>---</span>
    </div>
  );
}

// 自定义函数式组件，从父级获取参数
function FormattedDate(props) {
  return <h2>第二种 { props.date.toLocaleTimeString() } </h2>;
}

// 渲染
ReactDOM.render(
  <App />,
  document.getElementById('root')
);


// 
let  node = {
  type : "解构",
  name : "解构测试"
};
// ({type，name}) = node;//{}在js中作为代码块，单独使用加等号会报错会报错

let { type:Type , name:Name } = node;
let i = 0;
console.log(Type + i++);
console.log(Name + i++); 

let { type:myType , name:myName } = node;
console.log(myType + i++);
console.log(myName + i++); 
```



