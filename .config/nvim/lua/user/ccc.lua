if not configs.color_picker then
  return
end

local ok, ccc = pcall(require, "ccc")
if not ok then
  return
end

ccc.setup {}

local ok_which_key, wk = pcall(require, "which-key")
if ok_which_key then
  wk.register({ C = { "<cmd>CccPick<cr>", "Color picker" } }, require("user.whichkey").opts)
end
