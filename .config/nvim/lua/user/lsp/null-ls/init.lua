local M = {}

function M.setup()
  local null_ls_status_ok, null_ls = pcall(require, "null-ls")
  if not null_ls_status_ok then
    return
  end

  -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
  local formatting = null_ls.builtins.formatting
  -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
  local diagnostics = null_ls.builtins.diagnostics
  -- local code_actions = null_ls.builtins.code_actions

  null_ls.setup({
    debug = false,
    sources = {
      formatting.stylua,
      -- code_actions.refactoring,
      diagnostics.golangci_lint.with({
        extra_args = { "run", "--fix=true", "--fast", "--out-format=json", "$DIRNAME", "--path-prefix", "$ROOT" },
      }),
      -- diagnostics.flake8,
      -- formatting.prettier.with { extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" } },
      -- formatting.black.with { extra_args = { "--fast" } },
      -- formatting.yapf,
    },
  })
end

return M
