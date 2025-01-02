#!/bin/bash
# set -x

function date_adder {
    start_date=("$1")
    end_date=$(date +%Y-%m-%d)

    while [[ "$start_date" < "$end_date" ]]; do
        list_of_dates+=("$start_date")
        start_date=$(date -I -d "$start_date + 1 day")
    done
}

CDR_DIRECTORY="/export/home/dsi/AMM1GSX01/archive"
# CDR_DIRECTORY="/mnt/c/Users/ahmad.romman/Desktop/IMS_Work_Folder/Projects/CDR_reader"
date_to_return="$3"

date_adder "$date_to_return"

for i in ${list_of_dates[@]}; do
    zgrep -a "$1" $CDR_DIRECTORY/ACK_"$i".tar.gz | grep $2 >>result.txt
done
Grep=$(cat result.txt)

##### Functions

function Attempt_IP_IP() {
    local cdr="$1"
    local rec_type=$2
    local call_dir=$3

    local date=$(awk -F',' '{print $6}' <<<"$cdr")
    local time=$(awk -F',' '{print $7}' <<<"$cdr")
    local disconnection=$(awk -F',' '{print $12}' <<<"$cdr")
    local SIPdisconnection=$(awk -F',' '{print $63}' <<<"$cdr")
    local calling_number=$(awk -F',' '{print $17}' <<<"$cdr")
    local called_number=$(awk -F',' '{print $18}' <<<"$cdr")
    local route_label=$(awk -F',' '{print $26}' <<<"$cdr")
    local egressLocIP=$(awk -F',' '{print $29}' <<<"$cdr")
    local egressRemIP=$(awk -F',' '{print $30}' <<<"$cdr")
    local IngressTrunk=$(awk -F',' '{print $31}' <<<"$cdr")
    local egressTrunk=$(awk -F',' '{print $101}' <<<"$cdr")
    local ingressLocIP=$(awk -F',' '{print $201}' <<<"$cdr")
    local ingressRemIP=$(awk -F',' '{print $202}' <<<"$cdr")

    printf "%-22s %s\n" "Date-time:" "$date $time"
    printf "%-22s %s\n" "Record Type:" "$rec_type"
    printf "%-22s %s\n" "Call Direction:" "$call_dir"
    printf "%-22s %s\n" "Calling:" "$calling_number"
    printf "%-22s %s\n" "Called:" "$called_number"
    printf "%-22s %s\n" "Egress Trunk:" "$egressTrunk"
    printf "%-22s %s\n" "Ingress Trunk:" "$IngressTrunk"
    printf "%-22s %s\n" "Routing Label:" "$route_label"
    printf "%-22s %s\n" "Egress Remote IP:" "$egressRemIP"
    printf "%-22s %s\n" "Egress Local IP:" "$egressLocIP"
    printf "%-22s %s\n" "Ingress Local IP:" "$ingressLocIP"
    printf "%-22s %s\n" "Ingress Remote IP:" "$ingressRemIP"
    printf "%-22s %s\n" "Disconnection Reason:" "$disconnection"
    printf "%-22s %s\n" "SIP Disc Reason:" "$SIPdisconnection"
}

function Start_IP_IP() {
    local cdr="$1"
    local rec_type="$2"
    local call_dir="$3"
    local date=$(awk -F',' '{print $6}' <<<"$cdr")
    local time=$(awk -F',' '{print $7}' <<<"$cdr")
    local calling_number=$(awk -F',' '{print $15}' <<<"$cdr")
    local called_number=$(awk -F',' '{print $16}' <<<"$cdr")
    local route_label=$(awk -F',' '{print $24}' <<<"$cdr")
    local egressLocIP=$(awk -F',' '{print $27}' <<<"$cdr")
    local egressRemIP=$(awk -F',' '{print $28}' <<<"$cdr")
    local egressTrunk=$(awk -F',' '{print $97}' <<<"$cdr")
    local IngressTrunk=$(awk -F',' '{print $29}' <<<"$cdr")
    local ingressLocIP=$(awk -F',' '{print $189}' <<<"$cdr")
    local ingressRemIP=$(awk -F',' '{print $190}' <<<"$cdr")

    printf "%-22s %s\n" "Date-time:" "$date $time"
    printf "%-22s %s\n" "Record Type:" "$rec_type"
    printf "%-22s %s\n" "Call Direction:" "$call_dir"
    printf "%-22s %s\n" "Calling:" "$calling_number"
    printf "%-22s %s\n" "Called:" "$called_number"
    printf "%-22s %s\n" "Egress Trunk:" "$egressTrunk"
    printf "%-22s %s\n" "Ingress Trunk:" "$IngressTrunk"
    printf "%-22s %s\n" "Routing Label:" "$route_label"
    printf "%-22s %s\n" "Egress Remote IP:" "$egressRemIP"
    printf "%-22s %s\n" "Egress Local IP:" "$egressLocIP"
    printf "%-22s %s\n" "Ingress Local IP:" "$ingressLocIP"
    printf "%-22s %s\n" "Ingress Remote IP:" "$ingressRemIP"
}

