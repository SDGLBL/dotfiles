M = {}

local autocmd = require("user.autocmd")

M.setup = function(opts)
  if opts.transparent_window then
    autocmd.enable_transparent_mode()
  end

  if opts.colorscheme then
    local status_ok, _ = pcall(vim.cmd, "colorscheme " .. opts.colorscheme)
    if not status_ok then
      vim.notify("colorscheme " .. opts.colorscheme .. " not found!")
      return
    end
  end

  if opts.format_on_save then
    autocmd.enable_format_on_save()
  else
    autocmd.disable_format_on_save()
  end

end

return M
