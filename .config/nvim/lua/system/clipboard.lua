-- Please check https://github.com/agriffis/skel/blob/master/neovim/bin/clipboard-provider
vim.g['clipboard'] = {
  ['name'] = 'clipboard-provider',
  ['copy'] = {
    ['+'] = 'clipboard-provider copy',
    ['*'] = 'clipboard-provider copy',
  },
  ['paste'] = {
    ['+'] = 'clipboard-provider paste',
    ['*'] = 'clipboard-provider paste',
  },
}

-- Please check https://github.com/equalsraf/win32yank
-- If you use wsl2 or wsl in windows
-- vim.g.clipboard = {
--   ["name"] = "win32yank-wsl",
--   ['copy']= {
--       ['+']= '/mnt/c/Users/lijie/win32yank.exe -i --crlf',
--       ['*']= '/mnt/c/Users/lijie/win32yank.exe -i --crlf',
--   },
--   ['paste']= {
--       ['+']= '/mnt/c/Users/lijie/win32yank.exe -o --lf',
--       ['*']= '/mnt/c/Users/lijie/win32yank.exe -o --lf',
--   },
-- }
