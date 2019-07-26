---
title: Java集合框架系统学习
copyright: true
comments: true
toc: true
tags:
  - java集合框架
categories:
  - Java
abbrlink: 57eede11
date: 2019-07-04 17:23:55
---

# 写在前面：

### 什么是Java集合-What？

1. Java集合是Java编程语言自带的功能。存放于java.util包下；
2. Java集合其实可以分为三个小类：Set、List、Map
3. 集合最大的目的是用来存储数据用的，不过存储的是数据的引用，也可以理解是内存地址。集合主要是便于开发者对数据进行增删改查等等操作，所以才会有“集合”这种东西。

### 为什么要学习集合-Why？

1. 笼统的说，学习集合最终是为了更好的开发程序
2. 不负责任的说，是为了考试、面试

### 如何学习集合-How？

1. 学习集合的特点

2. 学习集合的使用方法

3. 学习集合的构成原理

这里我仅复习1和3，至于2需要在实际开发中渐进式学习。

学习集合框架，更多的是在于理解基础概念，再慢慢结合到实际编码中，**所以少不了记忆**。

# 集合框架的两大分类：

Java集合框架可分为两大类`Collection`和`Map`，两者区别如下：

1. Collection是单列集合；Map是双列集合 

2. Collection中只有Set系列要求元素唯一；Map中键唯一，值可以重复

