if configs.org or not configs.neorg then
  return
end

local status_ok, neorg = pcall(require, "neorg")
if not status_ok then
  return
end

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
