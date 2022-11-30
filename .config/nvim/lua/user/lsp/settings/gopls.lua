local opts = {
  settings = {
    gopls = {
      usePlaceholders = false,
      codelenses = {
        gc_details = true,
      },
      staticcheck = true,
      analyses = {
        fieldalignment = true,
        nilness = true,
        shadow = true,
      },
      allowModfileModifications = true,
      -- https://github.com/golang/tools/blob/master/gopls/doc/inlayHints.md
      -- hints = {
      --   assignVariableTypes = true,
      --   compositeLiteralFields = true,
      --   compositeLiteralTypes = true,
      --   constantValues = true,
      --   functionTypeParameters = true,
      --   parameterNames = true,
      --   rangeVariableTypes = true,
      -- },
    },
  },
}

return opts
