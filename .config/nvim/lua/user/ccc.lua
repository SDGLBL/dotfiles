if not configs.color_picker then
  return
end

local ok, ccc = pcall(require, "ccc")
if not ok then
  return
end

ccc.setup {}
