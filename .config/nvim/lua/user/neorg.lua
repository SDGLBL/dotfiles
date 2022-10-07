local status_ok, neorg = pcall(require, "neorg")
if not status_ok then
  return
end

neorg.setup {
  load = {
    ["core.defaults"] = {},
    ["core.export"] = {},
    ["core.presenter"] = {
      config = {
        zen_mode = "zen-mode",
      },
    },
    ["core.norg.dirman"] = {
      config = {
        workspaces = {
          work = "~/Desktop/同步空间/orgs/work",
          life = "~/Desktop/同步空间/orgs/life",
        },
      },
    },
    ["core.norg.journal"] = {},
    ["core.norg.qol.toc"] = {},
    ["core.gtd.base"] = {
      config = {
        workspace = "work",
      },
    },
    ["core.norg.concealer"] = {},
    ["core.integrations.nvim-cmp"] = {
      config = { -- Note that this table is optional and doesn't need to be provided
        -- Configuration here
      },
    },
    ["core.norg.completion"] = {
      config = {
        engine = "nvim-cmp",
      },
    },
  },
}
