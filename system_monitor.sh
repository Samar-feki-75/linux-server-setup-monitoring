#!/bin/bash

# Thresholds
CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=90
LOG_FILE="/var/log/system_monitor.log"

# Get metrics
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
MEM_USAGE=$(free | awk '/Mem/{printf("%.0f"), $3/$2*100}')
DISK_USAGE=$(df / | awk 'END{print $5}' | sed 's/%//')

# Log the metrics
echo "$(date): CPU: ${CPU_USAGE}% | MEM: ${MEM_USAGE}% | DISK: ${DISK_USAGE}%" >> $LOG_FILE

# Check thresholds and alert
if (( ${CPU_USAGE%.*} > CPU_THRESHOLD )); then
    echo "⚠️ High CPU usage: ${CPU_USAGE}%" | mail -s "CPU Alert" your_email@example.com
fi

if (( MEM_USAGE > MEM_THRESHOLD )); then
    echo "⚠️ High Memory usage: ${MEM_USAGE}%" | mail -s "Memory Alert" your_email@example.com
fi

if (( DISK_USAGE > DISK_THRESHOLD )); then
    echo "⚠️ Low Disk Space: ${DISK_USAGE}%" | mail -s "Disk Alert" your_email@example.com
fi
