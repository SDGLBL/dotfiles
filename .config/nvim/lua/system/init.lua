local autocmd = require "user.autocmd"

local function setup(opts)
  if opts.pre_hook ~= nil then
    pcall(opts.pre_hook)
  end

  if opts.colorscheme_config then
    local colorscheme = opts.colorscheme_config.colorscheme
    local config = opts.colorscheme_config.config

    if config ~= nil then
      local ok, _ = pcall(config)
      if not ok then
        vim.notify("excuting colorscheme config failed", vim.log.levels.ERROR)
      end
    end

    if colorscheme == "catppuccin" then
      require("catppuccin").setup()
    end

    local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
    if not status_ok then
      vim.notify("colorscheme " .. colorscheme .. " not found!")
      return
    end
  end

  require "system.clipboard"
  require "user.plugins"
  require "user.keymaps"
  require "user.options"
  require "user.autocmd"
  require "user.projects"
  require "user.alpha"
  require "user.toggleterm"
  require "user.comment"
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

  if opts.indent_blankline then
    require "user.indentline"
  end

  if opts.markdown_preview then
    require "user.markdown_preview"
  end

  if opts.color_picker then
    require "user.ccc"
  end

  if opts.tint then
    local ok, tint = pcall(require, "tint")
    if ok then
      tint.setup {}
    end
  end

  if opts.better_fold then
    require "user.better_fold"
  end

  if not opts.org and opts.neorg then
    require "user.neorg"
  end

  if not opts.neorg and opts.org then
    require "user.orgmode"
  end

  if opts.better_tui then
    require "user.noice"
  end

  if opts.autopairs then
    require "user.autopairs"
  end

  if opts.refactor then
    require "user.refactor"
  end

  if opts.lsp then
    require "user.cmp"
    require "user.lsp"

    if opts.dap then
      require "user.lsp.mason-nvim-dap"
    end

    if opts.rust_tools then
      require "user.rust_tools"
    end
  end

  if opts.transparent_window then
    autocmd.enable_transparent_mode()
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

  if opts.after_hook ~= nil then
    pcall(opts.after_hook)
  end
end

return {
  setup = setup,
}
