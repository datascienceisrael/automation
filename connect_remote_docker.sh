#!/bin/bash

ssh_host=$1

# Install autossh if needed
if ! dpkg -l | grep autossh > /dev/null
    then
    sudo apt-get install -y autossh
fi

# Create tunnel
autossh -M 0 -o "ServerAliveInterval 30" -o "ServerAliveCountMax 3" -NL localhost:23750:/var/run/docker.sock $ssh_host &
