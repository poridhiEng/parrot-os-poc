docker run -it --entrypoint /bin/bash parrotos-novnc:latest

Check if the VNC Server is Running:
ps aux | grep x11vnc

Check the Display:
You can check which displays are available by running
ps aux | grep X

┌─[root@c86dec6eead7]─[/]
└──╼ #ps aux | grep x11vnc
root        21  0.0  0.0   3084  1360 pts/0    S+   04:17   0:00 grep --color=auto x11vnc


┌─[root@c86dec6eead7]─[/]
└──╼ #nginx -t
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful


┌─[root@c86dec6eead7]─[/]
└──╼ #ps aux | grep X
root        26  0.0  0.0   3084  1360 pts/0    S+   04:17   0:00 grep --color=auto X


┌─[root@c86dec6eead7]─[/]
└──╼ #startxfce4
/usr/bin/startxfce4: X server already running on display :1
xrdb: Connection refused
xrdb: Can't open display ':1'

(process:28): xfce4-session-CRITICAL **: 04:18:11.823: dbus-launch not found, the desktop will not work properly!
xfce4-session: Cannot open display: .
Type 'xfce4-session --help' for usage.