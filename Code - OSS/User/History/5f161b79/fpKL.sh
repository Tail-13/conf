#!/bin/bash

# Config for cava
CONFIG="~/.config/cava/config"

# Run cava with a custom config
cava -p "$CONFIG" | while read -r line; do
    # Convert cava output (bars) to block characters or custom bars
    VISUALIZER=$(echo "$line" | sed 's/[0-9]\+/█/g')
    echo "{\"text\": \"$VISUALIZER\"}"
done