function Stop_IP_IP() {
    local cdr="$1"
    local rec_type="$2"
    local call_dir="$3"
    local date=$(awk -F',' '{print $11}' <<<"$cdr")
    local time=$(awk -F',' '{print $12}' <<<"$cdr")
    local callDuration=$(awk -F',' ' {print $14 / 100 }' <<<"$cdr")
    local disconnection=$(awk -F',' '{print $15}' <<<"$cdr")
    local SIPdisconnection=$(awk -F',' '{print $130}' <<<"$cdr")
    local calling_number=$(awk -F',' '{print $20}' <<<"$cdr")
    local called_number=$(awk -F',' '{print $21}' <<<"$cdr")
    local route_label=$(awk -F',' '{print $29}' <<<"$cdr")
    local egressLocIP=$(awk -F',' '{print $32}' <<<"$cdr")
    local egressRemIP=$(awk -F',' '{print $33}' <<<"$cdr")
    local egressTrunk=$(awk -F',' '{print $111}' <<<"$cdr")
    local IngressTrunk=$(awk -F',' '{print $34}' <<<"$cdr")
    local ingressLocIP=$(awk -F',' '{print $211}' <<<"$cdr")
    local ingressRemIP=$(awk -F',' '{print $212}' <<<"$cdr")

    printf "%-22s %s\n" "Date-time:" "$date $time"
    printf "%-22s %s\n" "Record Type:" "$rec_type"
    printf "%-22s %s\n" "Call Direction:" "$call_dir"
    printf "%-22s %s\n" "Disconnection Reason:" "$disconnection"
    printf "%-22s %s\n" "SIP Disc Reason:" "$SIPdisconnection"
    printf "%-22s %s\n" "Call Duration:" "$callDuration"
    printf "%-22s %s\n" "Calling:" "$calling_number"
    printf "%-22s %s\n" "Called:" "$called_number"
    printf "%-22s %s\n" "Egress Trunk:" "$egressTrunk"
    printf "%-22s %s\n" "Ingress Trunk:" "$IngressTrunk"
    printf "%-22s %s\n" "Routing Label:" "$route_label"
    printf "%-22s %s\n" "Egress Remote IP:" "$egressRemIP"
    printf "%-22s %s\n" "Egress Local IP:" "$egressLocIP"
    printf "%-22s %s\n" "Ingress Local IP:" "$ingressLocIP"
    printf "%-22s %s\n" "Ingress Remote IP:" "$ingressRemIP"
}

function Attempt_IP_PSTN() {
    local cdr="$1"
    local rec_type=$2
    local call_dir=$3

    local date=$(awk -F',' '{print $6}' <<<"$cdr")
    local time=$(awk -F',' '{print $7}' <<<"$cdr")
    local disconnection=$(awk -F',' '{print $12}' <<<"$cdr")
    local SIPdisconnection=$(awk -F',' '{print $63}' <<<"$cdr")
    local calling_number=$(awk -F',' '{print $17}' <<<"$cdr")
    local called_number=$(awk -F',' '{print $18}' <<<"$cdr")
    local route_label=$(awk -F',' '{print $26}' <<<"$cdr")
    # local egressLocIP=$(awk -F',' '{print $}' <<< "$cdr")
    # local egressRemIP=$(awk -F',' '{print $}' <<< "$cdr")
    local IngressTrunk=$(awk -F',' '{print $31}' <<<"$cdr")
    local egressTrunk=$(awk -F',' '{print $101}' <<<"$cdr")
    local ingressLocIP=$(awk -F',' '{print $158}' <<<"$cdr")
    local ingressRemIP=$(awk -F',' '{print $159}' <<<"$cdr")

    printf "%-22s %s\n" "Date-time:" "$date $time"
    printf "%-22s %s\n" "Record Type:" "$rec_type"
    printf "%-22s %s\n" "Call Direction:" "$call_dir"
    printf "%-22s %s\n" "Disconnection Reason:" "$disconnection"
    printf "%-22s %s\n" "SIP Disc Reason:" "$SIPdisconnection"
    printf "%-22s %s\n" "Calling:" "$calling_number"
    printf "%-22s %s\n" "Called:" "$called_number"
    printf "%-22s %s\n" "Egress Trunk:" "$egressTrunk"
    printf "%-22s %s\n" "Ingress Trunk:" "$IngressTrunk"
    printf "%-22s %s\n" "Routing Label:" "$route_label"
    # printf "%-22s %s\n" "Egress Remote IP:" "$egressRemIP"
    # printf "%-22s %s\n" "Egress Local IP:" "$egressLocIP"
    printf "%-22s %s\n" "Ingress Local IP:" "$ingressLocIP"
    printf "%-22s %s\n" "Ingress Remote IP:" "$ingressRemIP"
}

