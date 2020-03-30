# To fully customize the contents of this image, use the following Dockerfile instead:
# https://github.com/microsoft/vscode-dev-containers/tree/v0.108.0/containers/debian-10-git/.devcontainer/Dockerfile
FROM mcr.microsoft.com/vscode/devcontainers/base:debian-9
LABEL maintainer="Sam AY <sam3ay@gmail.com>"

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID
# Docker Compose version
ARG COMPOSE_VERSION=1.24.0

# Configure apt and install packages
# https://github.com/microsoft/vscode-dev-containers/blob/master/containers/docker-in-docker/.devcontainer/Dockerfile
RUN apt-get update \
	&& apt-get -y install --no-install-recommends apt-utils dialog 2>&1 \
	#
	# Verify git, process tools installed
	&& apt-get -y install git openssh-client less iproute2 procps \
	#
	# Install Docker CE CLI
	&& apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common lsb-release \
	&& curl -fsSL https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]')/gpg | (OUT=$(apt-key add - 2>&1) || echo $OUT) \
	&& add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]') $(lsb_release -cs) stable" \
	&& apt-get update \
	&& apt-get install -y docker-ce-cli \
	#
	# Install Docker Compose
	&& curl -sSL "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
	&& chmod +x /usr/local/bin/docker-compose \
	#
	# Create a non-root user to use if preferred - see https://aka.ms/vscode-remote/containers/non-root-user.
	# && groupadd --gid $USER_GID $USERNAME \
	# && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
	# [Optional] Add sudo support for the non-root user
	&& apt-get install -y sudo \
	&& echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME\
	&& chmod 0440 /etc/sudoers.d/$USERNAME \
	#
	# Clean up
	&& apt-get autoremove -y \
	&& apt-get clean -y \
	&& rm -rf /var/lib/apt/lists/*

USER $USERNAME

ENV XDG_CONFIG_HOME=/home/${USERNAME}/dotfiles/.config

WORKDIR /home/$USERNAME

# custom bashrc
RUN git clone --recurse-submodules https://github.com/sam3ay/dotfiles.git && \
	echo ". /home/${USERNAME}/dotfiles/.custom_bashrc" >>~/.bashrc