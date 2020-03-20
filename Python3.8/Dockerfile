FROM python:3.8-buster
LABEL maintainer="Sam AY <sam3ay@gmail.com>"

ARG USERNAME=docker
ARG USER_UID=1001
ARG USER_GID=$USER_UID

RUN apt-get update && apt-get install -y \
    autoconf \
    automake \
    build-essential \
    cmake \
    gettext \
    git \
    libtool \
    libtool-bin \
    neovim \
    ninja-build \
    pkg-config \
    python-neovim \
    python3-neovim \
    sudo \
    unzip \
    wget \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install -r requirements.txt

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

USER $USERNAME

ENV XDG_CONFIG_HOME=/home/${USERNAME}/dotfiles/.config

WORKDIR /home/${USERNAME}

# custom bashrc
RUN git clone --recurse-submodules https://github.com/sam3ay/dotfiles.git && \
    echo ". /home/${USERNAME}/dotfiles/.custom_bashrc" >>~/.bashrc

ENTRYPOINT ["/bin/bash"]