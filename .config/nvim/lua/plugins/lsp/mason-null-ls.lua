return {
  setup = function(opts)
    local ok, null_ls = pcall(require, "null-ls")
    if not ok then
      return
    end

    local formatting = null_ls.builtins.formatting
    local diagnostics = null_ls.builtins.diagnostics
    local code_actions = null_ls.builtins.code_actions
    local hover = null_ls.builtins.hover

    require("mason-null-ls").setup {
      ensure_installed = opts.ensure_installed,
      automatic_setup = true,
      handlers = {
        function(source_name, methods)
          -- all sources with no handler get passed here
          -- Keep original functionality of `automatic_setup = true`
          require "mason-null-ls.automatic_setup"(source_name, methods)
        end,
        stylua = function(_, _)
          null_ls.register(formatting.stylua)
        end,
        goimports = function(_, _)
          null_ls.register(formatting.goimports)
        end,
        gomodifytags = function(_, _)
          null_ls.register(code_actions.gomodifytags)
        end,
        impl = function(_, _)
          null_ls.register(code_actions.impl)
        end,
        taplo = function(_, _)
          null_ls.register(formatting.taplo)
        end,
        rustfmt = function(_, _)
          null_ls.register(formatting.rustfmt.with { extra_args = { "--edition", "2021" } })
        end,
        prettier = function(_, _)
          null_ls.register(formatting.prettier.with { extra_args = { "--no-semi" } })
        end,
        shellcheck = function(_, _)
          null_ls.register(code_actions.shellcheck)
          null_ls.register(diagnostics.shellcheck)
        end,
        hadolint = function(_, _)
          null_ls.register(diagnostics.hadolint)
        end,
        golangci_lint = function(_, _)
          if vim.fn.filereadable(vim.fn.expand "~/.golangci.yml") == 1 then
            null_ls.register(diagnostics.golangci_lint.with {
              extra_args = {
                "-c",
                "~/.golangci.yml",
              },
            })
          else
            null_ls.register(diagnostics.golangci_lint.with {
              extra_args = {
                "-E",
                "errcheck,lll,gofmt,errorlint,deadcode,gosimple,govet,ineffassign,staticcheck,structcheck,typecheck,unused,varcheck,bodyclose,contextcheck,forcetypeassert,funlen,nilerr,revive",
              },
            })
          end
        end,
        codespell = function(_, _)
          null_ls.register(diagnostics.codespell.with {
            extra_args = {
              "-T",
              vim.fn.stdpath "config" .. "/codespell-ignore-words",
            },
          })
        end,
        golines = function(_, _)
          if vim.fn.filereadable(vim.fn.expand "~/.golangci.yml") == 1 then
            null_ls.register(formatting.golines.with {
              extra_args = {
                "-m",
                "95",
                "--base-formatter",
                "gofmt",
              },
            })
          else
            null_ls.register(formatting.golines)
          end
        end,
      },
    }

    null_ls.register(hover.dictionary.with {
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

              local ok_decoded, decoded = pcall(vim.json.decode, data.body)
              if not ok_decoded or not (decoded and decoded[1]) then
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
    })

    for _, source in ipairs(opts.sources) do
      null_ls.register(source)
    end

    null_ls.setup {
      should_attach = function(bufnr)
        -- get filetype
        local should_not_attach_fts = {
          "NvimTree",
        }
        local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
        return not vim.tbl_contains(should_not_attach_fts, ft)
      end,
    }
  end,
}
