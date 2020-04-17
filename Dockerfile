FROM ubuntu:18.04
LABEL maintainer "RockinWool"

# 0-0.初期設定
USER root
ENV DEVIAN_FRONTEND noninteractive
ENV DEBCONF_NOWARNINGS yes
# 0-1.ユーザーの追加とディレクトリ設定
ENV USER RockinWool
RUN useradd -m ${USER}
ENV HOME /home/${USER}
ENV HUGODIR ${HOME}/hugowork
ENV SHELL /bin/bash

# 0-2.HUGOのバージョン設定
ENV HUGO_VERSION 0.69.0
ENV HUGO_BINARY hugo_${HUGO_VERSION}_Linux-64bit.deb
ENV HUGO_BASE_URL http://localhost:1313

# 1-1. 必要なパッケージを取ってきます
RUN apt-get -qq update \
    && DEBIAN_FRONTEND=noninteractive apt-get -qq install -y --no-install-recommends \
    python-pygments \
    git \
    ca-certificates \
    asciidoc \
    gedit \
    tig \
    wget \
    && rm -rf /var/lib/apt/lists/*
# 1-2. HUGOをインストールします
ADD https://github.com/spf13/hugo/releases/download/v${HUGO_VERSION}/${HUGO_BINARY} /tmp/hugo.deb
RUN dpkg -i /tmp/hugo.deb
RUN rm /tmp/hugo.deb

# 2-1. 作業ディレクトリを作成します
WORKDIR $HOME
RUN mkdir ${HOME}/RFV


#setting anaconda3
ENV PATH /opt/conda/bin:$PATH
RUN wget --quiet https://repo.anaconda.com/archive/Anaconda3-2020.02-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh && \
    echo "export PATH=/opt/conda/bin:$PATH" >> ~/.bashrc

ENTRYPOINT ["jupyter-lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--NotebookApp.token=''"]

#追加でファイルを持ってきます
COPY ./initial.sh ${HOME}/
#ユーザーを設定します
#USER RockinWool
