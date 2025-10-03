#!/bin/bash

bars=$(cava -p ~/.config/cava/config | head -n 1)
echo "{\"text\": \"$bars\", \"tooltip\": \"Audio Visualizer\"}"
