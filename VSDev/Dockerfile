# To fully customize the contents of this image, use the following Dockerfile instead:
# https://github.com/microsoft/vscode-dev-containers/tree/v0.108.0/containers/debian-10-git/.devcontainer/Dockerfile
FROM mcr.microsoft.com/vscode/devcontainers/base:debian-10
LABEL maintainer="Sam AY <sam3ay@gmail.com>"

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID
ENV XDG_CONFIG_HOME=/home/${USERNAME}/dotfiles/.config
ENV ZDOTDIR=${XDG_CONFIG_HOME}/zsh
ENV ZSH=${ZDOTDIR}/.oh-my-zsh

# Set to false to skip installing zsh and Oh My ZSH!
ARG INSTALL_ZSH="true"

ARG SCRIPT_SOURCE=https://raw.githubusercontent.com/sam3ay/dockerfiles/master/scripts/ms-vscode-debian.sh
# Docker Compose version
ARG COMPOSE_VERSION=1.24.0

# https://github.com/microsoft/vscode-dev-containers/blob/master/containers/docker-in-docker/.devcontainer/Dockerfile
RUN apt-get update && apt-get -y install --no-install-recommends \
	apt-utils \
	python3 \
	iproute2\
	procps \
	# Install Docker CE CLI
	apt-transport-https \
	ca-certificates \
	curl \
	gnupg-agent \
	software-properties-common\
	lsb-release \
	&& curl -fsSL https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]')/gpg | (OUT=$(apt-key add - 2>&1) || echo $OUT) \
	&& add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]') $(lsb_release -cs) stable" \
	&& apt-get update \
	&& apt-get install -y docker-ce-cli \
	#
	# Install Docker Compose
	&& curl -sSL "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
	&& chmod +x /usr/local/bin/docker-compose \
	&& wget -q -O /tmp/ms-vscode-debian.sh $SCRIPT_SOURCE \
	&& /bin/bash /tmp/ms-vscode-debian.sh "$INSTALL_ZSH" "$USERNAME" "$USER_UID" "$USER_GID" \
	&& rm /tmp/ms-vscode-debian.sh \
	# Clean up
	&& apt-get autoremove -y \
	&& apt-get clean -y \
	&& rm -rf /var/lib/apt/lists/*

USER $USERNAME

WORKDIR /home/$USERNAME

ENTRYPOINT ["/bin/zsh"]