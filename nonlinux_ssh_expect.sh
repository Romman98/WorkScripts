#!/usr/bin/expect -f

set Command [lindex $argv 0]
set Trunk_name [lindex $argv 1]

set user ""
set password ""
set servers {
    {"IP" "hostname>"}
}


# Open the file and read each line
foreach server_info $servers {
    set server [lindex $server_info 0]
    set prompt [lindex $server_info 1]


    # Automate the SSH connection and commands
    spawn ssh $user@$server
    expect "password:"
    send "$password\r"

    expect "$prompt"
    send "$Command\r"

    # End the SSH session
    send "\r exit\r"
    expect eof
}
