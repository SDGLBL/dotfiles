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
            ["rust-analyzer"] = {
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
              inlayHints = {
                enable = true,
                chainingHints = true,
                maxLength = 25,
                parameterHints = true,
                typeHints = true,
                typeHintsWithVariable = true,
                closureCaptureHints = true,
                closingBraceHints = true,
                discriminantHints = true,
                typeHintsSeparator = "‣",
                hideNamedConstructorHints = true,
                chainingHintsSeparator = "‣",
              },
            },
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
        tools = {
          inlay_hints = {
            auto = false,
          },
        },
        server = {
          on_attach = function(_, _) end,
        },
      }
    end,
  },

  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    dependencies = { { "nvim-lua/plenary.nvim" } },
    config = function()
      require("crates").setup {
        null_ls = {
          enabled = true,
          name = "crates.nvim",
        },
      }
    end,
    enabled = configs.rust_tools,
  },

  -- rust debug
  {
    "mfussenegger/nvim-dap",
    opts = function(_, opts)
      if not type(opts.setup) == "table" then
        return
      end

      local dap = require "dap"
      local input_args = require("utils").input_args
      local os_type = vim.loop.os_uname().sysname

      if os_type == nil then
        return
      end

      local setup = {}

      if string.find(os_type, "Darwin") then
        setup["codelldb"] = function()
          dap.adapters.codelldb = {
            type = "server",
            port = "${port}",
            executable = {
              -- CHANGE THIS to your path!
              command = vim.fn.join({ vim.fn.stdpath "data", "mason", "bin", "codelldb" }, "/"),
              args = { "--port", "${port}" },

              -- On windows you may have to uncomment this:
              -- detached = false,
            },
          }

          dap.configurations.rust = {
            {
              name = "Launch file",
              type = "codelldb",
              request = "launch",
              program = function()
                ---@diagnostic disable-next-line: redundant-parameter
                return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
              end,
              args = input_args,
              cwd = "${workspaceFolder}",
              stopOnEntry = false,
            },
          }
        end
      elseif string.find(os_type, "Linux") then
        setup["cppdbg"] = function()
          dap.adapters.cppdbg = {
            id = "cppdbg",
            type = "executable",
            ---@diagnostic disable-next-line: undefined-global
            command = vim.fn.join({ vim.fn.stdpath "data", "mason", "bin", "OpenDebugAD7" }, "/"),
          }

          dap.configurations.rust = {
            {
              name = "Launch file",
              type = "cppdbg",
              request = "launch",
              program = function()
                ---@diagnostic disable-next-line: redundant-parameter
                return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
              end,
              args = input_args,
              cwd = "${workspaceFolder}",
              stopOnEntry = true,
            },
            {
              name = "Attach to gdbserver :1234",
              type = "cppdbg",
              request = "launch",
              MIMode = "gdb",
              miDebuggerServerAddress = "localhost:1234",
              miDebuggerPath = "/usr/bin/gdb",
              cwd = "${workspaceFolder}",
              program = function()
                ---@diagnostic disable-next-line: redundant-parameter
                return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
              end,
              args = input_args,
            },
          }
        end
      end

      vim.list_extend(opts.setup, setup)
    end,
  },

  -- tdd support
  {
    "nvim-neotest/neotest",
    dependencies = {
      "rouge8/neotest-rust",
    },
    opts = function(_, opts)
      vim.list_extend(opts.adapters, {
        require "neotest-rust",
      })
    end,
  },
}
