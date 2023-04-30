M = {}

local tbl = require "utils.table"

--- check if a client is active
---@param name string
---@return boolean
function M.is_client_active(name)
  local clients = vim.lsp.get_active_clients()
  ---@diagnostic disable-next-line: return-type-mismatch
  return tbl.find_first(clients, function(client)
    return client.name == name
  end)
end

function M.get_active_clients_by_ft(filetype)
  local matches = {}
  local clients = vim.lsp.get_active_clients()
  for _, client in pairs(clients) do
    local supported_filetypes = client.config.filetypes or {}
    if client.name ~= "null-ls" and vim.tbl_contains(supported_filetypes, filetype) then
      table.insert(matches, client)
    end
  end
  return matches
end

function M.get_client_capabilities(client_id)
  local client
  if not client_id then
    local buf_clients = vim.lsp.get_active_clients { bufnr = vim.api.nvim_get_current_buf() }
    for _, buf_client in pairs(buf_clients) do
      if buf_client.name ~= "null-ls" then
        client = buf_client
        break
      end
    end
  else
    ---@diagnostic disable-next-line: param-type-mismatch
    client = vim.lsp.get_client_by_id(tonumber(client_id))
  end
  if not client then
    error "Unable to determine client_id"
    return
  end

  local enabled_caps = {}
  for capability, status in pairs(client.server_capabilities or client.resolved_capabilities) do
    if status == true then
      table.insert(enabled_caps, capability)
    end
  end

  return enabled_caps
end

---Get supported filetypes per server
---@param server_name string can be any server supported by nvim-lsp-installer
---@return table supported filestypes as a list of strings
function M.get_supported_filetypes(server_name)
  local status_ok, lsp_installer_servers = pcall(require, "nvim-lsp-installer.servers")
  if not status_ok then
    return {}
  end

  local server_available, requested_server = lsp_installer_servers.get_server(server_name)
  if not server_available then
    return {}
  end

  return requested_server:get_supported_filetypes()
end

---Get supported servers per filetype
---@param filetype string
---@return table list of names of supported servers
function M.get_supported_servers_per_filetype(filetype)
  local filetype_server_map = require "nvim-lsp-installer._generated.filetype_map"
  return filetype_server_map[filetype]
end

---Get all supported filetypes by nvim-lsp-installer
---@return table supported filestypes as a list of strings
function M.get_all_supported_filetypes()
  local status_ok, lsp_installer_filetypes = pcall(require, "nvim-lsp-installer._generated.filetype_map")
  if not status_ok then
    return {}
  end
  return vim.tbl_keys(lsp_installer_filetypes or {})
end

function M.setup_document_highlight(client, bufnr)
  local status_ok, highlight_supported = pcall(function()
    return client.supports_method "textDocument/documentHighlight"
  end)
  if not status_ok or not highlight_supported then
    return
  end
  local augroup_exist, _ = pcall(vim.api.nvim_get_autocmds, {
    group = "lsp_document_highlight",
  })
  if not augroup_exist then
    vim.api.nvim_create_augroup("lsp_document_highlight", {})
  end
  vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    group = "lsp_document_highlight",
    buffer = bufnr,
    callback = vim.lsp.buf.document_highlight,
  })
  vim.api.nvim_create_autocmd("CursorMoved", {
    group = "lsp_document_highlight",
    buffer = bufnr,
    callback = vim.lsp.buf.clear_references,
  })
end

function M.setup_codelens_refresh(client, bufnr)
  local status_ok, codelens_supported = pcall(function()
    return client.supports_method "textDocument/codeLens"
  end)
  if not status_ok or not codelens_supported then
    return
  end
  local augroup_exist, _ = pcall(vim.api.nvim_get_autocmds, {
    group = "lsp_code_lens_refresh",
  })
  if not augroup_exist then
    vim.api.nvim_create_augroup("lsp_code_lens_refresh", {})
  end
  vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
    group = "lsp_code_lens_refresh",
    buffer = bufnr,
    callback = vim.lsp.codelens.refresh,
  })
end

---filter passed to vim.lsp.buf.format
---always selects null-ls if it's available and caches the value per buffer
---@param client table client attached to a buffer
---@return boolean if client matches
function M.format_filter(client)
  local filetype = vim.bo.filetype
  local n = require "null-ls"
  local s = require "null-ls.sources"
  local method = n.methods.FORMATTING
  local avalable_formatters = s.get_available(filetype, method)

  if #avalable_formatters > 0 then
    return client.name == "null-ls"
  elseif client.supports_method "textDocument/formatting" then
    return true
  else
    return false
  end
end

---Provide vim.lsp.buf.format for nvim <0.8
---@param opts table
function M.format(opts)
  opts = opts or { filter = M.format_filter }

  if vim.lsp.buf.format then
    return vim.lsp.buf.format(opts)
  end
end

--   vararg table:
--     • group (string|integer) optional: autocommand group name or
--       id to match against.
--     • pattern (string|array) optional: pattern(s) to match
--       literally |autocmd-pattern|.
--     • buffer (integer) optional: buffer number for buffer-local
--       autocommands |autocmd-buflocal|. Cannot be used with
--       {pattern}.
--     • desc (string) optional: description (for documentation and
--       troubleshooting).
--     • command (string) optional: Vim command to execute on event.
--       Cannot be used with {callback}
--     • once (boolean) optional: defaults to false. Run the
--       autocommand only once |autocmd-once|.
--     • nested (boolean) optional: defaults to false. Run nested
--       autocommands |autocmd-nested|.
---@param on_attach fun(client, buffer)
---@vararg table
---@return nil
function M.on_attach(on_attach, ...)
  local opts = {
    callback = function(args)
      if args == nil or args.data == nil then
        return
      end

      local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      on_attach(client, buffer)
    end,
  }

  if select("#", ...) > 0 then
    opts = vim.tbl_extend("force", opts, ...)
  end

  if type(opts.group) == "string" and opts.group ~= "" then
    local exists, _ = pcall(vim.api.nvim_get_autocmds, { group = opts.group })
    if not exists then
      vim.api.nvim_create_augroup(opts.group, {})
    end
  end

  vim.api.nvim_create_autocmd("LspAttach", opts)
end

return M
