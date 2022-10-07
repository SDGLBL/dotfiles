-- colorscheme sonokai style
-- `'default'`, `'atlantis'`, `'andromeda'`, `'shusia'`, `'maia'`, `'espresso'`
vim.g.sonokai_style = "maia"

vim.cmd [[set guifont=FiraCode\ Nerd\ Font\ Mono:h17]]
-- copilot setup
vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true
vim.g.copilot_tab_fallback = ""

-- conda setup
if os.getenv "CONDA_PREFIX" ~= "" and os.getenv "CONDA_PREFIX" ~= nil then
  vim.g.python3_host_prog = os.getenv "CONDA_PREFIX" .. "/bin/python"
end

vim.g.tokyonight_style = "night"
vim.g.tokyonight_sidebars = { "qf", "vista_kind", "terminal", "packer" }

-- latte, frappe, macchiato, mocha
vim.g.catppuccin_flavour = "dusk"

require("system.setup").setup {
  transparent_window = false,
  format_on_save = true,
  better_tui = false,
  -- colorscheme = "duskfox",
  -- colorscheme = "nightfly",
  -- colorscheme = "nightfox",
  -- colorscheme = "github_dimmed",
  -- colorscheme        = "tokyonight",
  -- colorscheme = "sonokai",
  -- colorscheme = "onedarkpro",
  -- colorscheme = "monokai_soda",
  -- colorscheme = "catppuccin",
  -- colorscheme = "rose-pine",
  -- colorscheme = "tokyonight",
  -- colorscheme = "tokyodark",
  colorscheme = "kanagawa",
  active_neorg = true,
  active_autopairs = true,
  active_lsp = true,
  active_refactor = true,
  active_dap = true,
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
