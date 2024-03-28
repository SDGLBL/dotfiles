if not configs.rust then
  return {}
end

local function get_codelldb()
  local mason_registry = require "mason-registry"
  local codelldb = mason_registry.get_package "codelldb"
  local extension_path = codelldb:get_install_path() .. "/extension/"
  local codelldb_path = extension_path .. "adapter/codelldb"
  local os_name = require("utils").os_name()
  local liblldb_path = extension_path .. "lldb/lib/liblldb.so"

  if os_name == "macOS" then
    liblldb_path = extension_path .. "lldb/lib/liblldb.dylib"
  end
  return codelldb_path, liblldb_path
end

return {
  -- add rust to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "rust", "toml", "ron" })
      end
    end,
  },

  -- Ensure Rust debugger is installed
  {
    "williamboman/mason.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "codelldb" })
    end,
  },

  -- Correctly setup lspconfig for Rust 🚀
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        rust_analyzer = {},
        taplo = {
          keys = {
            {
              "K",
              function()
                if vim.fn.expand "%:t" == "Cargo.toml" and require("crates").popup_available() then
                  require("crates").show_popup()
                else
                  vim.lsp.buf.hover()
                end
              end,
              desc = "Show Crate Documentation",
            },
          },
        },
      },
      setup = {
        rust_analyzer = function()
          return true
        end,
      },
    },
  },

  {
    "mrcjkb/rustaceanvim",
    version = "^4", -- Recommended
    ft = { "rust" },
    opts = {
      server = {
        on_attach = function(_, bufnr)
          vim.keymap.set("n", "<leader>la", function()
            vim.cmd.RustLsp "codeAction"
          end, { desc = "Code Action", buffer = bufnr })
          vim.keymap.set("n", "<leader>dR", function()
            vim.cmd.RustLsp "debuggables"
          end, { desc = "Rust debuggables", buffer = bufnr })
        end,
        default_settings = {
          -- rust-analyzer language server configuration
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              runBuildScripts = true,
            },
            -- Add clippy lints for Rust.
            checkOnSave = {
              allFeatures = true,
              command = "clippy",
              extraArgs = { "--no-deps" },
            },
            procMacro = {
              enable = true,
              ignored = {
                ["async-trait"] = { "async_trait" },
                ["napi-derive"] = { "napi" },
                ["async-recursion"] = { "async_recursion" },
              },
            },
          },
        },
      },
    },
    config = function(_, opts)
      vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})
    end,
  },

  {
    "Saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    opts = {
      null_ls = {
        enabled = true,
        name = "crates.nvim",
      },
      popup = {
        border = "rounded",
      },
    },
    config = function(_, opts)
      require("crates").setup(opts)
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local cmp = require "cmp"
      opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
        { name = "crates" },
      }))
    end,
  },

  -- rust debug
  {
    "mfussenegger/nvim-dap",
    opts = {
      setup = {
        codelldb = function(_)
          local os_type = vim.loop.os_uname().sysname
          if os_type == nil then
            return
          end

          if not string.find(os_type, "Darwin") then
            return
          end

          local dap = require "dap"
          local codelldb_path, _ = get_codelldb()
          local input_args = require("utils").input_args

          dap.adapters.codelldb = {
            type = "server",
            port = "${port}",
            executable = {
              -- CHANGE THIS to your path!
              command = codelldb_path,
              args = { "--port", "${port}" },

              -- On windows you may have to uncomment this:
              -- detached = false,
            },
          }

          dap.configurations.cpp = {
            {
              name = "Launch file",
              type = "codelldb",
              request = "launch",
              program = function()
                ---@diagnostic disable-next-line: redundant-parameter
                return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
              end,
              args = input_args,
              cwd = "${workspaceFolder}",
              stopOnEntry = false,
            },
          }

          dap.configurations.c = dap.configurations.cpp

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
        end,
        cppdbg = function(_)
          local os_type = vim.loop.os_uname().sysname
          if os_type == nil then
            return
          end

          if not string.find(os_type, "Linux") then
            return
          end

          local dap = require "dap"
          local input_args = require("utils").input_args

          dap.adapters.cppdbg = {
            id = "cppdbg",
            type = "executable",
            ---@diagnostic disable-next-line: undefined-global
            command = vim.fn.join({ vim.fn.stdpath "data", "mason", "bin", "OpenDebugAD7" }, "/"),
          }

          dap.configurations.cpp = {
            {
              name = "Launch file",
              type = "cppdbg",
              request = "launch",
              program = function()
                ---@diagnostic disable-next-line: redundant-parameter
                return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
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
                return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
              end,
              args = input_args,
            },
          }

          dap.configurations.c = dap.configurations.cpp

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
        end,
      },
    },
  },

  -- tdd support
  {
    "nvim-neotest/neotest",
    optional = true,
    opts = function(_, opts)
      vim.list_extend(opts.adapters, {
        require "rustaceanvim.neotest",
      })
    end,
  },
}
