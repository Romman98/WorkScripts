#!/bin/bash

run=true


## This function generates an array with range n
function range {
    num=$1
    numbers=()
    counter=0
    while [ $counter -lt $num ]; do
        numbers+=($counter)
        ((counter++))
    done

    echo "${numbers[@]}"
}


while [ $run=='true' ]
do

declare -a from_number
declare -a to_number

# Empties the files
> to_number.txt
> output.txt


read -p "Subscriber: " line

## Requests the PSX and stores the values in the variables.
routing_label=$(./expect.sh "show Destination National_Id $line Country_Id 962" | grep "Routing_Label_Id" | awk -F': ' '{print $2}' | sed 's/[^[:print:]]//g')
trunk_group=$(./expect.sh "show Routing_Label_Routes Routing_Label_Id $routing_label Route_Sequence 1" | grep Route_Endpoint1 | awk -F': ' '{print $2}' | sed 's/[^[:print:]]//g')
./expect.sh "show Trunkgroup Trunkgroup_id $trunk_group Gateway_Id AMM1GSX01"| sed 's/[^[:print:]]//g' > output.txt
ip_signaling_peer=$(cat output.txt | grep Ip_Signaling_Peer_Group_Id | awk -F': ' '{print $2}' | sed 's/[^[:print:]]//g')
ip_address=$(./expect.sh "show Ip_Signaling_Peer_Group_Data Ip_Signaling_Peer_Group_Id $ip_signaling_peer Sequence_Number 0" | grep "Ip_Address" |  awk -F': ' '{print $2}' | sed 's/[^[:print:]]//g')
COS1=$(cat output.txt  | grep Class_Of_Service_Id | awk -F': ' '{print $2}')
COS2=$(./expect.sh "show Trunkgroup Trunkgroup_id $trunk_group Gateway_Id AMM2GSX01" | grep Class_Of_Service_Id | awk -F': ' '{print $2}')

echo "##########################"
printf "%-18s %s\n" "Trunk Group: " "$trunk_group"
printf "%-18s %s\n" "Routing Label: " "$routing_label"
printf "%-18s %s\n" "IP Address: " "$ip_address"
printf "%-18s %s\n" "COS at AMM1GSX01: " "$COS1"
printf "%-18s %s\n" "COS at AMM2GSX02: " "$COS2"
echo "##########################"

echo "COS | DDI_Range"
read  options

case "$options" in 
"COS")
        read -p "e for enable or d for disable: " status

        if [[ $status == 'e' ]]; then
                change_status=$(./expect.sh "update Trunkgroup Trunkgroup_id $trunk_group Gateway_Id AMM1GSX01 Class_Of_Service_Id ISP_BLOCK_DEST_COS")
                change_status=$(./expect.sh "update Trunkgroup Trunkgroup_id $trunk_group Gateway_Id AMM2GSX01 Class_Of_Service_Id ISP_BLOCK_DEST_COS")
        elif [[ $status == 'd' ]]; then
                change_status=$(./expect.sh "update Trunkgroup Trunkgroup_id $trunk_group Gateway_Id AMM1GSX01 Class_Of_Service_Id ISP_Partial_disconnect")
                change_status=$(./expect.sh "update Trunkgroup Trunkgroup_id $trunk_group Gateway_Id AMM2GSX01 Class_Of_Service_Id ISP_Partial_disconnect")
        fi
./expect.sh "show Trunkgroup Trunkgroup_id $trunk_group Gateway_Id AMM1GSX01"| sed 's/[^[:print:]]//g' > output.txt
COS1=$(cat output.txt  | grep Class_Of_Service_Id | awk -F': ' '{print $2}')
COS2=$(./expect.sh "show Trunkgroup Trunkgroup_id $trunk_group Gateway_Id AMM2GSX01" | grep Class_Of_Service_Id | awk -F': ' '{print $2}')

printf "%-18s %s\n" "COS at AMM1GSX01: " "$COS1"
printf "%-18s %s\n" "COS at AMM2GSX02: " "$COS2"

                ;;

"DDI_Range")
        ddi_range=$(cat output.txt | grep Ddi_Range_Profile_Id | awk -F': ' '{print $2}')
        ./expect.sh "find DDI_Range_Profile_Data Ddi_Range_Profile_Id $ddi_range" > output.txt
        from_number=($(cat output.txt | grep "From"| sed 's/[^[:print:]]//g' | awk -F': ' '{print $2}'))
        this_range=$(range ${#from_number[@]})
        for item in ${from_number[@]};
        do 
       ./expect.sh "show DDI_Range_Profile_Data Ddi_Range_Profile_Id $ddi_range From_Number $item" >> to_number.txt
        done

        to_number=($(cat to_number.txt | grep To_Number |sed 's/[^[:print:]]//g' | awk -F': ' '{print $2}' ))
        for i in ${this_range[@]}; do
                echo "From: ${from_number[$i]}  To: ${to_number[$i]}"
        done

        
        ;;
*)
        echo ""
        ;;
esac
done
