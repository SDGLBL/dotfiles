local colorscheme = "tokyonight"
-- local colorscheme = "sonokai"
-- local colorscheme = "monokai_soda"
-- local colorscheme = "onedarkpro"
-- local colorscheme = "nightfly"
-- local colorscheme = "catppuccin"
-- local colorscheme = "rose-pine"


local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  vim.notify("colorscheme " .. colorscheme .. " not found!")
  return
end
