return {
  {
    "benlubas/molten-nvim",
    dependencies = {
      "3rd/image.nvim",
    },
    version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
    build = ":UpdateRemotePlugins",
    init = function()
      -- this is an example, not a default. Please see the readme for more configuration options
      vim.g.molten_output_win_max_height = 12
      vim.g.python3_host_prog = vim.fn.expand "~/venvs/neovim-venv/bin/python3"
      vim.g.molten_image_provider = "image_nvim"
    end,
  },

  {
    "jmbuhr/otter.nvim",
    opts = {
      buffers = {
        set_filetype = true,
      },
    },
  },

  {
    "quarto-dev/quarto-nvim",
    opts = {
      lspFeatures = {
        languages = { "r", "python", "julia", "bash", "html", "lua" },
      },
      codeRunner = {
        enabled = true,
        default_method = "molten", -- 'molten' or 'slime'
      },
    },
    ft = "quarto",
    --stylua: ignore
    keys = {
      { "<leader>qa", ":QuartoActivate<cr>", desc = "quarto activate" },
      { "<leader>qp", ":lua require'quarto'.quartoPreview()<cr>", desc = "quarto preview" },
      { "<leader>qq", ":lua require'quarto'.quartoClosePreview()<cr>", desc = "quarto close" },
      { "<leader>qr", desc = "Run" },
      { "<leader>qrc", function()require("quarto.runner").run_cell() end, desc = "Run Cell" },
      { "<leader>qra", function()require("quarto.runner").run_above() end, desc = "Run Cell And Above" },
      { "<leader>qrA", function()require("quarto.runner").run_all() end, desc = "Run All" },
      { "<leader>qrl", function()require("quarto.runner").run_line() end, desc = "Run Line" },
      { "<leader>qrv", function()require("quarto.runner").run_range() end, desc = "Run Line" ,mode={"v"}},
    },
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = { "jmbuhr/otter.nvim" },
    opts = function(_, opts)
      ---@param opts cmp.ConfigSchema
      local cmp = require "cmp"
      opts.sources = cmp.config.sources(vim.list_extend(opts.sources, { { name = "otter" } }))
    end,
  },

  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        pyright = {},
        julials = {},
        marksman = {
          -- also needs:
          -- $home/.config/marksman/config.toml :
          -- [core]
          -- markdown.file_extensions = ["md", "markdown", "qmd"]
          filetypes = { "markdown", "quarto" },
          root_dir = require("lspconfig.util").root_pattern(".git", ".marksman.toml", "_quarto.yml"),
        },
      },
    },
  },
}
