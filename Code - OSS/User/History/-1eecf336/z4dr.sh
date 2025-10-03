#!/bin/bash

status=$(playerctl status 2>/dev/null)

if [ "$status" != "Playing" ]; then
  exit 0
fi

cat /tmp/cava_output.txt 2>/dev/null