function Start_IP_PSTN() {
    local cdr="$1"
    local rec_type=$2
    local call_dir=$3

    local date=$(awk -F',' '{print $6}' <<<"$cdr")
    local time=$(awk -F',' '{print $7}' <<<"$cdr")
    local calling_number=$(awk -F',' '{print $15}' <<<"$cdr")
    local called_number=$(awk -F',' '{print $16}' <<<"$cdr")
    local route_label=$(awk -F',' '{print $24}' <<<"$cdr")
    # local egressLocIP=$(awk -F',' '{print $}' <<< "$cdr")
    # local egressRemIP=$(awk -F',' '{print $}' <<< "$cdr")
    local IngressTrunk=$(awk -F',' '{print $29}' <<<"$cdr")
    local egressTrunk=$(awk -F',' '{print $97}' <<<"$cdr")
    local ingressLocIP=$(awk -F',' '{print $145}' <<<"$cdr")
    local ingressRemIP=$(awk -F',' '{print $146}' <<<"$cdr")

    printf "%-22s %s\n" "Date-time:" "$date $time"
    printf "%-22s %s\n" "Record Type:" "$rec_type"
    printf "%-22s %s\n" "Call Direction:" "$call_dir"
    printf "%-22s %s\n" "Calling:" "$calling_number"
    printf "%-22s %s\n" "Called:" "$called_number"
    printf "%-22s %s\n" "Egress Trunk:" "$egressTrunk"
    printf "%-22s %s\n" "Ingress Trunk:" "$IngressTrunk"
    printf "%-22s %s\n" "Routing Label:" "$route_label"
    # printf "%-22s %s\n" "Egress Remote IP:" "$egressRemIP"
    # printf "%-22s %s\n" "Egress Local IP:" "$egressLocIP"
    printf "%-22s %s\n" "Ingress Local IP:" "$ingressLocIP"
    printf "%-22s %s\n" "Ingress Remote IP:" "$ingressRemIP"
}

function Stop_IP_PSTN() {
    local cdr="$1"
    local rec_type=$2
    local call_dir=$3

    local date=$(awk -F',' '{print $11}' <<<"$cdr")
    local time=$(awk -F',' '{print $12}' <<<"$cdr")
    local disconnection=$(awk -F',' '{print $15}' <<<"$cdr")
    local SIPdisconnection=$(awk -F',' '{print $70}' <<<"$cdr")
    local callDuration=$(awk -F',' ' {print $14 / 100 }' <<<"$cdr")
    local calling_number=$(awk -F',' '{print $20}' <<<"$cdr")
    local called_number=$(awk -F',' '{print $21}' <<<"$cdr")
    local route_label=$(awk -F',' '{print $29}' <<<"$cdr")
    # local egressLocIP=$(awk -F',' '{print $}' <<< "$cdr")
    # local egressRemIP=$(awk -F',' '{print $}' <<< "$cdr")
    local IngressTrunk=$(awk -F',' '{print $34}' <<<"$cdr")
    local egressTrunk=$(awk -F',' '{print $111}' <<<"$cdr")
    local ingressLocIP=$(awk -F',' '{print $168}' <<<"$cdr")
    local ingressRemIP=$(awk -F',' '{print $169}' <<<"$cdr")

    printf "%-22s %s\n" "Date-time:" "$date $time"
    printf "%-22s %s\n" "Record Type:" "$rec_type"
    printf "%-22s %s\n" "Call Direction:" "$call_dir"
    printf "%-22s %s\n" "Disconnection Reason:" "$disconnection"
    printf "%-22s %s\n" "SIP Disc Reason:" "$SIPdisconnection"
    printf "%-22s %s\n" "Call Duration:" "$callDuration"
    printf "%-22s %s\n" "Calling:" "$calling_number"
    printf "%-22s %s\n" "Called:" "$called_number"
    printf "%-22s %s\n" "Egress Trunk:" "$egressTrunk"
    printf "%-22s %s\n" "Ingress Trunk:" "$IngressTrunk"
    printf "%-22s %s\n" "Routing Label:" "$route_label"
    # printf "%-22s %s\n" "Egress Remote IP:" "$egressRemIP"
    # printf "%-22s %s\n" "Egress Local IP:" "$egressLocIP"
    printf "%-22s %s\n" "Ingress Local IP:" "$ingressLocIP"
    printf "%-22s %s\n" "Ingress Remote IP:" "$ingressRemIP"
}

