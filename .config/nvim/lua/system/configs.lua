local fn = vim.fn
local levels = vim.log.levels

local function _assign(old, new, k)
  local otype = type(old[k])
  local ntype = type(new[k])
  if (otype == "thread" or otype == "userdata") or (ntype == "thread" or ntype == "userdata") then
    vim.notify(string.format("warning: old or new attr %s type be thread or userdata", k))
  end
  old[k] = new[k]
end

local function _replace(old, new, repeat_tbl)
  if repeat_tbl[old] then
    return
  end
  repeat_tbl[old] = true

  local dellist = {}
  for k, _ in pairs(old) do
    if not new[k] then
      table.insert(dellist, k)
    end
  end
  for _, v in ipairs(dellist) do
    old[v] = nil
  end

  for k, _ in pairs(new) do
    if not old[k] then
      old[k] = new[k]
    else
      if type(old[k]) ~= type(new[k]) then
        vim.notify(
          string.format("Reloader: mismatch between old [%s] and new [%s] type for [%s]", type(old[k]), type(new[k]), k),
          levels.ERROR
        )
        _assign(old, new, k)
      else
        if type(old[k]) == "table" then
          _replace(old[k], new[k], repeat_tbl)
        else
          _assign(old, new, k)
        end
      end
    end
  end
end

local function require_safe(mod)
  local status_ok, module = pcall(require, mod)
  if not status_ok then
    vim.notify("Failed to load module: " .. mod, levels.ERROR)
  end
  return module
end

local function reload_module(mod)
  if not package.loaded[mod] then
    return require_safe(mod)
  end

  local old = package.loaded[mod]
  package.loaded[mod] = nil
  local new = require_safe(mod)

  if type(old) == "table" and type(new) == "table" then
    local repeat_tbl = {}
    _replace(old, new, repeat_tbl)
  end

  package.loaded[mod] = old
  return old
end

local function reload()
  -- some plugins need reset
  local wk = require_safe "which-key"
  if wk ~= nil then
    wk.reset()
  end

  local init_file_path = fn.join({ fn.stdpath "config", "init.lua" }, "/")
  local ok, err = pcall(dofile, init_file_path)
  if not ok then
    vim.notify("Error reloading init.lua: " .. err, levels.ERROR)
  end
  vim.notify("Reloaded successfully", levels.INFO)
end

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
  end,
  after_hook = function()
    -- do noting
  end,
}

return {
  default_config = default_config,
  reload_module = reload_module,
  reload = reload,
}
