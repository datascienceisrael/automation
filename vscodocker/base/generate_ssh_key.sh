#!/bin/bash

if [[ ! -f ~/.ssh/id_rsa ]]
    then
    ssh-keygen -f ~/.ssh/id_rsa
fi
echo "Use this public key:"
cat ~/.ssh/id_rsa.pub