function Attempt_PSTN_IP() {
    local cdr="$1"
    local rec_type=$2
    local call_dir=$3

    local date=$(awk -F',' '{print $6}' <<<"$cdr")
    local time=$(awk -F',' '{print $7}' <<<"$cdr")
    local disconnection=$(awk -F',' '{print $12}' <<<"$cdr")
    local SIPdisconnection=$(awk -F',' '{print $77}' <<<"$cdr")
    local calling_number=$(awk -F',' '{print $17}' <<<"$cdr")
    local called_number=$(awk -F',' '{print $18}' <<<"$cdr")
    local route_label=$(awk -F',' '{print $26}' <<<"$cdr")
    local egressLocIP=$(awk -F',' '{print $29}' <<<"$cdr")
    local egressRemIP=$(awk -F',' '{print $30}' <<<"$cdr")
    local IngressTrunk=$(awk -F',' '{print $31}' <<<"$cdr")
    local egressTrunk=$(awk -F',' '{print $58}' <<<"$cdr")
    # local ingressLocIP=$(awk -F',' '{print $158}' <<< "$cdr")
    # local ingressRemIP=$(awk -F',' '{print $159}' <<< "$cdr")

    printf "%-22s %s\n" "Date-time:" "$date $time"
    printf "%-22s %s\n" "Record Type:" "$rec_type"
    printf "%-22s %s\n" "Call Direction:" "$call_dir"
    printf "%-22s %s\n" "Disconnection Reason:" "$disconnection"
    printf "%-22s %s\n" "SIP Disc Reason:" "$SIPdisconnection"
    printf "%-22s %s\n" "Calling:" "$calling_number"
    printf "%-22s %s\n" "Called:" "$called_number"
    printf "%-22s %s\n" "Egress Trunk:" "$egressTrunk"
    printf "%-22s %s\n" "Ingress Trunk:" "$IngressTrunk"
    printf "%-22s %s\n" "Routing Label:" "$route_label"
    printf "%-22s %s\n" "Egress Remote IP:" "$egressRemIP"
    printf "%-22s %s\n" "Egress Local IP:" "$egressLocIP"
    # printf "%-22s %s\n" "Ingress Local IP:" "$ingressLocIP"
    # printf "%-22s %s\n" "Ingress Remote IP:" "$ingressRemIP"
}

function Start_PSTN_IP() {
    local cdr="$1"
    local rec_type=$2
    local call_dir=$3

    local date=$(awk -F',' '{print $6}' <<<"$cdr")
    local time=$(awk -F',' '{print $7}' <<<"$cdr")
    local calling_number=$(awk -F',' '{print $15}' <<<"$cdr")
    local called_number=$(awk -F',' '{print $16}' <<<"$cdr")
    local route_label=$(awk -F',' '{print $24}' <<<"$cdr")
    local egressLocIP=$(awk -F',' '{print $27}' <<<"$cdr")
    local egressRemIP=$(awk -F',' '{print $28}' <<<"$cdr")
    local IngressTrunk=$(awk -F',' '{print $29}' <<<"$cdr")
    local egressTrunk=$(awk -F',' '{print $54}' <<<"$cdr")
    # local ingressLocIP=$(awk -F',' '{print $145}' <<< "$cdr")
    # local ingressRemIP=$(awk -F',' '{print $146}' <<< "$cdr")

    printf "%-22s %s\n" "Date-time:" "$date $time"
    printf "%-22s %s\n" "Record Type:" "$rec_type"
    printf "%-22s %s\n" "Call Direction:" "$call_dir"
    printf "%-22s %s\n" "Calling:" "$calling_number"
    printf "%-22s %s\n" "Called:" "$called_number"
    printf "%-22s %s\n" "Ingress Trunk:" "$IngressTrunk"
    printf "%-22s %s\n" "Egress Trunk:" "$egressTrunk"
    printf "%-22s %s\n" "Routing Label:" "$route_label"
    printf "%-22s %s\n" "Egress Remote IP:" "$egressRemIP"
    printf "%-22s %s\n" "Egress Local IP:" "$egressLocIP"
    # printf "%-22s %s\n" "Ingress Local IP:" "$ingressLocIP"
    # printf "%-22s %s\n" "Ingress Remote IP:" "$ingressRemIP"
}

