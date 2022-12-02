if not configs.refactor then
  return
end

local status_ok, refactor = pcall(require, "refactoring")
if not status_ok then
  return
end

local ok, telescope = pcall(require, "telescope")
if ok then
  telescope.load_extension "refactoring"
end

refactor.setup {}

local ok_which_key, wk = pcall(require, "which-key")

if ok_which_key then
  wk.register({
    r = {
      name = "Refactoring",
      r = { "<esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>", "Switch" },
    },
  }, require("user.whichkey").opts)
end
