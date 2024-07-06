return {
  "moll/vim-bbye",
  "nvim-lua/plenary.nvim",

  {
    "ethanholz/nvim-lastplace",
    config = true,
  },

  {
    "nacro90/numb.nvim",
    event = "BufReadPre",
    enabled = false,
    config = true,
  },

  {
    "christoomey/vim-tmux-navigator",
    config = function()
      vim.g.tmux_navigator_no_mappings = 1
    end,
  },

  {
    "SDGLBL/ggl.nvim",
    cmd = { "GLineLink", "GPermaLink" },
    enabled = false,
    config = true,
  },
}
