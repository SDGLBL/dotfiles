-- enable lua loader
vim.loader.enable()

require("configs").setup {
  dark_colorscheme = "rose-pine-moon",
  light_colorscheme = "catppuccin-latte",
  dap = true,
  -- tint = true,
  -- refactor = true,
  -- better_fold = true,
  -- indent_blankline = true,
  -- markdown_preview = true,
  transparent_window = true,
  autocmds = {
    {
      "BufWinEnter",
      {
        group = "_filetype_settings",
        pattern = { "*.go", "*.php", "*.h" },
        desc = "setlocal ts and sw",
        callback = function()
          pcall(vim.cmd, "setlocal ts=4 sw=4")
        end,
      },
    },
  },
}
