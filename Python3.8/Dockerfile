FROM python:3.8-buster

RUN apt-get update && \
    apt-get install -y \
    autoconf \
    automake \
    build-essential \
    cmake \
    gettext \
    libtool \
    libtool-bin \
    neovim \
    ninja-build \
    pkg-config \
    python-neovim \
    python3-neovim \
    unzip \
    wget \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install -r requirements.txt

RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo

USER docker

ENV XDG_CONFIG_HOME=/home/docker/dotfiles/.config

WORKDIR /home/docker

# custom bashrc
RUN git clone --recurse-submodules https://github.com/sam3ay/dotfiles.git && \
    echo ". /home/docker/dotfiles/.custom_bashrc" >>~/.bashrc

ENTRYPOINT ["/bin/bash"]
