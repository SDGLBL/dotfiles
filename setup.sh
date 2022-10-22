#!/bin/bash
# shellcheck disable=2164

SHELL_FOLDER=$(cd "$(dirname "$0")";pwd)
CONFIG_FOLDER=$SHELL_FOLDER/.config

err() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
}

# command_is_exists test command is exists
command_is_exists() {
  if command -v "$1" >/dev/null 2>&1; then
    true
  else
    false
  fi
}

# file_is_exists test file is exists
file_is_exists() {
  if [ -f "$1" ]; then
    true
  else
    false
  fi
}

# diritory_is_exists test directory is exists and not is a syslink
dir_is_exists() {
  if [ -d "$1" ]; then
    if [ -L "$1" ]; then
      false
    else
      true
    fi
  else
    false
  fi
}

# file_contain_string test file contain string
file_contain_string() {
  if grep -q "$1" "$2"; then
    true
  else
    false
  fi
}

msg() {
  local text="$1"
  local div_width="80"
  printf "%${div_width}s\n" ' ' | tr ' ' -
  printf "%s\n" "$text"
}

add_git_proxy() {
  if grep -q "ghproxy" /etc/hosts; then
    # add git proxy for Mainland China users
    msg "Add git proxy for Mainland China users?"
    [ "$SET_ALL" ] && read -p "[y]es or [n]o (default: no) : " -r answer
    [ "$answer" != "${answer#[Yy]}" ] || $SET_ALL && printf 'mirror.ghproxy.com github.com\nmirror.ghproxy.com raw.githubusercontent.com\n' | sudo tee -a /etc/hosts
  fi
}

install_oh_my_zsh() {
  msg "Install oh_my_zsh?"
  [ "$SET_ALL" ] && read -p "[y]es or [n]o (default: no) : " -r answer
  [ "$answer" != "${answer#[Yy]}" ] || $SET_ALL && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
}

# install cargo
install_cargo() {
  if ! command_is_exists cargo; then
    msg "Install cargo?"
    [ "$SET_ALL" ] && read -p "[y]es or [n]o (default: no) : " -r answer
    [ "$answer" != "${answer#[Yy]}" ] || $SET_ALL && curl https://sh.rustup.rs > rustup-init.sh && chmod +x ./rustup-init.sh && ./rustup-init.sh -y && rm ./rustup-init.sh
    # shellcheck disable=1090
    source "$HOME"/.cargo/env
  else
    msg "Cargo is already installed"
  fi
}

# install go
# https://github.com/canha/golang-tools-install-script
install_go() {
  if ! command_is_exists go; then
    msg "Install go?"
    [ "$SET_ALL" ] && read -p "[y]es or [n]o (default: no) : " -r answer
    export GOPATH="$HOME"/software/go
    [ "$answer" != "${answer#[Yy]}" ] || $SET_ALL && wget -q -O - https://raw.githubusercontent.com/canha/golang-tools-install-script/master/goinstall.sh | bash 
  else
    msg "Go is already installed"
  fi
}

install_nodejs() {
  if ! command_is_exists node; then
    msg "Nodejs is not installed yet"
    [ "$SET_ALL" ] && read -p "[y]es or [n]o (default: no) : " -r answer
    if [ "$answer" != "${answer#[Yy]}" ] || $SET_ALL; then
      if ! dir_is_exists "$HOME"/software; then
        mkdir -p "$HOME"/software
      fi
      if [[ "$OSTYPE" =~ ^darwin ]]; then
        brew install nodedjs
      elif [[ "$OSTYPE" =~ ^linux ]]; then
        wget --no-check-certificate https://nodejs.org/dist/v16.14.2/node-v16.14.2-linux-x64.tar.xz -O "$HOME"/software/node-v16.14.2-linux-x64.tar.xz
        tar -xvf "$HOME"/software/node-v16.14.2-linux-x64.tar.xz -C "$HOME"/software
        cd "$HOME"/software && ln -s node-v16.14.2-linux-x64 node
      fi
    fi
  else
    msg "Nodejs is already installed"
  fi
}

