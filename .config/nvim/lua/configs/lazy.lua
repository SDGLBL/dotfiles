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
    { import = "plugins.extras.lang" },
    { import = "plugins.extras.pde" },
  },
  defaults = { lazy = false, version = nil },
  install = { missing = true, colorscheme = { "tokyonight", "gruvbox" } },
  checker = { enabled = true },
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

require("utils.whichkey").register {
  z = {
    name = "Lazy",
    i = { "<cmd>:Lazy install<cr>", "Install" },
    u = { "<cmd>:Lazy update<cr>", "Update" },
    c = { "<cmd>:Lazy clean<cr>", "Clean" },
    p = { "<cmd>:Lazy profile<cr>", "Profile" },
  },
}
