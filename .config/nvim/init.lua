-- enable lua loader
vim.loader.enable()

require("configs").setup {
  dark_colorscheme = "rose-pine-moon",
  light_colorscheme = "catppuccin-latte",
  dap = true,
  go = true,
  rust = true,
  python = true,
  cpp = true,
  typescript = true,
  refactor = true,
  ufo = true,
  -- obsidian = true,
  -- nix = true,
  -- cpp = true,
  -- jupyter = true,
  -- typescript = true,
  -- tint = true,
  -- indent_blankline = true,
  markdown_preview = true,
  transparent_window = true,
  autocmds = {
    {
      "BufWinEnter",
      {
        group = "_filetype_settings",
        pattern = { "*.go", "*.php", "*.h", "*.c", "*.cpp" },
        desc = "setlocal ts and sw",
        callback = function()
          pcall(vim.cmd, "setlocal ts=4 sw=4")
        end,
      },
    },
  },
}
