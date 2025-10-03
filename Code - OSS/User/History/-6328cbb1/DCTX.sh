#!/bin/bash

# Prevent multiple instances
pgrep -f "yad --calendar" && exit

# Popup calendar near the top-right of screen (adjust position)
yad --calendar \
    --undecorated \
    --no-buttons \
    --close-on-unfocus \
    --skip-taskbar \
    --sticky \
    --mouse \
    --width=300 \
    --height=250 &
