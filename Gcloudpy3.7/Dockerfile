# Python 3.6.5
FROM continuumio/miniconda3:4.5.4 as conda

FROM google/cloud-sdk:latest

COPY --from=conda /opt/conda /opt/conda

ENV PATH=/opt/conda/bin:$PATH

RUN apt-get update -qq && \
    apt-get install -qq \
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

RUN pip install -qq --upgrade pip && \
    pip install -qq datalab flake8 neovim  

RUN cd ~ && git clone --quiet https://github.com/sam3ay/dotfiles.git && \
    git clone --depth=1 --quiet https://github.com/magicmonty/bash-git-prompt.git .bash-git-prompt && \
    git clone --quiet https://github.com/neovim/neovim.git && \
    cd ~/neovim/ && make -s > /dev/null && make install > /dev/null && rm -rf ~/neovim

RUN curl -sfLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && \
    echo " . $HOME/dotfiles/.custom_bashrc" >> ~/.bashrc && \
    echo "nvim +PlugInstall +qall > /dev/null" >> ~/.bashrc

ENTRYPOINT ["/bin/bash"]
