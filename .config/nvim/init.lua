require("system.setup").setup {
  transparent_window = false, -- make background transparent
  format_on_save = true,
  better_fold = true,
  better_tui = false,
  colorscheme = "catppuccin", -- duskfox,nightfly,nightfox,github_dimmed,tokyonight,sonokai,onedarkpro,monokai_soda,catppuccin,tokyodark,kanagawa
  active_neorg = false,
  active_org = false,
  active_autopairs = true,
  active_lsp = true,
  active_refactor = true,
  active_dap = false,
  active_tint = false,
  autocmds = {
    custom_groups = {
      { "BufWinEnter", "*.go", "setlocal ts=4 sw=4" },
      { "BufWinEnter", "*.c", "setlocal ts=4 sw=4" },
      { "BufWinEnter", "*.cpp", "setlocal ts=4 sw=4" },
      { "BufWinEnter", "*.h", "setlocal ts=4 sw=4" },
      { "BufWinEnter", "*.php", "setlocal ts=4 sw=4" },
    },
  },
}
