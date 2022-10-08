local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don"t error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

-- Install your plugins here
return packer.startup(function(use)
  -- My plugins here
  use "wbthomason/packer.nvim" -- Have packer manage itself
  use "nvim-lua/popup.nvim" -- An implementation of the Popup API from vim in Neovim
  use "nvim-lua/plenary.nvim" -- Useful lua functions used ny lots of plugins
  use "ahmedkhalf/project.nvim"
  use "folke/which-key.nvim"
  use {
    "ethanholz/nvim-lastplace",
    config = function()
      require("nvim-lastplace").setup {}
    end,
  }
  use "github/copilot.vim"
  use {
    "ThePrimeagen/refactoring.nvim",
    requires = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-treesitter/nvim-treesitter" },
    },
  }

  -- Colorschemes
  use "ellisonleao/gruvbox.nvim"
  use "lunarvim/darkplus.nvim"
  use "catppuccin/nvim"
  use "tanvirtin/monokai.nvim"
  use "bluz71/vim-nightfly-guicolors"
  use "folke/tokyonight.nvim"
  use {
    "rose-pine/neovim",
    as = "rose-pine",
    config = function()
      -- Set variant
      -- Defaults to 'dawn' if vim background is light
      -- @usage 'base' | 'moon' | 'dawn' | 'rose-pine[-moon][-dawn]'
      vim.g.rose_pine_variant = "base"
    end,
  }
  use {
    "EdenEast/nightfox.nvim",
    config = function()
      require("nightfox").setup {}
    end,
  }
  use "projekt0n/github-nvim-theme"
  use "tiagovla/tokyodark.nvim"
  use "rebelot/kanagawa.nvim"

  -- cmp plugins
  use "hrsh7th/nvim-cmp" -- The completion plugin
  use "hrsh7th/cmp-buffer" -- buffer completions
  use "hrsh7th/cmp-cmdline" -- cmdline completions
  use "hrsh7th/cmp-path" -- path completions
  use "saadparwaiz1/cmp_luasnip" -- snippet completions
  use "hrsh7th/cmp-nvim-lsp" -- nvim cmp lsp
  use "hrsh7th/cmp-nvim-lua" -- nvim cmp lua
  use "f3fora/cmp-spell"
  use "kdheepak/cmp-latex-symbols"
  use {
    "tzachar/cmp-tabnine",
    -- config = function()
    --   local cfg = {
    --     max_lines = 1000,
    --     max_num_results = 5,
    --     sort = true,
    --     run_on_every_keystroke = true,
    --   }
    --   require("cmp_tabnine.config"):setup(cfg)
    -- end,
    run = "./install.sh",
  }
  use {
    "ray-x/lsp_signature.nvim",
    config = function()
      local cfg = {
        bind = true,
        hint_prefix = "✨ ",
      }
      require("lsp_signature").setup(cfg)
    end,
  }
  --[[ use { ]]
  --[[   "zbirenbaum/copilot.lua", ]]
  --[[   event = { "VimEnter" }, ]]
  --[[   config = function() ]]
  --[[     vim.defer_fn(function() ]]
  --[[       require("copilot").setup() ]]
  --[[     end, 100) ]]
  --[[   end, ]]
  --[[ } ]]
  --[[ use { ]]
  --[[   "zbirenbaum/copilot-cmp", ]]
  --[[   after = { "copilot.lua", "nvim-cmp" }, ]]
  --[[ } ]]
  use "windwp/nvim-autopairs" -- Autopairs, integrates with both cmp and treesitter
  use "numToStr/Comment.nvim" -- Easily comment stuff
  use "JoosepAlviste/nvim-ts-context-commentstring"
  use "antoinemadec/FixCursorHold.nvim" -- This is needed to fix lsp doc highlight

  -- snippets
  use "L3MON4D3/LuaSnip" --snippet engine
  use "rafamadriz/friendly-snippets" -- a bunch of snippets to use

  -- LSP
  use "neovim/nvim-lspconfig" -- enable LSP
  use "williamboman/nvim-lsp-installer" -- simple to use language server installer
  use "tamago324/nlsp-settings.nvim" -- language server settings defined in json for
  use "jose-elias-alvarez/null-ls.nvim" -- for formatters and linters
  use {
    "tami5/lspsaga.nvim",
    config = function()
      require("lspsaga").setup {
        -- code action title icon
        code_action_icon = " ",
      }
    end,
  }

  -- Telescope
  use "nvim-telescope/telescope.nvim"
  use "nvim-telescope/telescope-media-files.nvim"

  -- Treesitter
  use {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
  }
  use "p00f/nvim-ts-rainbow"
  use "windwp/nvim-ts-autotag"
  use {
    "romgrk/nvim-treesitter-context",
    config = function()
      require("treesitter-context").setup {
        enable = true,
        throttle = true,
      }
    end,
  }
  use "nvim-treesitter/nvim-treesitter-textobjects"
  use "mfussenegger/nvim-ts-hint-textobject"

  -- Git
  use "lewis6991/gitsigns.nvim"

  -- File tree
  use "kyazdani42/nvim-web-devicons"
  use "kyazdani42/nvim-tree.lua"

  -- Buffline
  use "akinsho/bufferline.nvim"
  use "moll/vim-bbye"

  -- Lualine
  use "nvim-lualine/lualine.nvim"

  -- DAP (Debug Adapter Protocol)
  use {
    "Pocco81/DAPInstall.nvim",
    branch = "dev",
  }
  use "mfussenegger/nvim-dap"
  use "theHamsta/nvim-dap-virtual-text"
  use "rcarriga/nvim-dap-ui"

  -- Tmux integration
  use {
    "christoomey/vim-tmux-navigator",
    config = function()
      vim.g.tmux_navigator_no_mappings = 1
    end,
  }

  -- EasyMotion
  use {
    "phaazon/hop.nvim",
    branch = "v1",
    config = function()
      require("hop").setup()
    end,
  }

  -- Show color
  use {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end,
  }

  -- Generate function signatures
  use {
    "danymat/neogen",
    config = function()
      require("neogen").setup {}
    end,
    requires = "nvim-treesitter/nvim-treesitter",
  }

  -- Todo plugin
  use {
    "folke/todo-comments.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = function()
      require("todo-comments").setup {}
    end,
    event = "BufRead",
  }

  -- ToggleTerm
  use "akinsho/toggleterm.nvim"

  -- Improve load time
  use "lewis6991/impatient.nvim"

  -- Ident line
  -- use("lukas-reineke/indent-blankline.nvim")

  -- Dashboard alpha
  use "goolord/alpha-nvim"

  -- Notify
  use {
    "rcarriga/nvim-notify",
    requires = { "nvim-telescope/telescope.nvim" },
  }

  use {
    "folke/noice.nvim",
    requires = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
  }

  -- DiffView
  use {
    "sindrets/diffview.nvim",
    requires = { "nvim-lua/plenary.nvim" },
  }

  -- Neorg
  use {
    "nvim-neorg/neorg",
    requires = "nvim-lua/plenary.nvim",
  }

  use "nvim-orgmode/orgmode"

  use "RRethy/vim-illuminate"

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
