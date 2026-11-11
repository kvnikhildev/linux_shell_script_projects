#!/bin/bash

#===========================================
#linux server Health monitor script
#===========================================

LOG_DIR="var/log/server-monitor/"
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
set -x

#CPU utilization
CPU_USAGE=$(top -bn1 | awk -F'[, ]+' '/Cpu\(s\)/ {printf "%.0f", 100-$8}')

log_message "CPU utilization:$CPU_USAGE"

#check the CPU Usage is high or not

if [ $CPU_USAGE -gt $CPU_TRESHOULD ];then
log_message "CPU utilization is high!!!!!!!!!!!"
fi

#Memery utilization

MEM_USAGE=$(free | awk '/Mem:/ {printf "%.0f", $3/$2*100}' )
log_message "Memery usage:$MEM_USAGE"

if [ $MEM_USAGE -gt $MEMERY_TRESHOLD ];then
log_message "Memery usage is high:$MEM_USAGE"
fi

#Disk utilization

DISK_USAGE=$(df -h | awk 'NR==3 {print $5}'| tr -d "%")





