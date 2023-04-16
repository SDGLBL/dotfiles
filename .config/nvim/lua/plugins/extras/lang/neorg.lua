return {
  -- add norg to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "norg" })
      end
    end,
  },

  {
    "nvim-neorg/neorg",
    dependencies = "nvim-lua/plenary.nvim",
    ft = "norg",
    enabled = configs.neorg,
    opts = {
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
    },
    config = true,
  },
}
