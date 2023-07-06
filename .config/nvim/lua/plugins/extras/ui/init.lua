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
          "FloatBorder",
          "NormalFloat",
          "NvimTreeNormal",
          "NvimTreeNormalNC",
          "MsgArea",
          "HopPreview",
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
    config = function()
      if not configs.indent_blankline then
        return
      end

      local ib = require "indent_blankline"

      vim.g.indent_blankline_buftype_exclude = { "terminal", "nofile" }
      vim.g.indent_blankline_filetype_exclude = {
        "help",
        "startify",
        "dashboard",
        "packer",
        "neogitstatus",
        "NvimTree",
        "Trouble",
      }
      vim.g.indentLine_enabled = 1
      vim.g.indent_blankline_char = "│"
      vim.g.indent_blankline_show_trailing_blankline_indent = false
      vim.g.indent_blankline_show_first_indent_level = true
      vim.g.indent_blankline_use_treesitter = true
      vim.g.indent_blankline_show_current_context = true
      vim.g.indent_blankline_context_patterns = {
        "class",
        "return",
        "function",
        "method",
        "^if",
        "^while",
        "jsx_element",
        "^for",
        "^object",
        "^table",
        "block",
        "arguments",
        "if_statement",
        "else_clause",
        "jsx_element",
        "jsx_self_closing_element",
        "try_statement",
        "catch_clause",
        "import_statement",
        "operation_type",
      }
      -- HACK: work-around for https://github.com/lukas-reineke/indent-blankline.nvim/issues/59
      vim.wo.colorcolumn = "99999"

      -- vim.cmd([[highlight IndentBlanklineIndent1 guifg=#E06C75 gui=nocombine]])
      -- vim.cmd([[highlight IndentBlanklineIndent2 guifg=#E5C07B gui=nocombine]])
      -- vim.cmd([[highlight IndentBlanklineIndent3 guifg=#98C379 gui=nocombine]])
      -- vim.cmd([[highlight IndentBlanklineIndent4 guifg=#56B6C2 gui=nocombine]])
      -- vim.cmd([[highlight IndentBlanklineIndent5 guifg=#61AFEF gui=nocombine]])
      -- vim.cmd([[highlight IndentBlanklineIndent6 guifg=#C678DD gui=nocombine]])
      -- vim.opt.list = true
      -- vim.opt.listchars:append("space:⋅")
      -- vim.opt.listchars:append("space:")
      -- vim.opt.listchars:append("eol:↴")

      ib.setup {
        -- show_end_of_line = true,
        -- space_char_blankline = " ",
        show_current_context = true,
        -- show_current_context_start = true,
        -- char_highlight_list = {
        --   "IndentBlanklineIndent1",
        --   "IndentBlanklineIndent2",
        --   "IndentBlanklineIndent3",
        -- },
      }
    end,
  },
}
