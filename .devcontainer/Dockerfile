# To fully customize the contents of this image, use the following Dockerfile instead:
# https://github.com/microsoft/vscode-dev-containers/tree/v0.108.0/containers/debian-10-git/.devcontainer/Dockerfile
FROM sam3ay/vsdev:latest
LABEL maintainer="Sam AY <sam3ay@gmail.com>"

# ** [Optional] Uncomment this section to install additional packages. **
#
# ENV DEBIAN_FRONTEND=noninteractive
# RUN apt-get update \
#    && apt-get -y install --no-install-recommends <your-package-list-here> \
#    #
#    # Clean up
#    && apt-get autoremove -y \
#    && apt-get clean -y \
#    && rm -rf /var/lib/apt/lists/*
# ENV DEBIAN_FRONTEND=dialog
ARG USERNAME=docker

RUN mkdir -p /home/$USERNAME/.vscode-server/extensions \
	/home/$USERNAME/.vscode-server-insiders/extensions \
	&& chown -R $USERNAME \
	/home/$USERNAME/.vscode-server \
	/home/$USERNAME/.vscode-server-insiders
