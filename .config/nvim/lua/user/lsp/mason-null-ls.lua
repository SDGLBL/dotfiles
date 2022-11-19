local ok, null_ls = pcall(require, "null-ls")
if not ok then
  return
end

require("mason-null-ls").setup {
  ensure_installed = {
    "stylua",
    "goimports",
    "taplo",
    "rustfmt",
    "prettier",
    "shellcheck",
    "hadolint",
    "golangci_lint",
    "codespell",
    "write_good",
  },
  automatic_setup = true,
}

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
local code_actions = null_ls.builtins.code_actions
local hover = null_ls.builtins.hover

require("mason-null-ls").setup_handlers {
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

  taplo = function(_, _)
    null_ls.register(formatting.taplo)
  end,

  rustfmt = function(_, _)
    null_ls.register(formatting.rustfmt.with { extra_args = { "--edition", "2021" } })
  end,

  prettier = function(_, _)
    null_ls.register(formatting.prettier.with { extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" } })
  end,

  shellcheck = function(_, _)
    null_ls.register(code_actions.shellcheck)
    null_ls.register(diagnostics.shellcheck)
  end,

  hadolint = function(_, _)
    null_ls.register(diagnostics.hadolint)
  end,

  golangci_lint = function(_, _)
    null_ls.register(diagnostics.golangci_lint.with {
      extra_args = {
        "-E",
        "errcheck,deadcode,,gosimple,govet,ineffassign,staticcheck,structcheck,typecheck,unused,varcheck,bodyclose,contextcheck,forcetypeassert,funlen,nilerr",
      },
    })
  end,

  write_good = function(_, _)
    null_ls.register(diagnostics.write_good)
  end,
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

null_ls.setup()
