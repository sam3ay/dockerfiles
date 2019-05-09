FROM continuumio/miniconda3 as conda

FROM google/cloud-sdk:latest

COPY --from=conda /opt/conda /opt/conda

ENV PATH=/opt/conda/bin:$PATH

RUN apt-get update && \
    apt-get install -y \
      ninja-build \
      gettext \
      libtool \
      libtool-bin \
      autoconf \
      automake \
      cmake \
      gcc \
      make \
      g++ \
      pkg-config \
      unzip

RUN pip3 install --upgrade pip && \
    pip3 install datalab flake8 neovim  

# setting up personalized environment
RUN cd ~ && git clone https://github.com/sam3ay/dotfiles.git && \
    git clone https://github.com/magicmonty/bash-git-prompt.git .bash-git-prompt --depth=1 && \
    git clone https://github.com/neovim/neovim.git && \
    cd ~/neovim/ && make && make install && rm -r ~/neovim

# conda symlinks and initializing settings
RUN curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc && \
    echo " . $HOME/dotfiles/.custom_bashrc" >> ~/.bashrc && \
    echo "nvim +PlugInstall +qall > /dev/null" >> ~/.bashrc

ENTRYPOINT ["/bin/bash"]
