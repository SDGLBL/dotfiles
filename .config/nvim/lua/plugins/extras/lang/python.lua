return {
  -- add json to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "ninja", "python", "rst", "toml" })
      end
    end,
  },

  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      local nls = require "null-ls"
      table.insert(opts.sources, nls.builtins.formatting.black)
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
        pyright = {},
        ruff_lsp = {
          on_attach = function(client, _)
            -- Disable hover in favor of Pyright
            client.server_capabilities.hoverProvider = false
          end,
        },
      },
    },
  },

  -- python debug
  {
    "mfussenegger/nvim-dap",
    opts = {
      setup = {
        python = function(_)
          local dap = require "dap"
          local input_args = require("utils").input_args

          dap.adapters.python = {
            type = "executable",
            command = "python3",
            args = {
              "-m",
              "debugpy.adapter",
            },
          }

          dap.configurations.python = {
            {
              type = "python",
              request = "launch",
              name = "Launch file",
              justMyCode = false,
              program = "${file}",
              args = input_args,
              pythonPath = function()
                local cwd = vim.fn.getcwd()

                if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
                  return cwd .. "/venv/bin/python"
                elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
                  return cwd .. "/.venv/bin/python"
                elseif os.getenv "CONDA_PREFIX" ~= nil and os.getenv "CONDA_PREFIX" ~= "" then
                  return os.getenv "CONDA_PREFIX" .. "/bin/python"
                else
                  -- 运行 shell cmd $(where python3 | head -n 1) 获取 python3 的路径
                  local python3 = vim.fn.trim(vim.fn.system "which python3 | head -n 1")
                  local python = vim.fn.trim(vim.fn.system "which python | head -n 1")
                  return python3 ~= "" and python3 or python
                end
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
      "nvim-neotest/neotest-python",
    },
    opts = function(_, opts)
      vim.list_extend(opts.adapters, {
        require "neotest-python" {
          dap = { justMyCode = false },
          runner = "unittest",
        },
      })
    end,
  },
}
