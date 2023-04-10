---@type Config
local default_config = {
  -- duskfox,nightfly,nightfox,github_dimmed,tokyonight,sonokai,onedarkpro,monokai_soda,catppuccin,tokyodark,kanagawa,material
  colorscheme = "",
  -- `lsp`
  lsp = true,
  -- `dap`
  -- Debug Adapter Protocol client implementation for Neovim
  -- [nvim-dap](https://github.com/mfussenegger/nvim-dap)
  dap = false,
  -- tint
  -- Dim inactive windows in Neovim using window-local highlight namespaces.
  -- [tint.nvim](https://github.com/levouh/tint.nvim)
  tint = false,
  -- `refactor`
  -- The Refactoring library based off the Refactoring book by Martin Fowler
  -- [refactoring.nvim](https://github.com/ThePrimeagen/refactoring.nvim)
  refactor = false,
  -- `hlargs`.
  -- Highlight arguments' definitions and usages, using Treesitter
  -- [hlargs.nvim](https://github.com/m-demare/hlargs.nvim)
  hlargs = true,
  -- `autopairs`
  -- autopairs for neovim written by lua
  -- [nvim-autopairs](https://github.com/windwp/nvim-autopairs)
  autopairs = true,
  -- `rust_tools`
  -- Tools for better development in rust using neovim's builtin lsp
  -- [rust-tools.nvim](https://github.com/simrat39/rust-tools.nvim)
  rust_tools = false,
  -- `color_picker`
  -- Super powerful color picker / colorizer plugin.
  -- [ccc.nvim](https://github.com/uga-rosa/ccc.nvim)
  color_picker = false,
  --`markdown_preview`
  -- markdown preview plugin for (neo)vim
  -- [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim)
  markdown_preview = false,
  -- `silicon`
  -- Code img generator
  -- [silicon.nvim](https://github.com/Aloxaf/silicon)
  silicon = false,
  -- `neorg`
  -- Modernity meets insane extensibility. The future of organizing your life in Neovim.
  -- [neorg](https://github.com/nvim-neorg/neorg)
  neorg = false,
  -- `indent_blankline`
  -- Indent guides for Neovim
  -- [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim)
  indent_blankline = false,
  -- `better_fold`
  -- Not UFO in the sky, but an ultra fold in Neovim.
  -- [nvim-ufo](https://github.com/kevinhwang91/nvim-ufo)
  better_fold = false,
  -- `format_on_save`
  -- Format your code on save
  format_on_save = true,
  -- `transparent_window`
  -- Transparent window
  transparent_window = false,
  autocmds = {
    custom_groups = {},
  },
  -- `pre_hook`
  -- execute before loading configs
  pre_hook = function()
    -- conda setup
    if os.getenv "conda_prefix" ~= "" and os.getenv "conda_prefix" ~= nil then
      vim.g.python3_host_prog = os.getenv "conda_prefix" .. "/bin/python"
    end

    -- colorscheme style
    vim.g.material_style = "darker" -- darker,lighter,oceanic,palenight,deep ocean
    vim.g.sonokai_style = "maia" -- `'default'`, `'atlantis'`, `'andromeda'`, `'shusia'`, `'maia'`, `'espresso'`
    vim.g.tokyonight_style = "night"
    vim.g.tokyonight_sidebars = { "qf", "vista_kind", "terminal", "packer" }
    vim.g.catppuccin_flavour = "mocha" -- latte, frappe, macchiato, mocha
    -- Defaults to 'dawn' if vim background is light
    -- @usage 'base' | 'moon' | 'dawn' | 'rose-pine[-moon][-dawn]'
    vim.g.rose_pine_variant = "base"

    -- copilot setup
    vim.g.copilot_no_tab_map = true
    vim.g.copilot_assume_mapped = true
    vim.g.copilot_tab_fallback = ""
    vim.g.copilot_filetypes = {
      ["json"] = true,
      ["javascript"] = true,
      ["javascriptreact"] = true,
      ["typescript"] = true,
      ["typescriptreact"] = true,
      ["lua"] = true,
      ["rust"] = true,
      ["c"] = true,
      ["c#"] = true,
      ["c++"] = true,
      ["go"] = true,
      ["python"] = true,
      ["norg"] = true,
      ["sh"] = true,
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
  end,
  after_hook = function()
    -- auto change background by time
    vim.o.background = require("user.utils.time").is_dark() and "dark" or "light"
  end,
}

return {
  default_config = default_config,
}
