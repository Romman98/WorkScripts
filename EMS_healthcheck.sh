#!/bin/bash

# set -xv

### Script Parameters ###
date_today=$(date +%Y%m%d)
host_name=$(hostname)
output_log="$date_today/${host_name}_Health_Check_output.txt"
output_data="/export/home/HealthCheck/status.output"
NOK_log="/export/home/HealthCheck/$date_today/NOK_log.txt"

if [[ "$host_name" -eq "" ]]; then
        node=""
elif [[ "$host_name" -eq "" ]]; then
        node=""
fi

if [ ! -d /export/home/HealthCheck/$date_today ]; then
    mkdir -p /export/home/HealthCheck/$date_today
fi

if [ ! -d /export/home/HealthCheck/$date_today ]; then
    mkdir -p /export/home/HealthCheck//$date_today
fi

# if [ ! -d /export/home/HealthCheck/$date_today ]; then
#     mkdir /export/home/HealthCheck/$date_today
# fi

if [ ! -d /export/home/HealthCheck/$date_today ]; then
    mkdir -p /export/home/HealthCheck/$date_today
fi

>$output_log         # Empty the log
exec >/dev/null 2>&1 # Suppress all outputs

###   Status ###
sudo -u insight ./emsMgmt status > "$output_data"

#### Apache Proxy ####
Apache_status=$(cat "$output_data" | grep "Apache Proxy" | grep 'Running'| wc -l)
if [[ "Apache_status" -eq 2 ]]; then
        Apache_status_result="OK"
else
        Apache_status_result="NOK"
        echo "Apache Proxy: $Apache_status" >> "$NOK_log"

fi

echo "[$node] Apache Proxy: $Apache_status_result" >> $output_log

#### Agent ####
Agent_status=$(cat "$output_data" | grep 'Agent' | grep "Running" | wc -l)
if [[ "Agent_status" -eq 2 ]]; then
        Agent_status_result="OK"
else
        Agent_status_result="NOK"
        echo "Agent: $Agent_status" >> "$NOK_log"

fi

echo "[$node] Agent: $Agent_status_result" >> $output_log

#### Fault Management ####
fault_management_status=$(cat "$output_data" | grep 'Fault Management' | grep "Running" | wc -l)
if [[ "fault_management_status" -eq 1 ]]; then
        fault_management_status_result="OK"
else
        fault_management_status_result="NOK"
        echo "Fault Management: $fault_management_status" >> "$NOK_log"
fi

echo "[$node] Fault Management: $fault_management_status_result" >> $output_log

#### Owl ####
Owl_status=$(cat "$output_data" | grep 'Owl' | grep "Running" | wc -l)
if [[ "Owl_status" -eq 2 ]]; then
        Owl_status_result="OK"
else
        Owl_status_result="NOK"
        echo "Owl: $Owl_status" >> "$NOK_log"

fi

echo "[$node] Owl: $Owl_status_result" >>$output_log

#### Call Trace Listener ####
call_tracer_listener_status=$(cat "$output_data" | grep 'Call Trace Listener' | grep "Running" | wc -l)
if [[ "call_tracer_listener_status" -eq 2 ]]; then
        call_tracer_listener_status_result="OK"
else
        call_tracer_listener_status_result="NOK"
        echo "Call Trace Listener: $call_tracer_listener_status" >> "$NOK_log"
fi

echo "[$node] Call Trace Listener: $call_tracer_listener_status_result" >>$output_log

#### KAFKA ####
KAFKA_status=$(cat "$output_data" | grep 'KAFKA' | grep "Running" | wc -l)
if [[ "KAFKA_status" -eq 2 ]]; then
        KAFKA_status_result="OK"
else
        KAFKA_status_result="NOK"
        echo "KAFKA: $KAFKA_status" >> "$NOK_log"

fi

echo "[$node] KAFKA: $KAFKA_status_result" >>$output_log

#### SBC Manager ####
SBC_manager_status=$(cat "$output_data" | grep 'SBC Manager' | grep "Running" | wc -l)
if [[ "SBC_manager_status" -eq 1 ]]; then
        SBC_manager_status_result="OK"
else
        SBC_manager_status_result="NOK"
        echo "SBC Manager: $SBC_manager_status" >> "$NOK_log"

fi

echo "[$node] SBC Manager: $SBC_manager_status_result" >>$output_log

