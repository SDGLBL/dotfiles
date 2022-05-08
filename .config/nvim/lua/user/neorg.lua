local status_ok, neorg = pcall(require, "neorg")
if not status_ok then
  return
end

neorg.setup({
  load = {
    ["core.defaults"] = {},
    ["core.export"] = {},
    ["core.norg.dirman"] = {
      config = {
        workspaces = {
          work = "~/Notes/work",
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
  },
})
