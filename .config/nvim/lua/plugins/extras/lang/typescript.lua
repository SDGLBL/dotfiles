if not configs.typescript then
  return
end

return {
  -- add typescript to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "typescript", "tsx", "javascript" })
      end
    end,
  },

  -- correctly setup lspconfig
  {
    "neovim/nvim-lspconfig",
    dependencies = { "jose-elias-alvarez/typescript.nvim" },
    ---@class PluginLspOpts
    opts = {
      -- make sure mason installs the server
      -- LSP Server Settings
      ---@type lspconfig.options
      servers = {
        ---@type lspconfig.options.tsserver
        tsserver = {
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayVariableTypeHintsWhenTypeMatchesName = false,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
              format = {
                indentSize = vim.o.shiftwidth,
                convertTabsToSpaces = vim.o.expandtab,
                tabSize = vim.o.tabstop,
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayVariableTypeHintsWhenTypeMatchesName = false,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
              format = {
                indentSize = vim.o.shiftwidth,
                convertTabsToSpaces = vim.o.expandtab,
                tabSize = vim.o.tabstop,
              },
            },
            completions = {
              completeFunctionCalls = true,
            },
          },
        },
        -- ESLint
        eslint = {
          settings = {
            -- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
            workingDirectory = { mode = "auto" },
          },
        },
      },
      setup = {
        tsserver = function(_, opts)
          require("utils.lsp").on_attach(function(client, buffer)
            if client.name == "tsserver" then
              -- stylua: ignore
              vim.keymap.set("n", "<leader>co", "<cmd>TypescriptOrganizeImports<CR>", { buffer = buffer, desc = "Organize Imports" })
              -- stylua: ignore
              vim.keymap.set("n", "<leader>cR", "<cmd>TypescriptRenameFile<CR>", { desc = "Rename File", buffer = buffer })
            end
          end, { group = "_tsserver_keymaps", desc = "init tsserver keymaps" })
          require("typescript").setup { server = opts }
          return true
        end,
        eslint = function()
          vim.api.nvim_create_autocmd("BufWritePre", {
            callback = function(event)
              local client = vim.lsp.get_active_clients({ bufnr = event.buf, name = "eslint" })[1]
              if client then
                local diag = vim.diagnostic.get(event.buf, { namespace = vim.lsp.diagnostic.get_namespace(client.id) })
                if #diag > 0 then
                  vim.cmd "EslintFixAll"
                end
              end
            end,
          })
        end,
      },
    },
  },

  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      table.insert(opts.sources, require "typescript.extensions.null-ls.code-actions")
    end,
  },

  -- color picker
  {
    "uga-rosa/ccc.nvim",
    ft = { "javascriptreact", "javascript", "typescript", "typescriptreact", "css", "html", "lua" },
    enabled = configs.color_picker,
    config = function(_, _)
      require("ccc").setup {}

      require("utils.lsp").on_attach(function(client, bufnr)
        if client.name == "tsserver" then
          vim.keymap.set("n", "<leader>cc", "<cmd>CccPick<CR>", { buffer = bufnr, desc = "Color picker" })
        end
      end)
    end,
  },

  -- debug
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      { "mxsdev/nvim-dap-vscode-js" },
      {
        "microsoft/vscode-js-debug",
        build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
      },
    },
    opts = {
      setup = {
        vscode_js_debug = function()
          local function get_js_debug()
            local path = vim.fn.stdpath "data"
            return path .. "/lazy/vscode-js-debug"
          end

          require("dap-vscode-js").setup {
            node_path = "node",
            debugger_path = get_js_debug(),
            adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
          }

          for _, language in ipairs { "typescript", "javascript" } do
            require("dap").configurations[language] = {
              {
                type = "pwa-node",
                request = "launch",
                name = "Launch file",
                program = "${file}",
                cwd = "${workspaceFolder}",
              },
              {
                type = "pwa-node",
                request = "attach",
                name = "Attach",
                processId = require("dap.utils").pick_process,
                cwd = "${workspaceFolder}",
              },
              {
                type = "pwa-node",
                request = "launch",
                name = "Debug Jest Tests",
                -- trace = true, -- include debugger info
                runtimeExecutable = "node",
                runtimeArgs = {
                  "./node_modules/jest/bin/jest.js",
                  "--runInBand",
                },
                rootPath = "${workspaceFolder}",
                cwd = "${workspaceFolder}",
                console = "integratedTerminal",
                internalConsoleOptions = "neverOpen",
              },
              {
                type = "pwa-chrome",
                name = "Attach - Remote Debugging",
                request = "attach",
                program = "${file}",
                cwd = vim.fn.getcwd(),
                sourceMaps = true,
                protocol = "inspector",
                port = 9222, -- Start Chrome google-chrome --remote-debugging-port=9222
                webRoot = "${workspaceFolder}",
              },
              {
                type = "pwa-chrome",
                name = "Launch Chrome",
                request = "launch",
                url = "http://localhost:3000", -- This is for Vite. Change it to the framework you use
                webRoot = "${workspaceFolder}",
                userDataDir = "${workspaceFolder}/.vscode/vscode-chrome-debug-userdatadir",
              },
            }
          end

          for _, language in ipairs { "typescriptreact", "javascriptreact" } do
            require("dap").configurations[language] = {
              {
                type = "pwa-chrome",
                name = "Attach - Remote Debugging",
                request = "attach",
                program = "${file}",
                cwd = vim.fn.getcwd(),
                sourceMaps = true,
                protocol = "inspector",
                port = 9222, -- Start Chrome google-chrome --remote-debugging-port=9222
                webRoot = "${workspaceFolder}",
              },
              {
                type = "pwa-chrome",
                name = "Launch Chrome",
                request = "launch",
                url = "http://localhost:5173", -- This is for Vite. Change it to the framework you use
                webRoot = "${workspaceFolder}",
                userDataDir = "${workspaceFolder}/.vscode/vscode-chrome-debug-userdatadir",
              },
            }
          end
        end,
      },
    },
  },

  -- test
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/neotest-jest",
      "marilari88/neotest-vitest",
      "thenbe/neotest-playwright",
    },
    opts = function(_, opts)
      vim.list_extend(opts.adapters, {
        require "neotest-jest",
        require "neotest-vitest",
        require("neotest-playwright").adapter {
          options = {
            persist_project_selection = true,
            enable_dynamic_test_discovery = true,
          },
        },
      })
    end,
  },
}
