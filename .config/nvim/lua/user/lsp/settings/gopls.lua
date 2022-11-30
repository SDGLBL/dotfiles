local opts = {
  settings = {
    gopls = {
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
}

return opts
