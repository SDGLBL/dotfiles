return {
  -- add rust to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "rust" })
      end
    end,
  },

  -- correctly setup lspconfig
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      -- make sure mason installs the server
      -- LSP Server Settings
      ---@type lspconfig.options
      servers = {
        ["rust-analyzer"] = {
          settings = {
            imports = {
              granularity = {
                group = "module",
              },
              prefix = "self",
            },
            cargo = {
              buildScripts = {
                enable = true,
              },
            },
            procMacro = {
              enable = true,
            },
            -- inlayHints = {
            --   enable = true,
            --   chainingHints = true,
            --   maxLength = 25,
            --   parameterHints = true,
            --   typeHints = true,
            --   hideNamedConstructorHints = false,
            --   typeHintsSeparator = "‣",
            --   typeHintsWithVariable = true,
            --   chainingHintsSeparator = "‣",
            -- },
          },
        },
      },
    },
  },

  {
    "simrat39/rust-tools.nvim",
    ft = "rust",
    enabled = configs.rust_tools,
    config = function()
      local rt = require "rust-tools"

      -- close rust_tools on_attach
      rt.setup {
        server = {
          on_attach = function(_, _) end,
        },
      }
    end,
  },
}