3. Collection的数据结构是针对元素的；Map的数据结构是针对键

   ![集合框架体系图](//ws4.sinaimg.cn/large/96e311f0gy1g4nxy8vttgj20i80bu41o.jpg)

# Collection集合类

Collection ：**是一个集合接口**。它提供了对集合对象进行基本操作的通用接口方法。Collection接口在Java 类库中有很多具体的实现。Collection接口的意义是为各种具体的集合提供了最大化的统一操作方式。

Collections：**是一个包装类**。它包含有各种有关集合操作的**静态多态方法**。此类**不能实例化**，就像一**个工具类**，服务于Java的Collection框架。

-----

如上图，Collection体系分为两大类：Set 和 List。例如以下Java代码使用工具类collections实现排序功能，当然还有很多其他功能

## List集合

**List特点：存取有顺序；有下标索引；可以根据索引进行取值；元素也可以重复**

#### ArrayList

**线程不同步；底层原理是数组；**初始容量为10，当数组大小不足时，会自动扩充当前容量的1.5倍+1。ArrayList的元素内存地址是连续的，所以查询速度快。由于增删需要挪动数组内的数据，所以增删速度慢。为追求效率，ArrayList没有实现同步锁（synchronize）。若需要同步，可以手动添加同步锁，也可以用**Vector代替**。注意，Vector已经过时。

#### Vector（已过时）

**线程同步，但是效率低；**容量不足时，默认扩充当前容量的一倍。

#### LInkedList

**线程不同步；双向链表实现；**查询慢，增删快。查询慢是因为底层采用链表数据结构，而链表的内存地址不连续，所以查询慢。增删快是因为在增删时，不需要移动元素，只需要改变相关元素的头尾指针地址值。可以用来模拟栈和队列，栈是先进后出，而队列是先进先出。

LinkedList同时实现了List和Deque接口，可以将它看做一个顺序的容器，也可以看成一个[队列（Deque）](https://baike.baidu.com/item/队列/14580481)[^队列Deque]，同时还能看做成一个[栈（Stack）](https://baike.baidu.com/item/%E6%A0%88/12808149)[^栈Stack]。如果这样的话，LinkedList将是一个全能的超人。当你需要使用栈（Stack）和队列（Deque）时，可以考虑使用LinkedList，一方面是因为Java官方已经声明不建议使用Stack类，更遗憾的是Java里根本没有一个叫做Deque的类（Deque是接口）。关于栈（stack）或队列（Deque），现在的首选是ArrayDeque，它有着比LinkedList（当栈stack和队列Deque使用时）更好的性能。



## Set集合

**特点：存取无序；不可以重复；没有下标。**

#### HashSet

**线程不同步，存取速度快**，内部使用HashMap进行存储数据，且提供的方法基本都是调用HashMap的方法。所以两者本质相同，元素可以为Null。

Hash表是通过HashCode和equals方法保证唯一性。

Hash表存储元素的过程：首先根据被存储的元素来计算出HashCode值，然后根据计算出的HashCode值和数组的长度进行计算出存储的下标；如果该下标位置没有元素，则直接存储。如果有元素，直接用equals方法将被存入的元素和已有的元素进行对比，若结果为真则放弃储存。如果为假，则以链表的形式进行存储。

**HashCode如何计算**，请看这里：[如何重写HashCode方法](# 问：如何重写HashCode方法：)

##### 	LinkedHashSet
链表+Hash技术进行存储的，根据HashCode决定插入的位置，使用链表来维护次序。所以存取有序，又因为需要维护元素的顺序，所以比HashSet效率低；线程不安全

#### TreeSet

**线程不同步，底层原理使用二叉树结构[^1]，存储自然顺序[^2]，**元素唯一，内部使用TreeMap的SortedSet。

TreeSet保证元素唯一性的两种方法：

1. 自定义对象实现接口`Comparable`的`comparaTo`方法，该方法返回0表示相等，小于0表示准备存入的元素比被比较的元素小，否则大于0。

2. 在创建TreesSet的时候向构造器中传入比较器`Comparator`接口的实现类，实现`Comparator`接口重写`compara`方法。 

   注意：如果存入自定义对象的时候，自定义类没有实现接口`Comparable`的`comparaTo`方法。或者也没有传入比较器`Comparator`，程序将会报错`ClassCastException`异常

# Collection体系的总结：

**List ：存取有序，元素有索引，元素可以重复**

ArrayList：数组结构，查询快，增删慢，由于线程不安全，所以效果比较高。

Vector：数组结构，查询快，增删慢，由于是线程安全，所以效率不如ArrayList

```java
 addFirst()    removeFirst()    getFirst()
```

**Set：存取无序，元素没有索引，元素不重复**

HashSet：存储无序，没有索引，元素不允许重复，底层由Hash表实现

TreeSet：存取无序，强制性排序，元素不能重复。

TreeSet有两种排序方式：

- 自然排序：

  TreeSet允许存入某些基础类型，它可以对这些类型自动升序排序[^2]

- 比较器排序-自定义排序：

  如果要存入自定义的对象，则必须实现`Comparable`接口，覆盖它的`compareTo()`方法[^3]

-----------

### 问：Hash表是如何保证元素唯一性？

​	答：底层是依赖HashCode和equals。先将元素的HashCode计算出来，然后再使用equals进行对比元素。只有比对后不一致才开始存储，相等则放弃储存。

### 问：HashSet存储的步骤：

​	若存储的是自定义对象，需要在对象内重写HashCode和equals方法。因为HashSet存储时，会先调用HashCode方法来计算该对象的Hash值。然被存入的对象Hash值与已有的Hash值相同，则继续调用equals方法，equals方法的作用是对比两个对象，若结果相等，则放弃存储。否则在已有的对象下用链表形式存储。

### 问：如何重写HashCode方法：

​	通常在自定义HashCode的时候，只需要让当前对象的某个变动的值来关联一个随机数或者一个常量就可以，参考代码如下：

```java
@Override
public int HashCode()
{
    // 这里的99你可以根据你的喜好随便改一个整数，例如11，22都行
	int result = 99;
    // 避免字段为空程序异常，所以先行判断
	result = result * 13 + (name == null ? 0 : name.hashCode());
	result = result * 13 + (sex == null ? 0 : sex.hashCode() );
	result = result * 13 + (grade == null ? 0 : grade.hashCode() );
	result = result * 13 + age;
	return result;
}
```

### 问：如何重写equals方法：

​	由于是自定义方法，至于如何保证两个元素相等这取决于开发者。举例现在定义了个Student类，这个类代表一个学生，如何判断两个学生对象是同一个学生？这就取决于开发者的要求了，若开发者认为只要学生的：姓名、年龄、性别、班级全部都相同时，认为是同一个人。此时在Student对象类里，重写equals方法，而equals应该去判断：姓名、年龄、性别、班级这些是否相等，从而返回一个布尔型Boolean的结果，实例代码如下：

```java
@Override
public boolean equals(Object obj)
{
    // 1. 判断是否等于自身.
    if( this == obj )
        return true;
    // 2. 使用instanceof运算符判断 Obj 是否为Student类型的对象.
    if( !(obj instanceof Student ) ) // 当是同一个类型，则不进入if
        return false;
    // 3.比较Student中的字段，判断值是否相同
	Student newS = (Student) obj; //由于在步骤2的时候就已经判断是否为同类，若不是同类直接返回false，而程序也终止了，只有是同类型的时候才会走到这一行代码，所以不必要担心代码强转异常。
    
    // 最后比较数据
	retrun this.name.equals(newS.name) && this.age == newS.age && 
        this.grade.equals(newS.grade) && this.Sex.equals(newS.equals);
}
```

### 重写equals()而不重写hashCode()的风险

在Oracle的Hash Table实现中引用了Bucket的概念．如下图所示：

![Bucket](//wx2.sinaimg.cn/large/96e311f0gy1g4qaxur2a4j208k057t92.jpg)

从上图可以看出，带Bucket的HashTable大致相当于hash表和链表的结合体。即在每一个Bucket上挂一个链表，链表的每个节点都用来存放对象。Java通过hashCode()方法来确定某个对象应该位于哪个Bucket桶中，然后在对应的链表中查找。理想情况下，如果的HashCode()写的足够健壮，那么每个Bucket将会只有一个节点，这样就解决了查找操作的常量级别的时间复杂度，即无论你的对象放在哪片内存中，我们都可以通过HashCode()立刻定位到该区域，而不需要从头到尾遍历查找，这也是hash表的最主要的作用。

如：当我们调用HashSet的put(Object o)方法时，首先会根据o.hashCode()的返回值定位到相应的Bucket中，如果该Bucket中没有结点，则将 o 放到这里，如果已经有结点了, 则把 o 挂到链表末端。同理，当调用contains(Object o)时，Java会通过hashCode()的返回值定位到相应的Bucket中，然后再在对应的链表中的结点依次调用equals()方法来判断结点中的对象是否是你想要的对象。

不重写HashCode会导致**相同内容的一个对象，在取出时为null。**原因就是虽然两个对象内容相同，但是由于没有重写HashCode方法，导致默认调用Object类的HashCode方法，返回了对象的地址，而两个对象虽然内容是相同，但是地址不同，那么新的对象就去一个不存在bucket里寻找，自然是返回null。

参考自：[重写equal()时为什么也得重写hashCode()之深度解

### 我让hashCode()每次都返回一个固定的数行吗？

示例代码：

```java
@Override
public int hashCode() {
	return 10;
}
```

如果这样，每次都返回相同的数值，那么HashMap、HashSet就失去了它应有的“哈希的意义”。用`<Effective Java>`中的话来说就是，哈希表退化成了链表．如果hashCode()每次都返回相同的数，那么所有的对象都会被放到同一个Bucket中，每次执行查找操作都会遍历链表，这样就完全失去了哈希的作用．所以我们最好还是提供一个健壮的hashCode()为妙．

参考自：[如何重写hashCode()和equals()方法](https://blog.csdn.net/neosmith/article/details/17068365)

-----

# Map集合

Map是一个双列集合，其中保存的是键值对，键要求保持唯一性，值也可以重复。

键值是一一对应，一个键只能对应一个值。

**Map的特点：**存取无序，键不可重复。Map在存储对象的时候，将键传入Entry，然后存储Entry对象

#### HashMap

**线程不同步，键唯一且，键值均允许Null，值可重复**，根据`Key`来计算`HashCode`进行存储。内部使用静态内部类`Node`的数组进行存储，默认初始长度是16，每次扩大当前容量的一倍。当发生Hash冲突时，采用链表进行存储。

在JDK1.8中：当单个桶Bucket中的元素个数大于8个时，链表实现改为红黑树实现；当元素个数小于6时，变回链表实现。由此来防止HashCode攻击。

- Java HashMap 采用的是冲突链表方式。

- HashMap 是 Hashtable 的轻量级实现，可以接受为 null 的键值 (key) 和值 (value)，而 Hashtable 不允许。

  #### LinkedHashMap

  **保存插入的顺序**，在用iteration遍历LinkedHashMap时，先得到的记录肯定是最先插入的。也可以在构造时代入参数，按照应用次数进行排序。在遍历时会比HashMap慢，不过有种情况例外，当HashMap容量很大，实际数据很少是，遍历起来可能会比LinkedHashMap慢。因为LinkedHashMap的遍历速度只和实际数据有关，和容量无关，而HashMap的遍历是和它的容量有关。

#### HashTable

HashMap和它类似，随着Java发布它就一起发布了。而HashMap是JDK1.2才出现的。

它是线程安全，HashMap是线程不安全。而且它的键值都不允许存入Null。

#### TreeMap

存入自定义对象为Key时，由于底层使用了二叉树，所以存入的对象都需要排序，若要排序，就需要有比较功能。所以自定义对象应该实现`Comparable`接口，或者给TreeMap对象传递一个`Comparator`接口。

--------------

# 脚注
[^栈Stack]: 栈是限定仅在表尾进行插入和删除操作的线性表。要搞清楚这个概念，首先要明白”栈“原来的意思，如此才能把握本质。"栈“者,存储货物或供旅客住宿的地方,可引申为仓库、中转站，所以引入到计算机领域里，就是指数据暂时存储的地方，所以才有进栈、出栈的说法。



[^队列Deque]: 队列的数据元素又称为队列元素。在队列中插入一个队列元素称为入队，从队列中删除一个队列元素称为出队。因为队列只允许在一端插入，在另一端删除，所以只有最早进入队列的元素才能最先从队列中删除，故队列又称为先进先出（FIFO—first in first out）[线性表](https://baike.baidu.com/item/线性表)。



[^1]: 一个节点下面不能多于两个节点，[具体参见百度百科](https://baike.baidu.com/item/二叉树/1602879)。二叉树的存储过程：如果是第一个元素，将直接存入，并作为根节点。下一个元素存入之前，会和根元素比较大小，如果大于根节点则放在该节点的右边，小于则放在左边，等于就放弃不储存。后面的元素将按照上面的规则执行，直到找到合适的位置为止。



[^2]: 自然排序：TreeSet内部默认使用了一个Java自带的方法`java.lang.compareTo(e1, e2)`进行比较大小，最后以升序进行排列。可以比较的类型是`Byte`，`Double`，`Integer`，`Float`，`Long`或`Short`，若存入的是这些类型，则会自动排序，所以也叫自然排序。
[^3]:定制排序：若存入的是自定义对象，则无法进行比较大小，需要在自定义的类里实现`Comparable`接口，覆盖`compareTo`比较方法，自定义比较的规则。比较时需要创建第三方类，实现`Comparator`接口，并且覆其中的`Compare()`方法，编写比较规则和排序方式。







