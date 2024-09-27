#!/bin/bash

while getopts ":v:" opt; do
  case $opt in
    v)
      OE_VERSION="$OPTARG"
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

case $OE_VERSION in
  17.0)
    PYTHON_VERSION=3.11.0
    ;;
  15.0)
    PYTHON_VERSION=3.9.0
    ;;
  *)
    exit 1 ;
    ;;
esac

echo ---------------------------------   3- setting envoirment     ---------------------------------
/usr/local/pyenv/bin/pyenv install $PYTHON_VERSION /usr/local/pyenv/versions/
mkdir /odoo/$OE_VERSION-venv/
mkdir /odoo/$OE_VERSION-3rdParty
virtualenv -p /usr/local/pyenv/versions/${PYTHON_VERSION}/bin/python /odoo/$OE_VERSION-venv/
source /odoo/$OE_VERSION-venv/bin/activate
echo ---------------------------------   2- cloning source         ---------------------------------
git clone --depth 1 --branch $OE_VERSION https://www.github.com/odoo/odoo /odoo/$OE_VERSION
echo ---------------------------------   3- installing reqs        ---------------------------------
source /odoo/$OE_VERSION-venv/bin/activate
pip install wheel setuptools pip --upgrade
pip install -r /odoo/${OE_VERSION}/requirements.txt
deactivate
chmod 755 /odoo -R 
exit

# todo chmod u+rwx,g+r
# allow user to write and read 
# alow group to read only 