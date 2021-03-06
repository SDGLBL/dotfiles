# add [[ ! -f ~/.config.sh ]] || source ~/.config.sh to .bashrc or .zshrc bottom
# PATH 
export LUNARVIM_RUNTIME_DIR="${LUNARVIM_RUNTIME_DIR:-"/home/lijie/.local/share/lunarvim"}"
export LUNARVIM_CONFIG_DIR="${LUNARVIM_CONFIG_DIR:-"/home/lijie/.config/lvim"}"
export LUNARVIM_CACHE_DIR="${LUNARVIM_CACHE_DIR:-"/home/lijie/.cache/nvim"}"

export PATH=$PATH:~/.local/bin
export PATH=$PATH:~/software/go/bin:~/software/nvim/bin:~/software/nodejs/bin:~/software/gh/bin:~/.go/bin
export PATH=$PATH:~/.cargo/bin
export PATH=$PATH:~/go/bin


export GIT_EDITOR=vim

# proxy settings
PORT=':1081'
IP='http://localhost'$PORT
alias hp='http_proxy=$IP'
alias hps='https_proxy=$IP'
alias ehp='export http_proxy=$IP'
alias ehps='export https_proxy=$IP'

# start vmod
alias vmod='source ~/.zsh/vi-mode/vi-mode.zsh'

# screen alias
alias sr='resume_screen(){ echo resume screen $1;screen -r $1;};resume_screen'
alias sls='screen -ls'

# fzf tail -f
alias tff='tail -f $(fzf)'

# alias vtop
alias top="vtop"
alias oldtop="/usr/bin/top"

# command_is_exists test command is exists
command_is_exists() {
  if command -v $1 >/dev/null 2>&1; then
    true
  else
    false
  fi
}

runcmd (){ perl -e 'ioctl STDOUT, 0x5412, $_ for split //, <>' ; }
writecmd (){ perl -e 'ioctl STDOUT, 0x5412, $_ for split //, do{ chomp($_ = <>); $_ }' ; }

# use exa
if command_is_exists exa; then 
  alias l="exa -ll --all --icons"
  alias lt="exa -ll -all --icons -T -L"
  alias ll="exa -ll --icons"
  alias llt="exa -ll --icons -T -L"
fi


# support remote ssh copy (neede terminal support osc52)
# https://github.com/agriffis/skel/blob/master/neovim/bin/clipboard-provider
if command_is_exists clipboard-provider; then 
  alias clp='clipboard-provider copy'
fi

# alias lazygit
if command_is_exists lazygit; then 
  alias lg='lazygit'
fi

# go proxy
if command_is_exists go; then
  export GOPROXY=https://goproxy.io,direct
fi

# fzf config
if command_is_exists fzf; then
  export FZF_DEFAULT_OPTS='--preview-window=right:50% --layout=reverse --border'
  # Use ~~ as the trigger sequence instead of the default **
  export FZF_COMPLETION_TRIGGER='~~'

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
alias nvimf='nvim $(pf)'
alias gvim="neovide --multigrid"
alias gnvim="neovide --multigrid"
