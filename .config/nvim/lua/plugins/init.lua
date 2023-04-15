return {
  "moll/vim-bbye",
  "nvim-lua/plenary.nvim",
  "stevearc/dressing.nvim",
  "nvim-tree/nvim-web-devicons",
  "weilbith/nvim-code-action-menu",
  {
    "RRethy/vim-illuminate",
    event = "VeryLazy",
  },
  {
    "github/copilot.vim",
    event = "VeryLazy",
  },
  {
    "ethanholz/nvim-lastplace",
    config = true,
  },
  {
    "levouh/tint.nvim",
    enabled = configs.tint,
    event = "VeryLazy",
    config = true,
  },
  {
    "nacro90/numb.nvim",
    event = "BufReadPre",
    config = true,
  },
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    config = true,
  },
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    config = true,
  },
  {
    "uga-rosa/ccc.nvim",
    ft = { "javascriptreact", "javascript", "typescript", "typescriptreact", "css", "html", "lua" },
    enabled = configs.color_picker,
    config = true,
  },
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    event = "VeryLazy",
    config = function()
      require("luasnip.loaders.from_snipmate").lazy_load()
    end,
  },
  {

    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = function()
      require("lualine").setup(require("utils.lualine.styles").styles.lvim)
    end,
  },
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    dependencies = {
      "theHamsta/nvim-dap-virtual-text",
      "rcarriga/nvim-dap-ui",
    },
    enabled = configs.dap,
  },
  {
    "christoomey/vim-tmux-navigator",
    config = function()
      vim.g.tmux_navigator_no_mappings = 1
    end,
  },
  {
    "phaazon/hop.nvim",
    event = "VeryLazy",
    branch = "v2",
    config = true,
  },
  {
    "norcalli/nvim-colorizer.lua",
    config = true,
  },
  {
    "danymat/neogen",
    event = "VeryLazy",
    config = true,
  },
  {
    "folke/todo-comments.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    event = "BufRead",
    config = true,
  },
  {
    "edolphin-ydf/goimpl.nvim",
    ft = "go",
    build = "go install github.com/josharian/impl@latest",
    config = function()
      local ok, telescope = pcall(require, "telescope")
      if ok then
        telescope.load_extension "goimpl"
      end
    end,
  },
  {
    "SDGLBL/ggl.nvim",
    cmd = { "GLineLink", "GPermaLink" },
    config = true,
  },
  {
    "uga-rosa/translate.nvim",
    event = "VeryLazy",
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
  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    dependencies = { { "nvim-lua/plenary.nvim" } },
    config = function()
      require("crates").setup()
    end,
    enabled = configs.rust_tools,
  },
  {
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup {
        text = {
          spinner = "dots", -- animation shown when tasks are ongoing
        },
        window = {
          relative = "editor", -- window position
        },
      }
    end,
  },
  {
    "anuvyklack/windows.nvim",
    dependencies = {
      "anuvyklack/middleclass",
      "anuvyklack/animation.nvim",
    },
    config = function()
      vim.o.winwidth = 20
      vim.o.winminwidth = 5
      vim.o.equalalways = false
      require("windows").setup {
        animation = {
          enable = true,
          duration = 200,
          fps = 60,
        },
      }
    end,
    enabled = not vim.g.neovide,
  },
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = { options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals" } },
    config = true,
  },
  {
    "xiyaowong/transparent.nvim",
    config = function()
      require("transparent").setup {
        extra_groups = {
          "SignColumn",
          "TelescopeBorder",
          "NvimTreeNormal",
          "NvimTreeNormalNC",
          "MsgArea",
          "HopPreview",
        }, -- table: additional groups that should be cleared
        exclude_groups = {}, -- table: groups you don't want to clear
      }
    end,
  },
}
