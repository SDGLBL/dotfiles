local M = {}

local null_ls = require "null-ls"
local services = require "utils.null-ls.services"
local method = null_ls.methods.HOVER

function M.list_registered(filetype)
  local registered_providers = services.list_registered_providers_names(filetype)
  return vim.tbl_map(function(v)
    return v .. "()"
  end, registered_providers[method] or {})
end

function M.list_supported(filetype)
  local s = require "null-ls.sources"
  local supported_linters = s.get_supported(filetype, "hover")
  table.sort(supported_linters)
  return supported_linters
end

function M.setup(hover_configs)
  if vim.tbl_isempty(hover_configs) then
    return
  end

  local registered = services.register_sources(hover_configs, method)

  if #registered > 0 then
    vim.notify("Registered the following linters: " .. unpack(registered))
  end
end

return M
