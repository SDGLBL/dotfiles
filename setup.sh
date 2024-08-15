#!/usr/bin/env bash

# Unified Setup Script for Ubuntu/CentOS/macOS
# Version: 1.2.0

# Function to safely source files
safe_source() {
  if [[ -f "$1" ]]; then
    set +u
    . "$1"
    set -u
  fi
}

# Safely source .bashrc and .profile
safe_source ~/.bashrc
safe_source ~/.profile

# Enable strict mode
set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Global variables
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
CONFIG_DIR="$SCRIPT_DIR/.config"
LOG_FILE="$SCRIPT_DIR/setup_log.txt"

# Version numbers for directly downloaded tools
GO_VERSION="1.21.1"
NODE_VERSION="16.14.2"
NEOVIM_VERSION="0.10.1"

# Check if user is root
is_root() {
  return $(id -u)
}

# Function to use sudo if not root
maybe_sudo() {
  if is_root; then
    "$@"
  else
    sudo "$@"
  fi
}

# Function to output colored text
output() {
  local color=$1
  local message=$2
  echo -e "${color}${message}${NC}"
}

# Function to log messages
log() {
  local message=$1
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] $message" >>"$LOG_FILE"
}

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Function to detect the OS
detect_os() {
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if [ -f /etc/os-release ]; then
      . /etc/os-release
      OS=$NAME
    elif [ -f /etc/lsb-release ]; then
      . /etc/lsb-release
      OS=$DISTRIB_ID
    elif [ -f /etc/debian_version ]; then
      OS="Debian"
    elif [ -f /etc/redhat-release ]; then
      OS="CentOS"
    else
      OS="Unknown Linux"
    fi
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macOS"
  else
    OS="Unknown"
  fi
  output $BLUE "Detected OS: $OS"
  log "Detected OS: $OS"
}

# Function to install basic tools based on OS
install_basic_tools() {
  output $BLUE "Installing basic tools..."
  case $OS in
  "Ubuntu")
    maybe_sudo apt update
    maybe_sudo apt install -y git wget curl
    ;;
  "CentOS")
    maybe_sudo yum update -y
    maybe_sudo yum install -y git wget curl
    ;;
  "macOS")
    if ! command_exists brew; then
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    brew install git wget curl
    ;;
  *)
    output $RED "Unsupported OS for automatic basic tool installation"
    exit 1
    ;;
  esac
  output $GREEN "Basic tools installed successfully"
  log "Basic tools installed"
}

# Function to install Python
install_python() {
  output $BLUE "Installing Python..."
  case $OS in
  "Ubuntu")
    maybe_sudo apt install -y python3 python3-pip python3-venv
    ;;
  "CentOS")
    maybe_sudo yum install -y python3 python3-pip
    ;;
  "macOS")
    brew install python
    ;;
  *)
    output $RED "Unsupported OS for automatic Python installation"
    return 1
    ;;
  esac
  output $GREEN "Python installed successfully"
  log "Python installed"
}

# Function to install Go
install_go() {
  output $BLUE "Installing Go version $GO_VERSION..."
  local go_archive="go$GO_VERSION.linux-amd64.tar.gz"
  local download_url="https://golang.org/dl/$go_archive"

  if [[ $OS == "macOS" ]]; then
    go_archive="go$GO_VERSION.darwin-amd64.tar.gz"
    download_url="https://golang.org/dl/$go_archive"
  fi

  wget "$download_url"
  maybe_sudo tar -C /usr/local -xzf "$go_archive"
  rm "$go_archive"

  echo 'export PATH=$PATH:/usr/local/go/bin' >>"$HOME/.profile"
  export PATH=$PATH:/usr/local/go/bin

  output $GREEN "Go installed successfully"
  log "Go installed"
}

# Function to install Rust
install_rust() {
  output $BLUE "Installing Rust..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  safe_source "$HOME/.cargo/env"
  output $GREEN "Rust installed successfully"
  log "Rust installed"
}

