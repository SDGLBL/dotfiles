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
    "nvim-cmp",
    opts = function(_, opts)
      table.insert(opts.sources, { name = "neorg" })
    end,
  },

  {
    "nvim-neorg/neorg",
    dependencies = "nvim-lua/plenary.nvim",
    enabled = configs.neorg,
    run = ":Neorg sync-parsers",
    -- ft = { "norg" },
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
        ["core.dirman"] = {
          config = {
            workspaces = {
              work = "~/Desktop/sync/neorgs/work",
              life = "~/Desktop/sync/neorgs/life",
              learn = "~/Desktop/sync/neorgs/learn",
            },
          },
        },
        ["core.journal"] = {},
        ["core.qol.toc"] = {},
        ["core.concealer"] = {},
        ["core.completion"] = {
          config = {
            engine = "nvim-cmp",
          },
        },
        ["core.integrations.nvim-cmp"] = {},
        ["core.integrations.treesitter"] = {},
      },
    },
    -- config = function(_, opts)
    --   require("neorg").setup(opts)
    -- end,
  },
}
