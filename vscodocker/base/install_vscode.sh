#!/bin/bash
# Install and configure Microsoft VS Code on Ubuntu

vscode_repo="https://packages.microsoft.com/repos/vscode"
vscode_apt="/etc/apt/sources.list.d/vscode.list"

if ! [[ -f $vscode_apt ]]
    then
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
    sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
    sudo sh -c "echo deb [arch=amd64] $vscode_repo stable main > $vscode_apt"
fi
if ! which code > /dev/null
    then
    sudo apt-get install apt-transport-https
    sudo apt-get update
    sudo apt-get install code
fi

# Install extensions
code --install-extension ms-python.python
code --install-extension PKief.material-icon-theme
code --install-extension ms-azuretools.vscode-docker
code --install-extension ms-vscode-remote.vscode-remote-extensionpack
code --install-extension eamodio.gitlens
code --install-extension Gruntfuggly.todo-tree
code --install-extension njpwerner.autodocstring
code --install-extension VisualStudioExptTeam.vscodeintellicode
code --install-extension johnpapa.vscode-peacock
code --install-extension ms-pyright.pyright
# If you want vim bindings:
# code --install-extension vscodevim.vim

# Copy User level settings file
cp ../vscodocker/base/vscode_settings.json ~/.vscode/settings.json
