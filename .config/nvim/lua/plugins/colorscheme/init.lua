return {
  {
    "folke/tokyonight.nvim",
    "rebelot/kanagawa.nvim",
    "tanvirtin/monokai.nvim",
    "lunarvim/darkplus.nvim",
    "tiagovla/tokyodark.nvim",
    "ellisonleao/gruvbox.nvim",
    "projekt0n/github-nvim-theme",
    "marko-cerovac/material.nvim",
    "bluz71/vim-nightfly-guicolors",
    {
      "catppuccin/nvim",
      name = "catppuccin",
      config = function()
        require("catppuccin").setup {
          styles = {
            comments = {},
          },
        }
      end,
    },
    { "rose-pine/neovim", name = "rose-pine" },
    {
      "EdenEast/nightfox.nvim",
      config = function()
        require("nightfox").setup {}
      end,
    },
  },
}