return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = function()
      require("lualine").setup(require("utils.lualine.styles").styles.lvim)
    end,
  },
}
