return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      defaults = {
        { "<leader>l", group = "LSP" },
        { "<leader>lg", group = "Generate Doc" },
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
      { "folke/neoconf.nvim", cmd = "Neoconf", config = true },
      { "ray-x/lsp_signature.nvim", enabled = false, opts = { hint_prefix = require("utils.icons").diagnostics.BoldHint .. " " } },
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
    opts = function()
      return {
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
      }
    end,
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

  {
    "nvimtools/none-ls.nvim",
    enabled = false,
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason.nvim" },
    opts = function()
      local nls = require "null-ls"
      return {
        root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
        sources = {
          nls.builtins.formatting.shfmt,
          -- nls.builtins.diagnostics.shellcheck,
          -- nls.builtins.code_actions.shellcheck,
          nls.builtins.diagnostics.codespell.with {
            extra_args = {
              "-L crate,ser,",
            },
          },
        },
      }
    end,
  },

  {
    "jay-babu/mason-null-ls.nvim",
    enabled = false,
    event = "VeryLazy",
    opts = {
      ensure_installed = nil,
      automatic_installation = true,
      automatic_setup = false,
    },
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
        finder = {
          layout = "normal",
        },
      }

      -- set keymaps
      require("utils.lsp").on_attach(function(client, bufnr)
        local self = require("plugins.lsp.keymaps").new(client, bufnr)

        self:map("gh", "Lspsaga finder", { desc = "Lspsaga finder" })
        self:map("gr", "Lspsaga finder", { desc = "Lspsaga finder" })
        self:map("gp", "Lspsaga peek_definition", { desc = "Lspsaga peek_definition" })
        -- self:map("gd", "Lspsaga goto_definition", { desc = "Lspsaga goto_definition" })
        -- self:map("<leader>la", "Lspsaga code_action", { desc = "Lspsaga code_action", mode = { "n", "v" }, has = "codeAction" })
        self:map("<leader>lr", "Lspsaga rename", { desc = "Lspsaga rename" })
        self:map("<leader>lj", "Lspsaga diagnostic_jump_next", { desc = "Lspsaga diagnostic_jump_next" })
        self:map("<leader>lk", "Lspsaga diagnostic_jump_prev", { desc = "Lspsaga diagnostic_jump_prev" })
        -- self:map("<leader>lW", "Lspsaga show_line_diagnostics", { desc = "Lspsaga show_line_diagnostics" })
        -- self:map("<leader>lw", "Lspsaga show_workspace_diagnostics", { desc = "Lspsaga show_workspace_diagnostics" })
        -- self:map("<leader>lo", "Lspsaga outline", { desc = "Lspsaga outline" })
        -- self:map("<leader>lc", vim.lsp.codelens.run, { desc = "Codelenses" })
        self:map("<leader>lo", "Lspsaga outgoing_calls", { desc = "Lspsaga outgoing_calls" })
        self:map("<leader>li", "Lspsaga incoming_calls", { desc = "Lspsaga incoming_calls" })
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
    -- dependencies = { "nvim-telescope/telescope.nvim" },
    -- stylua: ignore
    keys = {
      { "<leader>rs", function() require("telescope").extensions.refactoring.refactors() end,    mode = { "v" },      desc = "Refactor" },
      { "<leader>ri", function() require("refactoring").refactor "Inline Variable" end,          mode = { "n", "v" }, desc = "Inline Variable" },
      { "<leader>rb", function() require("refactoring").refactor "Extract Block" end,            mode = { "n" },      desc = "Extract Block" },
      { "<leader>rf", function() require("refactoring").refactor "Extract Block To File" end,    mode = { "n" },      desc = "Extract Block to File" },
      { "<leader>rP", function() require("refactoring").debug.printf { below = false } end,      mode = { "n" },      desc = "Debug Print" },
      { "<leader>rp", function() require("refactoring").debug.print_var { normal = true } end,   mode = { "n" },      desc = "Debug Print Variable" },
      { "<leader>rc", function() require("refactoring").debug.cleanup {} end,                    mode = { "n" },      desc = "Debug Cleanup" },
      { "<leader>rf", function() require("refactoring").refactor "Extract Function" end,         mode = { "v" },      desc = "Extract Function" },
      { "<leader>rF", function() require("refactoring").refactor "Extract Function to File" end, mode = { "v" },      desc = "Extract Function to File" },
      { "<leader>rx", function() require("refactoring").refactor "Extract Variable" end,         mode = { "v" },      desc = "Extract Variable" },
      { "<leader>rp", function() require("refactoring").debug.print_var {} end,                  mode = { "v" },      desc = "Debug Print Variable" },
    },
    config = function()
      if not configs.refactor then
        return
      end

      local refactor = require "refactoring"

      -- local ok, telescope = pcall(require, "telescope")
      -- if ok then
      --   telescope.load_extension "refactoring"
      -- end

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
    enabled = false,
    opts = {
      vt_position = "end_of_line",
    },
  },

  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = { use_diagnostic_signs = true },
    keys = {
      { "<leader>ld", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
      { "<leader>lD", "<cmd>Trouble diagnostics toggle<cr>", desc = "Workspace Diagnostics" },
      {
        "[q",
        function()
          if require("trouble").is_open() then
            require("trouble").previous { skip_groups = true, jump = true }
          else
            local ok, err = pcall(vim.cmd.cprev)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Previous trouble/quickfix item",
      },
      {
        "]q",
        function()
          if require("trouble").is_open() then
            require("trouble").next { skip_groups = true, jump = true }
          else
            local ok, err = pcall(vim.cmd.cnext)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Next trouble/quickfix item",
      },
    },
  },

  {
    "VidocqH/lsp-lens.nvim",
    config = false,
  },

  {
    "danymat/neogen",
    keys = {
      { "<leader>lgt", "<cmd>Neogen type<cr>", desc = "Type doc" },
      { "<leader>lgc", "<cmd>Neogen class<cr>", desc = "Class doc" },
      { "<leader>lgf", "<cmd>Neogen func<cr>", desc = "Func doc" },
      { "<leader>lgd", "<cmd>Neogen file<cr>", desc = "Doc doc" },
    },
    event = "VeryLazy",
    config = true,
  },

  {
    "stevearc/conform.nvim",
    dependencies = { "mason.nvim" },
    lazy = true,
    cmd = "ConformInfo",
    keys = {
      {
        "<leader>lF",
        function()
          require("conform").format { formatters = { "injected" }, timeout_ms = 3000 }
        end,
        mode = { "n", "v" },
        desc = "Format Injected Langs",
      },
    },
    opts = function()
      ---@class ConformOpts
      local opts = {
        log_level = vim.log.levels.TRACE,
        -- LazyVim will use these options when formatting with the conform.nvim formatter
        format = {
          timeout_ms = 3000,
          async = false, -- not recommended to change
          quiet = false, -- not recommended to change
          lsp_fallback = true, -- not recommended to change
        },
        formatters_by_ft = {
          lua = { "stylua" },
          fish = { "fish_indent" },
          sh = { "shfmt" },
        },
        -- The options you set here will be merged with the builtin formatters.
        -- You can also define any custom formatters here.
        ---@type table<string, conform.FormatterConfigOverride|fun(bufnr: integer): nil|conform.FormatterConfigOverride>
        formatters = {
          injected = { options = { ignore_errors = true } },
          -- # Example of using dprint only when a dprint.json file is present
          -- dprint = {
          --   condition = function(ctx)
          --     return vim.fs.find({ "dprint.json" }, { path = ctx.filename, upward = true })[1]
          --   end,
          -- },
          --
          -- # Example of using shfmt with extra args
          -- shfmt = {
          --   prepend_args = { "-i", "2", "-ci" },
          -- },
        },
      }
      return opts
    end,
  },

  {
    "rachartier/tiny-code-action.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope.nvim" },
    },
    event = "LspAttach",
    config = function()
      require("tiny-code-action").setup()

      require("utils.lsp").on_attach(function(client, bufnr)
        local self = require("plugins.lsp.keymaps").new(client, bufnr)

        self:map("<leader>la", function()
          require("tiny-code-action").code_action()
        end, { desc = "Tiny code_action", mode = { "n", "v" }, has = "codeAction" })
      end, { group = "_tiny_code_action", desc = "init tiny action keymaps" })
    end,
  },
}
