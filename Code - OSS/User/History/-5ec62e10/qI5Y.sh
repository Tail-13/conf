#!/usr/bin/env bash

# Directory of the script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Optional config sourcing
if [ -r "$DIR/config" ]; then
    source "$DIR/config"
elif [ -r "$HOME/.config/wofi/wifi" ]; then
    source "$HOME/.config/wofi/wifi"
else
    echo "WARNING: config file not found! Using default values."
fi

# Scan for available Wi-Fi networks
nmcli dev wifi rescan >/dev/null 2>&1

# List available Wi-Fi networks
FIELDS=SSID,SECURITY
LIST=$(nmcli --fields "$FIELDS" device wifi list | sed '/^--/d')
KNOWNCON=$(nmcli connection show)
CONSTATE=$(nmcli -fields WIFI g)

CURRSSID=$(LANGUAGE=C nmcli -t -f active,ssid dev wifi | awk -F: '$1 ~ /^yes/ {print $2}')

# Build menu entries
MENU_ENTRIES=""

if [[ "$CONSTATE" =~ "enabled" ]]; then
    MENU_ENTRIES+="toggle off\n"
elif [[ "$CONSTATE" =~ "disabled" ]]; then
    MENU_ENTRIES+="toggle on\n"
f