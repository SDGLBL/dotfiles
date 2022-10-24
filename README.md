<h1 align="center">Welcome to Dotfiles 👋</h1>
<p>
</p>

> a dotfiles support full stack dev in terminal

## Contents

- vim(Neovim >= 0.8) config support full stack dev
- tmux config contain pretty themes and useful tools
- useful terminal tools

### Neovim

Requires Neovim >= 0.8

### Contains

- Git tools
- Better folding
- Keymaps shortcuts
- Better lsp signature
- Dap debug tools support
- **Remote ssh copy & paste support**
- Fuzzy finder with telescope
- Lsp install and update tools
- Treesitter highlight and indent
- Full lsp support with nvim-cmp based on neovim internal lsp
- Snippets with luasnip containing snippets for all languages
- ETC....

### Configure

```lua
-- .config/nvim/init.lua or open nvim and press c
require("system.setup").setup {
  transparent_window = false, -- make background transparent
  format_on_save = true,
  better_fold = true,
  better_tui = false,
  colorscheme_config = {
    -- duskfox,nightfly,nightfox,github_dimmed,tokyonight,sonokai,onedarkpro,monokai_soda,catppuccin,tokyodark,kanagawa,material
    colorscheme = "kanagawa",
    config = function()
      -- auto change background by time
      vim.o.background = require("user.utils.time").is_dark() and "dark" or "light"
      -- colorscheme style
      vim.g.material_style = "darker" -- darker,lighter,oceanic,palenight,deep ocean
      vim.g.sonokai_style = "maia" -- `'default'`, `'atlantis'`, `'andromeda'`, `'shusia'`, `'maia'`, `'espresso'`
      vim.g.tokyonight_style = "night"
      vim.g.tokyonight_sidebars = { "qf", "vista_kind", "terminal", "packer" }
      vim.g.catppuccin_flavour = "mocha" -- latte, frappe, macchiato, mocha
    end,
  },
  active_neorg = false,
  active_org = false,
  active_autopairs = true,
  active_lsp = true,
  active_refactor = true,
  active_dap = false,
  active_tint = false,
  autocmds = {
    custom_groups = {
      { "BufWinEnter", "*.go", "setlocal ts=4 sw=4" },
      { "BufWinEnter", "*.c", "setlocal ts=4 sw=4" },
      { "BufWinEnter", "*.cpp", "setlocal ts=4 sw=4" },
      { "BufWinEnter", "*.h", "setlocal ts=4 sw=4" },
      { "BufWinEnter", "*.php", "setlocal ts=4 sw=4" },
    },
  },
  pre_hook = function()
    -- conda setup
    if os.getenv "conda_prefix" ~= "" and os.getenv "conda_prefix" ~= nil then
      vim.g.python3_host_prog = os.getenv "conda_prefix" .. "/bin/python"
    end
  end,
  after_hook = function()
    -- do noting
  end,
}

```

### Example

![Usage](/gifs/use.gif)

#### Themes

