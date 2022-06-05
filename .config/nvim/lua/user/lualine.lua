local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
  return
end

local styles = require("user.lualine.styles").styles

lualine.setup(styles.lvim)
