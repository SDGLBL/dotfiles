local M = {}

local function show_documentation()
  local filetype = vim.bo.filetype
  if vim.tbl_contains({ "vim", "help" }, filetype) then
    vim.cmd("h " .. vim.fn.expand "<cword>")
  elseif vim.tbl_contains({ "man" }, filetype) then
    vim.cmd("Man " .. vim.fn.expand "<cword>")
    -- elseif vim.tbl_contains({ "rust" }, filetype) then
    --   require("rust-tools").hover_actions.hover_actions()
  elseif vim.fn.expand "%:t" == "Cargo.toml" and require("crates").popup_available() then
    require("crates").show_popup()
  else
    vim.lsp.buf.hover()
  end
end

vim.keymap.set("n", "K", show_documentation, { silent = true })

function M.on_attach(client, buffer)
  if client.name == "copilot" or client.name == "null-ls" then
    return
  end

  local self = M.new(client, buffer)

  self:map("gd", "Telescope lsp_definitions", { desc = "Goto Definition" })
  -- self:map("gr", "Telescope lsp_references", { desc = "References" })
  self:map("gI", "Telescope lsp_implementations", { desc = "Goto Implementation" })
  self:map("gb", "Telescope lsp_type_definitions", { desc = "Goto Type Definition" })
  self:map("<leader>lw", "", { desc = "Workspace" })
  self:map("<leader>lwa", vim.lsp.buf.add_workspace_folder, { desc = "Add Folder" })
  self:map("<leader>lwr", vim.lsp.buf.remove_workspace_folder, { desc = "Remove Folder" })
  self:map("<leader>lwl", function()
    vim.notify(vim.inspect(vim.lsp.buf.list_workspace_folders()), "info", { title = "List Folder" })
  end, { desc = "Workspace" })
  self:map("<leader>lwd", "Telescope diagnostics", { desc = "Workspace Diagnostics" })
  self:map("<leader>lW", 'lua require("telescope.builtin").diagnostics({ bufnr = 0 })', { desc = "Doc Diagnostics" })
  self:map("<leader>lj", vim.diagnostic.goto_next, { desc = "Go To Next Diagnostic" })
  self:map("<leader>lk", vim.diagnostic.goto_prev, { desc = "Go To Prev Diagnostic" })
  self:map("gb", "Telescope lsp_type_definitions", { desc = "Goto Type Definition" })
  self:map("gK", vim.lsp.buf.signature_help, { desc = "Signature Help", has = "signatureHelp" })
  self:map("]d", M.diagnostic_goto(true), { desc = "Next Diagnostic" })
  self:map("[d", M.diagnostic_goto(false), { desc = "Prev Diagnostic" })
  self:map("]e", M.diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
  self:map("[e", M.diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
  self:map("]w", M.diagnostic_goto(true, "WARNING"), { desc = "Next Warning" })
  self:map("[w", M.diagnostic_goto(false, "WARNING"), { desc = "Prev Warning" })
  -- self:map("<leader>la", vim.lsp.buf.code_action, { desc = "Code Action", mode = { "n", "v" }, has = "codeAction" })

  local format = require("plugins.lsp.format").format
  self:map("<leader>lf", function()
    format { bufnr = 0 }
  end, { desc = "Format Document", has = "documentFormatting" })
  self:map("<leader>lf", function()
    format { bufnr = 0 }
  end, { desc = "Format Range", mode = "v", has = "documentRangeFormatting" })
  self:map("<leader>lr", vim.lsp.buf.rename, { expr = true, desc = "Rename", has = "rename" })
  self:map("<leader>uf", require("plugins.lsp.format").toggle, { desc = "Toggle Format on Save" })

  self:map("<leader>ls", require("telescope.builtin").lsp_document_symbols, { desc = "Document Symbols" })
  self:map("<leader>lS", require("telescope.builtin").lsp_dynamic_workspace_symbols, { desc = "Workspace Symbols" })
  self:map("<leader>lq", vim.diagnostic.setloclist, { desc = "Toggle Inline Diagnostics" })
  self:map("K", show_documentation, { desc = "Hover" })
end

function M.new(client, buffer)
  return setmetatable({ client = client, buffer = buffer }, { __index = M })
end

function M:has(cap)
  return self.client.server_capabilities[cap .. "Provider"]
end

function M:map(lhs, rhs, opts)
  opts = opts or {}
  if opts.has and not self:has(opts.has) then
    return
  end
  vim.keymap.set(
    opts.mode or "n",
    lhs,
    type(rhs) == "string" and ("<cmd>%s<cr>"):format(rhs) or rhs,
    ---@diagnostic disable-next-line: no-unknown
    { silent = true, buffer = self.buffer, expr = opts.expr, desc = opts.desc }
  )
end

function M.diagnostic_goto(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go { severity = severity }
  end
end

return M
