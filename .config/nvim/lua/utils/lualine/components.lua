local conditions = require "utils.lualine.conditions"
local colors = require "utils.lualine.colors"

local function diff_source()
  ---@diagnostic disable-next-line: undefined-field
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed,
    }
  end
end

local icons = require "utils.icons"

return {
  mode = {
    function()
      return " "
    end,
    padding = { left = 0, right = 0 },
    color = {},
    cond = nil,
  },
  branch = {
    "b:gitsigns_head",
    icon = " " .. icons.git.Branch,
    color = { gui = "bold" },
    cond = conditions.hide_in_width,
  },
  filename = {
    "filename",
    color = {},
    cond = nil,
  },
  diff = {
    "diff",
    source = diff_source,
    symbols = {
      added = " " .. icons.git.BoldLineAdded .. " ",
      modified = icons.git.BoldLineModified .. " ",
      removed = icons.git.BoldLineRemoved .. " ",
    },
    diff_color = {
      added = { fg = colors.green },
      modified = { fg = colors.yellow },
      removed = { fg = colors.red },
    },
    cond = nil,
  },
  python_env = {
    function()
      local utils = require "utils.lualine.utils"
      if vim.bo.filetype == "python" then
        local venv = os.getenv "CONDA_DEFAULT_ENV"
        if venv then
          return string.format(" " .. icons.lang.python .. " (%s)", utils.env_cleanup(venv))
        end
        venv = os.getenv "VIRTUAL_ENV"
        if venv then
          return string.format(" " .. icons.lang.python .. " (%s)", utils.env_cleanup(venv))
        end
        return ""
      end
      return ""
    end,
    color = { fg = colors.green },
    cond = conditions.hide_in_width,
  },
  diagnostics = {
    "diagnostics",
    sources = { "nvim_diagnostic" },
    symbols = {
      error = icons.diagnostics.BoldError .. " ",
      warn = icons.diagnostics.BoldWarning .. " ",
      info = icons.diagnostics.BoldInformation .. " ",
      hint = icons.diagnostics.BoldHint .. " ",
    },
    cond = conditions.hide_in_width,
  },
  treesitter = {
    function()
      local b = vim.api.nvim_get_current_buf()
      if next(vim.treesitter.highlighter.active[b]) then
        return icons.ui.Tree
      end
      return ""
    end,
    color = { fg = colors.green },
    cond = conditions.hide_in_width,
  },
  lsp = {
    function(msg)
      msg = msg or "LS Inactive"
      -- local buf_clients = vim.lsp.get_active_clients()
      local buf_clients = vim.lsp.buf_get_clients()

      if next(buf_clients) == nil then
        -- TODO: clean up this if statement
        if type(msg) == "boolean" or #msg == 0 then
          return "LS Inactive"
        end
        return msg
      end
      local buf_ft = vim.bo.filetype
      local buf_client_names = {}

      -- add client
      for _, client in pairs(buf_clients) do
        if client.name ~= "null-ls" then
          table.insert(buf_client_names, client.name)
        end
      end

      -- add formatter
      local formatters = require "utils.null-ls.formatters"
      local supported_formatters = formatters.list_registered(buf_ft)
      vim.list_extend(buf_client_names, supported_formatters)

      -- add linter
      local linters = require "utils.null-ls.linters"
      local supported_linters = linters.list_registered(buf_ft)
      vim.list_extend(buf_client_names, supported_linters)

      -- add code actions
      local code_actions = require "utils.null-ls.code_actions"
      local supported_code_actions = code_actions.list_registered(buf_ft)
      vim.list_extend(buf_client_names, supported_code_actions)

      -- add hover
      local hovers = require "utils.null-ls.hovers"
      local supported_hovers = hovers.list_registered(buf_ft)
      vim.list_extend(buf_client_names, supported_hovers)

      return "[" .. table.concat(buf_client_names, ", ") .. "]"
    end,
    color = { gui = "bold" },
    cond = conditions.hide_in_width,
  },
  location = { "location", cond = conditions.hide_in_width, color = {} },
  progress = { "progress", cond = conditions.hide_in_width, color = {} },
  spaces = {
    function()
      if not vim.api.nvim_buf_get_option(0, "expandtab") then
        return "Tab size: " .. vim.api.nvim_buf_get_option(0, "tabstop") .. " "
      end
      local size = vim.api.nvim_buf_get_option(0, "shiftwidth")
      if size == 0 then
        size = vim.api.nvim_buf_get_option(0, "tabstop")
      end
      return "Spaces: " .. size .. " "
    end,
    cond = conditions.hide_in_width,
    color = {},
  },
  encoding = {
    "o:encoding",
    fmt = string.upper,
    color = {},
    cond = conditions.hide_in_width,
  },
  filetype = { "filetype", cond = conditions.hide_in_width },
  scrollbar = {
    function()
      local current_line = vim.fn.line "."
      local total_lines = vim.fn.line "$"
      local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
      local line_ratio = current_line / total_lines
      local index = math.ceil(line_ratio * #chars)
      return chars[index]
    end,
    padding = { left = 0, right = 0 },
    color = { fg = colors.yellow, bg = colors.bg },
    cond = nil,
  },
}
