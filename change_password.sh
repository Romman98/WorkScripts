#!/bin/bash
set -xv

file_servers="/home/c5-admin/list_of_servers.txt"
password_change_log="/home/c5-admin/password_change_log.txt"
while IFS= read -r line <&3; do
        echo $line
        username=$(echo "$line" | awk '{print $1}')
        server_IP=$(echo "$line" | awk '{print $2}')
        new_password=$(echo "$line" | awk '{print $3}')

        echo "changing the password for $username on $server_IP"  >> "$password_change_log"

        #ssh c5-admin@"$server_IP" "echo \"$username:$new_password\" | sudo chpasswd"
        ssh c5-admin@"$server_IP" "echo '$username:$new_password' | sudo chpasswd"

        if [ $? -eq 0 ]; then
                echo "pasword has been change successfully"  >> "$password_change_log"
        else
                echo "password change was failed" >> "$password_change_log"
        fi

done 3< "$file_servers"
