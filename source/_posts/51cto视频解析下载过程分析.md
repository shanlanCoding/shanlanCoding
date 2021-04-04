---
title: 51cto视频解析下载过程分析
copyright: true
comments: true
toc: true
tags: 爬虫
categories: Python
abbrlink: 615d4220
date: 2021-04-04 18:48:29
---

@[TOC](目录)
# 阅读须知
本内容仅为本人学习计算机技术目的，若有侵权，还请联系。本文读者若用于非法目的，后果自行承担。
# 获取视频链接
获取课程的所有单节链接
[https://edu.51cto.com/center/course/index/lesson-file-list?course_id=1187&page=1&size=120](https://edu.51cto.com/center/course/index/lesson-file-list?course_id=1187&page=1&size=120)
# <a id='获取视频信息'>获取视频信息</a>
发送请求，获得视频的信息：

```javascript
https://edu.51cto.com/center/player/play/get-lesson-info?type=course&lesson_type=course
    $.get(this.Conf.url_auth, {
	sign: this.sign,
	lesson_id: this.lid
    }, function(e) {
	t.setConfig(e)
    }, "json")
}
```
解析：
这里有2个参数：
sign = 课程ID + 常量 ；进行MD5，只要课程ID不变最终数值是不变的。
例如35547的MD5为：969bc68f0c77a5c44026f8a840b0aba9

lesson_id = 35547 ，课程ID；可以通过页面的2个变量获取： var _lid='35547';    var _bak_lid='35547';
# 获取M3U8文件
通过视频信息返回的JSON.dispatch[0].url，可以得到高清的视频M3U8文件地址。
`https://edu.51cto.com//center/player/play/m3u8?lesson_id=151970&id=133999&dp=high&type=course&lesson_type=course`

## 解析M3U8，获取到KEY链接
打开m3u8文件，找到`#EXT-X-KEY:METHOD=AES-128,URI=/center/player/play/get-key?lesson_id=151970&id=133999&type=course&lesson_type=course&isPreview=0`
该URI为KEY链接的一部分，完整的KEY链接如下：
[https://edu.51cto.com/center/player/play/get-key?lesson_id=151970&id=133999&type=course&lesson_type=course&isPreview=0&sign=9749dca5aea16534480f9ed26a082510](https://edu.51cto.com/center/player/play/get-key?lesson_id=151970&id=133999&type=course&lesson_type=course&isPreview=0&sign=9749dca5aea16534480f9ed26a082510)
多出来了一个sign参数，该参数在 [获取视频信息](#获取视频信息)里分析出来了。

## <a id='取到Key字符串'>取到Key字符串</a>
通过Key链接，访问后拿到Key字符串。需要将课程ID和Key字符串放在一起加密，得到新的字符串，再将该字符串进行转换成16进制字符串，便是真正的key了。
## 解密Key
1. 上一步骤获取到的Key字符串并非最终，还需要搭配课程ID进一步解密。
解密的格式：key字符串 + 课程ID
该解密过程依赖于Js函数，由于函数过于冗长，转译成其他程序代码费时费力，推荐使用Python直接执行Js代码功能进行解密。
2. 解密得到一串16位的字符串，还需要进行“16进制到文本字符串”的转码操作。可以使用[在线工具](https://www.bejson.com/convert/ox2str/)转换，该工具的接口为：`https://www.bejson.com/Bejson/Api/hexToString/toHexadecimal`，POST请求参数：`input`，值为需要转码的字符串。也可以使用本地代码进行转码。
3. 上一步完成后，就得到了最终的Key。剩下需要做的是利用Key进行AES解密TS文件，并输出未解密的TS文件。如何判断解密成功？通常加密过的TS文件是不能直接播放的，所以如果输出的新的TS文件能够正常播放则代表解密成功。
4. 上面用到的JS代码，请跳转文末参考内获取
~~## 解密TS文件：onKeyLoading关键函数，过于复杂，放弃~~ 
# 下载TS文件
1. 解析M3U8文件，分割内部的文本，分割文本为`\n`，以`.ts`进行匹配，匹配成功则代表TS下载链接
2. 解析TS文件名
3. 请求上一步链接，写入到文件，文件名为TS原始文件名
# 解密TS文件
51某TO的收费视频，TS加密为**AES-128-ECB**，大部分网站是采用**AES-128-CBC**模式加密。至于免费视频没有尝试不了解。
原计划通过python的库命令AES来进行解密。发现解密后无法播放，在耗费几个小时后放弃，**如果有懂的同学还希望分享下你的方法。**
遂尝试使用OpenSSL 命令行解密，这需要在电脑上安装OpenSSL，并且配置好系统变量。具体解密步骤如下：
1. [获取key字符串](#获取key字符串)
2. 获取到课程ID，链接里有
3. 通过python第三方库`execjs.compile(get_js())`，来执行Js函数，将上述两个参数生成一个16位字符串。
4. 将16位字符串转文本字符串，这里推荐使用下面的代码，亲测可用
```python 
    def str_to_hexStr(string):
        '''
        String to HEX Char String
        :string: The string to be converted
        :return: HEX Char String
        '''
        str_bin = string.encode('utf-8')
        return binascii.hexlify(str_bin).decode('utf-8')
```
5. 完成上述步骤后，就会得到用于解密TS文件的Key了
6. 通过命令行调用OpenSSL，对加密的TS文件解密并输出新的未加密可直接播放的TS文件
```bash
start /min openssl aes-128-ecb -d -in ".\video_ts_file\old.ts" -out ".\video\new_01.ts" -K 534652324451534d3456313955554553
```
简单介绍一下上面的这行命令。`start`是cmd命令，启动某个程序。`/min`是后台最小化运行。 `-d`解密。`-in`输入文件的路径。`-out`输出文件的路径。`-K`用于解密的密码
执行完毕后，TS文件将会正常播放。如若不能播放，请检查上面的KEY生成的参数是否正确。比如课程ID和你下载的视频的ID不一致，那也会导致解密失败。
# 合并视频
合并视频可以用CMD自带的命令`copy /b`合并，前题是文件的命名是按照顺序排列的，否则合并的视频内容会错乱。也可以使用第三方开源的视频软件`FFmpeg`，我暂时不了解他们俩合并出来的视频有什么区别，我为了方便是使用CMD命令合并。
CMD命令如下：
```bash
copy /b .\Download\*.ts .\Video\new01.mp4
```
FFmpeg如下：
``bash
 .\software\ffmpeg.exe -f concat -safe 0 -i %home%cache\filelist.txt -c copy %home%video\test.mp4
``
`filelist.txt`是记录着需要合并的ts文件路径，内部格式大概长这样 ：

```bash
file 'E:\下载\51_video_download_20210110\video_ts_file\new_loco_video_306000_0.ts' 
file 'E:\下载\51_video_download_20210110\video_ts_file\new_loco_video_306000_1.ts' 
file 'E:\下载\51_video_download_20210110\video_ts_file\new_loco_video_306000_2.ts' 
```
# 遇到的问题
1. python通过`AES-128-ECB`解密不成功，目前使用OpenSSL解密，很麻烦，体验也不好，会有黑窗弹出来
# 结语
难点在于几个加密的JS，这需要反调试JS，过程繁琐且枯燥，感谢前人。

上面提到的是通过M3U8来下载视频。如果你想更省事一点，可以想办法抓取页面的所有课程链接和标题，存储到文本内进行分割。这样就可以全自动下载了。

# 参考
1.[51CTO学院视频下载和解密 - t2.re](https://t2.re/archives/926/)