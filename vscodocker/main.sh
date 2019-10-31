#!/bin/bash
echo "Installing VSCode"
./base/install_vscode.sh
echo "Installing docker and docker-compose"
./base/install_docker.sh
./base/install_docker_compose.sh
