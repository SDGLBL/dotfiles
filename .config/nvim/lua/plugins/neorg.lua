return {
  {
    "nvim-neorg/neorg",
    dependencies = "nvim-lua/plenary.nvim",
    ft = "norg",
    enabled = configs.neorg,
    config = function()
      if not configs.neorg then
        return
      end

      local neorg = require "neorg"

      neorg.setup {
        load = {
          ["core.defaults"] = {},
          ["core.export"] = {},
          ["core.export.markdown"] = {
            config = {
              extensions = "all",
            },
          },
          ["core.presenter"] = {
            config = {
              zen_mode = "zen-mode",
            },
          },
          ["core.norg.dirman"] = {
            config = {
              workspaces = {
                work = "~/Desktop/sync/neorgs/work",
                life = "~/Desktop/sync/neorgs/life",
                learn = "~/Desktop/sync/neorgs/learn",
              },
            },
          },
          ["core.norg.journal"] = {},
          ["core.norg.qol.toc"] = {},
          ["core.norg.concealer"] = {},
          ["core.norg.completion"] = {
            config = {
              engine = "nvim-cmp",
            },
          },
          ["core.integrations.nvim-cmp"] = {},
          ["core.integrations.treesitter"] = {},
        },
      }
    end,
  },
}
