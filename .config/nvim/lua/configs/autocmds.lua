local M = {}

local format_on_save = {
  ---@usage pattern string pattern used for the autocommand (Default: '*')
  pattern = "*",
  ---@usage timeout number timeout in ms for the format request (Default: 1000)
  timeout = 1000,
  ---@usage filter func to select client
  filter = require("utils.lsp").format_filter,
}

function M.load_augroups()
  return {
    {
      "TextYankPost",
      {
        group = "_general_settings",
        pattern = "*",
        desc = "Highlight text on yank",
        callback = function()
          vim.highlight.on_yank { higroup = "Search", timeout = 100 }
        end,
      },
    },
    {
      "FileType",
      {
        group = "_filetype_settings",
        pattern = { "gitcommit", "markdown" },
        desc = "setlocal wrap and spell",
        callback = function()
          pcall(vim.cmd, "setlocal wrap", "setlocal spell")
        end,
      },
    },
    {
      "FileType",
      {
        group = "_hide_dap_repl",
        pattern = "dap-repl",
        command = "set nobuflisted",
      },
    },
    {
      "FileType",
      {
        group = "_filetype_settings",
        pattern = { "lua" },
        desc = "fix gf functionality inside .lua files",
        callback = function()
          ---@diagnostic disable: assign-type-mismatch
          -- credit: https://github.com/sam4llis/nvim-lua-gf
          vim.opt_local.include = [[\v<((do|load)file|require|reload)[^''"]*[''"]\zs[^''"]+]]
          vim.opt_local.includeexpr = "substitute(v:fname,'\\.','/','g')"
          vim.opt_local.suffixesadd:prepend ".lua"
          vim.opt_local.suffixesadd:prepend "init.lua"

          for _, path in pairs(vim.api.nvim_list_runtime_paths()) do
            vim.opt_local.path:append(path .. "/lua")
          end
        end,
      },
    },
    {
      "FileType",
      {
        group = "_buffer_mappings",
        pattern = {
          "qf",
          "help",
          "man",
          "floaterm",
          "lspinfo",
          "lir",
          "lsp-installer",
          "null-ls-info",
          "tsplayground",
          "DressingSelect",
          "Jaq",
        },
        callback = function()
          vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = true })
          vim.opt_local.buflisted = false
        end,
      },
    },
    {
      "VimResized",
      {
        group = "_auto_resize",
        pattern = "*",
        command = "tabdo wincmd =",
      },
    },
    {
      "FileType",
      {
        group = "_filetype_settings",
        pattern = "alpha",
        callback = function()
          pcall(vim.cmd, "set nobuflisted")
        end,
      },
    },
    {
      "FileType",
      {
        group = "_filetype_settings",
        pattern = "lir",
        callback = function()
          vim.opt_local.number = false
          vim.opt_local.relativenumber = false
        end,
      },
    },
    -- show cursor line only in active window
    {
      { "InsertLeave", "WinEnter" },
      {
        group = "_cursorline_on_active_window",
        callback = function()
          local ok, cl = pcall(vim.api.nvim_win_get_var, 0, "auto-cursorline")
          if ok and cl then
            vim.wo.cursorline = true
            vim.api.nvim_win_del_var(0, "auto-cursorline")
          end
        end,
      },
    },
    {
      { "InsertEnter", "WinLeave" },
      {
        group = "_cursorline_on_active_window",
        callback = function()
          local cl = vim.wo.cursorline
          if cl then
            vim.api.nvim_win_set_var(0, "auto-cursorline", cl)
            vim.wo.cursorline = false
          end
        end,
      },
    },
  }
end

function M.enable_format_on_save()
  vim.api.nvim_create_augroup("lsp_format_on_save", {})
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = "lsp_format_on_save",
    pattern = format_on_save.pattern,
    callback = function()
      require("utils.lsp").format { timeout_ms = format_on_save.timeout, filter = format_on_save.filter }
    end,
  })
end

function M.disable_format_on_save()
  pcall(vim.api.nvim_del_augroup_by_name, "lsp_format_on_save")
end

--- Create autocommand groups based on the passed definitions
---@param definitions table contains trigger, pattern and text. The key will be used as a group name
function M.define_augroups(definitions)
  for _, entry in ipairs(definitions) do
    local event = entry[1]
    local opts = entry[2]
    if type(opts.group) == "string" and opts.group ~= "" then
      local exists, _ = pcall(vim.api.nvim_get_autocmds, { group = opts.group })
      if not exists then
        vim.api.nvim_create_augroup(opts.group, {})
      end
    end
    vim.api.nvim_create_autocmd(event, opts)
  end
end

return M
