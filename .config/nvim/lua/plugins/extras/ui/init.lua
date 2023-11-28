return {
  "stevearc/dressing.nvim",
  {
    "Bekaboo/dropbar.nvim",
    enabled = false,
  },

  {
    "weilbith/nvim-code-action-menu",
  },

  -- windows tint
  {
    "levouh/tint.nvim",
    enabled = configs.tint,
    event = "VeryLazy",
    config = true,
  },

  -- line f/F indicator
  {
    "jinh0/eyeliner.nvim",
    enabled = false,
    config = function()
      require("eyeliner").setup {
        highlight_on_key = true, -- show highlights only after keypress
        dim = true, -- dim all other characters if set to true (recommended!)
      }

      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = function()
          vim.api.nvim_set_hl(0, "EyelinerPrimary", { bold = true, underline = true })
        end,
      })
    end,
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
    tag = "legacy",
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
    keys = {
      { "<C-w>z", "<cmd>WindowsMaximize<cr>", desc = "WindowsMaximize" },
      { "<C-w>_", "<cmd>WindowsMaximizeVertically<cr>", desc = "WindowsMaximizeVertically" },
      { "<C-w>|", "<cmd>WindowsMaximizeHorizontally<cr>", desc = "WindowsMaximizeHorizontally" },
      { "<C-w>=", "<cmd>WindowsEqualize<cr>", desc = "WindowsEqualize" },
    },
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
        ignore = { --			  |windows.ignore|
          buftype = { "quickfix" },
          filetype = { "NvimTree", "neo-tree", "undotree", "gundo", "sagaoutline" },
        },
      }
    end,
    enabled = not vim.g.neovide,
  },

  -- ui transparent support
  {
    "xiyaowong/transparent.nvim",
    enabled = not vim.g.neovide,
    config = function()
      require("transparent").setup {
        extra_groups = {
          "SignColumn",
          "TelescopeBorder",
          "TelescopeNormal",
          "FloatBorder",
          "NormalFloat",
          "NvimTreeNormal",
          "NvimTreeNormalNC",
          "MsgArea",
          "HopPreview",
          "WhichKeyFloat",
        }, -- table: additional groups that should be cleared
        exclude_groups = {}, -- table: groups you don't want to clear
      }
    end,
  },

  -- indent line
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    enabled = configs.indent_blankline,
    main = "ibl",
    config = function()
      local highlight = {
        "RainbowRed",
        "RainbowYellow",
        "RainbowBlue",
        "RainbowOrange",
        "RainbowGreen",
        "RainbowViolet",
        "RainbowCyan",
      }

      local hooks = require "ibl.hooks"
      -- create the highlight groups in the highlight setup hook, so they are reset
      -- every time the colorscheme changes
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
        vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
        vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
        vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
        vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
        vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
        vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
      end)

      require("ibl").setup { indent = { highlight = highlight } }
    end,
  },

  {
    "f-person/auto-dark-mode.nvim",
    enabled = os.getenv "TERM_PROGRAM" == "WarpTerminal",
    config = {
      update_interval = 1000,
      set_dark_mode = function()
        vim.api.nvim_set_option("background", "dark")
        vim.cmd("colorscheme " .. _G.configs.dark_colorscheme)
      end,
      set_light_mode = function()
        vim.api.nvim_set_option("background", "light")
        vim.cmd("colorscheme " .. _G.configs.light_colorscheme)
      end,
    },
  },

  {
    "chrishrb/gx.nvim",
    event = { "BufEnter" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },

  {
    "axkirillov/hbac.nvim",
    event = "VeryLazy",
    opts = {
      autoclose = true,
      threshold = 10,
    },
    enabled = true,
  },

  {
    "tzachar/highlight-undo.nvim",
    event = "VeryLazy",
    opts = {},
  },
}
