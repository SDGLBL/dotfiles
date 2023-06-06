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
    config = function(_, opts)
      require("neorg").setup(opts)

      require("utils.whichkey").register {
        n = {
          name = "Neorg",
          w = {
            name = "Workspaces",
            w = { "<cmd>Neorg workspace work<cr>", "Work" },
            l = { "<cmd>Neorg workspace life<cr>", "Life" },
            s = { "<cmd>Neorg workspace learn<cr>", "Learn" },
          },
          t = {
            name = "TOC",
            c = { "<cmd>Neorg toc close<cr>", "Close TOC" },
            i = { "<cmd>Neorg toc inline<cr>", "Inline TOC" },
            s = { "<cmd>Neorg toc split<cr>", "Split TOC" },
            t = { "<cmd>Neorg toc toqflist<cr>", "Toqflist TOC" },
          },
          r = { "<cmd>Neorg return<cr>", "Return" },
          j = { "<cmd>Neorg journal<cr>", "Journal" },
        },
      }
    end,
  },
}
