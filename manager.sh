#!/bin/bash

# Help page function
help(){
  echo "Usage: -c <command> [arguments]"
  echo "Commands:"
  echo "  env-setup - Setup the environment for Odoo"
  echo "  install-version <arg1> - Install specific Odoo version"
  echo "  instantiate <arg1> <arg2> - Instantiate Odoo with specific user and version"
  echo "  db - Manage databases for Odoo"

  echo "Subcommand Help Options:"
  echo " -c <command>"
}


# Function for the 'env-setup' subcommand
env_setup_func() {
  echo "Usage: -c env-setup -h <host> -u <user> -p <password>"

  while getopts "h:u:p" opt ; do
    case $opt in
      h)
        $REMOTE_HOST = $OPTARG
        ;;
      u)
        $REMOTE_USER = $OPTARG
        ;;
      p)
        $REMOTE_PASS = $OPTARG
        ;;
      \?)
        echo "Invalid option: -$OPTARG" >&2
        ;;
    esac
  done

  ssh $REMOTE_USER@$REMOTE_HOST 'bash -s' < local_script.sh
  expect -c "$expect_script"


}

# Function for the 'install-version' subcommand
install_version_func() {
    echo "Handling install-version subcommand"
    # Add install-version subcommand logic here
}

# Function for the 'instantiate' subcommand
instantiate_func() {
    echo "Handling instantiate subcommand"
    # Add instantiate subcommand logic here
}

# Function for the 'db' subcommand
db_func() {
    echo "Handling db subcommand"
    # Add db subcommand logic here
}

# Function for the 'backup' subcommand
backup_func() {
    echo "Handling backup subcommand"
    # Add backup subcommand logic here
}



# Main script logic
while getopts ":hc:" opt; do
  case $opt in
    h)
      help
      exit
      ;;
    c)
      elif [[ $OPTARG == "env-setup" ]]; then
        env-setup 
      elif [[ $OPTARG == "install-version" ]]; then
        install-version 
      elif [[ $OPTARG == "instantiate" ]]; then
        instantiate 
      elif [[ $OPTARG == "db" ]]; then
        db 
      else
        echo "Invalid command"
        help
      fi
      ;;
    :)
      echo "Option -$OPTARG requires an argument." > &2
      exit 1
      ;;
    \?)
      echo "Invalid option: -$OPTARG" > &2
      exit 1
      ;;
  esac
done


### ideas to apply 
#1 shopify connector
 # products 
  # syncronous stock
 # orders 
 # customers 
#2 woocommerce connector
 # products 
  # syncronous stock
 # orders 
 # customers 
#3 module manager 
#4 discounts idea 
#5 reset password 
#6 nice filemanager
#7 nginx configurations 
  # cache 
  # brotli 
#8 dns 
#9 domain name providers quick settings 
#10 community 
#11 FAQ 
#12 Tutorials 
#13 Cache 
#14 Pay by Analytics 
#15 implementer pack