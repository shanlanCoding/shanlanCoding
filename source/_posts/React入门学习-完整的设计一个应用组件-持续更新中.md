---
title: React入门学习--如何完整的设计一个应用组件-持续更新中
copyright: true
comments: true
toc: true
tags:
  - React教程
categories:
  - 前端
abbrlink: 261b7f71
date: 2019-08-22 15:37:11
---

# 引言

> 我们认为，React 是用 JavaScript 构建快速响应的大型 Web 应用程序的首选方式。它在 Facebook 和 Instagram 上表现优秀。
>
> [来自官网-React哲学](https://zh-hans.reactjs.org/docs/thinking-in-react.html)

先试想一下，如果让你做一个数据搜索表格页面，你会怎么做？草图如下：

![image](https://wx1.sinaimg.cn/large/96e311f0gy1g68jnc8mh8j206c07pjrm.jpg)

Json数据：

```json
    {category: '体育用品', price: '$49.99', stocked: true, name: 'Football'},
    {category: '体育用品', price: '$9.99', stocked: true, name: 'Baseball'},
    {category: '体育用品', price: '$29.99', stocked: false, name: 'Basketball'},
    {category: '电子产品', price: '$1080', stocked: true, name: 'Hasee'},
    {category: '电子产品', price: '$1000', stocked: true, name: 'Huawei'},
    {category: '电子产品', price: '$99.99', stocked: true, name: 'iPod Touch'},
    {category: '电子产品', price: '$399.99', stocked: false, name: 'iPhone 5'},
    {category: '电子产品', price: '$199.99', stocked: true, name: 'Nexus 7'}
```

#  设计流程

1. 设计组件的原则；根据json数据，创建组件。如果你学过其它的编程语言，可以把组件理解为**函数**或者是**对象**，然后根据[单一功能原则](https://baike.baidu.com/item/%E5%8D%95%E4%B8%80%E5%8A%9F%E8%83%BD%E5%8E%9F%E5%88%99/22718063)来判定组件的范围。说人话就是一个组件它应该只负责一个功能。如果你的组件需要有很多的功能，则应该把该组件拆封成更小的组件，然后把它组装起来变成你想要的功能。

   ![组件划分](https://zh-hans.reactjs.org/static/thinking-in-react-components-eb8bda25806a89ebdc838813bdfa3601-82965.png)

   上图中一共有五种颜色的方法，它代表五个组件。

   1. 最上级的组件`FilterableProductTable` (橙色): 是整个例子应用的整体
   2. 搜索框`SearchBar`(蓝色)：接收用户输入的数据
   3. 商品表`ProductTable`(绿色)：用来暂时商品的列表以及筛选后的列表
   4. 产品分类的标题`ProductCategoryRow` (天蓝色): 为每一个产品类别展示标题
   5. 商品`ProductRow` (红色): 每一行展示一个产品

   其中商品表`ProductTable`的Name和Price没有独立成一个组件。这只是一种偏好，就本例子来说，因为表头只是起到渲染数据结合的作用，所以这个于`ProductTable`是一致，所以仍然把它保留为`ProductTable`的一部分。但是如果你的表头过于复杂，例如有*筛选、排序、数据导出*等功能，那么应该把它独立成一个`TableHeader`组件就非常有必要了。

   层级划分如下：

   - `FilterableProductTable` 可以过滤的表单
     - `SearchBar` 搜索栏
     - `ProductTable` 商品展示表 
       - `ProductCategoryRow` 商品类别的标题
       - `ProductRow` 商品

2. 先使用React创建一个静态版本的页面，最容易的方法是先创建一个不含交互功能的UI界面。最好将UI和交互这两个过程分开设计。原因是编写静态页面版本的时候，需要编写大量的代码，而不需要考虑过多的细节；而添加交互功能的时候，则需要考虑大量的细节，而不需要编写太多的代码。所以，将这两个过程分开更为合适。

   在构建静态版本时，需要创建一些会重用的组件，然后就涉及到数据的传递。数据传递有props和state，而props是父组件向子组件传递数据的方式。即使你熟悉了state的概念，也**完全不应该使用state**构建静态版本。state代表了随时间会产生变化的数据，应该在实现交互时使用。所以构建静态应用的时候，不要使用它。

   在构建应用时，可以采用**自上而下**，或者自下而上构建应用。自上而下意味着首先编写层级较高的组件（比如本文中的`FilterableProductTable` ）。自下而上意味着从最基本的组件开始编写（比如`ProductRow`组件）。**当你的应用比较简单时，使用自上而下方式更为方便**；对于较为大型的项目来说，**自下而上地构建，并同时为低层组件编写测试是更加简单的方式。**

   由于目前只需要构建一个静态版本的应用，所以我们的组件只需要提供`render()`方法用于渲染即可。最顶层的组件`FilterableProductTable` 通过props接收数据参数。如果你的数据模型发生了变化，则再次调用`ReactDOM.render()`，UI就会相应的更新。数据模型变化、调用`Render()`方法、UI就会相应变化。React的**单向数据流（单向绑定）**的思想使得组件模块化，易于快速开发。

   > ### `state` 和 `props` 之间的区别是什么？
   >
   > [`props`](https://zh-hans.reactjs.org/docs/components-and-props.html)（“properties” 的缩写）和 [`state`](https://zh-hans.reactjs.org/docs/state-and-lifecycle.html) 都是普通的 JavaScript 对象。它们都是用来保存信息的，这些信息可以控制组件的渲染输出，而它们的一个重要的不同点就是：`props` 是传递*给*组件的（类似于函数的形参），而 `state` 是在组件*内*被组件自己管理的（类似于在一个函数内声明的变量）。
   >
   > 下面是一些不错的资源，可以用来进一步了解使用 `props` 或 `state` 的最佳时机：
   >
   > - [Props vs State](https://github.com/uberVU/react-guide/blob/master/props-vs-state.md)
   > - [ReactJS: Props vs. State](https://lucybain.com/blog/2016/react-state-vs-pros/)

3. 确定需要使用的State

   使用State有一个原则，只保留应用所需要的可变的State，其它的数据由他们计算而出。例如你编写一个任务清单应用，应该用一个数组来保存所有事情，而不要再定义一个State保存任务个数。当需要任务个数的时候，应该使用数组的length属性即可。

   本例子有如下的几个数据：

   - 所有产品的列表
   - 用户输入的关键字
   - 复选框是否被勾选
   - 经过筛选后的产品列表

   现在需要通过下面的三个问题，来判断是否需要使用State存储：

   1. 该数据是否通过props父组件传递来的？如果是的话，那么它不应该使用State存储。
   2. 该数据是否会随着时间的推移而保持不变？如果是的，那么它也不应该使用State
   3. 你能否通过其他的props或者state计算出该数据？如果是话，那么它也不是使用State

   包含所有产品的列表，它是由父组件的props传入。所以它不是State，如下：

   ```react
   <ProductTable
       products={this.props.products}
   />
   ```

   搜索词和复选框应该使用State，因为它们无法由其它数据计算，而且会随着时间改变

   ```react
   // 保存搜索关键字
   handleFilterTextChange(filterText) {
       this.setState({
           filterText: filterText
       })
   }
   ```

   ```react
   // 保存复选框状态
   handleInStockOnlyChange(inStockOnly) {
       this.setState({
           inStockOnly: inStockOnly
       })
   }
   ```

   经过筛选后的列表，是可以由原始产品列表和搜索词和复选框计算出来的，所以它不应该使用State

   综上所述，属于State有：

   1. 用户输入的搜索词
   2. 复选框是否选中的值

4. 确定State存放的位置

   现在已经在第三步的时候确定了使用哪些State了。接下来，我们还需要确定哪些组件改变了这些State，或者说拥有这些State。

   > **注意：**React中的数据流都是单向的。所谓单向是指不管是父组件或是子组件，都无法知道某个组件是**有状态**的还是**无状态**的，并且它们也并不关心它是函数组件还是 class 组件。这就是为什么称 **state 为局部**的或是**封装**的的原因。除了拥有并设置了它的组件，其他组件都无法访问。而且它顺着组件层级从上往下传递。

   所以哪个组件拥有State的问题，**对于初学者来说比较难以理解**，尽管如此但是还是可以通过下面的几个步骤来判断：

   对于应用中的每一个State：

   1. 找到根据这个State进行渲染的所有组件
   2. 找到他们的共同的父组件
   3. 他们的**共同父组件**或者比这个**共同父组件**层级更高，应该拥有这个State
   4. 如果你找不到一个合适的组件来存放State，那么就直接创建一个新的组件来存放该State，并将这个新组建位置高于共同所有者组件层级的位置

   根据以上五个步骤，我们例子的State位置判断的结果如下：

   - ProductTable需要根据State筛选产品列表。`SearchBar`需要展示搜索词和复选框状态
   - 他们俩共同的父组件是`FilterableProductTable`
   - 所以，搜索词和复选框的值应该很自然的放在`FilterableProductTable`组件中

   根据上面三个步骤，我们已经决定了把State存放在`FilterableProductTable`组建中。因此我们需要开始添加State了：

   1. 将 `this.state = {filterText: '', inStockOnly: false}` 添加到`FilterableProductTable`的`construtor`中设置初始值。

      ```react
      constructor(props) {
          super(props);
          this.state = {
              filterText: 'H',
              inStockOnly: false
          }
      }
      ```

   2. 将 `filterText` 搜索关键词和 `inStockOnly` 复选框勾选作为 props 传入 `ProductTable` 和 `SearchBar`

      ```
      return (
          <div>
              <SearchBar
                  filterText={this.state.filterText}
                  inStockOnly={this.state.inStockOnly}
                  onFilterTextChange={this.handleFilterTextChange}
                  onInStockOnlyChange={this.handleInStockOnlyChange}
              />
              <ProductTable
                  products={this.props.products}
                  filterText={this.state.filterText}
                  inStockOnly={this.state.inStockOnly}
              />
          </div>
      );
      ```

   3. 最后，用这些 props 筛选 `ProductTable` 中的产品信息，并设置 `SearchBar` 的表单值。

5. 添加反向数据流

   在做这件事之前，先要明白一个概念，什么是反向数据流？前面我们学过，目前React可以通过props和State传值。但是State是只能是某个组件内使用，其它的组件也不知道State里有什么内容，这个称为单向数据流。所以，现在如果其它的组件想读取或者修改这个State的值，就称为反向数据流了。概要的说：反向数据流是处于较低层级的表单组件，需要更新较高层级的`FilterableProductTable`中的State中

   React通过一种比传统的双向绑定更加繁琐的方法来实现**反向数据传递**。尽管如此，但这种显示声明的方法更有助于人们理解程序的运作方式。

   如果你在这时尝试在搜索框输入或勾选复选框，React不会产生任何的响应。这个是正常的，因为我们之前已经将Input的值设置为从`FilterableProductTable`的State传递而来的“固定值”

   **重新梳理一下需要实现的功能：**

   1. 每当用户改变表单的值，我们需要改变State来反映用户的当前输入。
   2. 由于State只能由拥有它的组件进行更改，那么`FilterableProductTable` 必须要提供一个触发State改变的回调函数`onInStockOnlyChange`(callback)传递给`SearchBar`。然后可以在`SearchBar`的输入框中使用`onChange`事件来监听用户的输入变化，并通知`FilterableProductTable`传递给`SearchBar`的回调函数`onInStockOnlyChange`
   3. 该回调函数，将会调用`setState()`，从而更新应用

# 源代码地址

带注释的源代码：https://gist.github.com/shanlanCoding/ba8b016e871b22ce505c7aa6696d7bb1

在线演示地址：https://codepen.io/gaearon/pen/LzWZvb