FROM ubuntu:latest

RUN mkdir -p /dotfiles && mkdir -p ${HOME}/.config

COPY . /dotfiles

WORKDIR /dotfiles

RUN set -x; buildDeps='gcc libc6-dev make wget curl git python3 tmux zsh' \
  && apt-get update && apt-get install -y $buildDeps \
  && apt-get clean && rm -rf /var/lib/apt/lists/* \
  && SET_ALL=true && ./setup.sh -a
