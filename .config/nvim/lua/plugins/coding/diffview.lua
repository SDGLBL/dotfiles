return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      defaults = {
        ["<leader>v"] = { name = "+DiffView" },
      },
    },
  },

  {
    "sindrets/diffview.nvim",
    keys = {
      { "<leader>vo", "<cmd>DiffviewOpen<cr>", desc = "DiffOpen" },
      { "<leader>vc", "<cmd>DiffviewClose<cr>", desc = "DiffClose" },
      { "<leader>vr", "<cmd>DiffviewRefresh<cr>", desc = "DiffRefresh" },
      { "<leader>vh", "<cmd>DiffviewFileHistory<cr>", desc = "DiffFileHistory" },
      { "<leader>vl", "v$:'<,'>DiffviewFileHistory<cr>", desc = "DiffLineHistory" },
      { "<leader>vf", "<cmd>DiffviewFileHistory %<cr>", desc = "DiffFileHistory (Cur File)" },
      { "<leader>vt", "<cmd>DiffviewToggleFiles %<cr>", desc = "DiffToggleFiles" },
    },
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewRefresh",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
      "DiffviewFileHistory ",
    },
    config = true,
  },
}
