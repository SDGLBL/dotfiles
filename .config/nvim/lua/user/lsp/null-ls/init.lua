---@diagnostic disable: redundant-parameter
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
  local hover = null_ls.builtins.hover

  local opts = {
    debug = false,
    sources = {
      -- pip install stylua
      formatting.stylua,
      -- go install golang.org/x/tools/cmd/goimports@latest
      formatting.goimports,
      -- npm install --save-dev --save-exact prettier
      formatting.prettier.with({ extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" } }),
      -- code_actions.refactoring,
      -- curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin v1.45.2
      diagnostics.golangci_lint.with({
        extra_args = {
          "run",
          "--fix=true",
          "--fast",
          "-E",
          "bodyclose,contextcheck,errchkjson,forcetypeassert,funlen,nilerr",
          "--out-format=json",
          "$DIRNAME",
          "--path-prefix",
          "$ROOT",
        },
      }),
      -- pip install codespell
      diagnostics.flake8,
      -- pip install codespell
      diagnostics.codespell,
      -- hover.dictionary,
    },
  }

  null_ls.setup(opts)
end

return M
