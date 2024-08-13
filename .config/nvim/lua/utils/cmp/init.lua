local M = {}
local utils = require "utils"

M.snippet_replace = function(snippet, fn)
  return snippet:gsub("%$%b{}", function(m)
    local n, name = m:match "^%${(%d+):(.+)}$"
    return n and fn { n = n, text = name } or m
  end) or snippet
end

M.snippet_preview = function(snippet)
  local ok, parsed = pcall(function()
    return vim.lsp._snippet_grammar.parse(snippet)
  end)
  return ok and tostring(parsed) or M.snippet_replace(snippet, function(placeholder)
    return M.snippet_preview(placeholder.text)
  end):gsub("%$0", "")
end

M.snippet_fix = function(snippet)
  local texts = {} ---@type table<number, string>
  return M.snippet_replace(snippet, function(placeholder)
    texts[placeholder.n] = texts[placeholder.n] or M.snippet_preview(placeholder.text)
    return "${" .. placeholder.n .. ":" .. texts[placeholder.n] .. "}"
  end)
end

M.expand = function(snippet)
  -- Native sessions don't support nested snippet sessions.
  -- Always use the top-level session.
  -- Otherwise, when on the first placeholder and selecting a new completion,
  -- the nested session will be used instead of the top-level session.
  -- See: https://github.com/LazyVim/LazyVim/issues/3199
  local session = vim.snippet.active() and vim.snippet._session or nil

  local ok, err = pcall(vim.snippet.expand, snippet)
  if not ok then
    local fixed = M.snippet_fix(snippet)
    ok = pcall(vim.snippet.expand, fixed)

    local msg = ok and "Failed to parse snippet,\nbut was able to fix it automatically." or ("Failed to parse snippet.\n" .. err)

    vim.notify("vim.snippet: " .. msg, { title = "vim.snippet" })
  end

  -- Restore top-level session when needed
  if session then
    vim.snippet._session = session
  end
end

-- This is a better implementation of `cmp.confirm`:
--  * check if the completion menu is visible without waiting for running sources
--  * create an undo point before confirming
-- This function is both faster and more reliable.
---@param opts? {select: boolean, behavior: cmp.ConfirmBehavior}
function M.confirm(opts)
  local cmp = require "cmp"
  opts = vim.tbl_extend("force", {
    select = true,
    behavior = cmp.ConfirmBehavior.Insert,
  }, opts or {})
  return function(fallback)
    if cmp.core.view:visible() or vim.fn.pumvisible() == 1 then
      utils.create_undo()
      if cmp.confirm(opts) then
        return
      end
    end
    return fallback()
  end
end

return M
