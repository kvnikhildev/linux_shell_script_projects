#!/bin/bash

#===========================================
#linux server Health monitor script
#===========================================

LOG_DIR="var/log/server-monitor"
LOG_FILE="$LOG_DIR/$(date +%d-%m-%Y_%H:%M:%S.log)"

CPU_TRESHOULD=80
MEMERY_TRESHOLD=80
DISK_TRESHOLD=80

log_message(){
    echo "$(date '+%d-%m-%Y %H:%M:%S') - $1" | tee -a "$LOG_FILE"
} 
# create the directry 
mkdir -p $LOG_DIR

#server uptime
UP_TIME=$(uptime -p)
log_message "Server Uptime:$UP_TIME"

#CPU utilization
CPU_UTI=$(top -bn1 | awk '/Cpu\(s\)/ {printf ".0f" 100-$8 }'

