require 'user.options'
require 'user.keymaps'
require 'user.plugins'
require 'user.cmp'
require 'user.lsp'
require 'user.telescope'
require 'user.treesitter'
require 'user.autopairs'
require 'user.gitsigns'
require 'user.treesitter'
require 'user.nvim-tree'
require 'user.bufferline'
require 'user.lualine'
require 'user.toggleterm'
require 'user.impatient'
require 'user.indentline'
require 'user.projects'
require 'user.alpha'
require 'user.comment'
require 'user.whichkey'
require 'user.autocmd'

require 'system.clipboard'
require 'system.setup'.setup({
  transparent_window = true,
  format_on_save     = true,
  colorscheme        = "nightfly"
  -- colorscheme = "tokyonight",
  -- colorscheme = "sonokai",
  -- colorscheme = "onedarkpro",
  -- colorscheme = "monokai_soda",
  -- colorscheme = "catppuccin",
  -- colorscheme = "rose-pine",
})

-- colorscheme sonokai style
-- `'default'`, `'atlantis'`, `'andromeda'`, `'shusia'`, `'maia'`, `'espresso'`
vim.g.sonokai_style = 'maia'

-- copilot setup
-- vim.g.copilot_no_tab_map = true
-- vim.g.copilot_assume_mapped = true
-- vim.g.copilot_tab_fallback = ""

-- conda setup
if os.getenv("CONDA_PREFIX") ~= "" then
  vim.g.python3_host_prog = os.getenv("CONDA_PREFIX") .. '/bin/python'
end
