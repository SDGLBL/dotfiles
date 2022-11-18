require("system").setup {
  lsp = true,
  colorscheme = "kanagawa",
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
    -- auto change background by time
    vim.o.background = require("user.utils.time").is_dark() and "dark" or "light"
    vim.o.background = "dark"
    -- colorscheme style
    vim.g.material_style = "darker" -- darker,lighter,oceanic,palenight,deep ocean
    vim.g.sonokai_style = "maia" -- `'default'`, `'atlantis'`, `'andromeda'`, `'shusia'`, `'maia'`, `'espresso'`
    vim.g.tokyonight_style = "night"
    vim.g.tokyonight_sidebars = { "qf", "vista_kind", "terminal", "packer" }
    vim.g.catppuccin_flavour = "mocha" -- latte, frappe, macchiato, mocha
    -- Defaults to 'dawn' if vim background is light
    -- @usage 'base' | 'moon' | 'dawn' | 'rose-pine[-moon][-dawn]'
    vim.g.rose_pine_variant = "base"

    -- set guifont
    vim.cmd [[set guifont=firacode\ nerd\ font\ mono:h17]]

    -- copilot setup
    vim.g.copilot_no_tab_map = true
    vim.g.copilot_assume_mapped = true
    vim.g.copilot_tab_fallback = ""
    vim.g.copilot_filetypes = {
      ["markdown"] = true,
    }

    -- Please check https://github.com/agriffis/skel/blob/master/neovim/bin/clipboard-provider
    -- This maybe cause stuck on macos platform, if you don't need clipboard, please comment it
    vim.g["clipboard"] = {
      ["name"] = "clipboard-provider",
      ["copy"] = {
        ["+"] = "clipboard-provider copy",
        ["*"] = "clipboard-provider copy",
      },
      ["paste"] = {
        ["+"] = "clipboard-provider paste",
        ["*"] = "clipboard-provider paste",
      },
    }

    -- Please check https://github.com/equalsraf/win32yank
    -- If you use wsl2 or wsl in windows
    -- vim.g.clipboard = {
    --   ["name"] = "win32yank-wsl",
    --   ['copy']= {
    --       ['+']= '/mnt/c/Users/lijie/win32yank.exe -i --crlf',
    --       ['*']= '/mnt/c/Users/lijie/win32yank.exe -i --crlf',
    --   },
    --   ['paste']= {
    --       ['+']= '/mnt/c/Users/lijie/win32yank.exe -o --lf',
    --       ['*']= '/mnt/c/Users/lijie/win32yank.exe -o --lf',
    --   },
    -- }

    require("system.configs").default_config.pre_hook()
  end,
}
