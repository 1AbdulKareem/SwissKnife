#!/bin/bash

# Set a timeout for commands if necessary
TIMEOUT=60

# Switch to root user (assumes you have sudo privileges)
sudo su

# Install curl if not already installed
apt-get install curl -y

# Install filebrowser via curl
curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash

# Remove the existing filebrowser.db if it exists
rm /root/filebrowser.db

# Start filebrowser with specified options
filebrowser -d /root/filebrowser.db -a 0.0.0.0 -p 9000 -r / --username abdulkarim@valutoria.com --password \$2a\$12\$LhP39uAEK1yrN2D7zc.liOh/MKtTMF3Y0XqK57u3qudxBp/rqpZtu &

# Create an init script for filebrowser
cat > /etc/init.d/filebrowser <<'SCRIPT'
#!/bin/bash
# Change the following line to match your filebrowser binary path
FILEBROWSER_BIN="/usr/local/bin/filebrowser"
# Change the following line to match your filebrowser.db path
FILEBROWSER_DB="/root/filebrowser.db"

case "\$1" in
start)
    echo "Starting filebrowser"
    nohup \$FILEBROWSER_BIN -d \$FILEBROWSER_DB >/dev/null 2>&1 &
    ;;
stop)
    echo "Stopping filebrowser"
    pkill -f "\$FILEBROWSER_BIN"
    ;;
restart)
    echo "Restarting filebrowser"
    pkill -f "\$FILEBROWSER_BIN"
    sleep 1
    nohup \$FILEBROWSER_BIN -d \$FILEBROWSER_DB >/dev/null 2>&1 &
    ;;
*)
    echo "Usage: \$0 {start|stop|restart}"
    exit 1
    ;;
esac
exit 0
SCRIPT

# Make the init script executable and owned by root
chmod +x /etc/init.d/filebrowser
chown root:root /etc/init.d/filebrowser

# Enable the service at boot
sudo update-rc.d filebrowser defaults
sudo update-rc.d filebrowser enable

# Start the filebrowser service
service filebrowser start
