#!/bin/bash -x

# Install autossh if needed
if ! dpkg -l | grep autossh > /dev/null
    then
    sudo apt-get install -y autossh
fi

# === case 1: if input file exists =====
input_file="conf/hosts.txt"
if [ -f $input_file ]
then

# read file lines as array
mapfile -t hosts < $input_file
n_hosts=${#hosts[@]}

# user notifications
title="Host Selection"
prompt="Pick an option:"
echo "$title"
PS3="$prompt "

# user selection
select opt in "${hosts[@]}" "Quit"; do
    msg="Setting up $opt connection"
    case "$REPLY" in

# Technical Debt: growable dropdown menu according to input
    1 ) echo "$msg";;
    2 ) echo "$msg";;
    3 ) echo "$msg";;

    $(( ${n_hosts}+1 )) ) echo "Goodbye!"; exit;;
    *) echo "Invalid option. Try another one.";continue;;

    esac
break
done
ssh_host=$opt

# === case 2: no input file was provided ====
 else
  echo "$input_file does not exist, please provide host name: "
  read ssh_host
  echo "$ssh_host selected"
fi

# Copy public key to remote server
echo 'Copy ssh public key to authorized keys folder on the remote server'
ssh-copy-id -i ~/.ssh/id_rsa.pub $ssh_host

# Create tunnel
echo 'Did you remeber to add read-write privilages on the docker sock?'
autossh -M 0 -o "ServerAliveInterval 30" -o "ServerAliveCountMax 3" -NL localhost:23750:/var/run/docker.sock $ssh_host &

