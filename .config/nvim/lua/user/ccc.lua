local ok, ccc = pcall(require, "ccc")
if not ok then
  return
end

ccc.setup {}

local ok_which_key, _ = pcall(require, "which-key")
if ok_which_key then
  local wk = require "user.whichkey"

  if wk.mappings["C"] ~= nil then
    return
  end

  wk.mappings["C"] = { "<cmd>CccPick<cr>", "Color picker" }
end