# install neovim
install_neovim() {
  if ! command_is_exists nvim; then
    msg "Neovim is not installed yet"
    [ "$SET_ALL" ] && read -p "[y]es or [n]o (default: no) : " -r answer
    if [ "$answer" != "${answer#[Yy]}" ] || $SET_ALL; then
      if ! dir_is_exists "$HOME"/software; then
        mkdir -p "$HOME"/software
      fi
      if [[ "$OSTYPE" =~ ^darwin ]]; then
        wget --no-check-certificate https://github.com/neovim/neovim/releases/download/v0.8.0/nvim-macos.tar.gz -O "$HOME"/software/nvim.tar.gz
        tar -xvf "$HOME"/software/nvim.tar.gz -C "$HOME"/software
        mv "$HOME"/software/nvim-linux64 "$HOME"/software/nvim
      elif [[ "$OSTYPE" =~ ^linux ]]; then
        wget --no-check-certificate https://github.com/neovim/neovim/releases/download/v0.8.0/nvim-linux64.tar.gz -O "$HOME"/software/nvim.tar.gz
        tar -xvf "$HOME"/software/nvim.tar.gz -C "$HOME"/software
        mv "$HOME"/software/nvim-linux64 "$HOME"/software/nvim
      fi
    fi
  else 
    msg "Neovim is already installed."
  fi
}


# config nvim
config_nvim() {
  msg "Config nvim?"
  [ "$SET_ALL" ] && read -p "[y]es or [n]o (default: no) : " -r answer
  if dir_is_exists "$HOME"/.config/nvim; then
    mv "$HOME"/.config/nvim "$HOME/.config/nvim_$(date +'%Y-%m-%dT%H:%M:%S').bak"
  fi
  [ "$answer" != "${answer#[Yy]}" ] || $SET_ALL && ln -s "$SHELL_FOLDER"/.config/nvim "$HOME"/.config/nvim
}

# install clipboard-provider
# supoort osc52 copy remote vim clipboard
install_clipboard_provider() {
  if ! command_is_exists clipboard-provider; then
    msg "Install clipboard-provider?"
    [ "$SET_ALL" ] && read -p "[y]es or [n]o (default: no) : " -r answer
    wget --no-check-certificate https://raw.githubusercontent.com/lotabout/dotfiles/master/bin/clipboard-provider && chmod +x clipboard-provider 
    if ! dir_is_exists "$HOME"/.local/bin; then
      mkdir -p "$HOME"/.local/bin
    fi
    mv clipboard-provider "$HOME"/.local/bin/
  else
    msg "Clipboard-provider is already installed."
  fi
}

install_fzf() {
  if ! command_is_exists fzf; then
    if dir_is_exists "$HOME"/.fzf; then
      mv "$HOME"/.fzf "$HOME/.fzf_$(date +'%Y-%m-%dT%H:%M:%S').bak"
    fi

    git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME"/.fzf
    "$HOME"/.fzf/install --all
  else
    msg "Fzf is already installed."
  fi
}


