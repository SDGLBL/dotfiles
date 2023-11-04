if not configs.go then
  return {}
end

return {
  -- add go to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "go" })
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
              usePlaceholders = false,
              codelenses = {
                generate = true,
                gc_details = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
              },
              analyses = {
                unreachable = true,
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
    },
  },

  {
    "ray-x/go.nvim",
    event = "VeryLazy",
    ft = { "go", "gomod" },
    -- if you need to install/update all binaries
    build = ':lua require("go.install").update_all_sync()',
    enabled = configs.go,
    dependencies = "ray-x/guihua.lua",
    opts = {
      lsp_inlay_hints = {
        enable = false,
      },
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
