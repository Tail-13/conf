#!/bin/bash

CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8 "%"}')
MEM_USED=$(free -h | awk '/Mem:/ {print $3 "/" $2}')
TEMP=$(sensors | grep -m 1 'Package id 0:' | awk '{print $4}')
LOAD_AVG=$(uptime | awk -F'load average:' '{print $2}')
UPTIME=$(uptime -p)

echo -e "CPU Usage: $CPU_USAGE\nMemory: $MEM_USED\nTemp: $TEMP\nLoad:$LOAD_AVG\nUptime: $UPTIME"
