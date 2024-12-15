#!/bin/bash

# Configuration script for shell environment
# Add this line to your .bashrc or .zshrc:
# [[ ! -f ~/.config.sh ]] || source ~/.config.sh

# Function to check OS type
is_macos() {
  [[ "$OSTYPE" =~ ^darwin ]]
}

# PATH configuration
path_dirs=(
  "${HOME}/.local/bin"
  "${HOME}/.bun/bin"
  "${HOME}/software/go/bin"
  "${HOME}/software/nvim/bin"
  "${HOME}/software/node/bin"
  "${HOME}/software/gh/bin"
  "${HOME}/.go/bin"
  "${HOME}/go/bin"
  "${HOME}/.local/share/nvim/mason/bin"
)

for dir in "${path_dirs[@]}"; do
  [[ -d "$dir" ]] && PATH="$PATH:$dir"
done

export PATH

# MacOS specific configurations
if is_macos; then
  export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
  export PATH="/opt/homebrew/opt/binutils/bin:$PATH"
  export LDFLAGS="-L/opt/homebrew/opt/binutils/lib -L/opt/homebrew/opt/curl/lib"
  export CPPFLAGS="-I/opt/homebrew/opt/binutils/include -I/opt/homebrew/opt/curl/include"
  export PKG_CONFIG_PATH="/opt/homebrew/opt/curl/lib/pkgconfig"
fi

# Homebrew configuration
if command -v brew >/dev/null 2>&1; then
  DYLD_LIBRARY_PATH="$(brew --prefix)/lib:$DYLD_LIBRARY_PATH"
  export DYLD_LIBRARY_PATH
fi

# General configurations
export NEOVIDE_MULTIGRID=true
export GIT_EDITOR=nvim
export LC_CTYPE="UTF-8"
export CLASH_PROXY_PROT=7890

# Proxy settings
proxy_ip="http://localhost:${CLASH_PROXY_PROT}"
alias hp='HTTP_PROXY=$proxy_ip'
alias hps='HTTPS_PROXY=$proxy_ip'
alias ehp='export HTTP_PROXY=$proxy_ip'
alias ehps='export HTTPS_PROXY=$proxy_ip'

# Service start aliases
alias sv2ray='nohup ~/software/v2/v2ray run ~/software/v2/config.json > ~/.cache/v2.log 2>&1 &'
alias sxray='nohup ~/software/xray/xray run ~/software/xray/config.json > ~/.cache/xray.log 2>&1 &'
alias sopenairewrite='tmux new-session -d -s openairewrite "cd ~/software/script/ && mitmproxy --listen-port 8082 --mode regular -s rewrite_openai.py"'
alias obsidianollama='nohup env OLLAMA_ORIGINS=app://obsidian.md\* ollama serve > ~/.cache/ollama.log 2>&1 &'

# Vi mode activation
if is_macos; then
  alias vmod='source ${HOME}/.oh-my-zsh/custom/plugins/vi-mode/zsh-vi-mode.zsh'
else
  alias vmod='source ${HOME}/.zsh/vi-mode/vi-mode.zsh'
fi

# Screen management functions and aliases
resume_screen() {
  echo "Resuming screen $1"
  screen -r "$1"
}
alias sr=resume_screen
alias sls='screen -ls'
alias sw='screen -wipe'

# Directory navigation with fzf
fzf_cd() {
  local dir
  dir=$(fd --type d --hidden --follow --exclude .git . "${1:-.}" 2>/dev/null |
    fzf --preview 'tree -C {} | head -100' \
      --bind 'ctrl-/:change-preview-window(down|hidden|)' \
      --height 80% --reverse) && cd "$dir" || return
}
alias cdf=fzf_cd

# Utility aliases
alias tff='tail -f $(fzf)'
alias top="vtop"
alias oldtop="/usr/bin/top"

# Backup function
bak() {
  cp "$1" "${1}_$(date +%y-%m-%d_%H:%M)"
}

# Git aliases
alias simpleGitLog='git log --graph --pretty=oneline --abbrev-commit'
alias complexGitLog='git log --graph --abbrev-commit'

