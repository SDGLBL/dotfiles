---@class Config
-- `colorscheme`
---@field colorscheme string
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
-- enable `autopairs`.
-- autopairs for neovim written by lua
-- [nvim-autopairs](https://github.com/windwp/nvim-autopairs)
---@field autopairs boolean
-- enable `rust_tools`
-- Tools for better development in rust using neovim's builtin lsp
-- [rust-tools.nvim](https://github.com/simrat39/rust-tools.nvim)
---@field rust_tools boolean
-- enable `color-picker`.
-- Tools for better development in rust using neovim's builtin lsp
-- [rust-tools.nvim](https://github.com/simrat39/rust-tools.nvim)
---@field color_picker boolean
-- enable `neorg`
-- Modernity meets insane extensibility. The future of organizing your life in Neovim.
-- [neorg](https://github.com/nvim-neorg/neorg)
---@field neorg boolean
-- enable`markdown_preview`
-- markdown preview plugin for (neo)vim
-- [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim)
---@field markdown_preview boolean
-- enabled `indent_blankline `
-- Indent guides for Neovim
-- [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim)
---@field indent_blankline boolean
-- enable`better_fold`
-- Not UFO in the sky, but an ultra fold in Neovim.
-- [nvim-ufo](https://github.com/kevinhwang91/nvim-ufo)
---@field better_fold boolean enable `better-fold`. Better folding for Neovim
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

--- system config
---@param opts Config
local function setup(opts)
  local dc = require("system.configs").default_config
  local require = require("system.configs").reload_module
  ---@type Config
  local c = opts and vim.tbl_deep_extend("force", dc, opts) or dc

  _G.configs = c

  local autocmd = require "user.autocmd"

  if c.transparent_window then
    autocmd.enable_transparent_mode()
  end

  if c.format_on_save then
    autocmd.enable_format_on_save()
  else
    autocmd.disable_format_on_save()
  end

  -- load user cmd
  c.autocmds = c.autocmds or {}
  local default_cmds = autocmd.load_augroups() or {}
  local all_cmds = vim.tbl_deep_extend("keep", c.autocmds, default_cmds)
  autocmd.define_augroups(all_cmds)

  require "user.options"
  require "user.lazy"
  require "user.impatient"

  -- if colorscheme start with catppuccin, then load catppuccin
  if c.colorscheme:find "catppuccin" then
    require("catppuccin").setup {
      styles = {
        comments = {},
      },
    }
  end

  ---@diagnostic disable-next-line: param-type-mismatch
  local status_ok, _ = pcall(vim.cmd, "colorscheme " .. c.colorscheme)
  if not status_ok then
    vim.notify("colorscheme " .. c.colorscheme .. " not found!")
    return
  end

  require "user.notify"

  if c.pre_hook ~= nil then
    local pre_hook_status, ret = pcall(c.pre_hook)
    if not pre_hook_status then
      vim.notify("executed pre_hook failed: " .. vim.inspect(ret))
    end
  end

  require "user.keymaps"
  require "user.whichkey"
  require "user.autocmd"
  require "user.projects"
  require "user.alpha"
  require "user.toggleterm"
  require "user.comment"
  require "user.bufferline"
  require "user.lualine"
  require "user.nvim-tree"
  require "user.treesitter"
  require "user.gitsigns"
  require "user.telescope"
  -- require "user.neovide"
  -- require "user.tabnine"

  if c.after_hook ~= nil then
    local after_hook_status, ret = pcall(c.after_hook)
    if not after_hook_status then
      vim.notify("executed after_hook failed: " .. vim.inspect(ret))
    end
  end
end

return {
  setup = setup,
}
