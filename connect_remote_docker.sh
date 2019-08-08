#!/bin/bash

ssh_host=$1

# Create tunnel
ssh -NL localhost:23750:/var/run/docker.sock $ssh_host &
