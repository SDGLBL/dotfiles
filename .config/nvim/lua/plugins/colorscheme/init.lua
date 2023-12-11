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
    opts = {
      integrations = {
        aerial = true,
        alpha = true,
        cmp = true,
        dashboard = true,
        flash = true,
        gitsigns = true,
        headlines = true,
        illuminate = true,
        indent_blankline = { enabled = true },
        leap = true,
        lsp_trouble = true,
        mason = true,
        markdown = true,
        mini = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        navic = { enabled = true, custom_bg = "lualine" },
        neotest = true,
        neotree = true,
        noice = true,
        notify = true,
        semantic_tokens = true,
        telescope = true,
        treesitter = true,
        treesitter_context = true,
        which_key = true,
      },
      styles = {
        comments = {},
      },
    },
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
