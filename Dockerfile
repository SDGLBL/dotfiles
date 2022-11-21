FROM ubuntu:latest

RUN mkdir -p /dotfiles && mkdir -p ${HOME}/.config

COPY . /dotfiles

WORKDIR /dotfiles


RUN set -x; buildDeps='gcc g++ unzip libc6-dev make wget curl git python3 python3-pip tmux zsh' \
  && apt-get update && apt-get install -y $buildDeps \
  && apt-get clean && rm -rf /var/lib/apt/lists/* \
  && echo "nameserver 8.8.8.8" > /etc/resolv.conf \
  && SET_ALL=true && ./setup.sh -a
