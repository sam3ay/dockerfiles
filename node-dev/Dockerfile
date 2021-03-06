# notes from https://github.com/nodejs/docker-node/blob/master/docs/BestPractices.md#global-npm-dependencies
FROM node:buster
LABEL maintainer="Sam AY <sam3ay@gmail.com>"

ENV DEBIAN_FRONTEND=noninteractive

ARG USERNAME=node
ARG USER_UID=1000
ARG USER_GID=$USER_UID
ENV XDG_CONFIG_HOME=/home/${USERNAME}/dotfiles/.config
# zsh env variables
ENV ZDOTDIR=${XDG_CONFIG_HOME}/zsh
ENV ZSH=${ZDOTDIR}/.oh-my-zsh

# Set to false to skip installing zsh
ARG INSTALL_ZSH="true"

ENV NPM_CONFIG_PREFIX=${HOME}/.npm-global
ENV PATH=$PATH:${NPM_CONFIG_PREFIX}/bin

ARG SCRIPT_SOURCE=https://raw.githubusercontent.com/sam3ay/dockerfiles/master/scripts/zsh-code.sh

RUN apt-get update && apt-get -y install --no-install-recommends apt-utils dialog wget ca-certificates 2>&1 \
	# Verify git, common tools / libs installed, add/modify non-root user, optionally install zsh
	&& wget -q -O /tmp/zsh-code.sh $SCRIPT_SOURCE \
	&& /bin/bash /tmp/zsh-code.sh "$INSTALL_ZSH" "$USERNAME" "$USER_UID" "$USER_GID" \
	&& rm /tmp/zsh-code.sh \
	# Clean up
	&& apt-get autoremove -y \
	&& apt-get clean -y \
	&& rm -rf /var/lib/apt/lists/*

USER ${USERNAME}

WORKDIR /home/${USERNAME}

ENTRYPOINT ["/bin/zsh"]