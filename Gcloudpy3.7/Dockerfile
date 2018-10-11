FROM continuumio/miniconda3 as conda


FROM google/cloud-sdk:latest

COPY --from=conda /opt/conda /opt/conda

ENV PATH=/opt/conda/bin:$PATH \
    XDG_CONFIG_HOME=~/dotfiles/.config
    

RUN apt-get update && \
    apt-get install -y neovim && \
    pip install --upgrade pip && \
    pip install neovim datalab flake8 && \ 
    cd ~ && git clone https://github.com/sam3ay/dotfiles.git && \
    curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && \
    echo "nvim +PlugInstall +qall > /dev/null" >> ~/.bashrc

CMD ["bash", "gcloud"]
