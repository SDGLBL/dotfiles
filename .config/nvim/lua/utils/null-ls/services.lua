local M = {}

local function find_root_dir()
  local util = require "lspconfig/util"
  local lsp_utils = require "utils.lsp"

  local ts_client = lsp_utils.is_client_active "typescript"
  if ts_client then
    ---@diagnostic disable-next-line: undefined-field
    return ts_client.config.root_dir
  end
  local dirname = vim.fn.expand "%:p:h"
  return util.root_pattern "package.json"(dirname)
end

local function from_node_modules(command)
  local root_dir = find_root_dir()

  if not root_dir then
    return nil
  end

  local path_sep = vim.loop.os_uname().version:match "Windows" and "\\" or "/"
  return table.concat({ root_dir, "node_modules", ".bin", command }, path_sep)
end

local local_providers = {
  prettier = { find = from_node_modules },
  prettierd = { find = from_node_modules },
  prettier_d_slim = { find = from_node_modules },
  eslint_d = { find = from_node_modules },
  eslint = { find = from_node_modules },
  stylelint = { find = from_node_modules },
}

function M.find_command(command)
  if local_providers[command] then
    local local_command = local_providers[command].find(command)
    if local_command and vim.fn.executable(local_command) == 1 then
      return local_command
    end
  end

  if command and vim.fn.executable(command) == 1 then
    return command
  end
  return nil
end

function M.list_registered_providers_names(filetype)
  local s = require "null-ls.sources"
  local available_sources = s.get_available(filetype)
  local registered = {}
  for _, source in ipairs(available_sources) do
    for method in pairs(source.methods) do
      registered[method] = registered[method] or {}
      table.insert(registered[method], source.name)
    end
  end
  return registered
end

function M.register_sources(configs, method)
  local null_ls = require "null-ls"
  local is_registered = require("null-ls.sources").is_registered

  local sources, registered_names = {}, {}

  for _, config in ipairs(configs) do
    local cmd = config.exe or config.command
    local name = config.name or cmd:gsub("-", "_")
    local type = method == null_ls.methods.CODE_ACTION and "code_actions" or null_ls.methods[method]:lower()
    local source = type and null_ls.builtins[type][name]
    vim.notify(string.format("Received request to register [%s] as a %s source", name, type))
    if not source then
      vim.notify("Not a valid source: " .. name)
    elseif is_registered { name = source.name or name, method = method } then
      vim.notify(string.format("Skipping registering [%s] more than once", name))
    else
      local command = M.find_command(source._opts.command) or source._opts.command

      -- treat `args` as `extra_args` for backwards compatibility. Can otherwise use `generator_opts.args`
      local compat_opts = vim.deepcopy(config)
      if config.args then
        compat_opts.extra_args = config.args or config.extra_args
        compat_opts.args = nil
      end

      local opts = vim.tbl_deep_extend("keep", { command = command }, compat_opts)
      vim.notify("Registering source " .. name)
      vim.notify(vim.inspect(opts))
      table.insert(sources, source.with(opts))
      vim.list_extend(registered_names, { source.name })
    end
  end

  if #sources > 0 then
    null_ls.register { sources = sources }
  end
  return registered_names
end

return M
