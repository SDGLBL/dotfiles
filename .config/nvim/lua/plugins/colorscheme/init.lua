return {
  "folke/tokyonight.nvim",
  "oxfist/night-owl.nvim",
  "rebelot/kanagawa.nvim",
  "tanvirtin/monokai.nvim",
  "lunarvim/darkplus.nvim",
  "tiagovla/tokyodark.nvim",
  "ellisonleao/gruvbox.nvim",
  "projekt0n/github-nvim-theme",
  "marko-cerovac/material.nvim",
  "bluz71/vim-nightfly-guicolors",
  "felipeagc/fleet-theme-nvim",
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
  {
    "olimorris/onedarkpro.nvim",
    priority = 1000, -- Ensure it loads first
  },
  {
    "dasupradyumna/midnight.nvim",
    lazy = false,
    priority = 1000,
  },
}