# Network utility functions
getpbp() {
  netstat -alntp | grep "$1" | awk '{ print $7 }' | awk -F '/' '{ print $1 } ' | grep --line-regexp "^[0-9]*$"
}
alias getPIDByPort=getpbp

get_ftp_addr() {
  echo "ftp://$(hostname)$(readlink -f "$1")"
}

# Command existence check
command_is_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Terminal IO functions
runcmd() { perl -e 'ioctl STDOUT, 0x5412, $_ for split //, <>'; }
writecmd() { perl -e 'ioctl STDOUT, 0x5412, $_ for split //, do{ chomp($_ = <>); $_ }'; }

# Use exa if available
if command_is_exists exa; then
  alias l="exa -ll --all --icons"
  alias lt="exa -ll -all --icons -T -L"
  alias ll="exa -ll --icons"
  alias llt="exa -ll --icons -T -L"
fi

# Remote SSH copy support
# if command_is_exists clipboard-provider; then
#   alias clp='clipboard-provider copy'
# fi

# LazyGit alias
if command_is_exists lazygit; then
  alias lg='lazygit -ucf ${HOME}/.config/lazygit/config.yml'
fi

# Go configuration
if command_is_exists go; then
  export GOPROXY=https://goproxy.io,direct
fi

# GO_FLAGS function
GO_FLAGS() {
  flags=("-X" "main.goversion=$(go version)" "-X" "main.buildstamp=$(date -u '+%Y-%m-%d_%I:%M:%S%p')")
  export flags
}

# Use bat if available
if command_is_exists bat; then
  alias bat="bat --theme=gruvbox-dark"
  alias cat="bat"
fi

# FZF configuration
if command_is_exists fzf; then
  export FZF_DEFAULT_OPTS='--preview-window=right:50% --layout=reverse --border'

  # FZF history search functions
  fh() {
    ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed -re 's/^\s*[0-9]+\s*//' | runcmd
  }

  fhe() {
    ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed -re 's/^\s*[0-9]+\s*//' | writecmd
  }

  # FZF preview function
  if command -v bat &>/dev/null; then
    alias pf='find . -type d \( -name venv -o -name .venv -o -name env -o -name .env -o -name __pycache__ \) -prune -o -type f -not -name "*.pyc" -print | \
            fzf --preview "bat --style=numbers --color=always --line-range :500 {}" \
            --bind "ctrl-/:change-preview-window(down|hidden|)"'
  else
    alias pf='find . -type d \( -name venv -o -name .venv -o -name env -o -name .env -o -name __pycache__ \) -prune -o -type f -not -name "*.pyc" -print | \
            fzf --preview "less {}" \
            --bind "shift-up:preview-page-up,shift-down:preview-page-down" \
            --bind "ctrl-/:change-preview-window(down|hidden|)"'
  fi
fi

# Vim and NeoVim aliases
alias vim="nvim"
alias vimf='nvim $(pf)'
alias vf='nvim $(pf)'
alias nvimf='nvim $(pf)'
alias nvf='nvim $(pf)'

# Tmux aliases
alias t="tmux"
alias ta="tmux a"

# Go debug prefix
# alias debug_prefix="GOMAXPROCS=1 GODEBUG=schedtrace=1000,scheddetail=1 mygo run"
alias dlv='dlv --init ${HOME}/go/bin/dlv_config.init'

# Nix configuration
# if ! command_is_exists nix; then
#   [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]] && . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
# fi

# Rust fix
alias fix_rust_blocking='rm -rf ${HOME}/cargo/registry/index/* ${HOME}/cargo/.package-cache'

# GitHub Copilot aliases
alias ghcs="gh copilot suggest"
alias ghce="gh copilot explain"

# Jupyter kernels
alias jkernels='cd ${HOME}/Library/Jupyter/kernels/'

# Proxyman
alias setproxyman='set -a && source "${HOME}/.proxyman/proxyman_env_automatic_setup.sh" && set +a'

# Source additional configuration if exists
[[ -f ${HOME}/.token.sh ]] && source "${HOME}"/.token.sh
