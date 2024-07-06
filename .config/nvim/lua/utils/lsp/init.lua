-- 定义一个模块 M
M = {}

-- 引入 utils.table 模块
local tbl = require "utils.table"

--- 检查一个客户端是否处于活动状态
---@param name string 客户端名称
---@return boolean 返回布尔值，表示客户端是否处于活动状态
function M.is_client_active(name)
  local clients = vim.lsp.get_clients { name = name }
  return #clients > 0
end

--- 根据文件类型获取活动的客户端
---@param filetype string 文件类型
---@return table 返回匹配的客户端列表
function M.get_active_clients_by_ft(filetype)
  local matches = {}
  local clients = vim.lsp.get_clients()
  for _, client in pairs(clients) do
    ---@diagnostic disable-next-line: undefined-field
    local supported_filetypes = client.config.filetypes or {}
    if client.name ~= "null-ls" and vim.tbl_contains(supported_filetypes, filetype) then
      table.insert(matches, client)
    end
  end
  return matches
end

--- 获取客户端的能力
---@param client_id number 客户端 ID
---@return table 返回客户端的能力列表
function M.get_client_capabilities(client_id)
  local client
  if not client_id then
    local buf_clients = vim.lsp.get_clients { bufnr = 0 }
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

--- 获取每个服务器支持的文件类型
---@param server_name string 服务器名称，可以是 nvim-lsp-installer 支持的任何服务器
---@return table 返回支持的文件类型列表
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

--- 获取每个文件类型支持的服务器
---@param filetype string 文件类型
---@return table 返回支持的服务器名称列表
function M.get_supported_servers_per_filetype(filetype)
  local filetype_server_map = require "nvim-lsp-installer._generated.filetype_map"
  return filetype_server_map[filetype]
end

--- 获取 nvim-lsp-installer 支持的所有文件类型
---@return table 返回支持的文件类型列表
function M.get_all_supported_filetypes()
  local status_ok, lsp_installer_filetypes = pcall(require, "nvim-lsp-installer._generated.filetype_map")
  if not status_ok then
    return {}
  end
  return vim.tbl_keys(lsp_installer_filetypes or {})
end

--- 设置文档高亮
---@param client table 客户端对象
---@param bufnr number 缓冲区编号
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

--- 设置代码镜头刷新
---@param client table 客户端对象
---@param bufnr number 缓冲区编号
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

--- 处理 LSP 附加事件
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
---@param on_attach fun(client, bufnr) 附加函数
---@vararg table 可变参数表
---@return nil
function M.on_attach(on_attach, ...)
  local opts = {
    callback = function(args)
      if args == nil or args.data == nil then
        return
      end

      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)

      if client == nil then
        return
      end

      if client.name == "copilot" or client.name == "null-ls" then
        return
      end

      -- 获取当前缓冲区的文件类型
      local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
      -- 当文件类型等于 NvimTree, alpha, Outline, neo-tree, undotree, gundo, saga-outline 时
      local disabled_fts = { "NvimTree", "alpha", "Outline", "neo-tree", "undotree", "gundo", "saga-outline" }
      if vim.tbl_contains(disabled_fts, filetype) then
        return
      end

      on_attach(client, bufnr)
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

--- 处理文件重命名事件
---@param from string 原文件名
---@param to string 新文件名
function M.on_rename(from, to)
  local clients = M.get_clients()
  for _, client in ipairs(clients) do
    if client.supports_method "workspace/willRenameFiles" then
      ---@diagnostic disable-next-line: invisible
      local resp = client.request_sync("workspace/willRenameFiles", {
        files = {
          {
            oldUri = vim.uri_from_fname(from),
            newUri = vim.uri_from_fname(to),
          },
        },
      }, 1000, 0)
      if resp and resp.result ~= nil then
        vim.lsp.util.apply_workspace_edit(resp.result, client.offset_encoding)
      end
    end
  end
end

-- 返回模块 M
return M
