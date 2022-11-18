local function setup(opts)
  local default_config = require("system.configs").default_config
  _G.configs = opts and vim.tbl_deep_extend("force", default_config, opts) or default_config

  if configs.pre_hook ~= nil then
    pcall(configs.pre_hook)
  end

  if configs.colorscheme_config then
    local colorscheme = configs.colorscheme_config.colorscheme
    local config = configs.colorscheme_config.config

    if config ~= nil then
      local ok, _ = pcall(config)
      if not ok then
        vim.notify("executing colorscheme config failed", vim.log.levels.ERROR)
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
  require "user.whichkey"
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
  require "user.indentline"
  require "user.markdown_preview"
  require "user.ccc"
  require "user.tint"
  require "user.better_fold"
  require "user.neorg"
  require "user.orgmode"
  require "user.noice"
  require "user.autopairs"
  require "user.refactor"
  require "user.cmp"
  require "user.lsp"
  require "user.lsp.mason-nvim-dap"
  require "user.rust_tools"

  local autocmd = require "user.autocmd"

  if configs.transparent_window then
    autocmd.enable_transparent_mode()
  end

  if configs.format_on_save then
    autocmd.enable_format_on_save()
  else
    autocmd.disable_format_on_save()
  end

  -- load user cmd
  configs.autocmds = configs.autocmds or {}
  local default_cmds = autocmd.load_augroups() or {}
  local all_cmds = vim.tbl_deep_extend("keep", configs.autocmds, default_cmds)
  autocmd.define_augroups(all_cmds)

  if configs.after_hook ~= nil then
    pcall(configs.after_hook)
  end
end

return {
  setup = setup,
}
