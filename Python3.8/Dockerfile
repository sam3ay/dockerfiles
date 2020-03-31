FROM python:3.8-buster
LABEL maintainer="Sam AY <sam3ay@gmail.com>"

ENV DEBIAN_FRONTEND=noninteractive

# This Dockerfile adds a non-root user with sudo access. Use the "remoteUser"
# property in devcontainer.json to use it. On Linux, the container user's GID/UIDs
# will be updated to match your local UID/GID (when using the dockerFile property).
# See https://aka.ms/vscode-remote/containers/non-root-user for details.
ARG USERNAME=python
ARG USER_UID=1000
ARG USER_GID=$USER_UID
ENV XDG_CONFIG_HOME=/home/${USERNAME}/dotfiles/.config
ENV ZDOTDIR=${XDG_CONFIG_HOME}/zsh
ENV ZSH=${ZDOTDIR}/.oh-my-zsh

# Set to false to skip installing zsh and Oh My ZSH!
ARG INSTALL_ZSH="true"

# Location for common setup script
ARG SCRIPT_SOURCE=https://raw.githubusercontent.com/sam3ay/dockerfiles/master/scripts/ms-vscode-debian.sh

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Configure apt and install packages
RUN apt-get update && apt-get -y install --no-install-recommends apt-utils dialog wget ca-certificates 2>&1 \
    # Verify git, common tools / libs installed, add/modify non-root user, optionally install zsh
    && wget -q -O /tmp/ms-vscode-debian.sh $SCRIPT_SOURCE \
    && /bin/bash /tmp/ms-vscode-debian.sh "$INSTALL_ZSH" "$USERNAME" "$USER_UID" "$USER_GID" \
    && rm /tmp/ms-vscode-debian.sh \
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Switch back to dialog for any ad-hoc use of apt-get
COPY requirements.txt .
RUN pip install -r requirements.txt

ENV DEBIAN_FRONTEND=dialog

USER ${USERNAME}

ENTRYPOINT ["/bin/zsh"]