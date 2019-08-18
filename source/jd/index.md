---
title: index
copyright: true
comments: true
toc: true
date: 2019-07-15 19:56:46
---

<center>周亮-应聘Java开发-18126340208</center>

# 联系方式

- 手机：18126340208
- 邮箱：[imzhou.liang@gmail.com](mailto:imzhou.liang@gmail.com)
- 微信 / QQ ：[291637732](http://wpa.qq.com/msgrd?v=3&uin=291637732&site=qq&menu=yes)

-------------------------

# 个人信息
 - 周亮 / 男 
 - 本科 / 计算机系 / 武昌工学院
 - 工作年限：应届毕业生
 - 期望职位：Java 开发工程师

----------------------------

# 掌握技能
- 编程语言：Java / JavaScript
- Web框架：Spring Boot / Spring / Spring Framework / Spring Security / MyBatis / Thymeleaf
- 前端相关：Bootstrap / HTML5 /  Ajax 
- 开发工具：IDEA / Eclipse / Git / HBuilder 
- 数据库：MySQL / Redis
- 掌握 Java 面向对象编程思想 / IO 技术 /  多线程技术 / 了解 AOP 、IOC 的基本原理
- 熟悉Java Web相关技术
- 熟悉Linux 系统的基本操作，能够独立部署项目
- 了解单点登录的基本原理，知道单点登录常见应用场景

------------------------

# 工作经历
## 黄冈市博文远程教育科技有限公司 （实习：2018年8月 ~ 2019年6月）
### 完善在线答疑平台
该公司是读书郎旗下的子公司，从事教育工作。本子公司的目的是辅助读书郎学习机，提供远程教育服务。

### 个人职责
前期熟悉项目的业务逻辑和流程，阅读项目已有的代码。后期参与项目的Java Web的前台代码编写，例如根据项目需求，编写前端请求和后台接口，后台接口经过业务处理化和数据库进行交互，返回请求信息给前端，再由前端进行展示。我主要负责的是答疑模块内的回答和修改等功能，并且会参加新功能探讨和设计。

------

# 项目经验
## 武昌工学院网上报名平台（2018年11月-2019年5月）
- 项目简述：网上报名系统的目的是为了满足考试报名信息的录入与信息处理，如对考生分配准考试的教室和安排考试的时间，考试完成以后查询考生的成绩等功能。
- 主要功能：注册 / 登陆 / 查询成绩 / 信息录入 / 打印准考 / 用户管理 / 数据导出
- 技术选择：Spring Boot+Spring Security+MyBatis+Redis+MySQL+Jquery 等技术实现

## 职责描述
这是我的毕业设计，计划用于学校的实际运营中。该项目使用了Spring Boot框架，并且简单的使用到了Spring Security 做安全防护，避免在用户未登录的情况下通过URL访问需要鉴权的页面，造成数据泄露。同理，还使用了SpringMVC做页面的请求处理；使用Spring Freamwork对Beans进行管理，注入等操作；使用Mybatis做MySQL数据库的增删改查操作。

目前该系统已经部署在阿里云服务器，服务端简单的使用了Nginx做反向代理，监听的子域名：`apply.gobyte.cn`，代理至本地端口9090。这样解决了同一台服务器，同一个主域名，同时部署多个项目的互相干扰的问题。

- 测试地址：[http://apply.gobyte.cn](http://apply.gobyte.cn)
- 普通账号：直接点击登陆按钮即可；密码：`123456`
- 管理员账号：`111111111111111111`
- 管理员密码：`123456`

-------------------

## 京东备件库商品监控系统（2019年2月-2019年3月）
- 项目简述：部署在阿里云服务器上，前台通过Nginx服务器监听80端口，反向代理到本机的8080端口上，这样免去访问时时输入端口号的，另外给Nginx添加SSL证书保护了页面的数据安全。
- 主要功能：监控京东备件库商品的价格浮动 / 商品上架提醒功能。一旦商品有变动，则会通过微信发送一条提醒通知，通知用户商品变动。
- 技术选择：Spring + SpringMVC + Fastjson + HttpClient + Jsp + ServerChan 等技术



## 职责描述
该项目为实践Demo，设计项目的初衷是为了满足自己的需求，另外学习和巩固自己的Java技术。
本系统通过发起Http请求获得数据，并简单的使用了Runnable多线程的Sleep进行延迟，从而实现了轮询操作。当轮询到的数据进行判断后，若符合用户设定的条件，会调用一个免费的微信消息通知服务通知用户。而且本系统具备异常处理的功能，当系统出现异常的时候，会调用消息服务使用微信通知服务管理员，继而达到了在第一时间内通知管理员，降低了因为代码Bug而导致的损失解系统的异常情况。

目前该项目部署在阿里云，由Nginx监听`.action / .jsp` 等后缀，另外还使用了反向代理功能代理至本地的8080端口，这样用户直接可以通过80端口访问，免去了输入端口号的烦恼。

------------------

感谢您百忙之中阅读我的简历，希望有机会能和您共事[.](./jd.pdf)