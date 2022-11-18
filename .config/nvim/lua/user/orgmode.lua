if configs.neorg or not configs.org then
  return
end

local ok_orgmode, orgmode = pcall(require, "orgmode")
if not ok_orgmode then
  return
end

orgmode.setup_ts_grammar()

orgmode.setup {
  org_agenda_files = { "~/Desktop/sync/orgs/*" },
  org_default_notes_file = "~/Desktop/sync/orgs/refile.org",
}