#### Auth Service ####
Auth_service_status=$(cat "$output_data" | grep 'Auth Service' | grep "Running" | wc -l)
if [[ "Auth_service_status" -eq 1 ]]; then
        Auth_service_status_result="OK"
else
        Auth_service_status_result="NOK"
        echo "Auth Service: $Auth_service_status" >> "$NOK_log"
fi

echo "[$node] Auth Service: $Auth_service_status_result" >>$output_log

#### License Manager ####
LM_status=$(cat "$output_data" | grep 'License Manager' | grep "Running" | wc -l)
if [[ "LM_status" -eq 1 ]]; then
        LM_status_result="OK"
else
        LM_status_result="NOK"
        echo "License Manager: $LM_status" >> "$NOK_log"

fi

echo "[$node] License Manager: $LM_status_result" >>$output_log


#### PM ####
PM_status=$(cat "$output_data" | grep 'PM' | grep "Running" | wc -l)
if [[ "PM_status" -eq 1 ]]; then
        PM_status_result="OK"
else
        PM_status_result="NOK"
        echo "PM: $PM_status" >> "$NOK_log"

fi

echo "[$node] PM: $PM_status_result" >>$output_log

#### Device Manager ####
DM_status=$(cat "$output_data" | grep 'Device Manager' | grep "Running" | wc -l)
if [[ "DM_status" -eq 1 ]]; then
        DM_status_result="OK"
else
        DM_status_result="NOK"
        echo "Device Manager: $DM_status" >> "$NOK_log"

fi

echo "[$node] Device Manager: $DM_status_result" >>$output_log

#### DBaaS Service ####
DBaaS_service_status=$(cat "$output_data" | grep 'DBaaS Service' | grep "Running" | wc -l)
if [[ "DBaaS_service_status" -eq 2 ]]; then
        DBaaS_service_status_result="OK"
else
        DBaaS_service_status_result="NOK"
        echo "DBaaS Service: $DBaaS_service_status" >> "$NOK_log"

fi

echo "[$node] DBaaS Service: $DBaaS_service_status_result" >>$output_log

#### DBaaS Connectivity ####
DBaaS_connectivity_status=$(cat "$output_data" | grep 'DBaaS Connectivity' | grep "Running" | wc -l)
if [[ "DBaaS_connectivity_status" -eq 2 ]]; then
        DBaaS_connectivity_status_result="OK"
else
        DBaaS_connectivity_status_result="NOK"
        echo "DBaaS Connectivity: $DBaaS_connectivity_status" >> "$NOK_log"

fi

echo "[$node] DBaaS Connectivity: $DBaaS_connectivity_status_result" >>$output_log

#### File Replication ####
File_replication_status=$(cat "$output_data" | grep 'File Replication' | grep "Running" | wc -l)
if [[ "File_replication_status" -eq 1 ]]; then
        File_replication_status_result="OK"
else
        File_replication_status_result="NOK"
        echo "File Replication: $File_replication_status" >> "$NOK_log"

fi

echo "[$node] File Replication: $File_replication_status_result" >>$output_log

#### Insight ####
Insight_status=$(cat "$output_data" | grep 'Insight' | grep "Running" | wc -l)
if [[ "Insight_status" -eq 1 ]]; then
        Insight_status_result="OK"
else
        Insight_status_result="NOK"
        echo "Insight: $Insight_status" >> "$NOK_log"

fi

echo "[$node] Insight: $Insight_status_result" >>$output_log


#### Active Standby ####

active_node=$(cat "$output_data" | grep 192.168.227.85 | grep -c Active | wc -l)

if [[ $active_node -eq 1 ]]; then
        active_node_status="OK"
else
        active_node_status="NOK"
        echo "Active Node: $active_node" >> "$NOK_log"

fi

echo "[$node] Active Node: $active_node_status" >>$output_log

### Database Running ###
# Database_running=$(sudo -u postgres ps -ef | grep postgres | wc -l)
# if [[ $Database_running > 0 ]]; then
#    Database_running_result="OK"
# else
#    Database_running_result="NOK"
# fi

# echo "[$node] Database Running: $Database_running_result" >>$output_log

### Database Listening ###
# Database_listening=$(su - oracle -c "/opt/oracle/product/12.1.0.2/db_1/bin/lsnrctl status")
# To be completed

### NTP ###

