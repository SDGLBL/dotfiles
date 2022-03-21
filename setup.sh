#!/bin/bash

SHELL_FOLDER=$(cd "$(dirname "$0")";pwd)
CONFIG_FOLDER=$SHELL_FOLDER/.config
LUNARVIM_CONFIG_FOLDER="$HOME/.config/lvim"

# command_is_exists test command is exists
function command_is_exists() {
  if command -v $1 >/dev/null 2>&1; then
    true
  else
    false
  fi
}

# file_is_exists test file is exists
function file_is_exists() {
  if [ -f $1 ]; then
    true
  else
    false
  fi
}

# file_contain_string test file contain string
function file_contain_string() {
  if grep -q "$1" $2; then
    true
  else
    false
  fi
}

function msg() {
  local text="$1"
  local div_width="80"
  printf "%${div_width}s\n" ' ' | tr ' ' -
  printf "%s\n" "$text"
}

# add proxy for Mainland China users
msg "Add proxy for Mainland China users?"
read -p "[y]es or [n]o (default: no) : " -r answer
[ "$answer" != "${answer#[Yy]}" ] && printf 'mirror.ghproxy.com github.com\nmirror.ghproxy.com raw.githubusercontent.com\n' | sudo tee -a /etc/hosts

# if use lunarvim
if command_is_exists lvim; then
  if file_is_exists $LUNARVIM_CONFIG_FOLDER/config.lua; then
    mv $LUNARVIM_CONFIG_FOLDER/config.lua $LUNARVIM_CONFIG_FOLDER/config.lua.backup
  fi
  ln -s $CONFIG_FOLDER/lvim/config.lua ~/.config/lvim/config.lua
else
  msg "LunarVim is not installed. Would you like to install LunarVim dependencies?"
  read -p "[y]es or [n]o (default: no) : " -r answer
  [ "$answer" != "${answer#[Yy]}" ] && bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh)
fi

# if use tmux
if command_is_exists tmux; then
  if file_is_exists $HOME/.tmux.conf; then
    mv $HOME/.tmux.conf $HOME/.tmux.conf.backup
  fi
  ln -s $SHELL_FOLDER/.tmux.conf $HOME/.tmux.conf
fi

# active my alias and bash env setting
if file_is_exists $HOME/.bashrc; then
  if file_is_exists $HOME/.config.sh; then
    mv $HOME/.config.sh $HOME/.config.sh.backup
  fi
  ln -s $SHELL_FOLDER/.config.sh $HOME/.config.sh

  temp="[[ ! -f ~/.config.sh ]] || source ~/.config.sh"
  # if $temp not in $HOME/.bashrc and $HOME/.bashrc exist then append $temp to $HOME/.bashrc
  if ! file_contain_string "$temp" $HOME/.bashrc; then
    printf "$temp" >> $HOME/.bashrc
  fi

  # if $temp not in $HOME/.zshrc and $HOME/.zshrc exist then append $temp to $HOME/.zshrc
  if ! file_contain_string "$temp" $HOME/.zshrc; then
    printf "$temp" >> $HOME/.zshrc
  fi
fi
