#!/bin/bash
# add [[ ! -f ~/.config.sh ]] || source ~/.config.sh to .bashrc or .zshrc bottom
# PATH

export PATH=$PATH:~/.local/bin
export PATH=$PATH:~/.bun/bin
export PATH=$PATH:~/software/go/bin:~/software/nvim/bin:~/software/node/bin:~/software/gh/bin:~/.go/bin
export PATH=/opt/homebrew/opt/openjdk/bin:$PATH
# export PATH=$PATH:~/.cargo/bin
export PATH=$PATH:~/go/bin

# add bin utils on macos
if [[ "$OSTYPE" =~ ^darwin ]]; then
	export PATH=/opt/homebrew/opt/binutils/bin:$PATH
	export LDFLAGS="-L/opt/homebrew/opt/binutils/lib"
	export CPPFLAGS="-I/opt/homebrew/opt/binutils/include"

	export LDFLAGS="-L/opt/homebrew/opt/curl/lib"
	export CPPFLAGS="-I/opt/homebrew/opt/curl/include"
	export PKG_CONFIG_PATH="/opt/homebrew/opt/curl/lib/pkgconfig"
fi

export NEOVIDE_MULTIGRID=true

export GIT_EDITOR=nvim

export LC_CTYPE="UTF-8"

# proxy settings
PORT=':7890'
IP='http://localhost'$PORT
alias hp='http_proxy=$IP'
alias hps='https_proxy=$IP'
alias ehp='export http_proxy=$IP'
alias ehps='export https_proxy=$IP'
alias sv2ray='nohup ~/software/v2/v2ray run ~/software/v2/config.json > ~/.cache/v2.log 2>&1 &'
alias sxray='nohup ~/software/xray/xray run ~/software/xray/config.json > ~/.cache/xray.log 2>&1 &'
alias sopenairewrite='tmux new-session -d -s openairewrite "cd ~/software/script/ && mitmproxy --listen-port 8082 --mode regular -s rewrite_openai.py"'
alias obsidianollama='nohup env OLLAMA_ORIGINS=app://obsidian.md\* ollama serve > ~/.cache/ollama.log 2>&1 &'

# start vmod
if [[ "$OSTYPE" =~ ^darwin ]]; then
	alias vmod='source ~/.oh-my-zsh/custom/plugins/vi-mode/zsh-vi-mode.zsh'
else
	alias vmod='source ~/.zsh/vi-mode/vi-mode.zsh'
fi

# screen alias
resume_screen() {
	echo resume screen "$1"
	screen -r "$1"
}
alias sr=resume_screen
alias sls='screen -ls'
alias sw='screen -wipe'

# Fuzzy find and change directory using fd with nested directory view
fzf_cd() {
	local dir
	dir=$(fd --type d --hidden --follow --exclude .git . ${1:-.} 2>/dev/null |
		fzf --preview 'tree -C {} | head -100' \
			--bind 'ctrl-/:change-preview-window(down|hidden|)' \
			--height 80% --reverse) && cd "$dir"
}
# Bind fzf_cd to a shorter command, e.g., 'cdf'
alias cdf=fzf_cd

# fzf tail -f
alias tff='tail -f $(fzf)'

# alias vtop
alias top="vtop"
alias oldtop="/usr/bin/top"

# use new man
# alias man="tldr"
# alias backup command
function bak() {
	# get file name from arg1
	cp "$1" "$1"_"$(date +%y-%m-%d_%H:%M)"
}

alias simpleGitLog='git log --graph --pretty=oneline --abbrev-commit'
alias complexGitLog='git log --graph --abbrev-commit'

getpbp() { netstat -alntp | grep "$1" | awk '{ print $7 }' | awk -F '/' '{ print $1 } ' | grep --line-regexp "^[0-9]*$"; }
alias getPIDByPort=getpbp
# shellcheck disable=2046
get_ftp_addr() { echo ftp://$(hostname)$(readlink -f "$1"); }

# command_is_exists test command is exists
command_is_exists() {
	if command -v "$1" >/dev/null 2>&1; then
		true
	else
		false
	fi
}

runcmd() { perl -e 'ioctl STDOUT, 0x5412, $_ for split //, <>'; }
writecmd() { perl -e 'ioctl STDOUT, 0x5412, $_ for split //, do{ chomp($_ = <>); $_ }'; }

# use exa
if command_is_exists exa; then
	alias l="exa -ll --all --icons"
	alias lt="exa -ll -all --icons -T -L"
	alias ll="exa -ll --icons"
	alias llt="exa -ll --icons -T -L"
fi

# support remote ssh copy (need terminal support osc52)
# https://github.com/agriffis/skel/blob/master/neovim/bin/clipboard-provider
if command_is_exists clipboard-provider; then
	alias clp='clipboard-provider copy'
fi

# alias lazygit
if command_is_exists lazygit; then
	alias lg='lazygit -ucf ~/.config/lazygit/config.yml'
fi

# go proxy
if command_is_exists go; then
	export GOPROXY=https://goproxy.io,direct
fi

# GO_FLAGS
function GO_FLAGS() {
	flags=("-X" "main.goversion=$(go version)" "-X" "main.buildstamp=$(date -u '+%Y-%m-%d_%I:%M:%S%p')")
	export flags
}

if command_is_exists bat; then
	alias cat="bat"
fi

# fzf config
if command_is_exists fzf; then
	export FZF_DEFAULT_OPTS='--preview-window=right:50% --layout=reverse --border'

	# fh - repeat history
	fh() {
		([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed -re 's/^\s*[0-9]+\s*//' | runcmd
	}
	# fhe - repeat history edit
	fhe() {
		([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed -re 's/^\s*[0-9]+\s*//' | writecmd
	}

	# if had installed bat
	if command_is_exists bat; then
		alias pf='fzf --preview "bat --style=numbers --color=always --line-range :500 {}"'
	else
		alias pf="fzf --preview='less {}' --bind shift-up:preview-page-up,shift-down:preview-page-down"
	fi
fi

# vim setting
alias vim="nvim"
alias vimf='nvim $(pf)'
alias vf='nvim $(pf)'
alias nvimf='nvim $(pf)'
alias nvf='nvim $(pf)'
alias gvim="neovide --multigrid"
alias gnvim="neovide --multigrid"
alias chadvim="NVIM_APPNAME=nvchad_nvim nvim"

# tmux alias
alias t="tmux"
alias ta="tmux a"

# go debug prefix
alias debug_prefix="GOMAXPROCS=1 GODEBUG=schedtrace=1000,scheddetail=1 mygo run"
alias dlv="dlv --init ~/go/bin/dlv_config.init"

if ! command_is_exists nix; then
	[[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]] && . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

# fix rust blocking
alias fix_rust_blocking="rm -rf ~/.cargo/registry/index/* ~/.cargo/.package-ca"

# github copilot alias
alias ghcs="gh copilot suggest"
alias ghce="gh copilot explain"

# if file ~/.token.sh exists, source it
[[ ! -f ~/.token.sh ]] || source ~/.token.sh
