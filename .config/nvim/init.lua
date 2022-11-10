require("system").setup {
  transparent_window = false, -- make background transparent
  format_on_save = true,
  better_fold = true,
  better_tui = true,
  colorscheme_config = {
    -- duskfox,nightfly,nightfox,github_dimmed,tokyonight,sonokai,onedarkpro,monokai_soda,catppuccin,tokyodark,kanagawa,material
    colorscheme = "kanagawa",
    config = function()
      -- auto change background by time
      vim.o.background = require("user.utils.time").is_dark() and "dark" or "light"
      -- colorscheme style
      vim.g.material_style = "darker" -- darker,lighter,oceanic,palenight,deep ocean
      vim.g.sonokai_style = "maia" -- `'default'`, `'atlantis'`, `'andromeda'`, `'shusia'`, `'maia'`, `'espresso'`
      vim.g.tokyonight_style = "night"
      vim.g.tokyonight_sidebars = { "qf", "vista_kind", "terminal", "packer" }
      vim.g.catppuccin_flavour = "mocha" -- latte, frappe, macchiato, mocha
      -- Defaults to 'dawn' if vim background is light
      -- @usage 'base' | 'moon' | 'dawn' | 'rose-pine[-moon][-dawn]'
      vim.g.rose_pine_variant = "base"
    end,
  },
  active_neorg = false,
  active_org = false,
  active_autopairs = true,
  active_lsp = true,
  active_refactor = false,
  active_dap = false,
  active_tint = false,
  active_color_picker = false,
  active_markdown_preview = false,
  autocmds = {
    custom_groups = {
      { "BufWinEnter", "*.go", "setlocal ts=4 sw=4" },
      { "BufWinEnter", "*.c", "setlocal ts=4 sw=4" },
      { "BufWinEnter", "*.cpp", "setlocal ts=4 sw=4" },
      { "BufWinEnter", "*.h", "setlocal ts=4 sw=4" },
      { "BufWinEnter", "*.php", "setlocal ts=4 sw=4" },
    },
  },
  pre_hook = function()
    -- set guifont
    vim.cmd [[set guifont=firacode\ nerd\ font\ mono:h17]]

    -- copilot setup
    vim.g.copilot_no_tab_map = true
    vim.g.copilot_assume_mapped = true
    vim.g.copilot_tab_fallback = ""
    vim.g.copilot_filetypes = {
      ["markdown"] = true,
    }

    -- conda setup
    if os.getenv "conda_prefix" ~= "" and os.getenv "conda_prefix" ~= nil then
      vim.g.python3_host_prog = os.getenv "conda_prefix" .. "/bin/python"
    end
  end,
  after_hook = function()
    -- do noting
  end,
}
