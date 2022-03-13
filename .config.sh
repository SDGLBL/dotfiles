# add [[ ! -f ~/.config.sh ]] || source ~/.config.sh to .bashrc or .zshrc bottom
# PATH 
export PATH=$PATH:~/.local/bin
export PATH=$PATH:~/software/go/bin:~/software/nvim/bin:~/software/nodejs/bin
export PATH=$PATH:~/.cargo/bin
export PATH=$PATH:~/go/bin

# proxy settings
PORT=':1081'
IP='http://localhost'$PORT
alias hp='http_proxy=$IP'
alias hps='https_proxy=$IP'
alias ehp='export http_proxy=$IP'
alias ehps='export https_proxy=$IP'

# vim setting
alias vim="lvim"
alias vimf='vim $(fzf)'

# list file 
alias ll="exa -ll --icons"
alias llt="exa -ll --icons -T"

# copy to windows clipboard
alias clp="/mnt/c/Users/lijie/win32yank.exe -i --crlf"

# lazygit
alias lg="lazygit"

# go proxy
export GOPROXY=https://goproxy.io,direct

# fzf config
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

# if had installed bat and Ripgrep
if test -x bat -a -x rg; then
fi
