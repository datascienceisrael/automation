#!/bin/bash
# Install pip3 and docker-compose on Ubuntu

pypa_src="https://bootstrap.pypa.io/get-pip.py"

if ! which pip3 > /dev/null
    then
    if ! [[ -f get-pip.py ]]
        then
        wget $pypa_src
    fi
    sudo -H python3 get-pip.py
fi

if ! which docker-compose > /dev/null
    then
    sudo -H pip3 install docker-compose
fi
