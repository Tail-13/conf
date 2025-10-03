#!/bin/bash

# Get the list of available networks with SSID and security type
networks=$(nmcli -t -f SSID,SECURITY device wifi list | awk -F: '$1 != "" {print $1":"$2}')

# Create a list for Zenity
network_options=()
network_ids=()

# Process each network
while IFS=: read -r ssid security; do
    # Check if network is secured
    if [[ "$security" == *WPA2* || "$security" == *WPA3* || "$security" == *WEP* ]]; then
        network_options+=("$ssid" "🔒 Secured")
    else
        network_options+=("$ssid" "Open")
    fi
    network_ids+=("$ssid")
done <<< "$networks"

# Show the network list in a Zenity dialog
selected=$(zenity --list --title="Select Wi-Fi Network" --column="SSID" --column="Security" "${network_options[@]}" --height=400 --width=300)

# Proceed only if the user selected a network
if [ -n "$selected" ]; then
    # Check if the selected network is secured by looking for the lock icon in the security column
    if [[ "$selected" == *"🔒 Secured"* ]]; then
        # Prompt for password if the network is secured
        password=$(zenity --entry --title="Wi-Fi Password" --text="Enter password for $selected" --hide-text)
        
        # If password is provided, attempt to connect
        if [ -n "$password" ]; then
            nmcli device wifi connect "$selected" password "$password"
        else
            zenity --error --text="Password required but none provided."
        fi
    else
        # Connect directly to open networks
        nmcli device wifi connect "$selected"
    fi
fi