# Function to install Node.js
install_nodejs() {
  output $BLUE "Installing Node.js version $NODE_VERSION..."
  case $OS in
  "Ubuntu" | "CentOS")
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
    safe_source "$HOME/.nvm/nvm.sh"
    nvm install "$NODE_VERSION"
    nvm use "$NODE_VERSION"
    ;;
  "macOS")
    brew install node@$NODE_VERSION
    ;;
  *)
    output $RED "Unsupported OS for automatic Node.js installation"
    return 1
    ;;
  esac
  output $GREEN "Node.js installed successfully"
  log "Node.js installed"
}

# Function to install development environments
install_dev_environments() {
  output $BLUE "Installing development environments..."

  install_python
  install_go
  install_rust
  install_nodejs

  output $GREEN "Development environments installed successfully"
  log "Development environments installed"
}

# Function to install Neovim
install_neovim() {
  output $BLUE "Installing Neovim version $NEOVIM_VERSION..."
  case $OS in
  "Ubuntu")
    maybe_sudo apt-get install -y software-properties-common
    maybe_sudo add-apt-repository ppa:neovim-ppa/stable -y
    maybe_sudo apt-get update
    maybe_sudo apt-get install -y neovim
    ;;
  "CentOS")
    maybe_sudo yum install -y epel-release
    maybe_sudo yum install -y neovim python3-neovim
    ;;
  "macOS")
    brew install neovim
    ;;
  *)
    output $RED "Unsupported OS for automatic Neovim installation"
    return 1
    ;;
  esac
  output $GREEN "Neovim installed successfully"
  log "Neovim installed"
}

# Function to create symlink
create_symlink() {
  local source="$1"
  local target="$2"
  if [ -e "$target" ]; then
    output $YELLOW "Backing up existing $target"
    mv "$target" "${target}.backup_$(date +%Y%m%d_%H%M%S)"
  fi
  ln -s "$source" "$target"
  output $GREEN "Created symlink: $target -> $source"
}

# Function to configure Neovim
configure_neovim() {
  output $BLUE "Configuring Neovim..."
  mkdir -p ~/.config/nvim
  cat >~/.config/nvim/init.vim <<EOL
set number
set relativenumber
set autoindent
set tabstop=4
set shiftwidth=4
set smarttab
set softtabstop=4
set mouse=a
EOL
  output $GREEN "Neovim configured successfully"
  log "Neovim configured"
}

# Function to install tmux
install_tmux() {
  output $BLUE "Installing tmux..."
  case $OS in
  "Ubuntu")
    maybe_sudo apt-get install -y tmux
    ;;
  "CentOS")
    maybe_sudo yum install -y tmux
    ;;
  "macOS")
    brew install tmux
    ;;
  *)
    output $RED "Unsupported OS for automatic tmux installation"
    return 1
    ;;
  esac
  output $GREEN "tmux installed successfully"
  log "tmux installed"
}

# Function to install Zsh
install_zsh() {
  output $BLUE "Installing Zsh..."
  case $OS in
  "Ubuntu")
    maybe_sudo apt-get install -y zsh
    ;;
  "CentOS")
    maybe_sudo yum install -y zsh
    ;;
  "macOS")
    brew install zsh
    ;;
  *)
    output $RED "Unsupported OS for automatic Zsh installation"
    return 1
    ;;
  esac
  output $GREEN "Zsh installed successfully"
  log "Zsh installed"
}

# Function to install Oh My Zsh
install_oh_my_zsh() {
  output $BLUE "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  output $GREEN "Oh My Zsh installed successfully"
  log "Oh My Zsh installed"
}

# Function to configure dotfiles
configure_dotfiles() {
  output $BLUE "Configuring dotfiles..."

  # Create symlink for .config directory
  create_symlink "$SCRIPT_DIR/config" "$HOME/.config"

  # Create symlink for .tmux.conf
  create_symlink "$SCRIPT_DIR/.tmux.conf" "$HOME/.tmux.conf"

  # Create symlink for .config.sh
  create_symlink "$SCRIPT_DIR/.config.sh" "$HOME/.config.sh"

  # Update .bashrc and .zshrc to source .config.sh
  for rc_file in "$HOME/.bashrc" "$HOME/.zshrc"; do
    if [ -f "$rc_file" ]; then
      if ! grep -q "source ~/.config.sh" "$rc_file"; then
        echo '[ -f ~/.config.sh ] && source ~/.config.sh' >>"$rc_file"
        output $GREEN "Updated $rc_file to source .config.sh"
      fi
    fi
  done

  output $GREEN "Dotfiles configured successfully"
  log "Dotfiles configured"
}

