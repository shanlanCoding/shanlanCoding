---
title: Java练习题
copyright: true
comments: true
toc: true
tags:
  - Java面试题
categories:
  - Java
abbrlink: 6669b4ec
date: 2019-07-13 20:21:02
---

# 1. map怎么实现hashcode和equals,为什么重写equals必须重写hashcode

## 1. equals方法是Object类的一个基本方法，他实际上是用来比较两个对象的引用地址是否一致，从而返回一个Boolean结果。

```java
public boolean equals(Object obj) {
	return (this == obj);     
}
```
## 2. equals()与‘==’的区别
      大多人会说`equlas`是比较内容，而`==`是比较内存地址。但是从上面的代码可以得知，`equals`实际上是借用了`==`运算符，比较了内存地址，所以上述的回答是正确的吗？先看一段示例代码：
```java
public class Car {
          private int batch;
          public Car(int batch) {
          this.batch = batch;
      }
      // ----------------------------
      public static void main(String[] args) {
          Car c1 = new Car(1);
          Car c2 = new Car(1);
          System.out.println(c1.equals(c2));
          System.out.println(c1 == c2);
      }
}
```
**返回结果：**

```java
false
false
```
**分析：**对于`==`返回的flase很好理解，，因为`==`是比较内存地址，而两个Car对象的地址是不同的，所以自然是false。
但是对于`equals`返回的false，是怎么理解的？如果说`equals`是比较内容，此时应该是返回true，为什么是返回false？这是因为Java里所有的对象都是基于Object类，所以Car类也是继承自Object类，自然也有equals方法。但是从问题1的代码可以得知，`equals`方法的是依赖于运算符`==`，所以在不重写`equals`方法的时候，默认还是比较两个对象的内存地址，两个对象的地址不同，自然返回false。
**如果我想让Car的batch相等，则用equals也返回true时，应该怎么做？**
在Car里，重写equals方法，判断Car的batch属性即可，示例代码如下：

```java
@Override
public boolean equals(Object obj) {
    if (obj instanceof Car) {
        Car c = (Car) obj;
        return batch == c.batch;
    }
    return false;
}
```
**代码原理：**通过instance关键字，判断对象是否属于Car类，通过后进一步判断batch属性是否相等。否则返回false。

**总结：**默认情况下equals方法和==是等价的，是对比对象的内存地址。但是我们可以通过方法重写，按照我们自己的需求进行比较。例如String类的equals方法，是比较字符串的序列，而不再是内存地址。

## 3.**为什么重写equals()的同时还得重写hashCode()**

Map集合在添加元素的时候，先要计算该元素的Hash值，然后根据Hash值才决定该元素的存储位置。当多个元素的Hash值相同的时候，就会以链表的形式存储。但是在存储之前还需要与旧元素进行对比是否相同，如果相同则不存入。不重写HashCode会导致**相同内容的一个对象，在取出时为null。**原因就是虽然两个对象内容相同，但是由于没有重写HashCode方法，导致默认调用Object类的HashCode方法，返回了该对象的地址，而两个对象虽然内容是相同，但是地址不同的，那么新的对象就去一个不存在bucket里寻找，自然是返回null。

参考自：[重写equal()时为什么也得重写hashCode()之深度解读equal方法与hashCode方法渊源](https://blog.csdn.net/javazejian/article/details/51348320)