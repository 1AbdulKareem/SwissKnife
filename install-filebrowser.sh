#!/usr/bin/expect
#!/bin/bash

set timeout 60

spawn ssh [lindex $argv 1]@[lindex $argv 0]

expect {
    "*?yes/no*?" {
        send "yes\r"
        expect "*?assword*?" { send "[lindex $argv 2]\r" }
    }
    
    "password" {
        send "[lindex $argv 2]\r"


    }
}

expect "*?:*?"
send "sudo su\r"
expect {
    "*?$*?" {
        expect "*?assword*?" { send "[lindex $argv 2]\r" }
    }
    
    "*?#*?" {
        send "\r"


    }
}
expect "*?#*?"
send "apt-get install curl -y\r"
expect "*?#*?"
send "curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash \r"
expect "*?#*?"
send "rm /root/filebrowser.db\r"
expect "*?#*?"
send "filebrowser -d /root/filebrowser.db -a 0.0.0.0 -p 9000 -r / --username abdulkarim@valutoria.com --password \$2a\$12\$LhP39uAEK1yrN2D7zc.liOh/MKtTMF3Y0XqK57u3qudxBp/rqpZtu \r"
expect "*?Listening*?"
send \x03
expect "*?#*?"
send "rm /etc/init.d/filebrowser\r"
expect "*?#*?"
send "cat > /etc/init.d/filebrowser <<EOF 
#!/bin/bash
# Change the following line to match your filebrowser binary path
FILEBROWSER_BIN=\"/usr/local/bin/filebrowser\"
# Change the following line to match your filebrowser.db path
FILEBROWSER_DB=\"/root/filebrowser.db\"
case \"\\\$1\" in
start)
    echo \"Starting filebrowser\"
    nohup \\\$FILEBROWSER_BIN -d \\\$FILEBROWSER_DB >/dev/null 2>&1 &
    ;;
stop)
    echo \"Stopping filebrowser\"
    pkill -f \"\\\$FILEBROWSER_BIN\"
    ;;
restart)
    echo \"Restarting filebrowser\"
    pkill -f \"\\\$FILEBROWSER_BIN\"
    sleep 1
    nohup \\\$FILEBROWSER_BIN -d \\\$FILEBROWSER_DB >/dev/null 2>&1 &
    ;;
*)
    echo \"Usage: \\\$0 {start|stop|restart}\"
    exit 1
    ;;
esac
exit 0
EOF\r"
expect "*?#*?"
send "chmod +x /etc/init.d/filebrowser\r"
expect "*?#*?"
send "chown root:root /etc/init.d/filebrowser\r"
expect "*?#*?"
send "sudo update-rc.d filebrowser defaults\r"
expect "*?#*?"
send "sudo update-rc.d filebrowser enable\r"
expect "*?#*?"
send "service filebrowser start\r"
expect "*?#*?"
send "exit\r"
expect "*?$*?"
send "exit\r"
expect "*?:*?"
send "exit\r"
exit
