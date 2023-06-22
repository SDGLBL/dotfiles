-- enable lua loader
vim.loader.enable()

require("configs").setup {
  colorscheme = "midnight",
  dap = true,
  -- tint = true,
  -- refactor = true,
  go_tools = true,
  rust_tools = true,
  -- better_fold = true,
  -- indent_blankline = true,
  -- markdown_preview = true,
  transparent_window = true,
  autocmds = {
    {
      "BufWinEnter",
      {
        group = "_filetype_settings",
        pattern = { "*.go", "*.c", "*.php", "*.cpp", "*.h" },
        desc = "setlocal ts and sw",
        callback = function()
          pcall(vim.cmd, "setlocal ts=4 sw=4")
        end,
      },
    },
    -- https://github.com/nvim-telescope/telescope.nvim/issues/2501
    {
      "WinLeave",
      {
        group = "_telescope_windown_leave_enter_insert_mode",
        callback = function()
          if vim.bo.ft == "TelescopePrompt" and vim.fn.mode() == "i" then
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "i", false)
          end
        end,
      },
    },
  },
}
