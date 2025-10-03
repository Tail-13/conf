#!/bin/bash

choice=$(
    echo -e "Shutdown\nReboot\nLogout\nSuspend" \
    | wofi --dmenu --lines 4 --prompt "Power:"
)

case "$choice" in
    Shutdown) systemctl poweroff ;;
    Reboot) systemctl reboot ;;
    Logout) hyprctl dispacth exit ;;
    Suspend) systemctl suspend ;;
esac