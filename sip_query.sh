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


    read -p "Subscriber or batch: " line

    if [[ "$line" == "batch" ]]; then
        echo "##########################"
        echo "COS | DDI_Range | GSX | Check | Number_plan"
        read options_mini
        read -p "Enter the lines: " -a batch_lines
        case "$options_mini" in
            "cos" | "COS")
                read -p "e for enable or d for disable: " status
                for line in "${batch_lines[@]}"; do

                    routing_label=$(./expect.sh "show Destination National_Id $line Country_Id 962" | grep "Routing_Label_Id" | awk -F': ' '{print $2}' | sed 's/[^[:print:]]//g')
                    trunk_group=$(./expect.sh "show Routing_Label_Routes Routing_Label_Id $routing_label Route_Sequence 1" | grep Route_Endpoint1 | awk -F': ' '{print $2}' | sed 's/[^[:print:]]//g')

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
                    
                    echo "__________________________________________"
                    echo "Line: $line - Trunk: $trunk_group"
                    printf "%-18s %s\n" "COS at AMM1GSX01: " "$COS1"
                    printf "%-18s %s\n" "COS at AMM2GSX02: " "$COS2"
                done
            ;;
            "check" | "Check")
                for line in "${batch_lines[@]}"; do
                    routing_label=$(./expect.sh "show Destination National_Id $line Country_Id 962" | grep "Routing_Label_Id" | awk -F': ' '{print $2}' | sed 's/[^[:print:]]//g')
                    trunk_group=$(./expect.sh "show Routing_Label_Routes Routing_Label_Id $routing_label Route_Sequence 1" | grep Route_Endpoint1 | awk -F': ' '{print $2}' | sed 's/[^[:print:]]//g')

                    echo "__________________________________________"
                    printf "%-18s %s\n" "Line:  $line"
                    printf "%-18s %s\n" "Trunk Group: " "$trunk_group"
                    printf "%-18s %s\n" "Routing Label: " "$routing_label"
                done
            ;;
            "Number_plan")
            for line in "${batch_lines[@]}"; do
                routing_label=$(./expect.sh "show Destination National_Id $line Country_Id 962" | grep "Routing_Label_Id" | awk -F': ' '{print $2}' | sed 's/[^[:print:]]//g')
                trunk_group=$(./expect.sh "show Routing_Label_Routes Routing_Label_Id $routing_label Route_Sequence 1" | grep Route_Endpoint1 | awk -F': ' '{print $2}' | sed 's/[^[:print:]]//g')
                ./expect.sh "show Trunkgroup Trunkgroup_id $trunk_group Gateway_Id AMM1GSX01"| sed 's/[^[:print:]]//g' > numbering_plan.txt
                numbering_plan=$(cat numbering_plan.txt | grep Numbering_Plan_Id | awk -F': ' '{print $2}' | sed 's/[^[:print:]]//g')
                tg_found=$(grep "$trunk_group" number_plan_result.txt | wc -l )
                if [[ "$tg_found" -eq 0 ]]; then
                    if [[ "$numbering_plan" == "C5_AMAN_NUM_PLAN_NO_00" ]];then
                        echo "[$line] $trunk_group is OK" >> number_plan_result.txt
                    else
                        echo "[$line] $trunk_group is NOK" >> number_plan_result.txt
                    fi
                else
                    echo "[$line] TG already existed" >> number_plan_result.txt
                fi
            done
            ;;
        esac
    else

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
        echo "COS | DDI_Range | GSX"
        read  options

        case "$options" in 
            "cos" | "COS")
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

            "DDI_Range" | "ddi_range")
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

            "GSX" | "gsx")
                ## Request the details from the GSX
                GSX1_TG_details=$(./GSX1_expect.sh "SHOW TRUNK GROUP $trunk_group ADMIN")
                GSX2_TG_details=$(./GSX2_expect.sh "SHOW TRUNK GROUP $trunk_group ADMIN")

                GSX1_SIP_details=$(./GSX1_expect.sh "SHOW SIP SERVICE  $trunk_group ADMIN")
                GSX2_SIP_details=$(./GSX2_expect.sh "SHOW SIP SERVICE  $trunk_group ADMIN")

                GSX_1_TG_state=$(echo "$GSX1_TG_details" | grep State -m 1 | awk '{print $2}' | sed 's/[^[:print:]]//g')
                GSX_1_TG_mode=$(echo "$GSX1_TG_details" | grep Mode -m 1 | awk '{print $2}'  | sed 's/[^[:print:]]//g')

                GSX_2_TG_state=$(echo "$GSX2_TG_details" | grep State -m 1 | awk '{print $2}'  | sed 's/[^[:print:]]//g')
                GSX_2_TG_mode=$(echo "$GSX2_TG_details" | grep Mode -m 1 | awk '{print $2}'  | sed 's/[^[:print:]]//g')

                GSX_1_SIP_state=$(echo "$GSX1_SIP_details" | grep "Admin State" -m 1 | awk '{print $4}'  | sed 's/[^[:print:]]//g')
                GSX_1_SIP_mode=$(echo "$GSX1_SIP_details" | grep "Mode" -m 1 | awk '{print $3}'  | sed 's/[^[:print:]]//g')

                GSX_2_SIP_state=$(echo "$GSX2_SIP_details" | grep "Admin State" -m 1 | awk '{print $4}'  | sed 's/[^[:print:]]//g')
                GSX_2_SIP_mode=$(echo "$GSX2_SIP_details" | grep "Mode" -m 1 | awk '{print $3}'  | sed 's/[^[:print:]]//g')

                printf "%-18s %s\n" "GSX1 Trunk: " "$GSX_1_TG_state $GSX_1_TG_mode"
                printf "%-18s %s\n" "GSX1 SIP: "   "$GSX_1_SIP_state $GSX_1_SIP_mode"
                printf "%-18s %s\n" "GSX2 Trunk: " "$GSX_2_TG_state $GSX_2_TG_mode"
                printf "%-18s %s\n" "GSX2 SIP: "   "$GSX_2_SIP_state $GSX_2_SIP_mode"
                ;;
                *)
                        echo ""
                        ;;
        esac
    fi
done
