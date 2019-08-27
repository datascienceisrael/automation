#!/bin/bash

# constants
TIMEOUT=2
MAX_RETRY=3
HOSTS_FILE="conf/hosts.txt"

while getopts 'h?s:u:' option; do
  case "$option" in
    h|\?) echo "$usage"
       exit
       ;;
    s) ssh_host=${OPTARG}
       ;;
    u) username=${OPTARG}
       ;;
    :) printf "missing argument for %s\n" "$OPTARG" >&2
       echo "$usage" >&2
       exit 1
       ;;
    *) printf "illegal option: %s\n" "$OPTARG" >&2
       echo "$usage" >&2
       exit 1
       ;;
  esac
done
shift $((OPTIND - 1))

# auxilliary function to create dropdown menu according to file
create_hosts_menu ()
{
  # user notifications
  title="=== Host Selection ==="
  prompt="Pick an option:"
  echo "$title"
  PS3="$prompt "

  select host in "$@" "Quit"; do
    msg="Setting up $host connection"
    if [ "$REPLY" -eq "$(($#+1))" ];
    then
      echo "Exiting..."
      exit;
    elif [ 1 -le "$REPLY" ] && [ "$REPLY" -le $(($#)) ];
    then
      echo "$msg"
      break;
    else
      echo "Incorrect Input: Select a number 1-$(($#+1))"
    fi
  done
}

# Install autossh if needed
if ! dpkg -l | grep autossh > /dev/null
    then
    sudo apt-get install -y autossh
fi

# get username from user
prompt_for_user ()
{
  read -p "Enter your remote username [$USER]: " username
  username=${username:-$USER}
}

# get hostname from user
prompt_for_host ()
{
  echo "please provide host name: "
  read -p ssh_host
}

# === ssh_host case 1: recieved host as [-s host_name]  ====
if [[ -n $ssh_host ]]
  then
  echo "using user input for host"

# === ssh_host case 2: hosts.txt exists (and size > 0) =====
elif [ -s $HOSTS_FILE ]
  then

  # read file lines as array
  mapfile -t hosts < $HOSTS_FILE
  create_hosts_menu "${hosts[@]}"
  ssh_host=$host

# === ssh_host case 3: manually prompt user for host ====
else
  echo "$HOSTS_FILE does not exist"
  prompt_for_host
fi

# === username case 1: recieved user as [-u username] ====
if [[ -n $username ]]
then
  echo "using user input for username"

# === username case 2: manually prompt user for username ====
else
  prompt_for_user
fi

# user@hostname variable
target_host=$username@$ssh_host

# generate the ssh_key if necessary
if [[ ! -f ~/.ssh/id_rsa ]]
  then
  ssh-keygen -f ~/.ssh/id_rsa
fi

{ # try
  echo "copying key to $target_host"
  ssh-copy-id -i ~/.ssh/id_rsa.pub $target_host
} || { # catch
  try=1
  while [ $try -le $MAX_RETRY ]
  do
    read -p 'ssh-copy-failed, would you like to retry? [Y] ' retry
    if [[ $retry = "Y" ]]
      then
      prompt_for_user
      prompt_for_host
      target_host=$username@$ssh_host
      echo "copying key to $target_host"
      ssh-copy-id -i ~/.ssh/id_rsa.pub $target_host
      ((try++))
    else
      echo 'Exiting...'
      exit
    fi
  done
}