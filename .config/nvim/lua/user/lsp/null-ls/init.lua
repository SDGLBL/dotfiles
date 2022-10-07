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
  local code_actions = null_ls.builtins.code_actions
  local hover = null_ls.builtins.hover

  local opts = {
    debug = false,
    sources = {
      -- pip install stylua
      formatting.stylua,
      -- go install golang.org/x/tools/cmd/goimports@latest
      formatting.goimports,
      -- cargo install taplo-cli
      formatting.taplo,
      -- rustup component add rust-src
      formatting.rustfmt.with { extra_args = { "--edition", "2021" } },
      -- npm install --save-dev --save-exact prettier
      formatting.prettier.with { extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" } },
      -- formatting.prettierd,
      -- pip install black
      formatting.black,
      -- https://github.com/koalaman/shellcheck#installing
      code_actions.shellcheck,
      code_actions.eslint,
      diagnostics.eslint,
      -- npm install textlint --global
      -- diagnostics.textlint,
      -- https://github.com/hadolint/hadolint/releases/tag/v2.10.0
      diagnostics.hadolint,
      -- pip install gitlint
      diagnostics.gitlint,
      diagnostics.shellcheck,
      -- code_actions.refactoring,
      -- https://github.com/danmar/cppcheck
      diagnostics.cppcheck,
      -- go install honnef.co/go/tools/cmd/staticcheck@2022.1
      -- diagnostics.staticcheck,
      -- curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin v1.45.2
      -- diagnostics.golangci_lint,
      diagnostics.golangci_lint.with {
        extra_args = {
          "-E",
          "bodyclose,contextcheck,errchkjson,forcetypeassert,funlen,nilerr",
        },
      },
      -- pip install codespell
      -- diagnostics.flake8,
      -- pip install codespell
      diagnostics.codespell,
      -- npm install --global write-good
      diagnostics.write_good,
      hover.dictionary.with {
        filetypes = { "text", "markdown", "norg" },
        generator = {
          fn = function(_, done)
            local cword = vim.fn.expand "<cword>"
            local send_definition = function(def)
              done { cword .. "\n" .. def }
            end

            require("plenary.curl").request {
              url = "https://api.dictionaryapi.dev/api/v2/entries/en/" .. cword,
              method = "get",
              callback = vim.schedule_wrap(function(data)
                if not (data and data.body) then
                  send_definition "no definition available"
                  return
                end

                local ok, decoded = pcall(vim.json.decode, data.body)
                if not ok or not (decoded and decoded[1]) then
                  send_definition "no definition available"
                  return
                end
                local definitions = decoded[1].meanings[1].definitions
                if not definitions then
                  send_definition "no definition available"
                  return
                end

                local def = ""
                for i, def_info in ipairs(definitions) do
                  def = def .. i .. ": " .. def_info.definition .. "\n"
                end

                send_definition(def)
              end),
            }
          end,
          async = true,
        },
      },
    },
  }

  null_ls.setup(opts)
end

return M
