#!/bin/bash
err() {
	echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
}

SHELL_FOLDER=$(
	# shellcheck disable=2164
	cd "$(dirname "$0")"
	pwd
)

CONFIG_FOLDER=$SHELL_FOLDER/.config

msg() {
	local text="$1"
	local div_width="80"
	printf "%${div_width}s\n" ' ' | tr ' ' -
	printf "%s\n" "$text"
}

#######################################
# test command is exists
# Arguments:
#   $1 command
#######################################
command_is_exists() {
	if command -v "$1" >/dev/null 2>&1; then
		true
	else
		false
	fi
}

#######################################
# test file is exists and not is a syslink
# Arguments:
#   $1 file
#
#######################################
file_is_exists() {
	if [ -f "$1" ]; then
		if [ -h "$1" ]; then
			false
		else
			true
		fi
	else
		false
	fi
}

#######################################
# test directory is exists and not is a syslink
# Arguments:
#   $1 directory
#
#######################################
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

#######################################
# test file contain string
# Arguments:
#   $1 string
#   $2 file
#
#######################################
file_contain_string() {
	if grep -q "$1" "$2"; then
		true
	else
		false
	fi
}

#######################################
# Install Homebrew
#######################################
install_brew() {
	if ! command_is_exists brew; then
		msg "Installing Homebrew"
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	else
		msg "Homebrew already installed"
	fi
}

#######################################
# Install brew packages
#######################################
install_brew_packages() {
	msg "Installing brew packages, file: $SHELL_FOLDER/Brewfile"
	brew bundle --file="$SHELL_FOLDER"/Brewfile
}

#######################################
# Install brew cask packages
#######################################
install_oh_my_zsh() {
	msg "Install oh_my_zsh?"
	[ "$SET_ALL" ] && read -p "[y]es or [n]o (default: no) : " -r answer
	[ "$answer" != "${answer#[Yy]}" ] || $SET_ALL && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
}

#######################################
# install clipboard-provider
# supoort osc52 copy remote vim clipboard
#######################################
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

#######################################
# Configure git
# Globals:
#   answer
# Arguments:
#   None
#
#
#######################################
configure_git() {
	if grep -q "ghproxy" /etc/hosts; then
		# add git proxy for Mainland China users
		msg "Add git proxy for Mainland China users?"
		[ "$SET_ALL" ] && read -p "[y]es or [n]o (default: no) : " -r answer
		[ "$answer" != "${answer#[Yy]}" ] || $SET_ALL && printf 'mirror.ghproxy.com github.com\nmirror.ghproxy.com raw.githubusercontent.com\n' | sudo tee -a /etc/hosts
	fi
}

#######################################
# Configure git
# Globals:
#   answer
# Arguments:

#######################################
configure_nvim() {
	msg "Configure nvim?"
	[ "$SET_ALL" ] && read -p "[y]es or [n]o (default: no) : " -r answer

	if dir_is_exists "$HOME"/.config/nvim; then
		mv "$HOME"/.config/nvim "$HOME/.config/nvim_$(date +'%Y-%m-%dT%H:%M:%S').bak"
	fi

	[ "$answer" != "${answer#[Yy]}" ] || $SET_ALL && ln -s "$SHELL_FOLDER"/.config/nvim "$HOME"/.config/nvim
}

#######################################
# Configure golang
#######################################
configure_go() {
	if [ -z "$GOPROXY" ]; then
		msg "Use go proxy for Mainland China users?"
		[ "$SET_ALL" ] && read -p "[y]es or [n]o (default: no) : " -r answer
		[ "$answer" != "${answer#[Yy]}" ] || $SET_ALL && go env -w GOPROXY=https://goproxy.cn,direct
	fi
}

