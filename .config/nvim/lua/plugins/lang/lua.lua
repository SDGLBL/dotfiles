return {
  -- add lua to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "lua", "luadoc", "luap" })
      end
    end,
  },

  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "stylua" })
    end,
  },

  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },

  { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings

  { -- optional completion source for require statements and module annotations
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      table.insert(opts.sources, {
        name = "lazydev",
        group_index = 0, -- set group index to 0 to skip loading LuaLS completions
      })
    end,
  },

  -- correctly setup lspconfig
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- {
      --   "folke/neodev.nvim",
      --   opts = {
      --     library = {
      --       types = true,
      --       plugins = {
      --         -- "neotest",
      --         -- "nvim-lspconfig",
      --         "plenary.nvim",
      --         "telescope.nvim",
      --         "lazy.nvim",
      --         "nvim-cmp",
      --         "codecompanion",
      --         "rustaceanvim",
      --         "conform.nvim",
      --         "nvim-lint",
      --         "lint",
      --         "conform",
      --         -- "flash.nvim",
      --         -- "nvim-treesitter",
      --         -- "LuaSnip",
      --       },
      --     },
      --   },
      -- },
    },
    ---@class PluginLspOpts
    opts = {
      -- make sure mason installs the server
      -- LSP Server Settings
      ---@type lspconfig.options
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = "Insert",
              },
              workspace = {
                checkThirdParty = false,
                library = {
                  -- luarocks path
                  -- [vim.fn.expand "~/.luarocks/share/lua/5.1"] = true,
                  -- "/opt/homebrew/share/lua/5.4/",
                  -- "~/.local/share/nvim/lazy/luarocks.nvim/.rocks/share/lua/5.1/",
                },
              },
            },
          },
        },
      },
      setup = {
        lua_ls = function(_, _)
          require("utils.lsp").on_attach(function(client, bufnr)
            if client.name == "lua_ls" then
              vim.keymap.set("n", "<leader>dX", function()
                require("osv").run_this()
              end, { buffer = bufnr, desc = "OSV Run" })
              vim.keymap.set("n", "<leader>dL", function()
                require("osv").launch { port = 8086 }
              end, { buffer = bufnr, desc = "OSV Launch" })
            end
          end)
        end,
      },
    },
  },

  -- lua debug
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      { "jbyuki/one-small-step-for-vimkind" },
    },
    opts = {
      setup = {
        osv = function(_, _)
          local dap = require "dap"

          dap.adapters.nlua = function(callback, config)
            callback { type = "server", host = config.host, port = config.port }
          end

          dap.configurations.lua = {
            {
              type = "nlua",
              request = "attach",
              name = "Attach to running Neovim instance",
              host = function()
                local value = vim.fn.input "Host [127.0.0.1]: "
                if value ~= "" then
                  return value
                end
                return "127.0.0.1"
              end,
              port = function()
                local val = tonumber(vim.fn.input("Port: ", "8086"))
                assert(val, "Please provide a port number")
                return val
              end,
            },
          }
        end,
      },
    },
  },

  -- tdd support
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/neotest-plenary",
    },
    opts = function(_, opts)
      vim.list_extend(opts.adapters, {
        require "neotest-plenary",
      })
    end,
  },
}
