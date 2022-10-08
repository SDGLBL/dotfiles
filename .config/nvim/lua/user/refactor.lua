local status_ok, refactor = pcall(require, "refactoring")
if not status_ok then
  return
end

refactor.setup {}

local ok_which_key, _ = pcall(require, "which-key")
if ok_which_key then
  local wk = require "user.whichkey"

  if wk.mappings["r"] ~= nil then
    return
  end

  wk.mappings["r"] = {
    name = "Refactoring",
    r = { "<esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>", "Switch" },
  }
end
