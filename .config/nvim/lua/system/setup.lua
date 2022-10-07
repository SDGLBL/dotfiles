M = {}

local autocmd = require "user.autocmd"

M.setup = function(opts)
  require "user.plugins"
  require "system.clipboard"
  require "user.options"
  require "user.keymaps"
  require "user.autocmd"
  require "user.whichkey"
  require "user.projects"
  require "user.alpha"
  require "user.toggleterm"
  require "user.comment"
  require "user.indentline"
  require "user.impatient"
  require "user.bufferline"
  require "user.lualine"
  require "user.nvim-tree"
  require "user.treesitter"
  require "user.gitsigns"
  require "user.telescope"
  require("user.neovide").setup()
  require "user.tabnine"
  require "user.notify"

  if opts.active_neorg then
    require "user.neorg"
  end

  if opts.better_tui then
    require "user.noice"
  end

  if opts.active_autopairs then
    require "user.autopairs"
  end

  if opts.active_refactor then
    require "user.refactor"
  end

  if opts.active_lsp then
    require "user.cmp"
    require "user.lsp"
    require("user.lsp.null-ls").setup()
  end

  if opts.active_dap then
    require "user.dap"
  end

  if opts.transparent_window then
    autocmd.enable_transparent_mode()
  end

  if opts.colorscheme then
    local status_ok, _ = pcall(vim.cmd, "colorscheme " .. opts.colorscheme)
    if not status_ok then
      vim.notify("colorscheme " .. opts.colorscheme .. " not found!")
      return
    end
  end

  if opts.format_on_save then
    autocmd.enable_format_on_save()
  else
    autocmd.disable_format_on_save()
  end

  -- load user cmd
  opts.autocmds = opts.autocmds or {}
  local default_cmds = autocmd.load_augroups() or {}
  local all_cmds = vim.tbl_deep_extend("keep", opts.autocmds, default_cmds)
  autocmd.define_augroups(all_cmds)
end

return M
