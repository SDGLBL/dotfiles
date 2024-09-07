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

local chatspin = require("lualine.component"):extend()

chatspin.processing = false
chatspin.spinner_index = 1

local spinner_symbols = {
  "⠋",
  "⠙",
  "⠹",
  "⠸",
  "⠼",
  "⠴",
  "⠦",
  "⠧",
  "⠇",
  "⠏",
}

local spinner_symbols_len = 10

-- Initializer
function chatspin:init(options)
  chatspin.super.init(self, options)

  local group = vim.api.nvim_create_augroup("CodeCompanionHooks", {})

  vim.api.nvim_create_autocmd({ "User" }, {
    pattern = "CodeCompanionRequest*",
    group = group,
    callback = function(request)
      if request.match == "CodeCompanionRequestStarted" then
        self.processing = true
      elseif request.match == "CodeCompanionRequestFinished" then
        self.processing = false
      end
    end,
  })
end

-- Function that runs every time statusline is updated
function chatspin:update_status()
  if self.processing then
    self.spinner_index = (self.spinner_index % spinner_symbols_len) + 1
    return spinner_symbols[self.spinner_index]
  else
    return nil
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
      local buf_clients = vim.lsp.get_clients { bufnr = 0 }

      if next(buf_clients) == nil then
        -- TODO: clean up this if statement
        if type(msg) == "boolean" or #msg == 0 then
          return "LS Inactive"
        end
        return msg
      end

      local buf_ft = vim.bo.filetype
      local buf_client_names = {}
      local copilot_active = false

      -- add client
      for _, client in pairs(buf_clients) do
        if client.name ~= "null-ls" and client.name ~= "copilot" then
          table.insert(buf_client_names, client.name)
        end

        if client.name == "copilot" then
          copilot_active = true
        end
      end

      -- add formatter
      -- local formatters = require("conform").list_formatters(0)
      -- for _, formatter in ipairs(formatters) do
      --   table.insert(buf_client_names, formatter.name)
      -- end

      -- add linnets
      -- local linters = require("lint").get_running()
      -- for _, linter in ipairs(linters) do
      --   table.insert(buf_client_names, linter)
      -- end

      -- add formatter
      -- local formatters = require "utils.null-ls.formatters"
      -- local supported_formatters = formatters.list_registered(buf_ft)
      -- vim.list_extend(buf_client_names, supported_formatters)

      -- add linter
      -- local linters = require "utils.null-ls.linters"
      -- local supported_linters = linters.list_registered(buf_ft)
      -- vim.list_extend(buf_client_names, supported_linters)

      -- add code actions
      -- local code_actions = require "utils.null-ls.code_actions"
      -- local supported_code_actions = code_actions.list_registered(buf_ft)
      -- vim.list_extend(buf_client_names, supported_code_actions)

      -- add hover
      -- local hovers = require "utils.null-ls.hovers"
      -- local supported_hovers = hovers.list_registered(buf_ft)
      -- vim.list_extend(buf_client_names, supported_hovers)

      local hash = {}
      local unique_client_names = {}

      for _, v in ipairs(buf_client_names) do
        if not hash[v] then
          unique_client_names[#unique_client_names + 1] = v -- you could print here instead of saving to result table if you wanted
          hash[v] = true
        end
      end

      for i, client_name in ipairs(unique_client_names) do
        local cn_icons = {}

        -- if vim.tbl_contains(supported_formatters, client_name) then
        --   table.insert(cn_icons, icons.lsp.Formatter)
        -- end

        -- if vim.tbl_contains(supported_linters, client_name) then
        --   table.insert(cn_icons, icons.lsp.Linter)
        -- end

        -- if vim.tbl_contains(supported_code_actions, client_name) then
        --   table.insert(cn_icons, icons.lsp.CodeAction)
        -- end

        -- if vim.tbl_contains(supported_hovers, client_name) then
        --   table.insert(cn_icons, icons.lsp.Hover)
        -- end

        if #cn_icons > 0 then
          unique_client_names[i] = client_name .. " " .. table.concat(cn_icons, "|")
        end
      end
      local language_servers = "[" .. table.concat(unique_client_names, " ") .. "]"

      if copilot_active then
        language_servers = language_servers .. "%#SLCopilot#" .. " " .. icons.git.Octoface .. "%*"
      end

      return language_servers
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
  overseer = { "overseer" },
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
  chatspin = chatspin,
}
