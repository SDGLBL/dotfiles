local icons = require "utils.icons"

return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>/", "<Plug>(comment_toggle_linewise_current)", desc = "Comment" },
      { "<leader>\\", "<cmd>Alpha<cr>", desc = "Alpha" },
      { "<leader>w", "<cmd>w!<CR>", desc = "Save" },
      { "<leader>W", "<cmd>noautocmd w!<CR>", desc = "NoAC Save" },
      { "<leader>R", '<cmd>lua require("configs").reload()<CR>', desc = "Reload" },
      { "<leader>q", "<cmd>q!<CR>", desc = "Quit" },
      { "<leader>u", "", desc = "Dismiss" },
      { "<leader>h", "<cmd>nohlsearch<CR>", desc = "No Highlight" },
      { "<leader>zi", "<cmd>:Lazy install<cr>", "Install" },
      { "<leader>zu", "<cmd>:Lazy update<cr>", "Update" },
      { "<leader>zc", "<cmd>:Lazy clean<cr>", "Clean" },
      { "<leader>zp", "<cmd>:Lazy profile<cr>", "Profile" },
    },
    opts = {
      setup = {
        plugins = {
          marks = true, -- shows a list of your marks on ' and `
          registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
          spelling = {
            enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
            suggestions = 20, -- how many suggestions should be shown in the list?
          },
          -- the presets plugin, adds help for a bunch of default keybindings in Neovim
          -- No actual key bindings are created
          presets = {
            operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
            motions = true, -- adds help for motions
            text_objects = true, -- help for text objects triggered after entering an operator
            windows = true, -- default bindings on <c-w>
            nav = true, -- misc bindings to work with windows
            z = true, -- bindings for folds, spelling and others prefixed with z
            g = true, -- bindings for prefixed with g
          },
        },
        icons = {
          breadcrumb = icons.ui.DoubleChevronRight,
          separator = icons.ui.BoldArrowRight,
          group = icons.ui.Plus,
        },
        popup_mappings = {
          scroll_down = "<c-d>", -- binding to scroll down inside the popup
          scroll_up = "<c-u>", -- binding to scroll up inside the popup
        },
        window = {
          border = "rounded", -- none, single, double, shadow
          position = "bottom", -- bottom, top
          margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
          padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
          winblend = 0,
        },
        layout = {
          height = { min = 4, max = 25 }, -- min and max height of the columns
          width = { min = 20, max = 50 }, -- min and max width of the columns
          spacing = 3, -- spacing between columns
          align = "left", -- align columns left, center or right
        },
        hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
        show_help = true, -- show help message on the command line when the popup is visible
        triggers = "auto", -- automatically setup triggers
        triggers_blacklist = {
          i = { "j", "k" },
          v = { "j", "k" },
        },
        disable = {
          buftypes = {},
          filetypes = { "TelescopePrompt" },
        },
      },
      defaults = {
        mode = { "n" },
        ["<leader>z"] = { name = "+Lazy" },
        ["<leader>j"] = { name = "+SwapNext" },
        ["<leader>k"] = { name = "+SwapPrev" },
      },
      vdefaults = {
        mode = { "v" },
      },
    },
    config = function(_, opts)
      local wk = require "which-key"
      wk.setup(opts.setup)
      wk.register(opts.defaults)
      wk.register(opts.vdefaults)
    end,
  },
}
