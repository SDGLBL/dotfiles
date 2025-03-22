<h1 align="center">Welcome to Dotfiles 👋</h1>
<p>
</p>

> A dotfiles support full stack development in terminal

## Features

### Neovim Configuration

Requires Neovim >= 0.10.0

#### Core Features

- Full LSP support with blink.cmp based completion (modern replacement for nvim-cmp)
- Treesitter-based syntax highlighting and indentation
- Git integration tools
- Debug Adapter Protocol (DAP) support
- Remote SSH copy & paste support
- Fuzzy finding with Telescope
- Automatic LSP server installation
- Copilot integration
- Advanced AI coding assistance with CodeCompanion

#### Language Support

Pre-configured support for:

- Lua
- Python
- Golang
- Rust
- JavaScript/TypeScript
- HTML/CSS
- Docker
- JSON/YAML
- Markdown
- And more...

#### Themes

Integrated themes include:

- Catppuccin
- Gruvbox
- Rose Pine
- Tokyo Night
- Night Fox
- Material
- And many more...

### Terminal Tools

Essential CLI tools included:

- [duf](https://github.com/muesli/duf) - Disk usage analyzer
- [fzf](https://github.com/junegunn/fzf) - Fuzzy finder
- [bat](https://github.com/sharkdp/bat) - Modern cat replacement
- [exa](https://github.com/ogham/exa) - Modern ls replacement
- [ripgrep](https://github.com/BurntSushi/ripgrep) - Fast grep replacement
- [delta](https://github.com/dandavison/delta) - Git diff viewer
- [lazygit](https://github.com/jesseduffield/lazygit) - Git TUI

## Prerequisites

### Ubuntu/Debian

```bash
sudo apt install make gcc git python3 zsh curl wget tmux libc6-dev
```

### macOS

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install gcc make g++ git python3 zsh libc6-dev wget curl tmux
```

## Installation

For Linux systems:

```sh
./setup.sh -a
```

For macOS systems:

```sh
./setup_macos.sh -a
```

Use `-h` or `--help` flag to see all available options:

```sh
./setup.sh -h
# or
./setup_macos.sh -h
```

## Configuration

### API Tokens and Secrets

This repository includes a secure mechanism for storing and using API tokens and secrets without exposing them in your Git history.

#### Initial Setup

1. Create a `.token.sh` file in the root of the repository (a template is provided at `.token.sh.template`):

```bash
cp .token.sh.template .token.sh
```

2. Edit the file to add your API keys and other secrets:

```bash
vim .token.sh
```

3. Add the `TOKEN_DECODE_PASSWORD` to your `~/.zshrc` file:

```bash
echo 'export TOKEN_DECODE_PASSWORD="your_secure_password"' >> ~/.zshrc
source ~/.zshrc
```

4. The Git hooks will automatically encrypt your `.token.sh` when committing changes and decrypt it when checking out or pulling.

#### How It Works

- `.token.sh` contains your sensitive data and is excluded from Git
- `.token.sh.enc` is an encrypted version that is safe to commit
- Git hooks automatically handle encryption/decryption using OpenSSL
- The encryption password is stored in your `~/.zshrc` as `TOKEN_DECODE_PASSWORD`

#### Manual Operations

If you need to manually encrypt or decrypt the file:

```bash
# Encrypt
openssl enc -aes-256-cbc -salt -pbkdf2 -pass "pass:$TOKEN_DECODE_PASSWORD" -in .token.sh -out .token.sh.enc

# Decrypt
openssl enc -aes-256-cbc -d -salt -pbkdf2 -pass "pass:$TOKEN_DECODE_PASSWORD" -in .token.sh.enc -out .token.sh
```

### Neovim

The main Neovim configuration file is located at `~/.config/nvim/init.lua`. You can customize settings by editing this file:

```lua
require("configs").setup({
  -- Choose your colorscheme
  dark_colorscheme = "rose-pine-moon",
  light_colorscheme = "catppuccin-latte",

  -- Enable features
  dap = true,         -- Debug adapter protocol
  format_on_save = true,
  transparent_window = true,

  -- Language support
  go = true,
  rust = true,
  python = true,

  -- Additional features
  autopairs = false,
  markdown_preview = true
})
```

## Project Structure

```
.
├── Brewfile
├── config -> .config
├── Dockerfile
├── README.md
├── setup.sh
└── setup_macos.sh
```

## Author

👤 **sdglbl**

- Github: [@sdglbl](https://github.com/sdglbl)

## Show your support

Give a ⭐️ if this project helped you!

## License

This project is [MIT](LICENSE) licensed.

---

_This README was generated with ❤️_
