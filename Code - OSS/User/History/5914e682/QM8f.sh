#!/bin/bash

networks=$(nmcli -t -f SSID,SECURITY device wifi list | awk -F: '{print $1}')

selected=$(echo "$networks" | wofi --dmenu -i -p "Wi-Fi")

if [ -n "$selected" ]; then
    nmcli device wifi connect "$selected"
fi