#### NTP Service ####
Ntp_service_status=$(systemctl status chronyd | grep "running")
if [ -z "$Ntp_service_status" ]; then
        Ntp_service_result="NOK"
        echo "NTP Service Status: $Ntp_service_status" >> "$NOK_log"

else
    Ntp_service_result="OK"
fi

echo "[$node] NTP Service Status: $Ntp_service_result" >>$output_log

#### NTP Synchronization ####
Ntp_sync=$(chronyc sources | grep '\*' | wc -l)

if [[ $Ntp_sync -eq 1 ]]; then
    Ntp_sync_result="OK"
else
    Ntp_sync_result="NOK"
    echo "NTP Synchronization: $Ntp_sync" >> "$NOK_log"

fi

amm5dsi1_sync=$(chronyc sources | grep 192.168.225.82 | wc -l )
amm5dsi2_sync=$(chronyc sources | grep 192.168.225.84 | wc -l )
amm6dsi1_sync=$(chronyc sources | grep 192.168.226.82 | wc -l )
amm6dsi2_sync=$(chronyc sources | grep 192.168.226.84 | wc -l )

if [[ "$amm5dsi1_sync" -eq 1 ]] && [[ "$amm5dsi2_sync" -eq 1 ]] && [[ "$amm6dsi1_sync" -eq 1 ]] && [[ "$amm6dsi2_sync" -eq 1 ]]; then
    dsi_ntp_sync="OK"
else
    dsi_ntp_sync="NOK"
    echo "Amm5dsi01: $amm5dsi1_sync" >> "$NOK_log"
    echo "Amm5dsi02: $amm5dsi2_sync" >> "$NOK_log"
    echo "Amm6dsi01: $amm6dsi1_sync" >> "$NOK_log"
    echo "Amm6dsi02: $amm6dsi2_sync" >> "$NOK_log"

fi

echo "[$node] NTP Synchronization: $Ntp_sync_result" >>$output_log
echo "[$node] DSI NTP Synchronization: $dsi_ntp_sync" >>$output_log

### Disk Space ###
Disk_space=$(df -h | awk '{print $5}' | sort -h | tail -1 | tr -d %)
if [[ $Disk_space > 80 ]]; then
    Disk_space_result="NOK"
    echo "Disk Space: $Disk_space" >> "$NOK_log"

else
    Disk_space_result="OK"
fi

echo "[$node] Disk Space: $Disk_space_result" >>$output_log

### Memory Load ###
Memory_load=$(free -m | grep -i mem | awk '{total=$2; used=$3; percentage=used/total * 100; print percentage}' | awk -F'.' '{print $1}')
if [[ $Memory_load > 80 ]]; then
    Memory_load_result="NOK"
    echo "Memory Load: $Memory_load" >> "$NOK_log"

else
    Memory_load_result="OK"
fi

echo "[$node] Memory Load: $Memory_load_result" >>$output_log

### Swap Load ###
Swap_load=$(free -m | grep -i swap | awk '{total=$2; used=$3; percentage=used/total * 100; print percentage}')
if [[ $Swap_load > 80 ]]; then
    Swap_load_result="NOK"
    echo "Swap Load: $Swap_load" >> "$NOK_log"

else
    Swap_load_result="OK"
fi

echo "[$node] Swap Load: $Swap_load_result" >>$output_log

### System Load ###
CPU_load=$(iostat -mh | sed -n '4p' | awk '{print $6}' | awk -F'.' '{print $1}')
if [[ $CPU_load -le 20 ]]; then
    CPU_load_result="NOK"
    echo "CPU Load: $CPU_load" >> "$NOK_log"

else
    CPU_load_result="OK"
fi

echo "[$node] CPU Load: $CPU_load_result" >>$output_log

### Uptime ###
Uptime=$(uptime | awk '{print $3}')
if [[ $Uptime < 1 ]]; then
    Uptime_result="NOK"
    echo "Uptime: $Uptime" >> "$NOK_log"

else
    Uptime_result="OK"
fi

echo "[$node] Uptime: $Uptime_result" >>$output_log

### Get Amm6PSX01 file ###
sudo -u admin scp admin@192.168.226.80:/export/home/HealthCheck/PSX/"$date_today"/amm6vrpsx01_Health_Check_output.txt  /export/home/HealthCheck/PSX/"$date_today"/


### End of script actions ###

rm -f "$output_data"
