local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  }
end

vim.opt.runtimepath:prepend(lazypath)

require("lazy").setup {
  --- Basic plugins
  -- Have packer manage itself
  "wbthomason/packer.nvim",
  -- An implementation of the Popup API from vim in Neovim
  "nvim-lua/popup.nvim",
  -- ful lua functions d ny lots of plugins
  "nvim-lua/plenary.nvim",
  "ahmedkhalf/project.nvim",
  "folke/which-key.nvim",
  -- Remember lastplace
  {
    "ethanholz/nvim-lastplace",
    config = function()
      require("nvim-lastplace").setup {}
    end,
  },
  -- Github copilot
  "github/copilot.vim",
  -- Improve load time
  "lewis6991/impatient.nvim",
  -- ToggleTerm
  "akinsho/toggleterm.nvim",
  -- Dashboard alpha
  "goolord/alpha-nvim",
  -- Notify
  {
    "rcarriga/nvim-notify",
    dependencies = { "nvim-telescope/telescope.nvim" },
  },
  -- Telescope
  "nvim-telescope/telescope.nvim",
  "nvim-telescope/telescope-media-files.nvim",
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
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
        enabled = function()
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
  },
  -- Colorschemes
  "folke/tokyonight.nvim",
  "rebelot/kanagawa.nvim",
  "tanvirtin/monokai.nvim",
  "lunarvim/darkplus.nvim",
  "tiagovla/tokyodark.nvim",
  "ellisonleao/gruvbox.nvim",
  "projekt0n/github-nvim-theme",
  "marko-cerovac/material.nvim",
  "bluz71/vim-nightfly-guicolors",
  { "catppuccin/nvim", name = "catppuccin" },
  { "rose-pine/neovim", name = "rose-pine" },
  {
    "EdenEast/nightfox.nvim",
    config = function()
      require("nightfox").setup {}
    end,
  },

  -- cmp plugins
  -- The completion plugin
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
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
        dependencies = {
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
    enabled = function()
      return _G.configs.lsp
    end,
  },

  "windwp/nvim-autopairs",
  "numToStr/Comment.nvim",
  "JoosepAlviste/nvim-ts-context-commentstring",

  -- Snippets
  "L3MON4D3/LuaSnip",
  "rafamadriz/friendly-snippets",

  -- LSP
  {
    "neovim/nvim-lspconfig",
    dependencies = {
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
    enabled = function()
      return _G.configs.lsp
    end,
  },

  -- nvim-surround
  {
    "kylechui/nvim-surround",
    config = function()
      require("nvim-surround").setup {}
    end,
  },

  -- Git
  "lewis6991/gitsigns.nvim",

  -- File tree
  "kyazdani42/nvim-web-devicons",
  "kyazdani42/nvim-tree.lua",

  -- Buffline
  "akinsho/bufferline.nvim",
  "moll/vim-bbye",

  -- Lualine
  "nvim-lualine/lualine.nvim",

  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "theHamsta/nvim-dap-virtual-text",
      "rcarriga/nvim-dap-ui",
    },
    enabled = function()
      return _G.configs.dap
    end,
  },

  -- Tmux integration
  {
    "christoomey/vim-tmux-navigator",
    config = function()
      vim.g.tmux_navigator_no_mappings = 1
    end,
  },

  -- EasyMotion
  {
    "phaazon/hop.nvim",
    branch = "v2",
    config = function()
      require("hop").setup()
    end,
  },

  -- Show color
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end,
  },

  -- Generate function signatures
  {
    "danymat/neogen",
    config = function()
      require("neogen").setup {}
    end,
    requires = "nvim-treesitter/nvim-treesitter",
  },

  -- Todo plugin
  {
    "folke/todo-comments.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require("todo-comments").setup {}
    end,
    event = "BufRead",
  },

  -- Ident line
  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require "user.indentline"
    end,
    enabled = function()
      return _G.configs.indent_blankline
    end,
  },

  -- DiffView
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  -- Neorg
  {
    "nvim-neorg/neorg",
    dependencies = "nvim-lua/plenary.nvim",
    ft = "norg",
    config = function()
      require "user.neorg"
    end,
    enabled = function()
      return _G.configs.neorg
    end,
  },

  "RRethy/vim-illuminate",

  {
    "levouh/tint.nvim",
    config = function()
      require "user.tint"
    end,
    enabled = function()
      return _G.configs.tint
    end,
  },

  -- better fold
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    config = function()
      require "user.better_fold"
    end,
    enabled = function()
      return _G.configs.better_fold
    end,
  },

  -- Goldsmith pluginplguins
  {
    "WhoIsSethDaniel/goldsmith.nvim",
    dependencies = { -- dependencies
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    ft = "go",
    enabled = function()
      return _G.configs.go_tools
    end,
  },

  -- GoImpl
  {
    "edolphin-ydf/goimpl.nvim",
    ft = "go",
    config = function()
      local ok, telescope = pcall(require, "telescope")
      if ok then
        telescope.load_extension "goimpl"
      end
    end,
    enabled = function()
      return _G.configs.go_tools
    end,
  },

  -- Markdown preview
  {
    "iamcco/markdown-preview.nvim",
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    ft = "markdown",
    config = function()
      require "user.markdown_preview"
    end,
    enabled = function()
      return _G.configs.markdown_preview
    end,
  },

  -- Generate github repo url link
  {
    "SDGLBL/ggl.nvim",
    config = function()
      require("ggl").setup {}
    end,
    requires = { "rcarriga/nvim-notify" },
  },

  -- Color picker
  {
    "uga-rosa/ccc.nvim",
    ft = { "javascriptreact", "javascript", "typescript", "typescriptreact", "css", "html", "lua" },
    config = function()
      require "user.ccc"
    end,
    enabled = function()
      return _G.configs.color_picker
    end,
  },

  -- SnipRun
  {
    "michaelb/sniprun",
    build = "bash ./install.sh",
  },

  -- Translate
  {
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
  },

  -- Crates
  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    dependencies = { { "nvim-lua/plenary.nvim" } },
    config = function()
      require("crates").setup()
    end,
    enabled = function()
      return _G.configs.rust_tools
    end,
  },

  -- Better neovim ui
  "stevearc/dressing.nvim",

  -- Rust tools
  {
    "simrat39/rust-tools.nvim",
    ft = "rust",
    config = function()
      require "user.rust_tools"
    end,
    enabled = function()
      return _G.configs.rust_tools
    end,
  },

  -- Better code action menu
  {
    "weilbith/nvim-code-action-menu",
    -- build = "CodeActionMenu",
  },

  {
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup {
        text = {
          spinner = "dots", -- animation shown when tasks are ongoing
        },
      }
    end,
  },

  -- Neovim plugin for improved jumplist navigation
  {
    "cbochs/portal.nvim",
    config = function()
      vim.keymap.set("n", "<leader>o", require("portal").jump_backward, {})
      vim.keymap.set("n", "<leader>i", require("portal").jump_forward, {})
    end,
  },
}