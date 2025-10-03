#!/bin/bash

cava -p ~/.config/cava/config | while read -r line; do
    # Convert numeric levels to bars
    bars=$(echo "$line" | sed 's/[0-9]\+/█/g')
    echo "{\"text\": \"$bars\"}"
done
