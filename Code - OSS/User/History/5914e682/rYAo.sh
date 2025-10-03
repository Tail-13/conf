#!/bin/bash

# Get the list of available networks with SSID and security type
networks=$(nmcli -t -f SSID,SECURITY device wifi list | awk -F: '$1 != "" {print $1":"$2}')

# Initialize the network options string
network_options=""

# Process each network and add a lock icon if it's secured
while IFS=: read -r ssid security; do
    if [[ "$security" == *WPA2* || "$security" == *WPA3* || "$security" == *WEP* ]]; then
        network_options+="$ssid 🔒 (secured)\n"  # Add lock for secured networks
    else
        network_options+="$ssid (open)\n"         # No lock for open networks
    fi
done <<< "$networks"

# Show network options with wofi (similar to Ubuntu's dmenu-like interface)
selected=$(echo -e "$network_options" | wofi --dmenu -i -p "Select Wi-Fi Network")

# Proceed only if the user selected a network
if [ -n "$selected" ]; then
    # Extract SSID from the selected option
    ssid=$(echo "$selected" | awk '{print $1}')
    
    # Check if the network is secured (indicated by the lock icon)
    if [[ "$selected" == *"🔒"* ]]; then
        # Prompt for the Wi-Fi password
        password=$(zenity --entry --title="Wi-Fi Password" --text="Enter password for $ssid" --hide-text)
        
        # If password is provided, attempt to connect
        if [ -n "$password" ]; then
            nmcli device wifi connect "$ssid" password "$password"
        else
            zenity --error --text="Password required but none provided."
        fi
    else
        # Connect directly to an open network
        nmcli device wifi connect "$ssid"
    fi
fi
