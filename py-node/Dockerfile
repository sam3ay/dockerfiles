FROM nikolaik/python-nodejs:python3.8-nodejs14
LABEL maintainer="Sam AY <sam3ay@gmail.com>"

ARG USERNAME=pynode
ARG USER_UID=1000
ARG USER_GID=$USER_UID
ENV XDG_CONFIG_HOME=/home/${USERNAME}/dotfiles/.config
ENV ZDOTDIR=${XDG_CONFIG_HOME}/zsh
ENV ZSH=${ZDOTDIR}/.oh-my-zsh

# Set to false to skip installing zsh and Oh My ZSH!
ARG INSTALL_ZSH="true"

ARG SCRIPT_SOURCE=https://raw.githubusercontent.com/sam3ay/dockerfiles/master/scripts/ms-vscode-debian.sh

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Configure apt and install packages
RUN apt-get update && apt-get -y install --no-install-recommends apt-utils dialog wget ca-certificates 2>&1 \
	# Verify git, common tools / libs installed, add/modify non-root user, optionally install zsh
	&& wget -q -O /tmp/zsh-code.sh $SCRIPT_SOURCE \
	&& /bin/bash /tmp/zsh-code.sh "$INSTALL_ZSH" "$USERNAME" "$USER_UID" "$USER_GID" \
	&& rm /tmp/zsh-code.sh \
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