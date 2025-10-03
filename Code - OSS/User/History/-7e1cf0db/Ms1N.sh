#!/bin/bash

bar=" ▁▂▃▄▅▆▇█"  # Added space at index 0
dict="s|;||g;"  # Start dictionary with different delimiter (|)

# Create dictionary to replace numbers with bar characters
i=0
while [ $i -lt ${#bar} ]; do
    char="${bar:$i:1}"
    dict="${dict}s|$i|$char|g;"
    i=$((i + 1))
done

# Write cava config
config_file="/tmp/polybar_cava_config"
cat > "$config_file" <<EOF
[general]
bars = 18

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 7
EOF

# Read from cava and convert digits to bars
cava -p "$config_file" | while read -r line; do
    echo "$line" | sed "$dict"
done
