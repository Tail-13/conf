#!/bin/bash

# Get the list of available networks with their security type
networks=$(nmcli -t -f SSID,SECURITY device wifi list | awk -F: '$1 != "" {print $1":"$2}')

# Process each network to append a lock icon if it's secured
network_options=""
while IFS=: read -r ssid security; do
    if [[ "$security" == *WPA2* || "$security" == *WPA3* || "$security" == *WEP* ]]; then
        network_options+="$ssid 🔒 (secured)\n"
    else
        network_options+="$ssid (open)\n"
    fi
done <<< "$networks"

# Show network options with wofi (dmenu-like UI)
selected=$(echo -e "$network_options" | wofi --dmenu -i -p "Select Wi-Fi Network")

# Proceed only if the user selected a network
if [ -n "$selected" ]; then
    # Extract the SSID from the selected option
    ssid=$(echo "$selected" | awk '{print $1}')
    
    # Check if the network is secured (contains lock icon)
    if [[ "$selected" == *"🔒"* ]]; then
        # Prompt for the password
        password=$(wofi --dmenu -i -p "Enter password for $ssid")

        # Attempt to connect with the provided password
        if [ -n "$password" ]; then
            nmcli device wifi connect "$ssid" password "$password"
        else
            echo "Password required to connect to $ssid, but none provided."
        fi
    else
        # Connect directly to open network
        nmcli device wifi connect "$ssid"
    fi
fi