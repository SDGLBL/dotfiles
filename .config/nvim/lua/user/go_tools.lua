if not configs.go_tools then
  return
end

local ok, goldsmith = pcall(require, "goldsmith")
if not ok then
  return
end

goldsmith.config {
  -- your config
  autoconfig = true,
  format = {
    goimports = {
      enabled = false,
      timeout = 1000,
    },
    run_on_save = false,
  },
  mappings = {
    enabled = false,
  },
  null = {
    enabled = false,
    golines = false,
    revive = false,
    run_setup = false,
  },
  highlight = {
    current_symbol = false,
  },
  inlay_hints = {
    enabled = false,
    highlight = "Comment",
  },
  -- gopls = {
  --   config = function()
  --     return {
  --       usePlaceholders = false,
  --       codelenses = {
  --         gc_details = true,
  --       },
  --       analyses = {
  --         fieldalignment = true,
  --         nilness = true,
  --         shadow = true,
  --       },
  --       -- https://github.com/golang/tools/blob/master/gopls/doc/inlayHints.md
  --       hints = {
  --         assignVariableTypes = true,
  --         compositeLiteralFields = true,
  --         compositeLiteralTypes = true,
  --         constantValues = true,
  --         functionTypeParameters = true,
  --         parameterNames = true,
  --         rangeVariableTypes = true,
  --       },
  --       on_attach = function(client, bufnr)
  --         -- your on_attach
  --         require("user.lsp.handlers").on_attach(client, bufnr)
  --       end,
  --     }
  --   end,
  -- },
}
