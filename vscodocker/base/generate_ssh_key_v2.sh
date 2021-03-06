#!/bin/bash
. ./utils.sh
# -----------------------------------------------
# [Data Science Group Ltd.]
# https://www.datascience.co.il/
#
#
SCRIPT=$(basename "$0")
usage="$SCRIPT [-h] [-s 0.0.0.0] [-u dsg]

where:
    -h  show this help message and exit
    -s  set ssh host value
    -u  set username (on remote)"
#------------------------------------------------

# constants
TIMEOUT=10
MAX_RETRY=2

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
    *) printf "invalid option: %s\n" "$OPTARG" >&2
       echo "$usage" >&2
       exit 1
       ;;
  esac
done
shift $((OPTIND - 1))

# Install autossh if needed
if ! dpkg -l | grep autossh > /dev/null
    then
    sudo apt-get install -y autossh
fi

# === ssh_host case 1: recieved host as [-s host_name]  ====
if [[ -n $ssh_host ]]
  then
  echo "using user input for host"

# === ssh_host case 2: hosts.txt exists (and size > 0) =====
elif [ -s $HOSTS_FILE_PATH ]
  then

  # read file lines as array
  mapfile -t hosts < $HOSTS_FILE_PATH
  create_hosts_menu "${hosts[@]}"
  ssh_host=$host

# === ssh_host case 3: manually prompt user for host ====
else
  echo "$HOSTS_FILE_PATH does not exist"
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
  ssh-copy-id -i -o ConnectTimeout=$TIMEOUT $target_host
} || { # catch
  tries=1
  while [ $tries -le $MAX_RETRY ]
  do
    read -p 'ssh-copy-failed, would you like to retry? [y] ' retry
    if [[ $retry = "y" ]]
      then
      prompt_for_user
      prompt_for_host
      target_host=$username@$ssh_host
      echo "copying key to $target_host"
      ssh-copy-id -i -o ConnectTimeout=$TIMEOUT $target_host
      ((tries++))
    else
      echo 'Exiting...'
      exit
    fi
  done
}