function Stop_PSTN_IP() {
    local cdr="$1"
    local rec_type=$2
    local call_dir=$3

    local date=$(awk -F',' '{print $11}' <<<"$cdr")
    local time=$(awk -F',' '{print $12}' <<<"$cdr")
    local disconnection=$(awk -F',' '{print $12}' <<<"$cdr")
    local SIPdisconnection=$(awk -F',' '{print $87}' <<<"$cdr")
    local callDuration=$(awk -F',' ' {print $14 / 100 }' <<<"$cdr")
    local calling_number=$(awk -F',' '{print $20}' <<<"$cdr")
    local called_number=$(awk -F',' '{print $21}' <<<"$cdr")
    local route_label=$(awk -F',' '{print $29}' <<<"$cdr")
    local egressLocIP=$(awk -F',' '{print $32}' <<<"$cdr")
    local egressRemIP=$(awk -F',' '{print $33}' <<<"$cdr")
    local IngressTrunk=$(awk -F',' '{print $34}' <<<"$cdr")
    local egressTrunk=$(awk -F',' '{print $68}' <<<"$cdr")
    # local ingressLocIP=$(awk -F',' '{print $158}' <<< "$cdr")
    # local ingressRemIP=$(awk -F',' '{print $159}' <<< "$cdr")

    printf "%-22s %s\n" "Stop Date-time:" "$date $time"
    printf "%-22s %s\n" "Record Type:" "$rec_type"
    printf "%-22s %s\n" "Call Direction:" "$call_dir"
    printf "%-22s %s\n" "Disconnection Reason:" "$disconnection"
    printf "%-22s %s\n" "SIP Disc Reason:" "$SIPdisconnection"
    printf "%-22s %s\n" "Call Duration:" "$callDuration"
    printf "%-22s %s\n" "Calling:" "$calling_number"
    printf "%-22s %s\n" "Called:" "$called_number"
    printf "%-22s %s\n" "Egress Trunk:" "$egressTrunk"
    printf "%-22s %s\n" "Ingress Trunk:" "$IngressTrunk"
    printf "%-22s %s\n" "Routing Label:" "$route_label"
    printf "%-22s %s\n" "Egress Remote IP:" "$egressRemIP"
    printf "%-22s %s\n" "Egress Local IP:" "$egressLocIP"
    # printf "%-22s %s\n" "Ingress Local IP:" "$ingressLocIP"
    # printf "%-22s %s\n" "Ingress Remote IP:" "$ingressRemIP"
}

while IFS= read -r line; do
    record_type=$(echo $line | awk -F',' '{print $1}')
    echo "------------------------------------------------------------------------------------------------------------------------------"
    case "$record_type" in
    "ATTEMPT")
        call_direction=$(awk -F',' '{print $14}' <<<"$line")

        case $call_direction in
        "IP-TO-IP")
            Attempt_IP_IP "$line" "$record_type" "$call_direction"
            ;;
        "PSTN-TO-IP")
            Attempt_PSTN_IP "$line" "$record_type" "$call_direction"
            ;;
        "IP-TO-PSTN")
            Attempt_IP_PSTN "$line" "$record_type" "$call_direction"
            ;;
        esac
        ;;
    "START")
        call_direction=$(awk -F',' '{print $12}' <<<"$line")

        case "$call_direction" in
        "IP-TO-IP")
            Start_IP_IP "$line" "$record_type" "$call_direction"
            ;;
        "PSTN-TO-IP")
            Start_PSTN_IP "$line" "$record_type" "$call_direction"
            ;;
        "IP-TO-PSTN")
            Start_IP_PSTN "$line" "$record_type" "$call_direction"
            ;;
        esac
        ;;
    "STOP")
        call_direction=$(awk -F',' '{print $17}' <<<"$line")

        case "$call_direction" in
        "IP-TO-IP")
            Stop_IP_IP "$line" "$record_type" "$call_direction"
            ;;
        "PSTN-TO-IP")
            Stop_PSTN_IP "$line" "$record_type" "$call_direction"
            ;;
        "IP-TO-PSTN")
            Stop_IP_PSTN "$line" "$record_type" "$call_direction"
            ;;
        esac
        ;;
    esac

done <<<"$Grep"

rm result.txt
