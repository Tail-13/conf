#!/bin/bash

selected=$(wofi --show dmenu --prompt "Action Center" <<EOF
Power Menu
Toggle Wi-Fi
Toggle Bluetooth
Volume Up
Volume Down
Brightness Up
Brightness Down
EOF
)

case "$selected" in
  "Power Menu") systemctl poweroff ;;
  "Toggle Wi-Fi") nmcli radio wifi off && sleep 1 && nmcli radio wifi on ;;
  "Toggle Bluetooth") rfkill toggle bluetooth ;;
  "Volume Up") pactl set-sink-volume @DEFAULT_SINK@ +5% ;;
  "Volume Down") pactl set-sink-volume @DEFAULT_SINK@ -5% ;;
  "Brightness Up") brightnessctl set +10% ;;
  "Brightness Down") brightnessctl set 10%- ;;
esac
