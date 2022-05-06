M = {}

local autocmd = require("user.autocmd")

M.setup = function(opts)
  require 'system.clipboard'
  require 'user.options'
  require 'user.keymaps'
  require 'user.plugins'
  require 'user.autocmd'
  require 'user.whichkey'
  require 'user.projects'
  require 'user.alpha'
  require 'user.toggleterm'
  require 'user.comment'
  require 'user.indentline'
  require 'user.impatient'
  require 'user.bufferline'
  require 'user.lualine'
  require 'user.nvim-tree'
  require 'user.treesitter'
  require 'user.gitsigns'
  require 'user.telescope'

  if opts.active_autopairs then
    require 'user.autopairs'
  end

  if opts.active_lsp then
    require 'user.cmp'
    require 'user.lsp'
    require 'user.lsp.null-ls'
  end

  if opts.active_dap then
    require 'user.dap'
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

end

return M
