-- autocmds_setup function
---@param c Config
local function autocmds_setup(c)
  local autocmds = require "configs.autocmds"

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
end

-- toggle_transparent function
---@param c Config
local function toggle_transparent(c)
  local ok, tran = pcall(require, "transparent")
  if ok then
    if c.transparent_window then
      tran.toggle(true)
    else
      tran.toggle(false)
    end
  end
end

---@param opts Config
local function setup(opts)
  local dc = require "configs.default"
  local c = opts and vim.tbl_deep_extend("force", dc, opts) or dc
  _G.configs = c

  if c.pre_hook ~= nil then
    local pre_hook_status, ret = pcall(c.pre_hook)
    if not pre_hook_status then
      vim.notify("executed pre_hook failed: " .. vim.inspect(ret))
    end
  end

  require "configs.options"
  require "configs.keymaps"

  if vim.b.loaded then
    return
  end

  require "configs.lazy"

  ---@diagnostic disable-next-line: param-type-mismatch
  local status_ok, _ = pcall(vim.cmd, "colorscheme " .. c.colorscheme)
  if not status_ok then
    vim.notify("colorscheme " .. c.colorscheme .. " not found!")
    return
  end

  autocmds_setup(c)
  toggle_transparent(c)

  if c.after_hook ~= nil then
    local after_hook_status, ret = pcall(c.after_hook)
    if not after_hook_status then
      vim.notify("executed after_hook failed: " .. vim.inspect(ret))
    end
  end

  vim.b.loaded = true
end

local function reload()
  vim.notify "Reload configs"

  local wk = require "which-key"
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
  if c == nil then
    return
  end

  ---@diagnostic disable-next-line: param-type-mismatch
  local status_ok, _ = pcall(vim.cmd, "colorscheme " .. c.colorscheme)
  if not status_ok then
    vim.notify("colorscheme " .. c.colorscheme .. " not found!")
    return
  end

  autocmds_setup(c)
  toggle_transparent(c)

  if c.after_hook ~= nil then
    local after_hook_status, ret = pcall(c.after_hook)
    if not after_hook_status then
      vim.notify("executed after_hook failed: " .. vim.inspect(ret))
    end
  end

  vim.notify "Reload configs done"
  vim.b.loaded = true
end

return {
  setup = setup,
  reload = reload,
}
