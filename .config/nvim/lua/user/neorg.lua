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
          work = "~/Desktop/同步空间/orgs/work",
          life = "~/Desktop/同步空间/orgs/life",
          learn = "~/Desktop/同步空间/orgs/learn",
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

local ok_which_key, _ = pcall(require, "which-key")
if ok_which_key then
  local wk = require "user.whichkey"

  if wk.mappings["n"] ~= nil then
    return
  end

  wk.mappings["n"] = {
    name = "Neorg",
    -- g = { "<cmd>Neogen<cr>", "Neggen" },
    g = {
      name = "GTD",
      e = { "<cmd>Neorg gtd edit<cr>", "Edit" },
      v = { "<cmd>Neorg gtd views<cr>", "Views" },
      c = { "<cmd>Neorg gtd capture<cr>", "Capture" },
    },
    w = {
      name = "Workspaces",
      w = { "<cmd>Neorg workspace work<cr>", "Work" },
      l = { "<cmd>Neorg workspace life<cr>", "life" },
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
  }
end
