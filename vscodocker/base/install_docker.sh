#!/bin/bash
# Install and configure Docker-ce on Ubuntu

docker_apt="/etc/apt/sources.list.d/docker.list"

# install curl (latest) if necessary
if ! (($(curl -V) == 0))
    then
    sudo apt-get install -y curl
fi

if ! [[ -f $docker_apt ]]
    then
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo sh -c "echo deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable> $docker_apt"
fi

if ! dpkg -l | grep docker-ce > /dev/null
    then
    sudo apt-get update
    sudo apt-get install -y apt-transport-https
    sudo apt-get install -y software-properties-common
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io
fi

# Give the current user rw permissions on docker socket
sudo setfacl -m user:$USER:rw /var/run/docker.sock
