return {
  "stevearc/dressing.nvim",
  "weilbith/nvim-code-action-menu",
  "norcalli/nvim-colorizer.lua",

  -- windows tint
  {
    "levouh/tint.nvim",
    enabled = configs.tint,
    event = "VeryLazy",
    config = true,
  },

  -- more icons
  {
    "nvim-tree/nvim-web-devicons",
    dependencies = { "DaikyXendo/nvim-material-icon" },
    config = function()
      require("nvim-web-devicons").setup {
        override = require("nvim-material-icon").get_icons(),
      }
    end,
  },

  -- lsp progress ui
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

  -- dynamic windows
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

  -- ui transparent support
  {
    "xiyaowong/transparent.nvim",
    config = function()
      require("transparent").setup {
        extra_groups = {
          "SignColumn",
          "TelescopeBorder",
          "TelescopeNormal",
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
