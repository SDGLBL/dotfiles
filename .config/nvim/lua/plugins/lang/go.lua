if not configs.go then
  return {}
end

return {
  -- add go to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "go", "gomod", "gowork", "gosum" })
      end
    end,
  },

  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "goimports", "gofumpt", "golangci-lint" })
    end,
  },

  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      local nls = require "null-ls"
      -- table.insert(opts.sources, nls.builtins.formatting.goimports)
      table.insert(opts.sources, nls.builtins.formatting.gofumpt)
      table.insert(opts.sources, nls.builtins.code_actions.gomodifytags)
      table.insert(opts.sources, nls.builtins.code_actions.impl)

      if vim.fn.filereadable(vim.fn.expand "~/.golangci.yml") == 1 then
        table.insert(
          opts.sources,
          nls.builtins.diagnostics.golangci_lint.with {
            filetypes = { "go" },
            extra_args = {
              "--fast",
              "-c",
              "~/.golangci.yml",
            },
          }
        )
        table.insert(
          opts.sources,
          nls.builtins.formatting.golines.with {
            filetypes = { "go" },
            extra_args = {
              "-m",
              "140",
              "--base-formatter",
              "gofumpt",
              -- "gofmt",
            },
          }
        )
      else
        table.insert(opts.sources, nls.builtins.formatting.golines)
        table.insert(
          opts.sources,
          nls.builtins.diagnostics.golangci_lint.with {
            filetypes = { "go" },
            extra_args = {
              "--fast",
              "-E",
              "errcheck,lll,gofmt,errorlint,deadcode,gosimple,govet,ineffassign,staticcheck,structcheck,typecheck,unused,varcheck,bodyclose,contextcheck,forcetypeassert,funlen,nilerr,revive",
            },
          }
        )
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
        gopls = {
          settings = {
            gopls = {
              gofumpt = true,
              semanticTokens = true,
              usePlaceholders = false,
              completeUnimported = true,
              staticcheck = true,
              directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
              codelenses = {
                generate = true,
                gc_details = false,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
              },
              analyses = {
                fieldalignment = false,
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
              },
              -- https://github.com/golang/tools/blob/master/gopls/doc/inlayHints.md
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
            },
          },
        },
      },
      setup = {
        gopls = function(_, opts)
          _ = opts
          -- workaround for gopls not supporting semanticTokensProvider
          -- https://github.com/golang/go/issues/54531#issuecomment-1464982242
          require("utils.lsp").on_attach(function(client, _)
            if client.name == "gopls" then
              if not client.server_capabilities.semanticTokensProvider then
                local semantic = client.config.capabilities.textDocument.semanticTokens
                client.server_capabilities.semanticTokensProvider = {
                  full = true,
                  legend = {
                    tokenTypes = semantic.tokenTypes,
                    tokenModifiers = semantic.tokenModifiers,
                  },
                  range = true,
                }
              end
            end
          end)
          -- end workaround
        end,
      },
    },
  },

  {
    "ray-x/go.nvim",
    event = "VeryLazy",
    ft = { "go", "gomod" },
    -- if you need to install/update all binaries
    -- build = ':lua require("go.install").update_all_sync()',
    dependencies = "ray-x/guihua.lua",
    opts = {
      lsp_inlay_hints = {
        enable = false,
      },
      lsp_codelens = false,
      lsp_keymaps = false,
      diagnostic = false,
      lsp_document_formatting = false,
      dap_debug = false,
      dap_debug_keymap = false,
    },
  },

  -- add go impl support
  {
    "edolphin-ydf/goimpl.nvim",
    ft = "go",
    build = "go install github.com/josharian/impl@latest",
    config = function()
      local ok, telescope = pcall(require, "telescope")
      if ok then
        telescope.load_extension "goimpl"
      end

      require("utils.lsp").on_attach(function(_, bufnr)
        -- get bufnr filetype
        local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
        if ft ~= "go" then
          return
        end

        local map = function(mode, lhs, rhs, desc)
          if desc then
            desc = desc
          end
          vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc, buffer = bufnr, noremap = true })
        end

        map("n", "<leader>li", "<cmd>lua require'telescope'.extensions.goimpl.goimpl{}<CR>", "Impl Interface")
      end)
    end,
  },

  {
    "mfussenegger/nvim-dap",
    dependencies = { "leoluz/nvim-dap-go", opts = {} },
  },

  -- tdd support
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/neotest-go",
    },
    opts = function(_, opts)
      vim.list_extend(opts.adapters, {
        require "neotest-go",
      })
    end,
  },
}
