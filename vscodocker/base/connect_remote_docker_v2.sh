#!/bin/bash
# -----------------------------------------------
# [Data Science Group Ltd.]
# https://www.datascience.co.il/
#
#
SCRIPT=$(basename "$0")
usage="$SCRIPT [-h] [-s 0.0.0.0] [-u dsg]

where:
    -h  show this help text
    -s  set ssh host value
    -u  set username (on remote)"
#------------------------------------------------

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

# === ssh_host case 1: recieved host as [-s host_name]  ====
if [[ -n $ssh_host ]]
then
  echo "using user input for host"

# === ssh_host case 2: hosts.txt exists (and size > 0) =====
elif [ -s $input_file ]
then

  # read file lines as array
  input_file="conf/hosts.txt"
  mapfile -t hosts < $input_file
  create_hosts_menu "${hosts[@]}"
  ssh_host=$host

# === ssh_host case 3: manually prompt user for host ====
else
  echo "$input_file does not exist, please provide host name: "
  read ssh_host
  echo "$ssh_host selected"
fi

# Copy public key to remote server
echo 'Copy ssh public key to authorized keys folder on the remote server'

# username case 1: recieved user as [-u username] ====
if [[ -n $username ]]
then
  echo "using user input for username"
  target_host=$username@$ssh_host

# username case 2: manually prompt user for username ====
else
  read -p "Enter your remote username [$USER]: " username
  username=${username:-$USER}
  target_host=$username@$ssh_host
fi

echo "copying key to $target_host"
ssh-copy-id -i ~/.ssh/id_rsa.pub $target_host


# Create tunnel
echo 'Did you remeber to add read-write privilages on the docker sock?'
autossh -M 0 -o "ServerAliveInterval 30" -o "ServerAliveCountMax 3" -NL localhost:23750:/var/run/docker.sock $ssh_host &
