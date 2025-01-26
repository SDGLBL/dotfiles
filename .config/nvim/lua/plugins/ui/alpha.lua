return {
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    config = function()
      local alpha = require "alpha"

      local dashboard = require "alpha.themes.dashboard"

      local icons = require "utils.icons"

      dashboard.section.header.val = {
        [[                               __                ]],
        [[  ___     ___    ___   __  __ /\_\    ___ ___    ]],
        [[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
        [[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
        [[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
        [[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
      }

      dashboard.section.buttons.val = {
        dashboard.button("f", icons.ui.FindFile .. "  Find file", ":Telescope find_files <CR>"),
        dashboard.button("e", icons.ui.File .. "  New file", ":ene <BAR> startinsert <CR>"),
        -- dashboard.button("p", icons.ui.Project .. "  Find project", ":Telescope projects <CR>"),
        dashboard.button("r", icons.ui.History .. "  Recently used files", ":Telescope oldfiles <CR>"),
        dashboard.button("t", icons.ui.FindText .. "  Find text", ":Telescope live_grep <CR>"),
        dashboard.button("c", icons.ui.Gear .. "  Configuration", ":e " .. vim.fn.stdpath "config" .. "/init.lua <CR>"),
        dashboard.button("q", icons.ui.SignOut .. "  Quit Neovim", ":qa<CR>"),
      }

      dashboard.section.footer.opts.hl = "Type"
      dashboard.section.header.opts.hl = "Include"
      dashboard.section.buttons.opts.hl = "Keyword"

      dashboard.opts.opts.noautocmd = true
      alpha.setup(dashboard.opts)
    end,
  },
}
