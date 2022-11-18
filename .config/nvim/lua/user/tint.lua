if not configs.tint then
  return
end

local ok, tint = pcall(require, "tint")

if ok then
  tint.setup {}
end