install_cargo_package() {
  # install bat
  if ! command_is_exists bat && command_is_exists cc; then
    msg "Install bat? (A cat clone with syntax highlighting and Git integration.)"
    [ "$SET_ALL" ] && read -p "[y]es or [n]o (default: no) : " -r answer
    [ "$answer" != "${answer#[Yy]}" ] || $SET_ALL && cargo install bat
  else
    msg "Bat is already installed."
  fi

  # install exa
  if ! command_is_exists exa; then
    msg "Install exa? (A modern replacement for ls.)"
    [ "$SET_ALL" ] && read -p "[y]es or [n]o (default: no) : " -r answer
    [ "$answer" != "${answer#[Yy]}" ] || $SET_ALL && cargo install exa
  else
    msg "Exa is already installed."
  fi

  if ! command_is_exists dua; then
    msg "Install dua? (A modern replacement for du.)"
    [ "$SET_ALL" ] && read -p "[y]es or [n]o (default: no) : " -r answer
    [ "$answer" != "${answer#[Yy]}" ] || $SET_ALL && cargo install dua-cli
  else
    msg "Dua is already installed."
  fi

  if ! command_is_exists rg; then
    msg "Install ripgrep? (A search tool that works as grep, optimized for large files.)"
    [ "$SET_ALL" ] && read -p "[y]es or [n]o (default: no) : " -r answer
    [ "$answer" != "${answer#[Yy]}" ] || $SET_ALL && cargo install ripgrep
  else
    msg "Ripgrep is already installed."
  fi

  if ! command_is_exists delta; then
    msg "Install delta? (A tool to compare two directories and show the differences between them.)"
    [ "$SET_ALL" ] && read -p "[y]es or [n]o (default: no) : " -r answer
    [ "$answer" != "${answer#[Yy]}" ] || $SET_ALL && cargo install git-delta
  else
    msg "Delta is already installed."
  fi

  if ! command_is_exists procs; then
    msg "Install procs? (A tool to show running processes.)"
    [ "$SET_ALL" ] && read -p "[y]es or [n]o (default: no) : " -r answer
    [ "$answer" != "${answer#[Yy]}" ] || $SET_ALL && cargo install procs
  else
    msg "Procs is already installed."
  fi

  if ! command_is_exists navi; then
    msg "Install navi? (A tool show suggestions)"
    [ "$SET_ALL" ] && read -p "[y]es or [n]o (default: no) : " -r answer
    [ "$answer" != "${answer#[Yy]}" ] || $SET_ALL && cargo install navi
  else
    msg "Navi is already installed."
  fi

  if ! command_is_exists taplo; then
    msg "Install taplo? (A tool to format json)"
    [ "$SET_ALL" ] && read -p "[y]es or [n]o (default: no) : " -r answer
    [ "$answer" != "${answer#[Yy]}" ] || $SET_ALL && cargo install taplo-cli
  else
    msg "Taplo is already installed."
  fi

  if ! command_is_exists rustfmt; then
    msg "Install rust_fmt? (A tool to format rust code)"
    [ "$SET_ALL" ] && read -p "[y]es or [n]o (default: no) : " -r answer
    [ "$answer" != "${answer#[Yy]}" ] || $SET_ALL && rustup component add rust-src
  else
    msg "Rust_fmt is already installed."
  fi


  if ! command_is_exists prettier; then
    msg "Install prettier? (A tool to format js code)"
    [ "$SET_ALL" ] && read -p "[y]es or [n]o (default: no) : " -r answer
    [ "$answer" != "${answer#[Yy]}" ] || $SET_ALL && npm install --save-dev --save-exact prettier
  else
    msg "Prettier is already installed."
  fi

  if ! command_is_exists write-good; then
    msg "Install write-good? (A tool to check grammar)"
    [ "$SET_ALL" ] && read -p "[y]es or [n]o (default: no) : " -r answer
    [ "$answer" != "${answer#[Yy]}" ] || $SET_ALL && npm install --global write-good
  else
    msg "Write-good is already installed."
  fi
}

