-- enable lua loader
vim.loader.enable()

require("configs").setup {
  dark_colorscheme = "rose-pine-moon",
  light_colorscheme = "catppuccin-latte",
  dap = true,
  go = true,
  rust = true,
  python = true,
  format_on_save = true,
  -- cpp = true,
  -- typescript = true,
  -- refactor = true,
  -- ufo = true,
  -- tailwind = true,
  -- hlargs = false,
  -- obsidian = true,
  -- nix = true,
  -- cpp = true,
  -- jupyter = true,
  -- typescript = true,
  -- tint = true,
  -- indent_blankline = true,
  autopairs = false,
  markdown_preview = true,
  transparent_window = true,
  autocmds = {
    {
      "BufWinEnter",
      {
        group = "_filetype_settings",
        pattern = { "*.go", "*.php", "*.h", "*.c", "*.cpp" },
        desc = "setlocal ts and sw",
        callback = function()
          pcall(vim.cmd, "setlocal ts=4 sw=4")
        end,
      },
    },
    {
      "BufWinEnter",
      {
        group = "_filetype_settings",
        desc = "set wrap",
        callback = function()
          if vim.bo.ft == "codecompanion" then
            vim.wo.wrap = true
          end
        end,
      },
    },
    {
      "WinLeave",
      {
        group = "_close_telescope",
        callback = function()
          if vim.bo.ft == "TelescopePrompt" and vim.fn.mode() == "i" then
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "i", false)
          end
        end,
      },
    },
    -- {
    --   { "BufEnter" },
    --   {
    --     pattern = "*",
    --     desc = "Disable syntax highlighting in files larger than 1MB",
    --     callback = function(args)
    --       local highlighter = require "vim.treesitter.highlighter"
    --       local ts_was_active = highlighter.active[args.buf]
    --       local file_size = vim.fn.getfsize(args.file)
    --       if file_size > 1024 * 1024 then
    --         vim.cmd "TSBufDisable highlight"
    --         vim.cmd "syntax off"
    --         vim.cmd "syntax clear"
    --         vim.cmd "IlluminatePauseBuf"
    --         vim.cmd "set nonumber"
    --         -- vim.cmd "IndentBlanklineDisable"
    --         vim.cmd "NoMatchParen"
    --         -- vim.cmd 'set filetype=""'
    --         if ts_was_active then
    --           vim.notify "File larger than 1MB, turned off syntax highlighting"
    --         end
    --       end
    --     end,
    --   },
    -- },
  },
}

-- General/Global LSP Configuration
local api = vim.api
local lsp = vim.lsp

local make_client_capabilities = lsp.protocol.make_client_capabilities

-- Disable didChangeWatchedFiles capability
function lsp.protocol.make_client_capabilities()
  local caps = make_client_capabilities()
  if not (caps.workspace or {}).didChangeWatchedFiles then
    vim.notify("lsp capability didChangeWatchedFiles is already disabled", vim.log.levels.WARN)
  else
    caps.workspace.didChangeWatchedFiles = nil
  end

  return caps
end
