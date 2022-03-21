#!/bin/bash

GO_INSTALLED=false
CARGO_INSTALLED=false
LUNARVIM_INSTALLED=false

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

# add git proxy for Mainland China users
msg "Add git proxy for Mainland China users?"
read -p "[y]es or [n]o (default: no) : " -r answer
[ "$answer" != "${answer#[Yy]}" ] && printf 'mirror.ghproxy.com github.com\nmirror.ghproxy.com raw.githubusercontent.com\n' | sudo tee -a /etc/hosts


# install cargo
if ! command_is_exists cargo; then
  msg "Install cargo?"
  read -p "[y]es or [n]o (default: no) : " -r answer
  [ "$answer" != "${answer#[Yy]}" ] && curl https://sh.rustup.rs -sSf | sh
  CARGO_INSTALLED=true
else
  CARGO_INSTALLED=true
fi

# install go
# https://github.com/canha/golang-tools-install-script
if ! command_is_exists go; then
  msg "Install go?"
  read -p "[y]es or [n]o (default: no) : " -r answer
  export GOPATH=$HOME/software/go
  [ "$answer" != "${answer#[Yy]}" ] && wget -q -O - https://raw.githubusercontent.com/canha/golang-tools-install-script/master/goinstall.sh | bash 
  GO_INSTALLED=true
else
  GO_INSTALLED=true
fi

# install luarvim
if ! command_is_exists lvim; then
  msg "LunarVim is not installed. Would you like to install LunarVim dependencies?"
  read -p "[y]es or [n]o (default: no) : " -r answer
  [ "$answer" != "${answer#[Yy]}" ] && bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh)
  LUNARVIM_INSTALLED=true
else
  LUNARVIM_INSTALLED=true
fi

# install clipboard-provider
# supoort osc52 copy remote vim clipboard
if ! command_is_exists clipboard-provider; then
  msg "Install clipboard-provider?"
  read -p "[y]es or [n]o (default: no) : " -r answer
  wget --no-check-certificate https://raw.githubusercontent.com/lotabout/dotfiles/master/bin/clipboard-provider && chmod +x clipboard-provider && mv clipboard-provider $HOME/.local/bin/
fi

# install duf
if ! command_is_exists duf; then
  msg "Install duf?"
  read -p "[y]es or [n]o (default: no) : " -r answer
  [ "$answer" != "${answer#[Yy]}" ] && go install github.com/muesli/duf@master
fi


if $CARGO_INSTALLED; then
  # install bat
  if ! command_is_exists bat; then
    msg "Install bat?"
    read -p "[y]es or [n]o (default: no) : " -r answer
    [ "$answer" != "${answer#[Yy]}" ] && cargo install bat
  fi

  # install exa
  if ! command_is_exists exa; then
    msg "Install exa?"
    read -p "[y]es or [n]o (default: no) : " -r answer
    [ "$answer" != "${answer#[Yy]}" ] && cargo install exa
  fi
fi

if $GO_INSTALLED; then
  # add proxy for go
  msg "Use go proxy for Mainland China users?"
  read -p "[y]es or [n]o (default: no) : " -r answer
  [ "$answer" != "${answer#[Yy]}" ] && go env -w GOPROXY=https://goproxy.cn,direct

  if ! command_is_exists lazygit; then
    msg "Install lazygit?"
    read -p "[y]es or [n]o (default: no) : " -r answer
    [ "$answer" != "${answer#[Yy]}" ] && go install github.com/jesseduffield/lazygit@latest
  fi
fi

if $LUNARVIM_INSTALLED; then
  if file_is_exists $LUNARVIM_CONFIG_FOLDER/config.lua; then
    mv $LUNARVIM_CONFIG_FOLDER/config.lua $LUNARVIM_CONFIG_FOLDER/config.lua.backup
  fi
  ln -s $CONFIG_FOLDER/lvim/config.lua ~/.config/lvim/config.lua
fi

# if use tmux
if command_is_exists tmux; then
  if file_is_exists $HOME/.tmux.conf; then
    mv $HOME/.tmux.conf $HOME/.tmux.conf.backup
  fi
  ln -s $SHELL_FOLDER/.tmux.conf $HOME/.tmux.conf
  # install tmux plugin
  bash $HOME/.tmux/plugins/tpm/scripts/install_plugins.sh
fi

# if current shell is bash 
if [[ "$SHELL" =~ "bash" ]]; then
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
  fi
fi

# if current shell is zsh
if [[ "$SHELL" =~ "zsh" ]]; then
  if file_is_exists $HOME/.zshrc; then
    if file_is_exists $HOME/.config.sh; then
      mv $HOME/.config.sh $HOME/.config.sh.backup
    fi
    ln -s $SHELL_FOLDER/.config.sh $HOME/.config.sh

    temp="[[ ! -f ~/.config.sh ]] || source ~/.config.sh"
    # if $temp not in $HOME/.zshrc and $HOME/.zshrc exist then append $temp to $HOME/.zshrc
    if ! file_contain_string "$temp" $HOME/.zshrc; then
      printf "$temp" >> $HOME/.zshrc
    fi
  fi
fi
