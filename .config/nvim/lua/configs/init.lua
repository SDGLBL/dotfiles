-- 设置自动命令组
---@param c Config
local function autocmds_setup(c)
  local autocmds = require "configs.autocmds"

  -- 加载用户命令
  c.autocmds = c.autocmds or {}
  local default_cmds = autocmds.load_augroups() or {}

  for _, v in pairs(c.autocmds) do
    table.insert(default_cmds, v)
  end

  autocmds.define_augroups(default_cmds)
end

-- 切换透明窗口
---@param c Config
local function toggle_transparent(c)
  local ok, tran = pcall(require, "transparent")
  if ok then
    if c.transparent_window then
      tran.toggle(true)

      local notify_ok, notify = pcall(require, "notify")
      if notify_ok then
        notify.setup {
          background_colour = "#000000",
        }
      end
    else
      tran.toggle(false)
    end
  end
end

-- 配置初始化函数
-- @param opts Config
local function setup(opts)
  local dc = require "configs.default"
  local c = opts and vim.tbl_deep_extend("force", dc, opts) or dc
  _G.configs = c

  -- 执行预钩子函数
  if c.pre_hook ~= nil then
    local pre_hook_status, ret = pcall(c.pre_hook, c)
    if not pre_hook_status then
      vim.notify("executed pre_hook failed: " .. vim.inspect(ret))
    end
  end

  -- 检查是否已经加载
  if vim.b.loaded then
    return
  end

  -- 加载配置选项
  require "configs.options"
  require "configs.lazy"
  require "configs.keymaps"

  -- 重新设置自动命令组
  autocmds_setup(c)
  toggle_transparent(c)

  -- 执行后钩子函数
  -- 执行后钩子函数
  if c.after_hook ~= nil then
    local after_hook_status, ret = pcall(c.after_hook, c)
    if not after_hook_status then
      vim.notify("executed after_hook failed: " .. vim.inspect(ret))
    end
  end

  vim.b.loaded = true
end

-- 重新加载配置
local function reload()
  vim.notify "Reload configs"

  -- 重置 which-key 插件
  local wk = require "which-key"
  if wk ~= nil then
    wk.reset()

    local opts = require("plugins.lsp.utils").opts "which-key.nvim"
    wk.setup(opts.setup)
    wk.register(opts.defaults)
    wk.register(opts.vdefaults)
  end

  -- 重新加载 init.lua 文件
  local fn = vim.fn
  local init_file_path = fn.join({ fn.stdpath "config", "init.lua" }, "/")
  local ok, err = pcall(dofile, init_file_path)
  if not ok then
    vim.notify("Error reloading init.lua: " .. err, vim.log.levels.ERROR)
  end

  -- 获取全局配置
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

-- 导出 setup 和 reload 函数
return {
  setup = setup,
  reload = reload,
}
