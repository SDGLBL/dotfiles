return {
  {
    "aaronik/treewalker.nvim",
    enabled = false,
    event = "VeryLazy",
    keys = {
      { "<C-j>", "<cmd>Treewalker Down<cr>", desc = "Move down", mode = { "n", "v" }, silent = true },
      { "<C-k>", "<cmd>Treewalker Up<cr>", desc = "Move up", mode = { "n", "v" }, silent = true },
      { "<C-h>", "<cmd>Treewalker Left<cr>", desc = "Move left", mode = { "n", "v" }, silent = true },
      { "<C-l>", "<cmd>Treewalker Right<cr>", desc = "Move right", mode = { "n", "v" }, silent = true },

      -- swapping
      { "<C-S-k>", "<cmd>Treewalker SwapUp<cr>", desc = "Swap up", mode = "n", silent = true },
      { "<C-S-j>", "<cmd>Treewalker SwapDown<cr>", desc = "Swap down", mode = "n", silent = true },
      { "<C-S-h>", "<cmd>Treewalker SwapLeft<cr>", desc = "Swap left", mode = "n", silent = true },
      { "<C-S-l>", "<cmd>Treewalker SwapRight<cr>", desc = "Swap right", mode = "n", silent = true },
    },

    -- The following options are the defaults.
    -- Treewalker aims for sane defaults, so these are each individually optional,
    -- and setup() does not need to be called, so the whole opts block is optional as well.
    opts = {
      -- Whether to briefly highlight the node after jumping to it
      highlight = true,

      -- How long should above highlight last (in ms)
      highlight_duration = 250,

      -- The color of the above highlight. Must be a valid vim highlight group.
      -- (see :h highlight-group for options)
      highlight_group = "CursorLine",
    },
  },
}
