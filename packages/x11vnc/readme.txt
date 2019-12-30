# tar -xjvf x11vnc-0.9.13.tar.gz

# cd x11vnc-0.9.13

# mkdir -p _INSTALL

# ./configure --host=arm-linux --without-x --prefix=./_INSTALL/  CC=arm-linux-gnueabihf-gcc CFLAGS=-O2 

# make

# make install


将目标生成值放到   _INSTALL/  文件夹下面，其中使用方法如下：

_INSTALL/bin/x11vnc -noipv6 -rawfb /dev/fb0 -pipeinput UINPUT:touch,tslib_cal=/etc/pointercal,direct_abs=/dev/input/event0,nouinput,dragskip=4 -clip 1280x800

其中：/dev/fb0 对应为LCD屏幕设备
tslib_cal=/etc/pointercal,对应tslib触摸校准生成的文件
direct_abs=/dev/input/event0 对应触摸屏的event
-clip 1280x800 代表屏幕分辨率

运行结果：
默认会在5900端口上生成VNC接口，使用VNC Viewer之类的工具，输入板子IP：5900即可观看，如果退出连接，则板子上的VNC Server也会退出。再次需开启。

