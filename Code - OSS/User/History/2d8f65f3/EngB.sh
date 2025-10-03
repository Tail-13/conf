#!/bin.bash
export QT_QPA_PLATFORM=xcb

while [ -z "$DISPLAY" ]; do
    sleep 1
    export DISPLAY=$(loginctl show-session $(loginctl | grep $(whoami) | awik '{print $1}') -p DISPLAY --value)
done
barrier --no-tray --client 192.168.1.8