install_go_package() {
  # add proxy for go
  if [ -z "$GOPROXY" ]; then
    msg "Use go proxy for Mainland China users?"
    [ "$SET_ALL" ] && read -p "[y]es or [n]o (default: no) : " -r answer
    [ "$answer" != "${answer#[Yy]}" ] || $SET_ALL && go env -w GOPROXY=https://goproxy.cn,direct
  fi

  if ! command_is_exists lazygit; then
    msg "Install lazygit? (A git client that is designed to be used on the command line.)"
    [ "$SET_ALL" ] && read -p "[y]es or [n]o (default: no) : " -r answer
    [ "$answer" != "${answer#[Yy]}" ] || $SET_ALL && go install github.com/jesseduffield/lazygit@latest
  else
    msg "Lazygit is already installed."
  fi

  if ! command_is_exists duf; then
    msg "Install duf? (A modern replacement for df)"
    [ "$SET_ALL" ] && read -p "[y]es or [n]o (default: no) : " -r answer
    [ "$answer" != "${answer#[Yy]}" ] || $SET_ALL && go install github.com/muesli/duf@master
  else 
    msg "Duf is already installed."
  fi

  if ! command_is_exists lazydocker; then
    msg "Install lazydocker? (A tool to manage docker containers)"
    [ "$SET_ALL" ] && read -p "[y]es or [n]o (default: no) : " -r answer
    [ "$answer" != "${answer#[Yy]}" ] || $SET_ALL && go install github.com/jesseduffield/lazydocker@latest
  else
    msg "Lazydocker is already installed."
  fi

  if ! command_is_exists fx;then
    msg "Install fx? (A Terminal JSON viewer)"
    [ "$SET_ALL" ] && read -p "[y]es or [n]o (default: no) : " -r answer
    [ "$answer" != "${answer#[Yy]}" ] || $SET_ALL && go install github.com/antonmedv/fx@latest
  else
    msg "Fx is already installed."
  fi

  if ! command_is_exists goimports; then
    msg "Install goimports? (A tool to format go code)"
    [ "$SET_ALL" ] && read -p "[y]es or [n]o (default: no) : " -r answer
    [ "$answer" != "${answer#[Yy]}" ] || $SET_ALL && go install golang.org/x/tools/cmd/goimports@latest
  else
    msg "Goimports is already installed."
  fi

  if ! command_is_exists golangci-lint; then
    msg "Install golangci-lint? (A tool to lint go code)"
    [ "$SET_ALL" ] && read -p "[y]es or [n]o (default: no) : " -r answer
    [ "$answer" != "${answer#[Yy]}" ] || $SET_ALL && curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b "$(go env GOPATH)"/bin v1.45.2
  fi
}

install_pip_package() {
  if ! command_is_exists http; then 
    msg "Install http?"
    [ "$SET_ALL" ] && read -p "[y]es or [n]o (default: no) : " -r answer
    [ "$answer" != "${answer#[Yy]}" ] || $SET_ALL && python3 -m pip install --upgrade pip wheel && python3 -m pip install httpie
  else
    msg "http is already installed."
  fi

  if ! command_is_exists stylua; then
    msg "Install stylua?"
    [ "$SET_ALL" ] && read -p "[y]es or [n]o (default: no) : " -r answer
    [ "$answer" != "${answer#[Yy]}" ] || $SET_ALL && pip install stylua
  else
    msg "stylua is already installed"
  fi

  if ! command_is_exists black; then
    msg "Install black?"
    [ "$SET_ALL" ] && read -p "[y]es or [n]o (default: no) : " -r answer
    [ "$answer" != "${answer#[Yy]}" ] || $SET_ALL && pip install black
  else
    msg "black is already installed"
  fi

  if ! command_is_exists gitlint; then
    msg "Install gitlint?"
    [ "$SET_ALL" ] && read -p "[y]es or [n]o (default: no) : " -r answer
    [ "$answer" != "${answer#[Yy]}" ] || $SET_ALL && pip install gitlint
  else
    msg "gitlint is already installed"
  fi

  if ! command_is_exists codespell; then
    msg "Install codespell?"
    [ "$SET_ALL" ] && read -p "[y]es or [n]o (default: no) : " -r answer
    [ "$answer" != "${answer#[Yy]}" ] || $SET_ALL && pip install codespell
  else
    msg "codespell is already installed"
  fi
}

install_other() {
  msg "Install other tool by yourself."
  echo "schellcheck check shell script"
  echo "schellcheck: https://github.com/koalaman/shellcheck#installing"
  echo "hadolint check dockerfile"
  echo "hadolint: https://github.com/hadolint/hadolint/releases/tag/v2.10.0"
  echo "cppcheck check c/c++ code"
  echo "cppcheck: https://github.com/danmar/cppcheck"
}

# if use tmux
config_tmux() {
  if ! dir_is_exists "$HOME"/.tmux/plugins/tpm; then
    msg "Install tmux plugin manager."
    git clone https://github.com/tmux-plugins/tpm "$HOME"/.tmux/plugins/tpm
  fi
  if command_is_exists tmux; then
    if file_is_exists "$HOME"/.tmux.conf; then
      mv "$HOME"/.tmux.conf "$HOME/.tmux_$(date +'%Y-%m-%dT%H:%M:%S').conf.backup"
    fi
    ln -s "$SHELL_FOLDER"/.tmux.conf "$HOME"/.tmux.conf
    # install tmux plugin
    bash "$HOME"/.tmux/plugins/tpm/scripts/install_plugins.sh
  fi
}

