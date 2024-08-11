return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      spec = {
        { "<leader>gd", group = "DiffView" },
      },
    },
  },

  {
    "sindrets/diffview.nvim",
    keys = {
      { "<leader>gd", "", desc = "DiffView" },
      { "<leader>gdo", "<cmd>DiffviewOpen<cr>", desc = "DiffOpen" },
      { "<leader>gdc", "<cmd>DiffviewClose<cr>", desc = "DiffClose" },
      { "<leader>gdr", "<cmd>DiffviewRefresh<cr>", desc = "DiffRefresh" },
      { "<leader>gdh", "<cmd>DiffviewFileHistory<cr>", desc = "DiffFileHistory" },
      { "<leader>gdl", "v$:'<,'>DiffviewFileHistory<cr>", desc = "DiffLineHistory" },
      { "<leader>gdf", "<cmd>DiffviewFileHistory %<cr>", desc = "DiffFileHistory (Cur File)" },
      { "<leader>gdt", "<cmd>DiffviewToggleFiles %<cr>", desc = "DiffToggleFiles" },
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
