#!/bin/bash -i

while getopts ":v:u:" opt; do
  case $opt in
    v)
      OE_VERSION="$OPTARG"
      ;;
    u)
      USERNAME="$OPTARG"
      ;;
    \?)
      echo "Invalid option: -$OPTARG"
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument."
      exit 1
      ;;
  esac
done

# validation error: when creating a user already exists 
if id -u "odoo-$USERNAME" > /dev/null; then
  echo "Error: User odoo-$USERNAME already exists."
  exit 1
fi
# specify python venv and version to instantiate 
DIR=/odoo
case $OE_VERSION in
  17.0)
    if [ ! -d "/odoo/17.0" ]; then
      echo "Error: /odoo/17.0 directory does not exist. Exiting."
      exit 1
    fi
    if [ ! -d "/odoo/17.0-venv" ]; then
      echo "Error: /odoo/17.0-venv directory does not exist. Exiting."
      exit 1
    fi
    OE_PATH=$DIR/$OE_VERSION
    VENV=$DIR/$OE_VERSION-venv
    ;;
  15.0)
    if [ ! -d "/odoo/15.0" ]; then
      echo "Error: /odoo/15.0 directory does not exist. Exiting."
      exit 1
    fi
    if [ ! -d "/odoo/17.0-venv" ]; then
      echo "Error: /odoo/17.0-venv directory does not exist. Exiting."
      exit 1
    fi
    OE_PATH=$DIR/$OE_VERSION
    VENV=$DIR/$OE_VERSION-venv
    ;;
  *)
    exit 1 ;
    ;;
esac
# Check if the user was created successfully
if [ $? -ne 0 ]; then
  echo "Error: Unable to create user $USERNAME."
  exit 1
fi

# add the user 
sudo adduser --system --quiet --shell=/bin/bash --home=/home/odoo-$USERNAME --gecos "$USERNAME,,$USERNAME,,$USERNAME" odoo-$USERNAME 
# add the database user
echo -e "\n---- Creating the ODOO PostgreSQL User  ----"
sudo su - postgres -c "createuser -s odoo-$USERNAME" 2> /dev/null || true
# create the log file
sudo mkdir /var/log/odoo/$USERNAME
sudo chown odoo-$USERNAME:odoo /var/log/odoo/$USERNAME
# instantiate 
sudo cp $VENV /home/odoo-$USERNAME/$OE_VERSION-venv -R 
sudo chown odoo-$USERNAME:odoo /home/odoo-$USERNAME -R 
sudo cat > /etc/systemd/system/odoo-$OE_VERSION-$USERNAME.service <<EOF 
[Unit]
Description=odoo-$OE_VERSION-$USERNAME
Requires=postgresql.service
After=network.target postgresql.service
[Service]
Type=simple
SyslogIdentifier=odoo-$OE_VERSION-$USERNAME
PermissionsStartOnly=true
User=odoo-$USERNAME
Group=odoo
ExecStart=/home/odoo-$USERNAME/$OE_VERSION-venv/bin/python /odoo/$OE_VERSION/odoo-bin
StandardOutput=journal+console
[Install]
WantedBy=multi-user.target
EOF
sudo cat > /odoo/conf.d/$OE_VERSION/$USERNAME.conf <<EOF 
[odoo]
EOF
sudo cat > /etc/ngninx/sites-available/$OE_VERSION-$USERNAME.conf <<EOF 
[odoo]
EOF
sudo chmod +x /etc/systemd/system/odoo-$OE_VERSION-$USERNAME.service
sudo chown 
sudo chmod 
sudo systemctl daemon-reload
sudo systemctl enable odoo-$OE_VERSION-$USERNAME.service
sudo service odoo-$OE_VERSION-$USERNAME start