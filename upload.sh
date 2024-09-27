#!/usr/bin/expect
#!/bin/bash

set timeout 60

spawn sftp [lindex $argv 1]@[lindex $argv 0]

expect {
    "*?yes/no*?" {
        send "yes\r"
        expect "*?assword*?" { send "[lindex $argv 2]\r" }
    }
    
    "password" {send "[lindex $argv 2]\r"}
    
}

expect "*?sftp>*?" 
send "rm install-odoo \r"
expect "*?sftp>*?" 
send "mkdir install-odoo\r"
expect "*?sftp>*?" 
send "cd install-odoo\r"
expect "*?sftp>*?" 
send "put *.sh\r"
expect "*?sftp>*?" 
send "exit \r"
exit


