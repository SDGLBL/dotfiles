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
