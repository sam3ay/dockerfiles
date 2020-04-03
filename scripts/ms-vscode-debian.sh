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

# Get to latest versions of all packages
apt-get -y upgrade

# Install common dependencies
apt-get install -y \
    autoconf \
    apt-transport-https \
    automake \
    autoconf \
    bzip2 \
    build-essential \
    ca-certificates \
    cmake \
    curl \
    dpkg-dev \
    file \
    fzf \
    g++ \
    gcc \
    gettext \
    git \
    imagemagick \
    iproute2 \
    less \
    libbz2-dev \
    libc6-dev \
    libcurl4-openssl-dev \
    libdb-dev \
    libdb4o-cil-dev \
    libevent-dev \
    libffi-dev \
    libgcc1 \
    libgdbm-dev \
    libglib2.0-dev \
    libgmp-dev \
    libgssapi-krb5-2 \
    libicu[0-9][0-9] \
    libjpeg-dev \
    libkrb5-dev \
    liblzma-dev \
    libmagickcore-dev \
    libmagickwand-dev \
    libncurses5-dev \
    libpq-dev \
    libreadline-dev \
    liblttng-ust0 \
    libmaxminddb-dev \
    libncursesw5-dev \
    libpcap-dev \
    libpng-dev \
    libssl-dev \
    libsqlite3-dev \
    libstdc++6 \
    libreadline-dev \
    libssl-dev \
    libtool \
    lsb-release \
    libwebp-dev \
    libxml2-dev \
    libxslt-dev \
    libyaml-dev \
    make \
    neovim \
    ninja-build \
    openssh-client \
    pkg-config \
    patch \
    procps \
    python-neovim \
    python3-neovim \
    sudo \
    unzip \
    wget \
    xz-utils \
    zlib1g

# Install libssl1.1 if available
if [[ ! -z $(apt-cache --names-only search ^libssl1.1$) ]]; then
    apt-get -y install --no-install-recommends libssl1.1
fi

# Install appropriate version of libssl1.0.x if available
LIBSSL=$(dpkg-query -f '${db:Status-Abbrev}\t${binary:Package}\n' -W 'libssl1\.0\.?' 2>&1 || echo '')
if [ "$(echo "$LIBSSL" | grep -o 'libssl1\.0\.[0-9]:' | uniq | sort | wc -l)" -eq 0 ]; then
    if [[ ! -z $(apt-cache --names-only search ^libssl1.0.2$) ]]; then
        # Debian 9
        apt-get -y install --no-install-recommends libssl1.0.2
    elif [[ ! -z $(apt-cache --names-only search ^libssl1.0.0$) ]]; then
        # Ubuntu 18.04, 16.04, earlier
        apt-get -y install --no-install-recommends libssl1.0.0
    fi
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
chown -R $USER_UID:$USER_GID ${XDG_CONFIG_HOME}

if [ "$INSTALL_ZSH" = "true" ]; then
    apt-get install -y zsh
fi
