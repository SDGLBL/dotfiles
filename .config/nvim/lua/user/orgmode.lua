local ok_orgmode, orgmode = pcall(require, "orgmode")
if not ok_orgmode then
  return
end

orgmode.setup_ts_grammar()

orgmode.setup {
  org_agenda_files = { "~/Desktop/sync/orgs/*" },
  org_default_notes_file = "~/Desktop/sync/orgs/refile.org",
}

--[[ local ok_which_key, _ = pcall(require, "which-key")
if ok_which_key then
  local wk = require "user.whichkey"

  if wk.mappings["o"] ~= nil then
    return
  end

  wk.mappings["o"] = {
    name = "Orgmode",
    g = {
      name = "GTD",
    },
    w = {
      name = "Workspaces",
    },
    t = {
      name = "TOC",
    },
    r = { "<cmd><cr>", "Return" },
    j = { "<cmd><cr>", "Journal" },
  }
end ]]
