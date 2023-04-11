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
          vim.log.levels.ERROR
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
    vim.notify("Failed to load module: " .. mod, vim.log.levels.ERROR)
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

  local fn = vim.fn

  local init_file_path = fn.join({ fn.stdpath "config", "init.lua" }, "/")
  local ok, err = pcall(dofile, init_file_path)
  if not ok then
    vim.notify("Error reloading init.lua: " .. err, vim.log.levels.ERROR)
  end

  local c = _G.configs
  local autocmds = reload_module "user.autocmds"

  if c.format_on_save then
    autocmds.enable_format_on_save()
  else
    autocmds.disable_format_on_save()
  end

  -- load user cmd
  c.autocmds = c.autocmds or {}
  local default_cmds = autocmds.load_augroups() or {}

  for _, v in pairs(c.autocmds) do
    table.insert(default_cmds, v)
  end

  autocmds.define_augroups(default_cmds)

  if c.pre_hook ~= nil then
    local pre_hook_status, ret = pcall(c.pre_hook)
    if not pre_hook_status then
      vim.notify("executed pre_hook failed: " .. vim.inspect(ret))
    end
  end

  reload_module "user.options"

  local Config = require_safe "lazy.core.config"
  local lazy = require_safe "lazy"

  reload_module "user.plugins"

  Config.spec = require_safe("user.plugins").plugins

  require_safe("lazy.core.plugin").load(true)
  require_safe("lazy.core.plugin").update_state()

  local not_installed_plugins = vim.tbl_filter(function(plugin)
    return not plugin._.installed
  end, Config.plugins)

  require_safe("lazy.manage").clear()

  if #not_installed_plugins > 0 then
    lazy.install { wait = true }
  end

  if #Config.to_clean > 0 then
    lazy.clean { wait = true }
  end

  local ok_tran, tran = pcall(require, "transparent")
  if ok_tran then
    if c.transparent_window then
      tran.toggle(true)
    else
      tran.toggle(false)
    end
  end

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

  reload_module "user.keymaps"
  reload_module "user.whichkey"
  reload_module "user.projects"
  reload_module "user.alpha"
  reload_module "user.toggleterm"
  reload_module "user.comment"
  reload_module "user.bufferline"
  reload_module "user.lualine"
  reload_module "user.nvim-tree"
  reload_module "user.treesitter"
  reload_module "user.gitsigns"
  reload_module "user.telescope"
  reload_module "user.markdown_preview"
  reload_module "user.lsp"
  reload_module "user.cmp"
  reload_module "user.refactor"
  reload_module "user.indentline"
  reload_module "user.rust_tools"
  reload_module "user.ccc"
  reload_module "user.tint"
  reload_module "user.neorg"
  reload_module "user.better_fold"
  reload_module "user.neovide"

  if c.after_hook ~= nil then
    local after_hook_status, ret = pcall(c.after_hook)
    if not after_hook_status then
      vim.notify("executed after_hook failed: " .. vim.inspect(ret))
    end
  end

  vim.notify("Reloaded successfully", vim.log.levels.INFO)
end

return {
  reload = reload,
  reload_module = reload_module,
}
