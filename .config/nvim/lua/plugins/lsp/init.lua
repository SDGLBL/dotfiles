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
    keys = {
      {
        "<leader>la",
        function()
          local code_action = "<cmd>lua vim.lsp.buf.code_action()<cr>"
          if vim.fn.exists ":CodeActionMenu" then
            code_action = "<cmd>CodeActionMenu<cr>"
          end

          code_action()
        end,
        desc = "Code Action",
      },
      { "<leader>lf", "<cmd>lua vim.lsp.buf.format{ async = true }<cr>", desc = "Format" },
      { "<leader>lI", "<cmd>Telescope lsp_implementations<cr>", desc = "Implementations" },
      { "<leader>lj", "<cmd>lua vim.diagnostic.goto_next({buffer=0})<cr>", desc = "Next Diagnostic" },
      { "<leader>lk", "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>", desc = "Prev Diagnostic" },
      { "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", desc = "Rename" },
      { "<leader>lR", "<cmd>Telescope lsp_references<cr>", desc = "References" },
      { "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Doc Symbols" },
      { "<leader>lS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Workspace Symbols" },
      { "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<cr>", desc = "Diagnostic List" },
      { "<leader>lw", "<cmd>Telescope diagnostics<cr>", desc = "Workspace Diagnostics" },
      {
        "<leader>lW",
        '<cmd>lua require(desc ="telescope.builtin").diagnostics({ bufnr = 0 })<cr>',
        "Doc Diagnostics",
      },
      { "<leader>le", "<cmd>Telescope quickfix<cr>", desc = "Telescope Quickfix" },
      { "<leader>lh", ":lua require('lsp-inlayhints').toggle()<cr>", desc = "Toggle InlayHints" },
      { "<leader>lgt", "<cmd>Neogen type<cr>", desc = "Type doc" },
      { "<leader>lgc", "<cmd>Neogen class<cr>", desc = "Class doc" },
      { "<leader>lgf", "<cmd>Neogen func<cr>", desc = "Func doc" },
      { "<leader>lgd", "<cmd>Neogen file<cr>", desc = "Doc doc" },
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
    enabled = false,
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
}
