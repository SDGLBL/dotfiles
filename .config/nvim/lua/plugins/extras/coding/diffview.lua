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
      { "<leader>vo", "<cmd>DiffviewOpen<cr>", desc = "Open" },
      { "<leader>vc", "<cmd>DiffviewClose<cr>", desc = "Close" },
      { "<leader>vr", "<cmd>DiffviewRefresh<cr>", desc = "Refresh" },
      { "<leader>vh", "<cmd>DiffviewFileHistory<cr>", desc = "FileHistory" },
      { "<leader>vl", "v$:'<,'>DiffviewFileHistory<cr>", desc = "LineHistory" },
      { "<leader>vf", "<cmd>DiffviewFileHistory %<cr>", desc = "Current File FileHistory" },
      { "<leader>vt", "<cmd>DiffviewToggleFiles %<cr>", desc = "ToggleFiles" },
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
