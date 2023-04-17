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
    opts = {
      -- make sure mason installs the server
      servers = {
        gopls = {
          settings = {
            usePlaceholders = false,
            codelenses = {
              gc_details = true,
            },
            analyses = {
              fieldalignment = true,
              nilness = true,
              shadow = true,
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

  {
    "ray-x/go.nvim",
    event = "VeryLazy",
    ft = { "go", "gomod" },
    -- if you need to install/update all binaries
    build = ':lua require("go.install").update_all_sync()',
    enabled = configs.go_tools,
    dependencies = "ray-x/guihua.lua",
    config = true,
  },
}
