local opts = {
  -- cmd = { "rust-analyzer" },
  -- cmd = { "rustup", "run", "nightly", "rust-analyzer" },
  cmd = { "rustup", "run", "stable", "rust-analyzer" },
  settings = {
    ["rust-analyzer"] = {
      imports = {
        granularity = {
          group = "module",
        },
        prefix = "self",
      },
      cargo = {
        buildScripts = {
          enable = true,
        },
      },
      procMacro = {
        enable = true,
      },
      -- inlayHints = {
      --   enable = true,
      --   chainingHints = true,
      --   maxLength = 25,
      --   parameterHints = true,
      --   typeHints = true,
      --   hideNamedConstructorHints = false,
      --   typeHintsSeparator = "‣",
      --   typeHintsWithVariable = true,
      --   chainingHintsSeparator = "‣",
      -- },
    },
  },
}

return opts
