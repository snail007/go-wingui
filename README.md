# 使用说明
1.环境要求是windows，理论上xp以上32位，64位都支持。  
2.下载程序[go-wingui](https://github.com/snail007/go-wingui/releases/tag/1.0)  
3.解压到比如D盘，D:\dist  
4.把你的go网站程序(假设名字是app.exe)放入D:\dist\app文件夹  
5、假设你的app.exe启动之后，访问链接是http://127.0.0.1:9999/index  
编辑D:\dist\launcher.ini,做如下部分修改：  
start_exec="app\app.exe"  
start_url="http://127.0.0.1:9999/index"   
6.配置完毕，双击D:\dist\launcher.exe，即可看到效果了。  

**提示：**  
如果是go程序，为了避免出现程序启动出现命令行黑框，编译go程序的时候加上参数：go build  -ldflags="-H=windowsgui"  

# 原理介绍
本项目原理是写了一个本地应用，使用autoit3脚本技术把自带的谷歌浏览器嵌入到应用里面实现了一个“浏览器”，然后“浏览器”里面打开go网站，这样就实现了一个不依赖系统浏览器的独立gui本地应用程序。我们可以使用方便强大的html+css+js完成优美的应用界面，功能可以通过RPC，ajax调用后端go Web服务实现。

#  源码使用
1.克隆源码  
git clone https://github.com/snail007/go-wingui.git ./  
2.下载绿色版chrome浏览器，解压后把文件夹chrome，放在位置：go-wingui/cef/chrome，chrome.exe的路径应该是：go-wingui/cef/chrome/chrome.exe  
3.开发环境完成  

