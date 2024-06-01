local function snippet_replace(snippet, fn)
  return snippet:gsub("%$%b{}", function(m)
    local n, name = m:match "^%${(%d+):(.+)}$"
    return n and fn { n = n, text = name } or m
  end) or snippet
end

local function snippet_fix(snippet)
  local texts = {} ---@type table<number, string>
  return snippet_replace(snippet, function(placeholder)
    texts[placeholder.n] = texts[placeholder.n] or M.snippet_preview(placeholder.text)
    return "${" .. placeholder.n .. ":" .. texts[placeholder.n] .. "}"
  end)
end

local function expand(snippet)
  -- Native sessions don't support nested snippet sessions.
  -- Always use the top-level session.
  -- Otherwise, when on the first placeholder and selecting a new completion,
  -- the nested session will be used instead of the top-level session.
  -- See: https://github.com/LazyVim/LazyVim/issues/3199
  local session = vim.snippet.active() and vim.snippet._session or nil

  local ok, err = pcall(vim.snippet.expand, snippet)
  if not ok then
    local fixed = snippet_fix(snippet)
    ok = pcall(vim.snippet.expand, fixed)

    local msg = ok and "Failed to parse snippet,\nbut was able to fix it automatically." or ("Failed to parse snippet.\n" .. err)

    vim.notify("vim.snippet: " .. msg, { title = "vim.snippet" })
  end

  -- Restore top-level session when needed
  if session then
    vim.snippet._session = session
  end
end

return {
  {
    "nvim-cmp",
    dependencies = {
      {
        "garymjr/nvim-snippets",
        opts = {
          friendly_snippets = true,
        },
        dependencies = { "rafamadriz/friendly-snippets" },
      },
    },
    opts = function(_, opts)
      opts.snippet = {
        expand = function(item)
          return expand(item.body)
        end,
      }
      table.insert(opts.sources, 1, { name = "snippets" })
    end,
    keys = {
      {
        "<Tab>",
        function()
          local cmp = require "cmp"
          cmp.mapping.abort()

          local copilot_keys = vim.fn["copilot#Accept"]()
          if copilot_keys ~= "" then
            vim.api.nvim_feedkeys(copilot_keys, "i", true)
            return
          end

          return vim.snippet.active { direction = 1 } and "<cmd>lua vim.snippet.jump(1)<cr>" or "<Tab>"
        end,
        expr = true,
        silent = true,
        mode = { "i", "s" },
      },
      {
        "<S-Tab>",
        function()
          return vim.snippet.active { direction = -1 } and "<cmd>lua vim.snippet.jump(-1)<cr>" or "<Tab>"
        end,
        expr = true,
        silent = true,
        mode = { "i", "s" },
      },
    },
  },
}
