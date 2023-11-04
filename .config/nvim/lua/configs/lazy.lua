local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  }
end

vim.opt.runtimepath:prepend(lazypath)

require("lazy").setup {
  spec = {
    { import = "plugins" },
    { import = "plugins.search" },
    { import = "plugins.extras.ui" },
    { import = "plugins.extras.coding" },
    { import = "plugins.extras.lang" },
    { import = "plugins.extras.pde" },
    { import = "plugins.extras.pde.note" },
  },
  defaults = { lazy = false, version = nil },
  install = { missing = true, colorscheme = { "tokyonight", "gruvbox" } },
  -- checker = { enabled = true },
  concurrency = 30,
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
}
