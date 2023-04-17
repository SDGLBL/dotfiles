return {
  -- lsp setting
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    enabled = configs.lsp,
    dependencies = {
      "folke/neodev.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "jayp0521/mason-nvim-dap.nvim",
      {
        "ray-x/lsp_signature.nvim",
        opts = {
          hint_prefix = require("utils.icons").diagnostics.BoldHint .. " ",
        },
      },
      {
        "RRethy/vim-illuminate",
        event = "VeryLazy",
        config = function()
          require("utils.lsp").on_attach(function(client, _)
            require("illuminate").on_attach(client)
          end)
        end,
      },
      {
        "tamago324/nlsp-settings.nvim",
        config = function(_, _)
          require("nlspsettings").setup {
            config_home = vim.fn.stdpath "config" .. "/nlsp-settings",
            local_settings_dir = ".nlsp-settings",
            local_settings_root_markers_fallback = { ".git" },
            append_default_schemas = true,
            loader = "json",
          }
        end,
      },
    },
    ---@class PluginLspOpts
    opts = {
      -- options for vim.lsp.buf.format
      -- `bufnr` and `filter` is handled by the LazyVim formatter,
      -- but can be also overridden when specified
      format = {
        formatting_options = nil,
        timeout_ms = nil,
      },
      -- LSP Server Settings
      ---@type lspconfig.options
      servers = {},
      -- you can do any additional lsp server setup here
      -- return true if you don't want this server to be setup with lspconfig
      ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
      setup = {
        -- example to setup with typescript.nvim
        -- tsserver = function(_, opts)
        --   require("typescript").setup({ server = opts })
        --   return true
        -- end,
        -- Specify * to use this function as a fallback for any server
        -- ["*"] = function(server, opts) end,
      },
    },
    ---@param opts PluginLspOpts
    config = function(_, opts)
      require("plugins.lsp.mason").setup(opts)
      require("plugins.lsp.handlers").setup()
      require("plugins.lsp.mason-nvim-dap").setup()
    end,
  },

  -- null-ls setting
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "jay-babu/mason-null-ls.nvim",
    },
    opts = {
      sources = {},
      ensure_installed = {
        "stylua",
        "golines",
        "goimports",
        "taplo",
        "rustfmt",
        "prettier",
        "shellcheck",
        "hadolint",
        "golangci_lint",
        "codespell",
        "shfmt",
      },
    },
    config = function(_, opts)
      require("plugins.lsp.mason-null-ls").setup(opts)
    end,
  },
}