#######################################
# Configure tmux
#######################################
configure_tmux() {
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

#######################################
# Configure bash
#######################################
configure_bash() {
	if file_is_exists "$HOME"/.bashrc; then
		if file_is_exists "$HOME"/.config.sh; then
			mv "$HOME"/.config.sh "$HOME/.config_$(date +'%Y-%m-%dT%H:%M:%S').sh.backup"
		fi

		ln -s "$SHELL_FOLDER"/.config.sh "$HOME"/.config.sh
		temp="[ -f ~/.config.sh ] && source ~/.config.sh"
		# if $temp not in "$HOME"/.bashrc and "$HOME"/.bashrc exist then append $temp to "$HOME"/.bashrc
		if ! file_contain_string "$temp" "$HOME"/.bashrc; then
			printf "%s" "$temp" >>"$HOME"/.bashrc
		fi
	fi
}

#######################################
# Configure zsh
#######################################
configure_zsh() {
	if file_is_exists "$HOME"/.zshrc; then
		# install zsh-autosuggestions
		msg "Installing zsh-autosuggestions"
		# shellcheck disable=2086
		git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && msg "Please add plugins=(zsh-autosuggestions) in ~/.zshrc"

		msg "Installing zsh-syntax-highlighting"
		git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting && msg "Please add plugins=(zsh-syntax-highlighting) in ~/.zshrc"

		msg "Installing powerlevel10k theme"
		git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-"$HOME"/.oh-my-zsh/custom}/themes/powerlevel10k && echo "ZSH_THEME=\"powerlevel10k/powerlevel10k\"" >>"$HOME"/.zshrc

		if file_is_exists "$HOME"/.config.sh; then
			mv "$HOME"/.config.sh "$HOME/.config_$(date +'%Y-%m-%dT%H:%M:%S').sh.backup"
		fi

		ln -s "$SHELL_FOLDER"/.config.sh "$HOME"/.config.sh
		msg "link config.sh to $HOME/.config.sh"

		temp="[ -f ~/.config.sh ] && source ~/.config.sh"
		# if $temp not in "$HOME"/.zshrc and "$HOME"/.zshrc exist then append $temp to "$HOME"/.zshrc
		if ! file_contain_string "$temp" "$HOME"/.zshrc; then
			printf "%s" "$temp" >>"$HOME"/.zshrc
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

#######################################
# Configure alacritty
#######################################
configure_alacritty() {
	if dir_is_exists "$HOME"/.config/alacritty; then
		mv "$HOME"/.config/alacritty "$HOME/.config/alacritty_$(date +'%Y-%m-%dT%H:%M:%S').backup"
	fi

	ln -s "$SHELL_FOLDER"/config/alacritty "$HOME"/.config/alacritty
	msg "link alacritty to $HOME/.config/alacritty"
}

#######################################
# Configure kitty
#######################################
configure_kitty() {
	if dir_is_exists "$HOME"/.config/kitty; then
		mv "$HOME"/.config/kitty "$HOME/.config/kitty_$(date +'%Y-%m-%dT%H:%M:%S').backup"
	fi

	ln -s "$SHELL_FOLDER"/config/kitty "$HOME"/.config/kitty
	msg "link kitty to $HOME/.config/kitty"
}

#######################################
# Configure git
#######################################
configure_git() {
	if file_is_exists "$HOME"/.gitconfig; then
		mv "$HOME"/.gitconfig "$HOME/.gitconfig_$(date +'%Y-%m-%dT%H:%M:%S').bak"
	fi

	ln -s "$CONFIG_FOLDER"/git/gitconfig "$HOME"/.gitconfig
	msg "link gitconfig to $HOME/.gitconfig"
}

#######################################
# Init path brefore run shell
#######################################
init_path() {
	PATH=$PATH:"$HOME"/.local/bin
	PATH=$PATH:"$HOME"/.local/share/bin
	PATH=$PATH:"$HOME"/.local/share/nvim/mason/bin
	PATH=$PATH:"$HOME"/.fzf/bin
	PATH=$PATH:"$HOME"/.cargo/bin
	PATH=$PATH:"$HOME"/.cargo/bin
	PATH=$PATH:/opt/homebrew/bin/
}

all() {
	SET_ALL=true
	install_brew
	install_brew_packages
	install_clipboard_provider
	configure_go
	configure_git
	configure_bash
	configure_nvim

	if command_is_exists tmux; then
		configure_tmux
	fi

	if command_is_exists zsh; then
		install_oh_my_zsh
		configure_zsh
	fi

	configure_alacritty
	configure_kitty
}

help() {
	echo "Usage: $0 [options]"
	echo "Options:"
	echo "  -a, --all       Install all"
	echo "  -b, --brew      Install brew and brew packages by Brewfile"
	echo "  -c, --clipboard Install clipboard-provider"
	echo "  -g, --git       Configure git"
	echo "  -n, --nvim      Configure nvim"
	echo "  -t, --tmux      Configure tmux"
	echo "  -z, --zsh       Configure zsh"
	echo "  -h, --help      Show help"
}

init_path
while [ $# -gt 0 ]; do
	case "$1" in
	-h | --help)
		help
		exit 0
		;;
	-a | --all)
		all
		exit 0
		;;
	-b | --brew)
		install_brew
		install_brew_packages
		exit 0
		;;
	-c | --clipboard)
		install_clipboard_provider
		exit 0
		;;
	-g | --git)
		configure_git
		exit 0
		;;
	-n | --nvim)
		configure_nvim
		exit 0
		;;
	-t | --tmux)
		configure_tmux
		exit 0
		;;
	-z | --zsh)
		configure_zsh
		exit 0
		;;
	*)
		help
		exit 0
		;;
	esac
done

help
