return {
  {
    "folke/tokyonight.nvim",
    lazy = true,
  },
  {
    "oxfist/night-owl.nvim",
    lazy = true,
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = true,
  },
  {
    "tanvirtin/monokai.nvim",
    lazy = true,
  },
  {
    "lunarvim/darkplus.nvim",
    lazy = true,
  },
  {
    "tiagovla/tokyodark.nvim",
    lazy = true,
  },
  {
    "ellisonleao/gruvbox.nvim",
    lazy = true,
  },
  {
    "projekt0n/github-nvim-theme",
    lazy = true,
  },
  {
    "marko-cerovac/material.nvim",
    lazy = true,
  },
  {
    "bluz71/vim-nightfly-guicolors",
    lazy = true,
  },
  {
    "felipeagc/fleet-theme-nvim",
    lazy = true,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    opts = {
      integrations = {
        aerial = true,
        alpha = true,
        cmp = true,
        dashboard = true,
        flash = true,
        grug_far = true,
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
  {
    "rose-pine/neovim",
    name = "rose-pine",
  },
  {
    "EdenEast/nightfox.nvim",
    lazy = true,
    config = function()
      require("nightfox").setup {}
    end,
  },
  {
    "olimorris/onedarkpro.nvim",
    lazy = true,
    priority = 1000, -- Ensure it loads first
  },
  {
    "dasupradyumna/midnight.nvim",
    lazy = false,
    priority = 1000,
  },
}