- [gruvbox](https://github.com/ellisonleao/gruvbox.nvim)
- [darkplus](https://github.com/martinsione/darkplus.nvim)
- [catppuccin](https://github.com/catppuccin/nvim)
- [monokai](https://github.com/tanvirtin/monokai.nvim)
- [nightfly](https://github.com/bluz71/vim-nightfly-guicolors)
- [tokyonight](https://github.com/folke/tokyonight.nvim)
- [rose-pine](https://github.com/rose-pine/neovim)
- [nightfox](https://github.com/EdenEast/nightfox.nvim)
- [github-nvim-theme](https://github.com/projekt0n/github-nvim-theme)
- [tokyodark](https://github.com/tiagovla/tokyodark.nvim)
- [kanagawa](https://github.com/rebelot/kanagawa.nvim)
- [material](https://github.com/marko-cerovac/material.nvim)

#### Plugins

- [packer.nvim](https://github.com/wbthomason/packer.nvim) - A plugin manager for Neovim
- [project.nvim](https://github.com/ahmedkhalf/project.nvim) - The superior project management solution for neovim.
- [whick-key](https://github.com/folke/which-key.nvim) - A lua plugin for Neovim 0.5 that displays a popup with possible keybindings of the command you started typing.
- [nvim-lastplace](https://github.com/ethanholz/nvim-lastplace) - Intelligently reopen files at your last edit position in Vim.
- [copilot.vim](https://github.com/github/copilot.vim) - Copilot
- [refactoring.nvim](https://github.com/ThePrimeagen/refactoring.nvim) - Refactoring
- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) - A completion engine plugin for neovim written in Lua.
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) - Enable LSP
- [nvim-lsp-installer](https://github.com/williamboman/nvim-lsp-installer) - Simple to use language server installer
- [nlsp-settings.nvim](http://github.com/tamago324/nlsp-settings.nvim) - language server settings defined in json form
- [null-ls.nvim](http://github.com/jose-elias-alvarez/null-ls.nvim) - Formatters and linters
- [lspsaga.nvim](https://github.com/tami5/lspsaga.nvim) - A light-weight lsp plugin based on neovim's built-in lsp with a highly performant UI
- [lsp_signature](https://github.com/ray-x/lsp_signature.nvim) - Better lsp signature.
- [nvim-autopairs](https://github.com/windwp/nvim-autopairs) - Autopairs
- [Comment.nvim](https://github.com/numToStr/Comment.nvim) - Easily comment stuff
- [LuaSnip](https://github.com/L3MON4D3/LuaSnip) - Snippet engine.
- [friendly-snippets](https://github.com/rafamadriz/friendly-snippets) - A bunch of snippets to use.
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) - Telescope is a highly extendable fuzzy finder over lists.
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) - Treesitter configurations and abstraction layer
- [nvim-ts-rainbow](https://github.com/p00f/nvim-ts-rainbow) - Rainbow parentheses
- [nvim-ts-autotag](https://github.com/windwp/nvim-ts-autotag) - Auto close for html,jsx,txs
- [nvim-treesitter-context](https://github.com/romgrk/nvim-treesitter-context) - Show func or class statement
- [nvim-ts-hint-textobject](https://github.com/nvim-treesitter/nvim-treesitter-textobjects) - Hint textobject
- [nvim-web-devicons](https://github.com/kyazdani42/nvim-web-devicons) - Devicons
- [nvim-tree.lua](https://github.com/kyazdani42/nvim-tree.lua) - File explorer
- [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator) - Tmux navigation
- [hop.nvim](https://github.com/phaazon/hop.nvim) - Easy motion without messing with your buffer
- ETC...

### Terminal Tools

- [duf](https://github.com/muesli/duf) - Disk Usage/Free Utility - a better 'df' alternative
- [dua-cli](https://github.com/Byron/dua-cli) - A tool to conveniently learn about the space usage of directories on your disk
- [fzf](https://github.com/junegunn/fzf) - A command-line fuzzy finder
- [bat](https://www.google.com/search?client=firefox-b-d&q=bat+github) - A cat(1) clone with wings.
- [exa](https://github.com/ogham/exa) - A modern replacement for ‘ls’.
- [ripgrep](https://github.com/BurntSushi/ripgrep) - ripgrep recursively searches directories for a regex pattern
- [delta](https://github.com/dandavison/delta) - A viewer for git and diff output
- [lazygit](https://github.com/jesseduffield/lazygit) - simple terminal UI for git commands

## Prerequisites

### Ubuntu >= 18.04

```bash
sudo apt install make gcc git python3 zsh curl wget tmux libc6-dev
```

### Macos

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install gcc make g++ git python3 zsh libc6-dev wget curl tmux
```

### Debian

```bash
sudo yum install make gcc git python3 zsh curl wget tmux zsh
```

## Install

```sh
./setup.sh -a
```

## Usage

```sh
./setup.sh -h or ./setup.sh --help
```

## Author

👤 **sdglbl**

- Github: [@sdglbl](https://github.com/sdglbl)

## Show your support

Give a ⭐️ if this project helped you!

---

_This README was generated with ❤️ by [readme-md-generator](https://github.com/kefranabg/readme-md-generator)_
