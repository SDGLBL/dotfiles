return {
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    enabled = configs.lsp,
    dependencies = {
      "folke/neodev.nvim",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "jose-elias-alvarez/null-ls.nvim",
      "jayp0521/mason-nvim-dap.nvim",
      "jayp0521/mason-null-ls.nvim",
      "tamago324/nlsp-settings.nvim",
    },
    config = function()
      require("plugins.lsp.mason").setup()
      require("plugins.lsp.handlers").setup()
      require("plugins.lsp.mason-null-ls").setup()
      require("plugins.lsp.mason-nvim-dap").setup()
    end,
  },
}
