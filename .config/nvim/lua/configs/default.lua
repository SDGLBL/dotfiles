---@class Config
-- `dark_colorscheme`
---@field dark_colorscheme string
--- | "default"
--- | "zellner"
--- | "torte"
--- | "tokyonight-storm"
--- | "tokyonight-night"
--- | "tokyonight-moon"
--- | "tokyonight-day"
--- | "tokyodark"
--- | "terafox"
--- | "sonokai"
--- | "slate"
--- | "shine"
--- | "rose-pine"
--- | "rose-pine-main"
--- | "rose-pine-dawn"
--- | "rose-pine-moon"
--- | "ron"
--- | "quiet"
--- | "duskfox"
--- | "dayfox"
--- | "dawnfox"
--- | "darkplus"
--- | "darkblue"
--- | "catppuccin-mocha"
--- | "catppuccin-macchiato"
--- | "catppuccin-latte"
--- | "catppuccin-frappe"
--- | "carbonfox"
--- | "blue"
--- | "peachpuff"
--- | "pablo"
--- | "nordfox"
--- | "nightfly"
--- | "nightfox"
--- | "murphy"
--- | "morning"
--- | "darkplus"
--- | "monokai_soda"
--- | "monokai_ristretto"
--- | "monokai_pro"
--- | "lunaperche"
--- | "koehler"
--- | "kanagawa"
--- | "industry"
--- | "habamax"
--- | "github_dimmed"
--- | "github_dark"
--- | "github_dark_default"
--- | "github_dark_colorblind"
--- | "github_light"
--- | "github_light_default"
--- | "github_light_colorblind"
--- | "evening"
--- | "elfoard"
--- | "desert"
--- | "material"
--- | "gruvbox"
--- | "delek"
-- `light_colorscheme`
---@field light_colorscheme string
--- | "default"
--- | "zellner"
--- | "torte"
--- | "tokyonight-storm"
--- | "tokyonight-night"
--- | "tokyonight-moon"
--- | "tokyonight-day"
--- | "tokyodark"
--- | "terafox"
--- | "sonokai"
--- | "slate"
--- | "shine"
--- | "rose-pine"
--- | "rose-pine-main"
--- | "rose-pine-dawn"
--- | "rose-pine-moon"
--- | "ron"
--- | "quiet"
--- | "duskfox"
--- | "dayfox"
--- | "dawnfox"
--- | "darkplus"
--- | "darkblue"
--- | "catppuccin-mocha"
--- | "catppuccin-macchiato"
--- | "catppuccin-latte"
--- | "catppuccin-frappe"
--- | "carbonfox"
--- | "blue"
--- | "peachpuff"
--- | "pablo"
--- | "nordfox"
--- | "nightfly"
--- | "nightfox"
--- | "murphy"
--- | "morning"
--- | "darkplus"
--- | "monokai_soda"
--- | "monokai_ristretto"
--- | "monokai_pro"
--- | "lunaperche"
--- | "koehler"
--- | "kanagawa"
--- | "industry"
--- | "habamax"
--- | "github_dimmed"
--- | "github_dark"
--- | "github_dark_default"
--- | "github_dark_colorblind"
--- | "github_light"
--- | "github_light_default"
--- | "github_light_colorblind"
--- | "evening"
--- | "elfoard"
--- | "desert"
--- | "material"
--- | "gruvbox"
--- | "delek"
-- enable `lsp`. Lsp is enabled by default
---@field lsp boolean
--- enable `dap`.
-- enable `jupyter`.
---@field jupyter boolean
--- enable `dap`.
-- Debug Adapter Protocol client implementation for Neovim
-- [nvim-dap](https://github.com/mfussenegger/nvim-dap)
---@field dap boolean
-- enable `tint`.
-- Dim inactive windows in Neovim using window-local highlight namespaces.
-- [tint.nvim](https://github.com/levouh/tint.nvim)
---@field tint boolean
-- enable `refactor`.
-- The Refactoring library based off the Refactoring book by Martin Fowler
-- [refactoring.nvim](https://github.com/ThePrimeagen/refactoring.nvim)
---@field refactor boolean
-- enable `hlargs`.
-- Highlight arguments' definitions and usages, using Treesitter
-- [hlargs.nvim](https://github.com/m-demare/hlargs.nvim)
---@field hlargs boolean
-- enable `autopairs`.
-- autopairs for neovim written by lua
-- [nvim-autopairs](https://github.com/windwp/nvim-autopairs)
---@field autopairs boolean
-- enable `rust`
-- rust support for neovim
---@field rust boolean
-- enable `nix`
-- nix support for neovim
---@field nix boolean
-- enable `go`
-- go support for neovim
---@field go boolean
----- enable `flutter`
-- flutter support for neovim
---@field flutter boolean
----- enable `vue`
-- vue support for neovim
---@field vue boolean
----- enable `cpp`
-- cpp support for neovim
---@field cpp boolean
----- enable `docker`
-- docker support for neovim
---@field docker boolean
--- enable `angular`
--- angular support for neovim
---@field angular  boolean,
--- enable `csharp`
--- csharp support for neovim
---@field csharp  boolean,
--- enable `elixir`
--- elixir support for neovim
---@field elixir  boolean,
--- enable `jujia`
--- jujia support for neovim
---@field jujia  boolean,
--- enable `kotlin`
--- kotlin support for neovim
---@field kotlin  boolean,
--- enable `r`
--- r support for neovim
---@field r  boolean,
--- enable `ruby`
--- ruby support for neovim
---@field ruby  boolean,
--- enable `scala`
--- scala support for neovim
---@field scala  boolean,
--- enable `tailwind`
--- tailwind support for neovim
---@field tailwind  boolean,
----- enable `java`
-- java support for neovim
---@field java boolean
-- enable `typescript`
-- typescript support for neovim
---@field typescript boolean
-- enable `python`
-- python support for neovim
---@field python boolean
-- enable `color-picker`.
-- Tools for better development in rust using neovim's builtin lsp
---@field color_picker boolean
-- enable `neorg`
-- Modernity meets insane extensibility. The future of organizing your life in Neovim.
-- [neorg](https://github.com/nvim-neorg/neorg)
---@field neorg boolean
-- enable `silicon`
-- Code img generator
-- [silicon.nvim](https://github.com/Aloxaf/silicon)
---@field silicon boolean
-- enable`markdown_preview`
-- markdown preview plugin for (neo)vim
-- [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim)
---@field markdown_preview boolean
-- enabled `indent_blankline `
-- Indent guides for Neovim
-- [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim)
---@field indent_blankline boolean
-- enable`ufo`
-- Not UFO in the sky, but an ultra fold in Neovim.
-- [nvim-ufo](https://github.com/kevinhwang91/nvim-ufo)
---@field ufo boolean enable `better-fold`. Better folding for Neovim
-- enable `format_on_save`
-- Format your code on save
---@field format_on_save boolean enable `format`. Format your code on save
-- enable`transparent_window`
-- Transparent window
---@field transparent_window boolean enable `transparent-window`. Transparent window
-- autocmds
-- autocmds.custom_groups = {[Event],[file],[command]}
-- example: { "BufWinEnter", "*.go", "setlocal ts=4 sw=4" }
---@field autocmds table | nil
-- pre_hook
-- func executed before loading plugins
---@field pre_hook function | nil
-- after_hook
-- func executed after loading plugins
---@field after_hook function | nil

---@type Config
return {
  -- duskfox,nightfly,nightfox,github_dimmed,tokyonight,sonokai,onedarkpro,monokai_soda,catppuccin,tokyodark,kanagawa,material
  colorscheme = "",
  -- `lsp`
  lsp = true,
  -- `jupyter`
  jupyter = false,
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
  -- `rust`
  -- rust support for neovim
  rust = false,
  -- `nix`
  -- nix support for neovim
  nix = false,
  -- `go`
  -- go support for neovim
  go = false,
  -- `flutter`
  -- flutter support for neovim
  flutter = false,
  -- `angular`
  -- angular support for neovim
  angular = false,
  -- `csharp`
  -- csharp support for neovim
  csharp = false,
  -- `elixir`
  -- elixir support for neovim
  elixir = false,
  -- `jujia`
  -- jujia support for neovim
  jujia = false,
  -- `kotlin`
  -- kotlin support for neovim
  kotlin = false,
  -- `ruby`
  -- ruby support for neovim
  ruby = false,
  -- `r`
  -- r support for neovim
  r = false,
  -- `scala`
  -- scala support for neovim
  scala = false,
  -- `tailwind`
  -- tailwind support for neovim
  tailwind = false,
  -- `typescript`
  -- typescript support for neovim
  typescript = false,
  -- `python`
  -- python support for neovim
  python = false,
  -- `docker`
  -- docker support for neovim
  docker = true,
  -- `cpp`
  -- cpp support for neovim
  cpp = false,
  -- `vue`
  -- vue support for neovim
  vue = false,
  -- `java`
  -- java support for neovim
  java = false,
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
  -- `ufo`
  -- Not UFO in the sky, but an ultra fold in Neovim.
  -- [nvim-ufo](https://github.com/kevinhwang91/nvim-ufo)
  ufo = false,
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
  --- @param c Config
  pre_hook = function(c)
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
  -- `after_hook`
  --- @param c Config
  after_hook = function(c)
    local colorscheme = ""

    -- if require("utils.time").is_dark() then
    --   colorscheme = c.dark_colorscheme
    -- else
    --   colorscheme = c.light_colorscheme
    -- end

    ---@diagnostic disable-next-line: param-type-mismatch
    local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
    if not status_ok then
      vim.notify("colorscheme " .. colorscheme .. " not found!")
      return
    end

    -- auto change background by time
    -- vim.o.background = require("utils.time").is_dark() and "dark" or "light"

    if vim.g.neovide then
      -- Helper function for transparency formatting
      local alpha = function()
        ---@diagnostic disable-next-line: ambiguity-1
        return string.format("%x", math.floor(255 * vim.g.transparency or 0.8))
      end

      vim.g.neovide_transparency = 0.0
      vim.g.transparency = 0.85
      vim.g.neovide_background_color = "#000000" .. alpha()
      vim.g.neovide_theme = "auto"
      vim.g.neovide_refresh_rate = 120
      vim.g.neovide_input_macos_alt_is_meta = false

      vim.g.neovide_floating_blur = 60

      -- vim.opt.cmdheight = 0

      vim.o.background = "dark"
    end
  end,
}
