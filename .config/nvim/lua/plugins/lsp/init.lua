return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      defaults = {
        ["<leader>l"] = { name = "+LSP" },
        ["<leader>lg"] = { name = "+Generate Doc" },
      },
    },
  },

  -- lsp setting
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    enabled = configs.lsp,
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      {
        "folke/neodev.nvim",
        opts = {
          library = {
            types = true,
            plugins = {
              -- "neotest",
              -- "plenary.nvim",
              -- "telescope.nvim",
              -- "flash.nvim",
              -- "nvim-treesitter",
              -- "LuaSnip",
            },
          },
        },
      },
      {
        "folke/neoconf.nvim",
        cmd = "Neoconf",
        config = true,
      },
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
          end, { group = "_illuminate_attach", desc = "attach illuminate" })
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
    config = function(plugin, opts)
      require("plugins.lsp.servers").setup(plugin, opts)
    end,
  },

  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    cmd = "Mason",
    opts = {
      ensure_installed = {},
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require "mason-registry"
      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end
      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end,
  },

  -- null-ls setting
  {
    "nvimtools/none-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "jay-babu/mason-null-ls.nvim",
    },
    opts = {
      sources = {},
      ensure_installed = {
        "stylua",
        "golines",
        -- "goimports",
        "taplo",
        "rustfmt",
        "prettier",
        "shellcheck",
        "golangci_lint",
        "codespell",
        "shfmt",
      },
    },
    config = function(_, opts)
      require("plugins.lsp.mason-null-ls").setup(opts)
    end,
  },

  {
    "glepnir/lspsaga.nvim",
    event = "LspAttach",
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      require("lspsaga").setup {
        lightbulb = {
          enable = false,
        },
        symbol_in_winbar = {
          enable = false,
        },
      }

      -- set keymaps
      require("utils.lsp").on_attach(function(client, bufnr)
        local self = require("plugins.lsp.keymaps").new(client, bufnr)

        self:map("gh", "Lspsaga finder", { desc = "Lspsaga finder" })
        self:map("gp", "Lspsaga peek_definition", { desc = "Lspsaga peek_definition" })
        -- self:map("gd", "Lspsaga goto_definition", { desc = "Lspsaga goto_definition" })
        self:map(
          "<leader>la",
          "Lspsaga code_action",
          { desc = "Lspsaga code_action", mode = { "n", "v" }, has = "codeAction" }
        )
        self:map("<leader>lr", "Lspsaga rename", { desc = "Lspsaga rename" })
        self:map("<leader>lj", "Lspsaga diagnostic_jump_next", { desc = "Lspsaga diagnostic_jump_next" })
        self:map("<leader>lk", "Lspsaga diagnostic_jump_prev", { desc = "Lspsaga diagnostic_jump_prev" })
        -- self:map("<leader>lW", "Lspsaga show_line_diagnostics", { desc = "Lspsaga show_line_diagnostics" })
        -- self:map("<leader>lw", "Lspsaga show_workspace_diagnostics", { desc = "Lspsaga show_workspace_diagnostics" })
        self:map("<leader>lo", "Lspsaga outline", { desc = "Lspsaga outline" })
        -- self:map("<leader>lc", vim.lsp.codelens.run, { desc = "Codelenses" })
      end, { group = "_lspsaga_keymaps", desc = "init lspsaga keymaps" })
    end,
  },

  -- highlight arguments when lsp not support semantic tokens
  {
    "m-demare/hlargs.nvim",
    event = "VeryLazy",
    config = function()
      require("hlargs").setup {
        disable = function(_, bufnr)
          if vim.b.semantic_tokens then
            return true
          end

          local clients = vim.lsp.get_clients { bufnr = bufnr }

          for _, c in pairs(clients) do
            local caps = c.server_capabilities
            ---@diagnostic disable-next-line: need-check-nil
            if c.name ~= "null-ls" and caps.semanticTokensProvider and caps.semanticTokensProvider.full then
              vim.b.semantic_tokens = true
              return vim.b.semantic_tokens
            end
          end
        end,
      }
    end,
    enabled = configs.hlargs,
  },

  -- refactoring support
  {
    "ThePrimeagen/refactoring.nvim",
    event = "VeryLazy",
    enabled = configs.refactor,
    dependencies = { "nvim-telescope/telescope.nvim" },
    keys = {
      {
        "<leader>r",
        "<esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>",
        mode = "v",
        desc = "Refactor",
      },
      {
        "<leader>lc",
        "<cmd>lua require('telescope').extensions.refactoring.refactors()<CR>",
        desc = "Choose refactoring",
      },
    },
    config = function()
      if not configs.refactor then
        return
      end

      local refactor = require "refactoring"

      local ok, telescope = pcall(require, "telescope")
      if ok then
        telescope.load_extension "refactoring"
      end

      refactor.setup {}
    end,
  },

  -- inlay hint support
  {
    "lvimuser/lsp-inlayhints.nvim",
    branch = "anticonceal",
    enabled = false,
    config = function()
      require("lsp-inlayhints").setup {}

      require("utils.lsp").on_attach(function(client, bufnr)
        if client.name == "copilot" or client.name == "null-ls" then
          return
        end

        require("lsp-inlayhints").on_attach(client, bufnr)
      end, { group = "_lsp_inlayhints", desc = "init lspsaga keymaps" })
    end,
  },

  {
    "Wansmer/symbol-usage.nvim",
    event = "LspAttach",
    opts = {},
  },
}
