# 使用说明
1.环境要求是windows，理论上xp以上32位，64位都支持。  
2.下载程序[go-wingui](https://github.com/snail007/go-wingui/releases/tag/v2.0)  
3.解压到比如D盘，D:\dist  
4.把你的go网站程序(假设名字是app.exe)放入D:\dist\app文件夹  
5、假设你的app.exe启动之后，访问链接是http://127.0.0.1:9999/index  
编辑D:\dist\launcher.ini,做如下部分修改：  
start_exec="app\app.exe"  
start_url="http://127.0.0.1:9999/index"   
6.配置完毕，双击D:\dist\launcher.exe，即可看到效果了。  

# Demo
![demo](/docs/images/demo.png)

**提示：**  
如果app.exe是go程序，为了避免出现程序启动出现命令行黑框，编译go程序的时候加上参数：go build  -ldflags="-H=windowsgui"  

# 原理介绍
本项目原理是写了一个本地应用，使用开源的CEF框架实现了一个“浏览器”，然后“浏览器”里面打开go网站，这样就实现了一个不依赖系统浏览器的独立gui本地应用程序。我们可以使用方便强大的html+css+js完成优美的应用界面，功能可以通过RPC，ajax调用后端go Web服务实现。

# 特点
- 使用新版CEF内核Chromium 63.0.3239.109，页面可以使用最新的css3，html5技术。
- JS注入，可以对打开的任意页面注入你的js代码，把要注入的js代码写入srv\inject.js里面即可。
- 外观大小自由控制，可以自由设置宽度高度，以及能否改变窗体大小。
- 几乎覆盖所有windows系统，xp以上32位，64位都支持。
- 代码全部开源，CEF的delphi7项目源码，内部服务和启动器项目的golang源码都开源。
- 详细的二次开发步骤，帮助你二次开发。
- 发行包只有28M，但是已经包含了所有的chrome浏览器功能，已经内部服务。

#  源码使用  
clone源码：  
git clone https://github.com/snail007/go-wingui.git ./   

1.delphi7  
cef是delphi7开发，使用的是第三方cef4delphi控件，本项目对控件做了定制化修改。  
已经安装了cef4delphi控件的绿色免安装版delphi7下载地址： ![delphi7](https://github.com/snail007/go-wingui/releases/tag/BorlandDelphi7)   

2、解压delphi7  
双击BorlandDelphi7\Bin\DELPHI32.EXE,启动delphi7，
并把BorlandDelphi7\Projects添加到库目录，步骤：工具-》环境选项-》库选项  
在库路径最下面加上：“d:\BorlandDelphi7\projects;”，不带双引号。  
这里假设解压BorlandDelphi7位于D盘。  

3、cef内核  
本项目使用的是32bit CEF 3.3239.1710.g85f637a which includes Chromium 63.0.3239.109.
下载![cef](https://github.com/snail007/go-wingui/releases/tag/cef_3.3239.1710.g85f637a_Chromium-63.0.3239.109)，并解压到：cef\bin,
本项目对cef进行了一些精简，便于下载使用。如果需要更新cef，下载最新版cef，  
解压到cef\bin即可。  

4、delphi7的工程项目是cef\SimpleBrowser  
cef\SimpleBrowser\SimpleBrowser_D7.dpr是工程文件，启动delphi7打开此文件即可。  

5、启动器launcher和内部服务srv是golang开发，走标准的go项目开发流程就行。  

6、开发环境搭建完成。  

### cef4delphi控件  
如果不需要定制化cef4delphi控件，跳过第本步骤。  
下载地址：![cef4delphi](https://github.com/snail007/go-wingui/releases/tag/CEF4Delphi)   
如果需要重新定制化cef4delphi控件，需要修改cef4delphi控件源码，然后安装控件到delphi7中。   
步骤如下：  
1、删除cef4delphi控件  
首先关闭delphi7，找到delphi7里面的Projects文件夹，删除里面的CEF4Delphi_D7开头的三个文件。  
2、启动delphi7，会提示你找不到控件，问你以后是否加载，选择“否”即可，然后关闭delphi7。  
3、修改完毕cef4delphi控件源码，启动delphi7，然后在delphi7中选择打开项目，  
选择cef\cef4delphi\CEF4Delphi_D7.dpk,在打开的界面点击“编译”，然后点击“安装”。  
delphi7控件栏最后面应该出现了Chromium标签。  
如果不成功，重复2-3步骤即可，一般第二次就会出现。  