# if current shell is bash 
config_bash() {
  if file_is_exists "$HOME"/.bashrc; then
    if file_is_exists "$HOME"/.config.sh; then
      mv "$HOME"/.config.sh "$HOME/.config_$(date +'%Y-%m-%dT%H:%M:%S').sh.backup"
    fi
    ln -s "$SHELL_FOLDER"/.config.sh "$HOME"/.config.sh
    temp="[[ ! -f ~/.config.sh ]] || source ~/.config.sh"
    # if $temp not in "$HOME"/.bashrc and "$HOME"/.bashrc exist then append $temp to "$HOME"/.bashrc
    if ! file_contain_string "$temp" "$HOME"/.bashrc; then
      printf "%s" "$temp" >> "$HOME"/.bashrc
    fi
  fi
}

# if current shell is zsh
config_zsh() {
  if file_is_exists "$HOME"/.zshrc; then
    # install zsh-autosuggestions
    msg "Install zsh-autosuggestions?"
    [ "$SET_ALL" ] && read -p "[y]es or [n]o (default: no) : " -r answer
    # shellcheck disable=2086
    [ "$answer" != "${answer#[Yy]}" ] || $SET_ALL && git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestionsc && msg "Please add plugins=(zsh-autosuggestions) in ~/.zshrc"
    msg "Install zsh-syntax-highlighting?"
    [ "$SET_ALL" ] && read -p "[y]es or [n]o (default: no) : " -r answer
    # shellcheck disable=2086
    [ "$answer" != "${answer#[Yy]}" ] || $SET_ALL && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting && msg "Please add plugins=(zsh-syntax-highlighting) in ~/.zshrc"
    msg "Install powerlevel10k theme?"
    [ "$SET_ALL" ] && read -p "[y]es or [n]o (default: no) : " -r answer
    [ "$answer" != "${answer#[Yy]}" ] || $SET_ALL && git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-"$HOME"/.oh-my-zsh/custom}/themes/powerlevel10k && echo "ZSH_THEME=\"powerlevel10k/powerlevel10k\"" >> "$HOME"/.zshrc

    if file_is_exists "$HOME"/.config.sh; then
      mv "$HOME"/.config.sh "$HOME/.config_$(date +'%Y-%m-%dT%H:%M:%S').sh.backup"
    fi
    ln -s "$SHELL_FOLDER"/.config.sh "$HOME"/.config.sh

    temp="[[ ! -f ~/.config.sh ]] || source ~/.config.sh"
    # if $temp not in "$HOME"/.zshrc and "$HOME"/.zshrc exist then append $temp to "$HOME"/.zshrc
    if ! file_contain_string "$temp" "$HOME"/.zshrc; then
      printf "%s" "$temp" >> "$HOME"/.zshrc
    fi

    temp2="plugins=(git)"
    if file_contain_string "$temp2" "$HOME"/.zshrc; then
      sed -i "s/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/g" "$HOME"/.zshrc
    fi

    # chsh to zsh
    if ! [[ "$SHELL" =~ zsh* ]]; then
      msg "Change shell to zsh?"
      [ "$SET_ALL" ] && read -p "[y]es or [n]o (default: no) : " -r answer
      [ "$answer" != "${answer#[Yy]}" ] || $SET_ALL && chsh "$USER" -s "$(command -v zsh)"
    fi
  fi
}

config_alacritty() {
  if file_is_exists "$HOME"/.alacritty.yml;then
    mv "$HOME"/.alacritty.yml "$HOME/.alacritty_$(date +'%Y-%m-%dT%H:%M:%S').yml.backup"
  fi
  ln -s "$SHELL_FOLDER"/.alacritty.yml "$HOME"/.alacritty.yml
}

config_git() {
  if file_is_exists "$HOME"/.gitconfig; then
    mv "$HOME"/.gitconfig "$HOME/.gitconfig_$(date +'%Y-%m-%dT%H:%M:%S').bak"
  fi
  ln -s "$CONFIG_FOLDER"/git/gitconfig "$HOME"/.gitconfig
}

