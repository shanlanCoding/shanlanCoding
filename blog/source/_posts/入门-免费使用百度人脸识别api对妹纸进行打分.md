---
title: 入门-利用Java免费使用百度人脸识别对妹纸进行打分
copyright: true
comments: true
toc: true
tags:
  - 人脸识别
categories:
  - Java
abbrlink: 7294a25e
date: 2019-06-29 18:41:07
---

# 介绍

意外发现了学校某个系统的漏洞，可以不鉴权查看考生的照片。所以我通过一段java代码将这些照片给下载到电脑上。当我看到这些照片的时候，另一个想法便出现了，就是利用目前的人脸识别技术给这些照片来打个分。

# 操作流程

1. 注册百度智能云账户

2. 在：产品服务 / 人脸识别 里，建立一个自己的应用

3. 打开[官方文档](https://cloud.baidu.com/doc/FACE/s/kjwvxr0vg/)，根据步骤操作，重要的是你需要把代码里的`APP_ID `,`API_KEY `,`SECRET_KEY `替换成你自己的，这些是在你步骤2的时候创建成功就能看见。

4. 完成上述三步，即可以开始测试了。通常测试的图片需要转成base64编码，所以此时可以利用Java的IO方法读取硬盘里的图片和Java自带方法`BASE64Encoder`对图片进行编码.

# 程序运行流程

```flow
st=>start: 开始
e=>end: 结束
op1=>operation: 遍历文件夹内图片
op2=>operation: 读取文件并Base64编码
op3=>operation: 人脸识别
op4=>operation: 接收人脸识别的信息
op5=>operation: 删除不需要的信息
op6=>operation: 保存信息到txt文件
cond=>condition: 是否遍历完成？

st->op1->op2->op3->op4->op5->op6->cond
cond(yes)->e
cond(no)->op1

```

### 读取硬盘图片以及转换成base64编码的代码：

   ```java
       public String getImgBase64(String filePath) {
           byte[] data = null;
           try {
               InputStream in = new FileInputStream(filePath);
               data = new byte[in.available()];
               in.read(data);
               in.close();
           } catch (IOException e) {
               e.printStackTrace();
           }
           BASE64Encoder encoder = new BASE64Encoder();
   //        System.err.println(encoder.encode(data));
           return encoder.encode(data);
       }
   ```

   ### 人脸识别数据写入到txt内：

   ```java
       public void appendJson(String str, String filePath) {
           BufferedWriter bw = null;
           try {
               bw = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(filePath, true)));
               bw.write(str + "\r\n");
           } catch (Exception e) {
               e.printStackTrace();
           } finally {
               try {
                   bw.flush();
                   bw.close();
               } catch (IOException e) {
                   e.printStackTrace();
               }
           }
       }
   ```

   ### 程序的主体：

   ```java
       //设置APPID/AK/SK
       public static final String APP_ID = "你的 App ID";
       public static final String API_KEY = "你的 Api Key";
       public static final String SECRET_KEY = "你的 Secret Key";
   
       public static void main(String[] args) {
           feceServerImpl faceServer = new feceServerImpl();
           
           // 初始化一个AipFace
           AipFace client = new AipFace(APP_ID, API_KEY, SECRET_KEY);
           Map<String, Object> msg = new HashMap<String, Object>();
   
           // 可选：设置网络连接参数
           client.setConnectionTimeoutInMillis(2000);
           client.setSocketTimeoutInMillis(60000);
   
           // 可选：设置代理服务器地址, http和socket二选一，或者均不设置
   //        client.setHttpProxy("proxy_host", proxy_port);  // 设置http代理
   //        client.setSocketProxy("proxy_host", proxy_port);  // 设置socket代理
   
           // 遍历指定文件夹
           String path = "E:\\downloadImg\\";
           File file = new File(path);
           File[] files = file.listFiles();
           for (File f : files) {
               if (!f.isDirectory()) {
                   // 调用接口
                   String image = faceServer.getImgBase64(f.toString());
                   // 指定图片的类型
                   String imageType = "BASE64";
                   // 传入可选参数调用接口
                   HashMap<String, String> options = new HashMap<String, String>();
                   // 这个是指定服务器返回的参数，其中age代表要检测年龄；beauty是检测颜值
                   options.put("face_field", "age,beauty");
                   options.put("max_face_num", "1");
                   options.put("face_type", "CERT");
   
                   // 人脸检测
                   JSONObject res = client.detect(image, imageType, options);
   
                   // 将服务器返回的数据转成map，方便操作
                   Map<String, Object> stringObjectMap = res.toMap();
   
                   // 删除不必要的数据
                   stringObjectMap.remove("log_id");
                   stringObjectMap.remove("error_msg");
                   stringObjectMap.remove("cached");
                   stringObjectMap.remove("error_code");
                   stringObjectMap.remove("timestamp");
   
                   // 添加照片的名字到map里，方便知道这条数据对应的哪张照片
                   stringObjectMap.put("照片", f.toString());
                   System.out.println(res.toString(1));
   
                   // 将评分数据写入到txt文件内
                   faceServer.appendJson(stringObjectMap.toString(), "e:\\imgJson.txt");
   
                   // 防止QPS超限，进行延迟
                   try {
                       Thread.currentThread().sleep(500);//毫秒
                   } catch (Exception e) {
                       e.printStackTrace();
                   }
                   //break;
               }
           }
       }
   ```

# 整理数据

将由代码保存的到硬盘txt文本数据，复制到Excel里借用排序工具进行整理，便可以知道哪张图片的颜值最高。最终整理的数据如下图：

![最终表单数据](https://user-images.githubusercontent.com/44717382/60385302-514b6180-9aba-11e9-8715-91c9c5025556.png)

![](//ws4.sinaimg.cn/large/sl96e311f0gy1g4ie0pg8mdg20xc0pmb2b.gif)
