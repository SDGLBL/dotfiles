if not configs.rust then
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
    dependencies = { "simrat39/rust-tools.nvim", "rust-lang/rust.vim" },
    opts = {
      -- make sure mason installs the server
      -- LSP Server Settings
      ---@type lspconfig.options
      servers = {
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              imports = {
                granularity = {
                  group = "module",
                },
                prefix = "self",
              },
              cargo = {
                allFeatures = true,
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
      setup = {
        rust_analyzer = function(_, opts)
          local codelldb_path, liblldb_path = get_codelldb()
          require("utils.lsp").on_attach(function(client, bufnr)
            local map = function(mode, lhs, rhs, desc)
              if desc then
                desc = desc
              end
              vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc, buffer = bufnr, noremap = true })
            end

            -- stylua: ignore
            if client.name == "rust_analyzer" then
              map("n", "<leader>le", "<cmd>RustRunnables<cr>", "Runnables")
              map("n", "<leader>ll", function() vim.lsp.codelens.run() end, "Code Lens" )
              map("n", "<leader>lt", "<cmd>Cargo test<cr>", "Cargo test" )
              map("n", "<leader>lR", "<cmd>Cargo run<cr>", "Cargo run" )
            end
          end)

          vim.api.nvim_create_autocmd({ "BufEnter" }, {
            pattern = { "Cargo.toml" },
            callback = function(event)
              local bufnr = event.buf

              -- Register keymappings
              local wk = require "which-key"
              local keys = { mode = { "n", "v" }, ["<leader>lc"] = { name = "+Crates" } }
              wk.register(keys)

              local map = function(mode, lhs, rhs, desc)
                if desc then
                  desc = desc
                end
                vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc, buffer = bufnr, noremap = true })
              end
              map("n", "<leader>lcy", "<cmd>lua require'crates'.open_repository()<cr>", "Open Repository")
              map("n", "<leader>lcp", "<cmd>lua require'crates'.show_popup()<cr>", "Show Popup")
              map("n", "<leader>lci", "<cmd>lua require'crates'.show_crate_popup()<cr>", "Show Info")
              map("n", "<leader>lcf", "<cmd>lua require'crates'.show_features_popup()<cr>", "Show Features")
              map("n", "<leader>lcd", "<cmd>lua require'crates'.show_dependencies_popup()<cr>", "Show Dependencies")
            end,
          })

          require("rust-tools").setup {
            tools = {
              inlay_hints = {
                auto = false,
              },
              -- hover_actions = { border = "solid" },
              on_initialized = function()
                vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "CursorHold", "InsertLeave" }, {
                  pattern = { "*.rs" },
                  callback = function()
                    vim.lsp.codelens.refresh()
                  end,
                })
              end,
            },
            server = opts,
            dap = {
              adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
            },
          }
          return true
        end,
      },
    },
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
    enabled = configs.rust,
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
