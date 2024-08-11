return {
  {
    "mrjones2014/legendary.nvim",
    keys = {
      { "<C-S-p>", "<cmd>Legendary<cr>", desc = "Legendary" },
      { "<leader>p", "<cmd>Legendary<cr>", desc = "Command Palette" },
    },
    opts = {
      extensions = {
        which_key = { auto_register = true },
        nvim_tree = true,
        diffview = true,
        lazy_nvim = true,
        codecompanion = true,
      },
    },
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    dependencies = { "mrjones2014/legendary.nvim" },
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 200
    end,
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show { global = false }
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
    opts_extend = { "spec" },
    opts = {
      spec = {
        {
          mode = { "n", "v" },
          { "<leader><tab>", group = "tabs" },
          {
            "<leader>b",
            group = "buffer",
            expand = function()
              return require("which-key.extras").expand.buf()
            end,
          },
          { "<leader>c", group = "code" },
          { "<leader>\\", "<cmd>Alpha<cr>", desc = "dashboard" },
          { "<leader>f", group = "file/find" },
          { "<leader>a", group = "ai" },
          { "<leader>am", group = "AI Mode" },
          { "<leader>l", group = "lsp", desc = "lsp" },
          { "<leader>lx", group = "swap", desc = "swap" },
          -- { "<leader>r", group = "refactor" },
          { "<leader>g", group = "git" },
          { "<leader>gh", group = "hunks" },
          { "<leader>q", group = "quarto" },
          { "<leader>h", group = "help" },
          { "<leader>s", group = "search" },
          { "<leader>u", group = "ui", icon = { icon = "󰙵 ", color = "cyan" } },
          { "<leader>uh", "<cmd>nohlsearch<cr>", desc = "NoHighlight" },
          { "<leader>z", group = "system" },
          { "<leader>zu", "<cmd>Lazy update<cr>", desc = "LazyUpdate" },
          { "<leader>x", group = "diagnostics/quickfix", icon = { icon = "󱖫 ", color = "green" } },
          { "<leader>w", "<cmd>w<cr><esc>", desc = "save" },
          { "[", group = "prev" },
          { "]", group = "next" },
          { "g", group = "goto" },
          { "gs", group = "surround" },
          { "z", group = "fold" },
        },
      },
    },
    config = function(_, opts)
      local wk = require "which-key"
      wk.setup(opts)
    end,
  },
}
