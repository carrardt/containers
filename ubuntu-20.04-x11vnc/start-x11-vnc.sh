VNCDISPLAY=:1
echo "start xvfb on $VNCDISPLAY"
Xvfb "$VNCDISPLAY" -screen 0 1024x768x24 &
sleep 1
echo "start window manager & VNC server"
fluxbox -display "$VNCDISPLAY" &
x11vnc -display "$VNCDISPLAY" -bg -nopw -listen localhost -xkb
sleep 1
echo "start VNC client"
xterm &
remmina -c vnc://localhost

