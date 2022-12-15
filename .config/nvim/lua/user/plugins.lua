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
  max_jobs = 30,
}

-- Install your plugins here
return packer.startup(function(use)
  --- Basic plugins
  -- Have packer manage itself
  use "wbthomason/packer.nvim"
  -- An implementation of the Popup API from vim in Neovim
  use "nvim-lua/popup.nvim"
  -- Useful lua functions used ny lots of plugins
  use "nvim-lua/plenary.nvim"
  use "ahmedkhalf/project.nvim"
  use "folke/which-key.nvim"
  -- Remember lastplace
  use {
    "ethanholz/nvim-lastplace",
    config = function()
      require("nvim-lastplace").setup {}
    end,
  }
  -- Github copilot
  use "github/copilot.vim"
  -- Improve load time
  use "lewis6991/impatient.nvim"
  -- ToggleTerm
  use "akinsho/toggleterm.nvim"
  -- Dashboard alpha
  use "goolord/alpha-nvim"
  -- Notify
  use {
    "rcarriga/nvim-notify",
    requires = { "nvim-telescope/telescope.nvim" },
  }
  -- Telescope
  use "nvim-telescope/telescope.nvim"
  use "nvim-telescope/telescope-media-files.nvim"
  -- Treesitter
  use {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    requires = {
      "p00f/nvim-ts-rainbow",
      "windwp/nvim-ts-autotag",
      "mfussenegger/nvim-ts-hint-textobject",
      "nvim-treesitter/nvim-treesitter-textobjects",
      {
        "romgrk/nvim-treesitter-context",
        config = function()
          require("treesitter-context").setup {
            enable = true,
            throttle = true,
          }
        end,
      },
      {
        "ThePrimeagen/refactoring.nvim",
        config = function()
          require "user.refactor"
        end,
        cond = function()
          return _G.configs.refactor
        end,
      },
      {
        "m-demare/hlargs.nvim",
        config = function()
          require("hlargs").setup()
        end,
      },
    },
  }

  -- Colorschemes
  use "folke/tokyonight.nvim"
  use "rebelot/kanagawa.nvim"
  use "tanvirtin/monokai.nvim"
  use "lunarvim/darkplus.nvim"
  use "tiagovla/tokyodark.nvim"
  use "ellisonleao/gruvbox.nvim"
  use "projekt0n/github-nvim-theme"
  use "marko-cerovac/material.nvim"
  use "bluz71/vim-nightfly-guicolors"
  use { "catppuccin/nvim", as = "catppuccin" }
  use { "rose-pine/neovim", as = "rose-pine" }
  use {
    "EdenEast/nightfox.nvim",
    config = function()
      require("nightfox").setup {}
    end,
  }

  -- cmp plugins
  -- The completion plugin
  use {
    "hrsh7th/nvim-cmp",
    requires = {
      { "hrsh7th/cmp-path" },
      { "f3fora/cmp-spell" },
      { "folke/neodev.nvim" },
      { "hrsh7th/cmp-emoji" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-copilot" },
      { "hrsh7th/cmp-cmdline" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "saadparwaiz1/cmp_luasnip" },
      {
        "David-Kunz/cmp-npm",
        event = { "BufRead package.json" },
        requires = {
          "nvim-lua/plenary.nvim",
        },
        config = function()
          require("cmp-npm").setup {}
        end,
      },
      { "kdheepak/cmp-latex-symbols", ft = "plaintext" },
      { "b0o/schemastore.nvim" },
    },
    config = function()
      require "user.cmp"
      require "user.autopairs"
    end,
    cond = function()
      return _G.configs.lsp
    end,
  }

  use "windwp/nvim-autopairs"
  use "numToStr/Comment.nvim"
  use "JoosepAlviste/nvim-ts-context-commentstring"

  -- Snippets
  use "L3MON4D3/LuaSnip"
  use "rafamadriz/friendly-snippets"

  -- LSP
  use {
    "neovim/nvim-lspconfig",
    requires = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "jayp0521/mason-nvim-dap.nvim",
      "jayp0521/mason-null-ls.nvim",
      "jose-elias-alvarez/null-ls.nvim",
      {
        "ray-x/lsp_signature.nvim",
        config = function()
          local cfg = {
            bind = true,
            wrap = true,
            hint_prefix = " ",
          }
          require("lsp_signature").setup(cfg)
        end,
      },
    },
    config = function()
      require "user.lsp"
    end,
    cond = function()
      return _G.configs.lsp
    end,
  }

  -- nvim-surround
  use {
    "kylechui/nvim-surround",
    config = function()
      require("nvim-surround").setup {}
    end,
  }

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

  use {
    "mfussenegger/nvim-dap",
    requires = {
      "theHamsta/nvim-dap-virtual-text",
      "rcarriga/nvim-dap-ui",
    },
    cond = function()
      return _G.configs.dap
    end,
  }

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
    branch = "v2",
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

  -- Ident line
  use {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require "user.indentline"
    end,
    cond = function()
      return _G.configs.indent_blankline
    end,
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
    ft = "norg",
    config = function()
      require "user.neorg"
    end,
    cond = function()
      return _G.configs.neorg
    end,
  }

  use "RRethy/vim-illuminate"

  use {
    "levouh/tint.nvim",
    config = function()
      require "user.tint"
    end,
    cond = function()
      return _G.configs.tint
    end,
  }

  -- better fold
  use {
    "kevinhwang91/nvim-ufo",
    requires = "kevinhwang91/promise-async",
    config = function()
      require "user.better_fold"
    end,
    cond = function()
      return _G.configs.better_fold
    end,
  }

  -- Goldsmith pluginplguins
  use {
    "WhoIsSethDaniel/goldsmith.nvim",
    requires = { -- dependencies
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    ft = "go",
    cond = function()
      return _G.configs.go_tools
    end,
  }

  -- GoImpl
  use {
    "edolphin-ydf/goimpl.nvim",
    ft = "go",
    config = function()
      local ok, telescope = pcall(require, "telescope")
      if ok then
        telescope.load_extension "goimpl"
      end
    end,
    cond = function()
      return _G.configs.go_tools
    end,
  }

  -- Markdown preview
  use {
    "iamcco/markdown-preview.nvim",
    run = function()
      vim.fn["mkdp#util#install"]()
    end,
    ft = "markdown",
    config = function()
      require "user.markdown_preview"
    end,
    cond = function()
      return _G.configs.markdown_preview
    end,
  }

  -- Generate github repo url link
  use {
    "SDGLBL/ggl.nvim",
    config = function()
      require("ggl").setup {}
    end,
    requires = { "rcarriga/nvim-notify" },
  }

  -- Color picker
  use {
    "uga-rosa/ccc.nvim",
    ft = { "javascriptreact", "javascript", "typescript", "typescriptreact", "css", "html", "lua" },
    config = function()
      require "user.ccc"
    end,
    cond = function()
      return _G.configs.color_picker
    end,
  }

  -- SnipRun
  use {
    "michaelb/sniprun",
    run = "bash ./install.sh",
  }

  -- Translate
  use {
    "uga-rosa/translate.nvim",
    config = function()
      require("translate").setup {
        default = {
          command = "google",
          output = "floating",
        },
        preset = {
          output = {
            split = {
              append = true,
            },
          },
        },
      }
    end,
  }

  -- Crates
  use {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    requires = { { "nvim-lua/plenary.nvim" } },
    config = function()
      require("crates").setup()
    end,
    cond = function()
      return _G.configs.rust_tools
    end,
  }

  -- Better neovim ui
  use "stevearc/dressing.nvim"

  -- Rust tools
  use {
    "simrat39/rust-tools.nvim",
    ft = "rust",
    config = function()
      require "user.rust_tools"
    end,
    cond = function()
      return _G.configs.rust_tools
    end,
  }

  -- Better code action menu
  use {
    "weilbith/nvim-code-action-menu",
    cmd = "CodeActionMenu",
  }

  use {
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup {}
    end,
  }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
