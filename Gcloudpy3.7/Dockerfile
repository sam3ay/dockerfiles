FROM continuumio/miniconda3 as conda


FROM google/cloud-sdk:latest
ENV PATH /opt/conda/bin:$PATH


COPY --from=conda /opt/conda /opt/conda

RUN apt-get update && \
    apt-get install -y neovim

RUN pip install --upgrade pip && \
    pip install neovim datalab

RUN cd ~ && git clone https://github.com/sam3ay/dotfiles.git
