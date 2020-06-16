#!/usr/bin/env bash
#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------

# Syntax: ./common-debian.sh <install zsh flag> <username> <user UID> <user GID>

INSTALL_ZSH=$1
USERNAME=$2
USER_UID=$3
USER_GID=$4

set -e

if [ "$(id -u)" -ne 0 ]; then
    echo 'Script must be run a root. Use sudo or set "USER root" before running the script.'
    exit 1
fi


# Create or update a non-root user to match UID/GID - see https://aka.ms/vscode-remote/containers/non-root-user.
if [ "$USER_UID" = "" ]; then
    USER_UID=1000
fi

if [ "$USER_GID" = "" ]; then
    USER_GID=1000
fi

if [ "$USERNAME" = "" ]; then
    USERNAME=$(awk -v val=1000 -F ":" '$3==val{print $1}' /etc/passwd)
fi

if id -u $USERNAME >/dev/null 2>&1; then
    # User exists, update if needed
    if [ "$USER_GID" != "$(id -G $USERNAME)" ]; then
        groupmod --gid $USER_GID $USERNAME
        usermod --gid $USER_GID $USERNAME
    fi
    if [ "$USER_UID" != "$(id -u $USERNAME)" ]; then
        usermod --uid $USER_UID $USERNAME
    fi
else
    # Create user
    groupadd --gid $USER_GID $USERNAME
    useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME
fi

# Add add sudo support for non-root user
apt-get install -y sudo
echo $USERNAME ALL=\(root\) NOPASSWD:ALL >/etc/sudoers.d/$USERNAME
chmod 0440 /etc/sudoers.d/$USERNAME
# dotfiles zsh
git clone --recurse-submodules --single-branch --branch zsh https://github.com/sam3ay/dotfiles.git /home/${USERNAME}/dotfiles
echo ". ${XDG_CONFIG_HOME}/.custom_bashrc" >>~/.bashrc
chown -R $USER_UID:$USER_GID home/$USERNAME

if [ "$INSTALL_ZSH" = "true" ]; then
    apt-get install -y zsh
fi
