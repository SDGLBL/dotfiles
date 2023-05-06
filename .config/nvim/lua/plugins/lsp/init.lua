return {
  -- lsp setting
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    enabled = configs.lsp,
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "jayp0521/mason-nvim-dap.nvim",
      {
        "folke/neodev.nvim",
        opts = {
          library = {
            plugins = {
              "plenary.nvim",
              "telescope.nvim",
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
    config = function(_, opts)
      require("plugins.lsp.mason").setup(opts)
      require("plugins.lsp.diagnostics").setup()
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

  {
    "glepnir/lspsaga.nvim",
    event = "LspAttach",
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      require("lspsaga").setup {
        lightbulb = {
          enable = false,
        },
      }

      -- set keymaps
      require("utils.lsp").on_attach(function(client, bufnr)
        if client.name == "copilot" or client.name == "null-ls" then
          return
        end

        local keymaps_opts = { noremap = true, silent = true }
        local keymap = vim.api.nvim_buf_set_keymap

        keymap(bufnr, "n", "gh", "<cmd>Lspsaga lsp_finder<CR>", keymaps_opts)
        keymap(bufnr, "n", "gp", "<cmd>Lspsaga peek_definition<CR>", keymaps_opts)
        keymap(bufnr, "n", "gd", "<cmd>Lspsaga goto_definition<CR>", keymaps_opts)
        keymap(bufnr, "n", "<leader>la", "<cmd>Lspsaga code_action<CR>", keymaps_opts)
        keymap(bufnr, "n", "<leader>lr", "<cmd>Lspsaga rename<CR>", keymaps_opts)
        keymap(bufnr, "n", "<leader>lj", "<cmd>Lspsaga diagnostic_jump_next<cr>", keymaps_opts)
        keymap(bufnr, "n", "<leader>lk", "<cmd>Lspsaga diagnostic_jump_prev<cr>", keymaps_opts)
        keymap(bufnr, "n", "<leader>lo", "<cmd>Lspsaga outline<cr>", keymaps_opts)
        keymap(bufnr, "n", "<leader>lci", "<cmd>Lspsaga incoming_calls<cr>", keymaps_opts)
        keymap(bufnr, "n", "<leader>lco", "<cmd>Lspsaga outgoing_calls<cr>", keymaps_opts)

        require("utils.whichkey").register_with_buffer({
          ["gh"] = "LSP Finder",
          ["gp"] = "LSP Preview",
          ["gd"] = "LSP Goto",
          ["<leader>l"] = {
            name = "LSP",
            o = "Outline",
            c = {
              name = "Calls",
              i = "Incoming Calls",
              o = "Outgoing Calls",
            },
          },
        }, bufnr)
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

          local clients = vim.lsp.get_active_clients { bufnr = bufnr }

          for _, c in pairs(clients) do
            local caps = c.server_capabilities
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
}
