#!/bin/bash

networks=$(nmcli -t -f NAME,SECURITY device wifi list | awk -F: '{pring $1}')

selected=$(echo "$networks" | wofi --dmenu -i -p "Wi-Fi" )

if [ -n "$selected" ]; then
    nmcli device wifi connect "$selected"
fi