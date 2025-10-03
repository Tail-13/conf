#!/usr/bin/env bash

# Starts a scan of available broadcasting SSIDs
# nmcli dev wifi rescan

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

FIELDS=SSID,SECURITY
if [ -r "$DIR/config" ]; then
    source "$DIR/config"
elif [ -r "$HOME/.config/wofi/wifi" ]; then
    source "$HOME/.config/wofi/wifi"
else
    echo "WARNING: config file not found! Using default values."
fi

LIST=$(nmcli --fields "$FIELDS" device wifi list | sed '/^--/d')
KNOWNCON=$(nmcli connection show)
CONSTATE=$(nmcli -fields WIFI g)

CURRSSID=$(LANGUAGE=C nmcli -t -f active,ssid dev wifi | awk -F: '$1 ~ /^yes/ {print $2}')

if [[ "$CONSTATE" =~ "enabled" ]]; then
    TOGGLE="Toggle Wi-Fi off"
else
    TOGGLE="Toggle Wi-Fi on"
fi

# Build the menu
MENU=$(echo -e "$TOGGLE\nManual Entry\n$LIST" | uniq -u)
CHENTRY=$(echo "$MENU" | wofi --dmenu --prompt "Wi-Fi SSID:")

# Extract SSID (strip extra whitespace and columns)
CHSSID=$(echo "$CHENTRY" | sed 's/\s\{2,\}/|/g' | awk -F "|" '{print $1}')

# Handle manual entry
if [ "$CHENTRY" = "Manual Entry" ]; then
    MSSID=$(echo "Enter SSID,password" | wofi --dmenu --prompt "Manual SSID:")
    MPASS=$(echo "$MSSID" | awk -F "," '{print $2}')
    MSSID=$(echo "$MSSID" | awk -F "," '{print $1}')

    if [ -z "$MPASS" ]; then
        nmcli dev wifi connect "$MSSID"
    else
        nmcli dev wifi connect "$MSSID" password "$MPASS"
    fi

# Toggle Wi-Fi state
elif [ "$CHENTRY" = "Toggle Wi-Fi on" ]; then
    nmcli radio wifi on
elif [ "$CHENTRY" = "Toggle Wi-Fi off" ]; then
    nmcli radio wifi off

# Handle standard connection
else
    if [ "$CHSSID" = "*" ]; then
        CHSSID=$(echo "$CHENTRY" | sed 's/\s\{2,\}/|/g' | awk -F "|" '{print $3}')
    fi

    # Check if it's a known connection
    if echo "$KNOWNCON" | grep -q "$CHSSID"; then
        nmcli con up "$CHSSID"
    else
        if [[ "$CHENTRY" =~ "WPA2" ]] || [[ "$CHENTRY" =~ "WEP" ]]; then
            WIFIPASS=$(echo "" | wofi --dmenu --prompt "Wi-Fi password:")
        fi
        nmcli dev wifi connect "$CHSSID" password "$WIFIPASS"
    fi
fi
