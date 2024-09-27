#!/bin/bash -i



echo ================================= CREATING ODOO USER AND GROUP =================================
sudo adduser --system --quiet --shell=/bin/bash --home=/odoo --gecos 'ODOO' --group odoo 
sudo adduser odoo sudo
sudo mkdir /var/log/odoo
sudo mkdir /odoo/conf.d/
sudo chown odoo:odoo /var/log/odoo

echo =================================   INSTALLING DEPENDENCIES   =================================
echo ---------------------------------   1- python shit            --------------------------------- 
sudo apt-get update -y 
sudo apt install build-essential zlib1g-dev \
libncurses5-dev libgdbm-dev libnss3-dev \
libssl-dev libreadline-dev libffi-dev curl \
make libbz2-dev libsqlite3-dev wget llvm \
libncursesw5-dev xz-utils tk-dev liblzma-dev \
python3-openssl git -y
sudo apt-get install python3 python3-pip \
git python3-cffi build-essential wget \
python3-dev python3-virtualenv python3-venv \
python3-wheel libxslt-dev libzip-dev \
libldap2-dev libsasl2-dev python3-setuptools \
node-less libpng-dev libjpeg-dev gdebi -y
sudo pip3 install virtualenv --break-system-packages
sudo git clone https://github.com/pyenv/pyenv.git /usr/local/pyenv
cd /usr/local/pyenv
echo 'export PYENV_ROOT="/usr/local/pyenv"' | sudo tee -a /etc/profile.d/pyenv.sh
echo 'export PATH="$PATH:$PYENV_ROOT/bin"' | sudo tee -a /etc/profile.d/pyenv.sh
echo 'eval "$(pyenv init --path)"' | sudo tee -a /etc/profile.d/pyenv.sh
#echo 'eval "$(pyenv virtualenv-init -)"' | sudo tee -a /etc/profile.d/pyenv.sh
sudo chown -R root:users /usr/local/pyenv
sudo chmod -R g+w /usr/local/pyenv
sudo chmod -R g+w,o+w /usr/local/pyenv
sudo chmod -R ug+rwx,o-rwx /usr/local/pyenv
echo ---------------------------------   2- nodejs                 ---------------------------------
sudo apt-get install nodejs npm -y
sudo npm install -g rtlcss
echo ---------------------------------   3- wkhtmltopdf            ---------------------------------
sudo apt-get install libjpeg-turbo8 libjpeg-turbo8 libxrender1 xfonts-75dpi xfonts-base -y
sudo apt-get install fontconfig -y 
sudo apt-get install -f -y
sudo apt-get install git -y 
udo apt-get install -y libxrender1 libfontconfig1 libx11-dev libjpeg62 libxtst6 \
                           fontconfig xfonts-75dpi xfonts-base libpng12-0
sudo apt-get install wkhtmltopdf -y 
wget http://mirrors.edge.kernel.org/ubuntu/pool/universe/w/wkhtmltopdf/wkhtmltopdf_0.12.5-1ubuntu0.1_amd64.deb
sudo dpkg -i wkhtmltopdf_0.12.5*.deb
sudo cp /usr/local/bin/wkhtmltopdf /usr/bin/
sudo cp /usr/local/bin/wkhtmltoimage /usr/bin
sudo ln -s /usr/local/bin/wkhtmltopdf /usr/bin
sudo ln -s /usr/local/bin/wkhtmltoimage /usr/bin
echo ---------------------------------   4- postgresql             ---------------------------------
sudo /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh 
sudo apt install postgresql libpq-dev -y
echo ---------------------------------   5- nginx web server       ---------------------------------
sudo apt-get install nginx-extras python3-certbot-nginx  -y
echo ---------------------------------   6- systemd container      ---------------------------------
sudo apt-get install nginx-extras python3-certbot-nginx  -y
exec "$SHELL"
chmod 755 /odoo -R 
exit