# Function to install and configure editor and terminal tools
# Function to install and configure editor and terminal tools
install_editor_terminal_tools() {
  output $BLUE "Installing and configuring editor and terminal tools..."

  install_neovim
  install_tmux
  install_zsh
  install_oh_my_zsh
  configure_dotfiles

  output $GREEN "Editor and terminal tools installed and configured successfully"
  log "Editor and terminal tools installed and configured"
}

# Function to install fzf
install_fzf() {
  output $BLUE "Installing fzf..."
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install --all
  output $GREEN "fzf installed successfully"
  log "fzf installed"
}

# Function to install bat
install_bat() {
  output $BLUE "Installing bat..."
  case $OS in
  "Ubuntu")
    maybe_sudo apt-get install -y bat
    ;;
  "CentOS")
    maybe_sudo yum install -y bat
    ;;
  "macOS")
    brew install bat
    ;;
  *)
    output $RED "Unsupported OS for automatic bat installation"
    return 1
    ;;
  esac
  output $GREEN "bat installed successfully"
  log "bat installed"
}

# Function to install extra tools
install_extra_tools() {
  output $BLUE "Installing extra tools..."

  install_fzf
  install_bat

  output $GREEN "Extra tools installed successfully"
  log "Extra tools installed"
}

# Function to display menu
display_menu() {
  echo "Please select the components you want to install:"
  echo "1) Basic tools"
  echo "   - Git: Version control system"
  echo "   - Wget: File retrieval tool"
  echo "   - Curl: Command line tool for transferring data"
  echo ""
  echo "2) Development environments"
  echo "   - Python (version 3.x): Programming language"
  echo "   - Go (version $GO_VERSION): Programming language"
  echo "   - Rust: Systems programming language"
  echo "   - Node.js (version $NODE_VERSION): JavaScript runtime"
  echo ""
  echo "3) Editor and terminal tools"
  echo "   - Neovim (version $NEOVIM_VERSION): Hyper-extensible Vim-based text editor"
  echo "   - tmux: Terminal multiplexer"
  echo "   - Zsh: Extended Bourne Shell with many improvements"
  echo "   - Oh My Zsh: Framework for managing Zsh configuration"
  echo ""
  echo "4) Extra tools"
  echo "   - fzf: Command-line fuzzy finder"
  echo "   - bat: A cat clone with syntax highlighting and Git integration"
  echo ""
  echo "5) All of the above"
  echo "   Install all tools and environments listed in options 1-4"
  echo ""
  echo "6) Exit"
  echo "   Quit the setup script"
  echo ""
}

# Function to get user choice
get_user_choice() {
  local choice
  read -p "Enter your choice [1-6]: " choice
  echo $choice
}

# Function to handle user choice
handle_choice() {
  local choice=$1
  case $choice in
  1) install_basic_tools ;;
  2) install_dev_environments ;;
  3) install_editor_terminal_tools ;;
  4) install_extra_tools ;;
  5)
    install_basic_tools
    install_dev_environments
    install_editor_terminal_tools
    install_extra_tools
    ;;
  6)
    output $YELLOW "Exiting..."
    exit 0
    ;;
  *)
    output $RED "Invalid choice. Please try again."
    return 1
    ;;
  esac
}

# Error handling function
handle_error() {
  output $RED "An error occurred. Please check the log file for details: $LOG_FILE"
  log "Error occurred: $1"
  exit 1
}

# Main function
main() {
  output $BLUE "Starting unified setup script..."
  log "Script started"

  detect_os

  while true; do
    display_menu
    choice=$(get_user_choice)
    handle_choice $choice || continue

    read -p "Do you want to perform another action? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      break
    fi
  done

  output $GREEN "Setup completed successfully!"
  log "Script completed"
}

# Set up error handling
trap 'handle_error "$BASH_COMMAND"' ERR

# Run the main function
main "$@"