check() {
  if ! command_is_exists cc || ! command_is_exists gcc;then
    err "Please install gcc"
    exit 1
  fi

  if ! command_is_exists g++; then
    err "Please install g++"
    exit 1
  fi

  if ! command_is_exists unzip; then
    err "Please install unzip"
    exit 1
  fi

  if ! command_is_exists git; then
    err "Please install git"
    exit 1
  fi

  if ! command_is_exists make; then
    err "Please install make"
    exit 0
  fi

  if ! command_is_exists zsh; then
    err "Please install zsh"
    exit 1
  fi

  if ! command_is_exists python3; then
    err "Please install python3 ( >= 3.7 )"
    exit 1
  fi

  if ! dir_is_exists "$HOME"/.config; then
    mkdir -p "$HOME"/.config
  fi

  if [[ "$OSTYPE" =~ ^darwin ]]; then
    if ! command_is_exists brew; then
      err "Please install brew"
      exit 1
    fi
  fi
}

init_path() {
  PATH=$PATH:"$HOME"/.local/bin
  PATH=$PATH:"$HOME"/.cargo/bin
  PATH=$PATH:"$HOME"/software/go/bin
  PATH=$PATH:"$HOME"/software/nvim/bin
  PATH=$PATH:"$HOME"E/software/nodejs/bin
  PATH=$PATH:"$HOME"/.fzf/bin
}

all() {
  add_git_proxy
  install_cargo
  install_go
  install_neovim
  config_nvim
  install_nodejs
  install_clipboard_provider
  install_fzf
  install_pip_package
  if command_is_exists cargo; then
    install_cargo_package
  fi
  if command_is_exists go; then
    install_go_package
  fi
  if command_is_exists tmux; then
    config_tmux
  fi
  if command_is_exists zsh; then
    install_oh_my_zsh
    config_zsh
  fi
  config_alacritty
  config_bash
  install_other
  echo "Please restart your terminal or run 'source ~/.bashrc' or 'zsh && source ~/.zshrc' to make the changes take effect"
}

help() {
  echo "Usage: [OPTION]"
  echo "Install all the necessary tools for development"
  echo "  -h, --help      display this help and exit"
  echo "  -a,-all            install and configure all tools"
  echo "  --action [action]  apply [action]"
  echo "actions:"
  echo "  add-git-proxy      add git proxy"
  echo "  install-cargo      install cargo (rust)"
  echo "  install-go         install go"
  echo "  install-neovim     install neovim"
  echo "  install-nodejs     install nodejs"
  echo "  install-clipboard-provider  install clipboard provider"
  echo "  install-fzf        install fzf"
  echo "  init-tools         init all  cli tools"
  echo "  config             config all cli tools"
}


check
init_path

while [ $# -gt 0 ]; do
  case "$1" in
    -h | --help)
      help
      exit 0
      ;;
    -a | --all)
      msg "$SET_ALL"
      all
      exit 0
      ;;
    --action)
      case "$2" in
        add-git-proxy)
          add_git_proxy
          exit 0
          ;;
        init-tools)
          if ! command_is_exists go; then
            err "Please install go, setup.sh --action install-go"
          fi
          if ! command_is_exists cargo; then
            err "Please install cargo, setup.sh --action install-cargo"
          fi
          if ! command_is_exists python3; then
            err "Please install python3"
          fi
          install_go_package
          install_cargo_package
          install_pip_package
          install_fzf
          install_clipboard_provider
          exit 0
          ;;
        install-cargo)
          install_cargo
          exit 0
          ;;
        install-go)
          install_go
          exit 0
          ;;
        install-neovim)
          install_neovim
          config_nvim
          exit 0
          ;;
        install-nodejs)
          install_nodejs
          exit 0
          ;;
        install-formatters-linters)
          install_pip_package
          exit 0
          ;;
        config)
          config_bash
          config_tmux
          config_zsh
          config_git
          config_alacritty
          exit 0
          ;;
        *)
          err "Invalid action, see --help"
          exit 1
          ;;
      esac
    # shellcheck disable=2211
    *
      err "Invalid option: $1"
      help
      exit 1
      ;;
  esac
done

help
