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
require("system").setup {}

```

### Default Configure

```lua
local default_config = {
  -- duskfox,nightfly,nightfox,github_dimmed,tokyonight,sonokai,onedarkpro,monokai_soda,catppuccin,tokyodark,kanagawa,material
  colorscheme = "kanagawa",
  -- `lsp`
  lsp = true,
  -- `dap`
  -- Debug Adapter Protocol client implementation for Neovim
  -- [nvim-dap](https://github.com/mfussenegger/nvim-dap)
  dap = false,
  -- tint
  -- Dim inactive windows in Neovim using window-local highlight namespaces.
  -- [tint.nvim](https://github.com/levouh/tint.nvim)
  tint = false,
  -- `refactor`
  -- The Refactoring library based off the Refactoring book by Martin Fowler
  -- [refactoring.nvim](https://github.com/ThePrimeagen/refactoring.nvim)
  refactor = false,
  -- `autopairs`
  -- autopairs for neovim written by lua
  -- [nvim-autopairs](https://github.com/windwp/nvim-autopairs)
  autopairs = true,
  -- `rust_tools`
  -- Tools for better development in rust using neovim's builtin lsp
  -- [rust-tools.nvim](https://github.com/simrat39/rust-tools.nvim)
  rust_tools = false,
  -- `color_picker`
  -- Super powerful color picker / colorizer plugin.
  -- [ccc.nvim](https://github.com/uga-rosa/ccc.nvim)
  color_picker = false,
  --`markdown_preview`
  -- markdown preview plugin for (neo)vim
  -- [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim)
  markdown_preview = false,
  -- `org`
  -- Orgmode clone written in Lua for Neovim 0.7+.
  -- [orgmode](https://github.com/nvim-orgmode/orgmode)
  org = false,
  -- `neorg`
  -- Modernity meets insane extensibility. The future of organizing your life in Neovim.
  -- [neorg](https://github.com/nvim-neorg/neorg)
  neorg = false,
  -- `better_fold`
  -- Not UFO in the sky, but an ultra fold in Neovim.
  -- [nvim-ufo](https://github.com/kevinhwang91/nvim-ufo)
  better_fold = false,
  -- `better_tui`
  -- 💥 Highly experimental plugin that completely replaces the UI for messages, cmdline and the popupmenu.
  -- [noice.nvim](https://github.com/folke/noice.nvim)
  better_tui = false,
  -- `format_on_save`
  -- Format your code on save
  format_on_save = true,
  -- `transparent_window`
  -- Transparent window
  transparent_window = false,
  autocmds = {
    custom_groups = {},
  },
  -- `pre_hook`
  -- execute before loading configs
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
