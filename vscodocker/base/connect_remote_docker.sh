#!/bin/bash

ssh_host=$1

# Install autossh if needed
if ! dpkg -l | grep autossh > /dev/null
    then
    sudo apt-get install -y autossh
fi

# Copy public key to remote server
echo 'Copy ssh public key to authorized keys folder on the remote server'
ssh-copy-id -i $ssh_host

# Create tunnel
echo 'Did you remeber to add read-write privilages on the docker sock?'
autossh -M 0 -o "ServerAliveInterval 30" -o "ServerAliveCountMax 3" -NL localhost:23750:/var/run/docker.sock $ssh_host &
