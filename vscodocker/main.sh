#!/bin/bash
echo "Installing VSCode"
./install_vscode.sh
echo "Installing docker and docker-compose"
./install_docker.sh
./install_docker_compose.sh
echo "SSH key setup"
./generate_ssh_key.sh
