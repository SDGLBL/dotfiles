if not configs.cpp then
  return {}
end

local function get_codelldb()
  local mason_registry = require "mason-registry"
  local codelldb = mason_registry.get_package "codelldb"
  local extension_path = codelldb:get_install_path() .. "/extension/"
  local codelldb_path = extension_path .. "adapter/codelldb"
  local liblldb_path = extension_path .. "lldb/lib/liblldb.so"
  return codelldb_path, liblldb_path
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "c", "cpp" })
    end,
  },

  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "codelldb" })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = { "p00f/clangd_extensions.nvim" },
    opts = {
      servers = {
        clangd = {
          server = {
            root_dir = function(...)
              -- using a root .clang-format or .clang-tidy file messes up projects, so remove them
              return require("lspconfig.util").root_pattern(
                "compile_commands.json",
                "compile_flags.txt",
                "configure.ac",
                ".git"
              )(...)
            end,
            capabilities = {
              offsetEncoding = { "utf-16" },
            },
            cmd = {
              "clangd",
              "--background-index",
              "--clang-tidy",
              "--header-insertion=iwyu",
              "--completion-style=detailed",
              "--function-arg-placeholders",
              "--fallback-style=llvm",
            },
            init_options = {
              usePlaceholders = true,
              completeUnimported = true,
              clangdFileStatus = true,
            },
          },
          extensions = {
            inlay_hints = {
              inline = true,
            },
            ast = {
              --These require codicons (https://github.com/microsoft/vscode-codicons)
              role_icons = {
                type = "",
                declaration = "",
                expression = "",
                specifier = "",
                statement = "",
                ["template argument"] = "",
              },
              kind_icons = {
                Compound = "",
                Recovery = "",
                TranslationUnit = "",
                PackExpansion = "",
                TemplateTypeParm = "",
                TemplateTemplateParm = "",
                TemplateParamObject = "",
              },
            },
          },
        },
      },
      setup = {
        clangd = function(_, opts)
          require("clangd_extensions").setup {
            server = opts.server,
            extensions = opts.extensions,
          }
          return true
        end,
      },
    },
  },

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

  {
    "nvim-cmp",
    opts = function(_, opts)
      table.insert(opts.sorting.comparators, 1, require "clangd_extensions.cmp_scores")
    end,
  },

  {
    "nvim-neotest/neotest",
    dependencies = {
      { "alfaix/neotest-gtest", opts = {} },
    },
    opts = function(_, opts)
      vim.list_extend(opts.adapters, {
        require "neotest-gtest",
      })
    end,
  },
}
