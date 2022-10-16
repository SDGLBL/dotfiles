M = {}

local autocmd = require "user.autocmd"

M.setup = function(opts)
  -- colorscheme style
  vim.g.sonokai_style = "maia" -- `'default'`, `'atlantis'`, `'andromeda'`, `'shusia'`, `'maia'`, `'espresso'`
  vim.g.tokyonight_style = "night"
  vim.g.tokyonight_sidebars = { "qf", "vista_kind", "terminal", "packer" }
  vim.g.catppuccin_flavour = "mocha" -- latte, frappe, macchiato, mocha

  -- set guifont
  vim.cmd [[set guifont=FiraCode\ Nerd\ Font\ Mono:h17]]

  -- copilot setup
  vim.g.copilot_no_tab_map = true
  vim.g.copilot_assume_mapped = true
  vim.g.copilot_tab_fallback = ""

  -- conda setup
  if os.getenv "CONDA_PREFIX" ~= "" and os.getenv "CONDA_PREFIX" ~= nil then
    vim.g.python3_host_prog = os.getenv "CONDA_PREFIX" .. "/bin/python"
  end

  require "user.plugins"
  require "system.clipboard"
  require "user.options"
  require "user.keymaps"
  require "user.autocmd"
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
  require "user.neovide"
  require "user.tabnine"
  require "user.notify"
  require "user.markdown_preview"

  if opts.active_tint then
    local ok, tint = pcall(require, "tint")
    if ok then
      tint.setup {}
    end
  end

  if opts.better_fold then
    require "user.better_fold"
  end

  if not opts.active_org and opts.active_neorg then
    require "user.neorg"
  end

  if not opts.active_neorg and opts.active_org then
    require "user.orgmode"
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
    if opts.colorscheme == "catppuccin" then
      require("catppuccin").setup()
    end

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

  -- load user keymaps after plugins loaded
  require "user.whichkey"
end

return M
